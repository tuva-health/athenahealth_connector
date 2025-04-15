select
    contextid
    , departmentid
    , departmentname
    , contextname
    , departmentaddress
    , departmentcity
    , departmentstate
    , departmentzip
    , latitude
    , longitude
from {{ source('athena','DEPARTMENT') }}
where deletedby is null and deleteddatetime is null
