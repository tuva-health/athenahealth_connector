select
      cast(p.contextid || '.clinprov.' || p.clinicalproviderid as {{ dbt.type_string() }}) as practitioner_id
    , cast(p.npi as {{ dbt.type_string() }}) as npi
    , cast(p.firstname as {{ dbt.type_string() }}) as first_name
    , cast(p.lastname as {{ dbt.type_string() }}) as last_name
    , cast(null as {{ dbt.type_string() }}) as practice_affiliation
    , cast(p.ansispecialtyid as {{ dbt.type_string() }}) as specialty
    , cast(null as {{ dbt.type_string() }}) as sub_specialty
    , cast('athena.' || p.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime
    , title as credentials
    , '{{ dbt_utils.pretty_time(format="%Y-%m-%d %H:%M:%S") }}' as tuva_last_run
from {{ ref('stg_athena_clinical_provider') }} as p
