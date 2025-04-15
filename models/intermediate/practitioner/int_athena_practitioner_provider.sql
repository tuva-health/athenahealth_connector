select
      cast(p.contextid || '.prov.' || p.providerid as {{ dbt.type_string() }}) as practitioner_id
    , cast(p.providernpinumber as {{ dbt.type_string() }}) as npi
    , cast(p.providerfirstname as {{ dbt.type_string() }}) as first_name
    , cast(p.providerlastname as {{ dbt.type_string() }}) as last_name
    , cast(null as {{ dbt.type_string() }}) as practice_affiliation
    , cast(p.specialty as {{ dbt.type_string() }}) as specialty
    , cast(null as {{ dbt.type_string() }}) as sub_specialty
    , cast('athena.' || p.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime
    , p.providertype as credentials
    , '{{ dbt_utils.pretty_time(format="%Y-%m-%d %H:%M:%S") }}' as tuva_last_run
from {{ ref('stg_athena_provider') }} as p
