select
    contextid
    , contextname
    , visitchargeid
    , fromdatedatetime
    , procedurecode
    , providerid
    , visitid
    , deletedby
    , deleteddatetime

from {{ source('athena', 'VISITCHARGE') }}
where deletedby is null and deleteddatetime is null
