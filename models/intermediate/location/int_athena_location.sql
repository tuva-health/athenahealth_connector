select
      cast(d.contextid as {{ dbt.type_string() }}) || '.' || cast(d.departmentid as {{ dbt.type_string() }}) as location_id
    , cast(null as {{ dbt.type_string() }}) as npi
    , cast(d.departmentname as {{ dbt.type_string() }}) as name
    , cast(null as {{ dbt.type_string() }}) as facility_type
    , cast(d.contextname as {{ dbt.type_string() }}) as parent_organization
    , cast(d.departmentaddress as {{ dbt.type_string() }}) as address
    , cast(d.departmentcity as {{ dbt.type_string() }}) as city
    , cast(d.departmentstate as {{ dbt.type_string() }}) as state
    , cast(d.departmentzip as {{ dbt.type_string() }}) as zip_code
    , cast(d.latitude as {{ dbt.type_float() }}) as latitude
    , cast(d.longitude as {{ dbt.type_float() }}) as longitude
    , cast(d.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime
from {{ ref('stg_athena_department') }} as d
