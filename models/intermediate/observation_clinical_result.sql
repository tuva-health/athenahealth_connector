
select
      cast(cro.contextid as {{ dbt.type_string() }} ) || '.clin_res.' || cast(cro.CLINICALOBSERVATIONID as {{ dbt.type_string() }} ) as observation_id
    , cast(cro.contextid as {{ dbt.type_string() }} ) || '.' || cast(d.patientid as {{ dbt.type_string() }} ) as person_id
    , cast(cro.contextid as {{ dbt.type_string() }} ) || '.' || cast(d.patientid as {{ dbt.type_string() }} ) as patient_id
    , cast(d.contextid as {{ dbt.type_string() }} ) || '.' || cast(d.clinicalencounterid as {{ dbt.type_string() }} ) as encounter_id
    , cast(cro.clinicalresultid as {{ dbt.type_string() }} ) as panel_id
    , cast(cr.observationdatetime as date) as observation_date
    , cast('observation result' as {{ dbt.type_string() }} ) as observation_type
    , cast(case when l.loinccode is not null then 'loinc'
                when cro.observationidentifierloinc is not null then 'loinc'
                when crcotl.loinc is not null and crcotl.class_code not like '%PANEL%' and crcotl.paneltype = '' then 'loinc'
                when lcltcotl.loinc is not null and lcltcotl.class_code not like '%PANEL%' and lcltcotl.paneltype = '' then 'loinc'
                when lcltl.localclinicallabtemplatelistid is not null then 'athena-template-list-id'
                when cro.observationidentifiertext is not null then 'athena-observation-identifier-text'
                when cro.templateanalytename is not null then 'athena-template-analyte-name'
                end as {{ dbt.type_string() }} ) as source_code_type
    , cast(case when l.loinccode is not null then l.loinccode
                when cro.observationidentifierloinc is not null then cro.observationidentifierloinc
                when crcotl.loinc is not null and crcotl.class_code not like '%PANEL%' and crcotl.paneltype = '' then crcotl.loinc
                when lcltcotl.loinc is not null and lcltcotl.class_code not like '%PANEL%' and lcltcotl.paneltype = '' then lcltcotl.loinc
                when lcltl.localclinicallabtemplatelistid is not null then cast(lcltl.localclinicallabtemplatelistid  as {{ dbt.type_string() }} )
                end as {{ dbt.type_string() }} ) as source_code
    , cast(case when l.loinccode is not null then l.longcommonname
                when cro.observationidentifierloinc is not null then cro.observationidentifiertext
                when crcotl.loinc is not null and crcotl.class_code not like '%PANEL%' and crcotl.paneltype = '' then 'loinc'
                when lcltcotl.loinc is not null and lcltcotl.class_code not like '%PANEL%' and lcltcotl.paneltype = '' then 'loinc'
                when lcltl.localclinicallabtemplatelistid is not null then coalesce(lcltcot.name || ' - ','') || lcltl.name
                else coalesce(crcot.name || ' - ','') || coalesce( cro.observationidentifiertext, cro.templateanalytename) end
            as {{ dbt.type_string() }} ) as source_description
    , cast(null as {{ dbt.type_string() }} ) as normalized_code_type
    , cast(null as {{ dbt.type_string() }} ) as normalized_code
    , cast(null as {{ dbt.type_string() }} ) as normalized_description
    , cast(cro.result as {{ dbt.type_string() }} ) as result
    , cast(null as {{ dbt.type_string() }} ) as source_units
    , cast(null as {{ dbt.type_string() }} ) as normalized_units
    , cast(null as {{ dbt.type_string() }} ) as source_reference_range_low
    , cast(null as {{ dbt.type_string() }} ) as source_reference_range_high
    , cast(null as {{ dbt.type_string() }} ) as normalized_reference_range_low
    , cast(null as {{ dbt.type_string() }} ) as normalized_reference_range_high
    , cast('athena.' || cro.contextname  as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime
from {{ source('athena','dataview_imports__clinicalresultobservation__v1') }} as cro
inner join  {{ source('athena','dataview_imports__clinicalresult__v1') }} as cr
    on cro.clinicalresultid = cr.clinicalresultid and cro.contextid = cr.contextid
inner join {{ source('athena','dataview_imports__document__v1') }} as d
    on cr.documentid = d.documentid and cr.contextid = d.contextid
inner join {{ source('athena','dataview_imports__patient__v1') }} as p
    on d.patientid = p.patientid and d.contextid = p.contextid
left join {{ source('athena','dataview_imports__loinc__v1') }} as l
    on cro.loincid = l.loincid and cro.contextid = l.contextid
left join {{ source('athena','dataview_imports__clinicalordertype__v1') }} as crcot
    on cr.clinicalordertypeid = crcot.clinicalordertypeid
left join {{ ref('terminology__loinc') }} as crcotl
    on crcot.loinc = crcotl.loinc
left join {{ source('athena','dataview_imports__localclinicallabtemplatelist__v1') }} as lcltl
    on cro.localclinicallabtemplatelistid = lcltl.localclinicallabtemplatelistid and cro.contextid = lcltl.contextid
left join {{ source('athena','dataview_imports__localclinicallabtemplate__v1') }} as lclt
    on lcltl.localclinicallabtemplateid = lclt.localclinicallabtemplateid and lcltl.contextid =lclt.contextid
left join {{ source('athena','dataview_imports__clinicalordertype__v1') }} as lcltcot
    on lclt.clinicalordertypeid = lcltcot.clinicalordertypeid
left join {{ ref('terminology__loinc') }} as lcltcotl
    on lcltcot.loinc = lcltcotl.loinc
where cr.clinicalordertypegroup <> 'LAB'
and cro.deletedby is null and cro.deleteddatetime is null
and d.deleteddatetime is null and d.deletedby is null and  d.STATUS <> 'DELETED'
