select
      contextid
    , clinicalordertypeid
    , loinc
    , name
from {{ source('athena', 'CLINICALORDERTYPE' ) }}
where deletedby is null and deleteddatetime is null
