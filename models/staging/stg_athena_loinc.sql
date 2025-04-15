select
    loinccode
    , l.longcommonname
    , loincid
    , contextid
from {{ source('athena','LOINC' ) }} as l
where not coalesce(isdeleted, false)
