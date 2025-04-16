select
      cast(cro.contextid || '.' || cro.clinicalobservationid as {{ dbt.type_string() }}) as lab_result_id
    , cast(cro.contextid || '.' || p.enterpriseid as {{ dbt.type_string() }}) as person_id
    , cast(cro.contextid || '.' || p.enterpriseid as {{ dbt.type_string() }}) as patient_id
    , cast(d.contextid as {{ dbt.type_string() }}) || '.' || cast(d.clinicalencounterid as {{ dbt.type_string() }}) as encounter_id
    , cast(cr.externalaccessionidentifier as {{ dbt.type_string() }}) as accession_number
    , cast(case when l.loinccode is not null then 'loinc'
                when cro.observationidentifierloinc is not null then 'loinc'
                when crcotl.loinc is not null and crcotl.class_code not like '%PANEL%' and crcotl.paneltype = '' then 'loinc'
                when lcltcotl.loinc is not null and lcltcotl.class_code not like '%PANEL%' and lcltcotl.paneltype = '' then 'loinc'
                when lcltl.localclinicallabtemplatelistid is not null then 'athena-template-list-id'
                when cro.observationidentifiertext is not null then 'athena-observation-identifier-text'
                when cro.templateanalytename is not null then 'athena-template-analyte-name'
                end as {{ dbt.type_string() }}) as source_code_type
    , cast(case when l.loinccode is not null then l.loinccode
                when cro.observationidentifierloinc is not null then cro.observationidentifierloinc
                when crcotl.loinc is not null and crcotl.class_code not like '%PANEL%' and crcotl.paneltype = '' then crcotl.loinc
                when lcltcotl.loinc is not null and lcltcotl.class_code not like '%PANEL%' and lcltcotl.paneltype = '' then lcltcotl.loinc
                when lcltl.localclinicallabtemplatelistid is not null then cast(lcltl.localclinicallabtemplatelistid as {{ dbt.type_string() }})
                end as {{ dbt.type_string() }}) as source_code
    , cast(case when l.loinccode is not null then l.longcommonname
                when cro.observationidentifierloinc is not null then cro.observationidentifiertext
                when crcotl.loinc is not null and crcotl.class_code not like '%PANEL%' and crcotl.paneltype = '' then 'loinc'
                when lcltcotl.loinc is not null and lcltcotl.class_code not like '%PANEL%' and lcltcotl.paneltype = '' then 'loinc'
                when lcltl.localclinicallabtemplatelistid is not null then coalesce(lcltcot.name || ' - ', '') || lcltl.name
                else coalesce(crcot.name || ' - ', '') || coalesce(cro.observationidentifiertext, cro.templateanalytename) end
            as {{ dbt.type_string() }}) as source_description
    , cast(null as {{ dbt.type_string() }}) as source_component
    , cast(null as {{ dbt.type_string() }}) as normalized_code_type
    , cast(null as {{ dbt.type_string() }}) as normalized_code
    , cast(null as {{ dbt.type_string() }}) as normalized_description
    , cast(null as {{ dbt.type_string() }}) as normalized_component
    , cast(cro.resultstatus as {{ dbt.type_string() }}) as status
    , cast(coalesce(cro.result, cro.plcobservationvalue, cro.observationnote) as {{ dbt.type_string() }}) as result
    , cast(cr.resultsreporteddatetime as date) as result_date
    , cast(coalesce(cr.observationdatetime, cr.specimenreceiveddatetime) as date) as collection_date
    , cast(cro.observationunits as {{ dbt.type_string() }}) as source_units
    , cast(null as {{ dbt.type_string() }}) as normalized_units
    , cast(cro.referencerange as {{ dbt.type_string() }}) as source_reference_range_low
    , cast(cro.referencerange as {{ dbt.type_string() }}) as source_reference_range_high
    , cast(null as {{ dbt.type_string() }}) as normalized_reference_range_low
    , cast(null as {{ dbt.type_string() }}) as normalized_reference_range_high
    , cast(cr.resultcategoryname as {{ dbt.type_string() }}) as source_abnormal_flag
    , cast(null as {{ dbt.type_string() }}) as normalized_abnormal_flag
    , cast(cr.specimensource as {{ dbt.type_string() }}) as specimen
    , cast(null as {{ dbt.type_string() }}) as ordering_practitioner_id
    , cast('athena.' || cro.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime
from {{ ref('stg_athena_clinical_result_observation') }} as cro
inner join {{ ref('stg_athena_clinical_result') }} as cr
    on cro.clinicalresultid = cr.clinicalresultid and cro.contextid = cr.contextid
inner join {{ ref('stg_athena_document') }} as d
    on cr.documentid = d.documentid and cr.contextid = d.contextid
inner join {{ ref('stg_athena_patient') }} as p
    on d.patientid = p.patientid and d.contextid = p.contextid
left outer join {{ ref('stg_athena_loinc') }} as l
    on cro.loincid = l.loincid and cro.contextid = l.contextid
left outer join {{ ref('stg_athena_clinical_order_type') }} as crcot
    on cr.clinicalordertypeid = crcot.clinicalordertypeid
left outer join {{ ref('terminology__loinc') }} as crcotl
    on crcot.loinc = crcotl.loinc
left outer join {{ ref('stg_athena_local_clinical_lab_template_list') }} as lcltl
    on cro.localclinicallabtemplatelistid = lcltl.localclinicallabtemplatelistid and cro.contextid = lcltl.contextid
left outer join {{ ref('stg_athena_local_clinical_lab_template') }} as lclt
    on lcltl.localclinicallabtemplateid = lclt.localclinicallabtemplateid and lcltl.contextid = lclt.contextid
left outer join {{ ref('stg_athena_local_clinical_order_type') }} as lcltcot
    on lclt.clinicalordertypeid = lcltcot.clinicalordertypeid
left outer join {{ ref('terminology__loinc') }} as lcltcotl
    on lcltcot.loinc = lcltcotl.loinc
where cr.clinicalordertypegroup = 'LAB'
and d.status is distinct from 'DELETED'
