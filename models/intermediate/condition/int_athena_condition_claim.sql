select
      cast(cd.contextid as {{ dbt.type_string() }}) || '.claim.' || cast(cd.claimdiagnosisid as {{ dbt.type_string() }}) as condition_id --event id?
    , cast(cd.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as person_id
    , cast(cd.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as patient_id
    , cast(null as {{ dbt.type_string() }}) as encounter_id
    , cast(c.claimid as {{ dbt.type_string() }}) as claim_id
    , cast(cd.createddatetime as date) as recorded_date
    , cast(null as date) as onset_date
    , cast(null as date) as resolved_date
    , cast(null as {{ dbt.type_string() }}) as status
    , cast('claimcharge' as {{ dbt.type_string() }}) as condition_type
    , cast(case when cd.diagnosiscodesetname = 'ICD10' then 'icd-10-cm'
                when cd.diagnosiscodesetname = 'ICD9' then 'icd-9-cm' end as {{ dbt.type_string() }}) as source_code_type
    , cast(cd.diagnosiscode as {{ dbt.type_string() }}) as source_code
    , cast(i.diagnosiscodedescription as {{ dbt.type_string() }}) as source_description
    , cast(null as {{ dbt.type_string() }}) as normalized_code_type
    , cast(null as {{ dbt.type_string() }}) as normalized_code
    , cast(null as {{ dbt.type_string() }}) as normalized_description
    , cast(cd.sequencenumber as {{ dbt.type_int() }}) as condition_rank
    , cast(null as {{ dbt.type_string() }}) as present_on_admit_code
    , cast(null as {{ dbt.type_string() }}) as present_on_admit_description
    , cast('athena.' || cd.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime

from {{ ref('stg_athena_claim_diagnosis') }} as cd
inner join {{ ref('stg_athena_claim') }} as c
    on cd.claimid = c.claimid and cd.contextid = c.contextid
inner join {{ ref('stg_athena_patient') }} as p
    on c.patientid = p.patientid and cd.contextid = p.contextid
left outer join {{ ref('stg_athena_icd_code_all') }} as i
    on cd.icdcodeid = i.icdcodeid and cd.contextid = i.contextid
