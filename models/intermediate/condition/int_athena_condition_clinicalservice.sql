select
       cast(csd.contextid as {{ dbt.type_string() }}) || '.clinicalservice.' || cast(csd.clinicalservicediagnosisid as {{ dbt.type_string() }}) as condition_id --event id?
    , cast(csd.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as person_id
    , cast(csd.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as patient_id
    , cast(csd.contextid || '.' || ce.clinicalencounterid as {{ dbt.type_string() }}) as encounter_id
    , cast(null as {{ dbt.type_string() }}) as claim_id
    , cast(csd.createddatetime as date) as recorded_date
    , cast(null as date) as onset_date
    , cast(null as date) as resolved_date
    , cast(null as {{ dbt.type_string() }}) as status
    , cast('clinicalservice' as {{ dbt.type_string() }}) as condition_type
    , cast(case when csd.diagnosiscodeset = 'ICD10' then 'icd-10-cm'
                when csd.diagnosiscodeset = 'ICD9' then 'icd-9-cm' end as {{ dbt.type_string() }}) as source_code_type
    , cast(csd.diagnosiscode as {{ dbt.type_string() }}) as source_code
    , cast(null as {{ dbt.type_string() }}) as source_description
    , cast(null as {{ dbt.type_string() }}) as normalized_code_type
    , cast(null as {{ dbt.type_string() }}) as normalized_code
    , cast(null as {{ dbt.type_string() }}) as normalized_description
    , cast(csd.ordering as {{ dbt.type_int() }}) + 1 as condition_rank
    , cast(null as {{ dbt.type_string() }}) as present_on_admit_code
    , cast(null as {{ dbt.type_string() }}) as present_on_admit_description
    , cast('athena.' || csd.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime

from {{ ref('stg_athena_clinical_service_diagnosis') }} as csd
inner join {{ ref('stg_athena_clinical_service_procedure_code') }} as cspc
    on csd.clinicalserviceproccodeid = cspc.clinicalserviceproccodeid and csd.contextid = cspc.contextid
inner join {{ ref('stg_athena_clinical_service') }} as cs
    on cs.clinicalserviceid = cspc.clinicalserviceid and cs.contextid = cspc.contextid
inner join {{ ref('stg_athena_clinical_encounter') }} as ce
    on cs.clinicalencounterid = ce.clinicalencounterid and cs.contextid = ce.contextid
inner join {{ ref('stg_athena_patient') }} as p
    on ce.patientid = p.patientid and cs.contextid = p.contextid
where cspc.procedurecode is not null
