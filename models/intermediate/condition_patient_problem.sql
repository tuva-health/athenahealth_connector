select
      cast(pp.contextid as {{ dbt.type_string() }} ) || '.pat_prob.' || cast(pp.PATIENTPROBLEMID as {{ dbt.type_string() }} ) as condition_id --event id?
    , cast(pp.contextid as {{ dbt.type_string() }} ) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as person_id
    , cast(pp.contextid as {{ dbt.type_string() }} ) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as patient_id
    , cast(null as {{ dbt.type_string() }} ) as encounter_id
    , cast(null as {{ dbt.type_string() }} ) as claim_id
    , cast(pp.createddatetime as date) as recorded_date
    , cast(pp.onsetdate as date) as onset_date
    , cast(null as date) as resolved_date
    , cast(pp.status as {{ dbt.type_string() }} ) as status
    , cast('problem' as {{ dbt.type_string() }} ) as condition_type
    , cast('snomed-ct' as {{ dbt.type_string() }} ) as source_code_type
    , cast(pp.snomedcode as {{ dbt.type_string() }} ) as source_code
    , cast(null as {{ dbt.type_string() }} ) as source_description
    , cast(null as {{ dbt.type_string() }} ) as normalized_code_type
    , cast(null as {{ dbt.type_string() }} ) as normalized_code
    , cast(null as {{ dbt.type_string() }} ) as normalized_description
    , cast(null as {{ dbt.type_int() }} ) as condition_rank
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_code
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_description
    , cast('athena.' || pp.contextname  as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime
--select top 100 *
from {{source('athena','PATIENTPROBLEM')}} pp
left join {{source('athena','CHART')}} c
    on pp.chartid = c.chartid and pp.contextid = c.contextid
where pp.deleteddatetime is null and pp.deactivateddatetime is null
