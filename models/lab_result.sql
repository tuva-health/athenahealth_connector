select
      cast(cro.contextid || '.' || cro.clinicalobservationid as {{ dbt.type_string() }} ) as lab_result_id
    , cast( cro.contextid || '.' || p.enterpriseid as {{ dbt.type_string() }} ) as person_id
    , cast( cro.contextid || '.' || p.enterpriseid as {{ dbt.type_string() }} ) as patient_id
    , cast(d.contextid as {{ dbt.type_string() }} ) || '.' || cast(d.clinicalencounterid as {{ dbt.type_string() }} ) as encounter_id
    , cast(cr.externalaccessionidentifier as {{ dbt.type_string() }} ) as accession_number
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
    , cast(null as {{ dbt.type_string() }} ) as source_component
    , cast(null as {{ dbt.type_string() }} ) as normalized_code_type
    , cast(null as {{ dbt.type_string() }} ) as normalized_code
    , cast(null as {{ dbt.type_string() }} ) as normalized_description
    , cast(null as {{ dbt.type_string() }} ) as normalized_component
    , cast(cro.resultstatus as {{ dbt.type_string() }} ) as status
    , cast(coalesce(cro.result, cro.plcobservationvalue, cro.observationnote) as {{ dbt.type_string() }} ) as result
    , cast(cr.resultsreporteddatetime as date) as result_date
    , cast(coalesce(cr.observationdatetime, cr.specimenreceiveddatetime ) as date) as collection_date
    , cast(cro.observationunits as {{ dbt.type_string() }} ) as source_units
    , cast(null as {{ dbt.type_string() }} ) as normalized_units
    , cast(cro.referencerange as {{ dbt.type_string() }} ) as source_reference_range_low  -- additional logic here?
    , cast(cro.referencerange as {{ dbt.type_string() }} ) as source_reference_range_high -- additional logic here?
    , cast(null as {{ dbt.type_string() }} ) as normalized_reference_range_low
    , cast(null as {{ dbt.type_string() }} ) as normalized_reference_range_high
    , cast(cr.resultcategoryname as {{ dbt.type_string() }} ) as source_abnormal_flag
    , cast(null as {{ dbt.type_string() }} ) as normalized_abnormal_flag
    , cast(cr.specimensource as {{ dbt.type_string() }} ) as specimen
    , cast(null as {{ dbt.type_string() }} ) as ordering_practitioner_id
    , cast('athena.' || cro.contextname as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime
from {{ source('athena','CLINICALRESULTOBSERVATION') }} as cro
inner join  {{ source('athena','CLINICALRESULT') }} as cr
    on cro.clinicalresultid = cr.clinicalresultid and cro.contextid = cr.contextid
inner join {{ source('athena','DOCUMENT' ) }} as d
    on cr.documentid = d.documentid and cr.contextid = d.contextid
inner join {{ source('athena','PATIENT' ) }} as p
    on d.patientid = p.patientid and d.contextid = p.contextid
left join {{ source('athena','LOINC' ) }} as l
    on cro.loincid = l.loincid and cro.contextid = l.contextid
left join {{ source('athena', 'CLINICALORDERTYPE' ) }} as crcot
    on cr.clinicalordertypeid = crcot.clinicalordertypeid
left join {{ ref('terminology__loinc') }} as crcotl
    on crcot.loinc = crcotl.loinc
left join {{ source('athena','LOCALCLINICALLABTEMPLATELIST') }} as lcltl
    on cro.localclinicallabtemplatelistid = lcltl.localclinicallabtemplatelistid and cro.contextid = lcltl.contextid
left join {{ source('athena','LOCALCLINICALLABTEMPLATE') }} as lclt
    on lcltl.localclinicallabtemplateid = lclt.localclinicallabtemplateid and lcltl.contextid =lclt.contextid
left join {{ source('athena', 'CLINICALORDERTYPE' ) }} as lcltcot
    on lclt.clinicalordertypeid = lcltcot.clinicalordertypeid
left join {{ ref('terminology__loinc') }} as lcltcotl
    on lcltcot.loinc = lcltcotl.loinc
where cr.clinicalordertypegroup = 'LAB'
and cro.deletedby is null and cro.deleteddatetime is null
and d.deleteddatetime is null and d.deletedby is null and  d.STATUS <> 'DELETED'