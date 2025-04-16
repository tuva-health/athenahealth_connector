select
      contextid
    , providerid
    , providernpinumber
    , providerfirstname
    , providerlastname
    , specialty
    , contextname
    , providertype
from {{ source('athena','PROVIDER') }}
where deletedby is null and deleteddatetime is null
