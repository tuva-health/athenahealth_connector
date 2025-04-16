select
    contextid
    , contextname
    , procedurecode
    , procedurecodedescription
    , createddatetime
    , deleteddatetime
    , lastmodifieddatetime,

from {{ source('athena','PROCEDURECODE' ) }}
where deleteddatetime is null
