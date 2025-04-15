select
      contextid
    , contextname
    , encounterdataid
    , clinicalencounterid
    , key
    , createddatetime
    , displayvalue
    , value
    , displayunit
    , dbunit
from {{ source('athena','VITALSIGN') }} as v
where deletedby is null and deleteddatetime is null
