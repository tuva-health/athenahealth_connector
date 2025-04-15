select
      contextid
    , clinicalproviderid
    , npi
    , firstname
    , lastname
    , ansispecialtyid
    , contextname
    , title
from {{ source('athena','CLINICALPROVIDER') }}
where deleteddatetime is null and not coalesce(isdeleted, false)
