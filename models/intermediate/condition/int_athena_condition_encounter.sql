select
      cast(ced.contextid as {{ dbt.type_string() }}) || '.enc.' || cast(ceicd.clinicalencounterdxicd10id as {{ dbt.type_string() }}) as condition_id --event id?
    , cast(ced.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as person_id
    , cast(ced.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as patient_id
    , cast(ced.contextid as {{ dbt.type_string() }}) || '.' || cast(ce.clinicalencounterid as {{ dbt.type_string() }}) as encounter_id
    , cast(null as {{ dbt.type_string() }}) as claim_id
    , cast(ce.createddatetime as date) as recorded_date
    , cast(null as date) as onset_date
    , cast(null as date) as resolved_date
    , cast(null as {{ dbt.type_string() }}) as status
    , cast('encounter' as {{ dbt.type_string() }}) as condition_type
    , cast('icd-10-cm' as {{ dbt.type_string() }}) as source_code_type
    , cast(i.diagnosiscode as {{ dbt.type_string() }}) as source_code
    , cast(i.diagnosiscodedescription as {{ dbt.type_string() }}) as source_description
    , cast(null as {{ dbt.type_string() }}) as normalized_code_type
    , cast(null as {{ dbt.type_string() }}) as normalized_code
    , cast(null as {{ dbt.type_string() }}) as normalized_description
    , cast(null as {{ dbt.type_int() }}) as condition_rank
    , cast(null as {{ dbt.type_string() }}) as present_on_admit_code
    , cast(null as {{ dbt.type_string() }}) as present_on_admit_description
    , cast('athena.' || ce.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime

from {{ ref('stg_athena_clinical_encounter') }} as ce
inner join {{ ref('stg_athena_patient') }} as p
    on ce.patientid = p.patientid and ce.contextid = p.contextid
inner join {{ ref('stg_athena_clinical_encounter_diagnosis') }} as ced
    on ce.clinicalencounterid = ced.clinicalencounterid and ce.contextid = ced.contextid
inner join {{ ref('stg_athena_clinical_encounter_dx_icd10') }} as ceicd
    on ced.clinicalencounterdxid = ceicd.clinicalencounterdxid and ce.contextid = ceicd.contextid
inner join {{ ref('stg_athena_icd_code_all') }} as i
    on ceicd.icdcodeid = i.icdcodeid and ce.contextid = i.contextid
