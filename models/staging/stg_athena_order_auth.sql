select
    contextid
    , orderauthid
    , proceduredatedatetime
    , documentid
from {{ source('athena','ORDERAUTH') }}
where deletedby is null and deleteddatetime is null
