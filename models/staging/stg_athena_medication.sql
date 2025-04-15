select
      contextid
    , medicationid
    , ndc
    , rxnorm
    , fdbmedid
    , medicationname
from {{ source('athena','MEDICATION') }}
where not coalesce(isdeleted, false)
