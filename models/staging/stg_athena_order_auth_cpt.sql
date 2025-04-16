select
    contextid
    , orderauthid
    , orderauthcptid
    , procedurecode
    , contextname
from {{ source('athena','ORDERAUTHCPT') }}
where deletedby is null and deleteddatetime is null
