
select
      contextid
    , clinicalresultid
    , documentid
    , clinicalordertypegroup
    , clinicalordertypeid
    , externalaccessionidentifier
    , resultsreporteddatetime
    , observationdatetime
    , specimenreceiveddatetime
    , resultcategoryname
    , specimensource
from {{ source('athena','CLINICALRESULT') }}
where deletedby is null and deleteddatetime is null
