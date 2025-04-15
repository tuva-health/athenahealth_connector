select
    contextid
    , patientid
    , visitid
    , deletedby
    , deleteddatetime
from {{ source('athena','VISIT') }}
where deletedby is null and deleteddatetime is null
