select
      cast(psi.contextid as {{ dbt.type_string() }} ) || '.pat_sno_icd.' || cast(psi.patientsnomedicd10id as {{ dbt.type_string() }} ) as condition_id --event id?
    , cast(psi.contextid as {{ dbt.type_string() }} ) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as person_id
    , cast(psi.contextid as {{ dbt.type_string() }} ) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as patient_id
    , cast(null as {{ dbt.type_string() }} ) as encounter_id
    , cast(null as {{ dbt.type_string() }} ) as claim_id
    , cast(psi.createddatetime as date) as recorded_date
    , cast(null as date) as onset_date
    , cast(null as date) as resolved_date
    , cast(null as {{ dbt.type_string() }} ) as status
    , cast('pat_sno_icd' as {{ dbt.type_string() }} ) as condition_type
    , cast('icd-10-cm' as {{ dbt.type_string() }} ) as source_code_type
    , cast(i.diagnosiscode as {{ dbt.type_string() }} ) as source_code
    , cast(i.diagnosiscodedescription as {{ dbt.type_string() }} ) as source_description
    , cast(null as {{ dbt.type_string() }} ) as normalized_code_type
    , cast(null as {{ dbt.type_string() }} ) as normalized_code
    , cast(null as {{ dbt.type_string() }} ) as normalized_description
    , cast(null as {{ dbt.type_int() }} ) as condition_rank
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_code
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_description
    , cast('athena.' || psi.contextname as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime
-- select top 100 *
from {{source('athena','PATIENTSNOMEDICD10')}}  psi
inner join {{source('athena','CHART')}} as c
    on psi.chartid = c.chartid and psi.contextid = c.contextid
inner join {{source('athena','ICDCODEALL')}} as i
    on psi.icdcodeallid = i.icdcodeid and psi.contextid = i.contextid
where psi.deletedby is null and psi.deleteddatetime is null

