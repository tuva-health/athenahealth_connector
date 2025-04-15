select
      contextid
    , localclinicallabtemplateid
    , clinicalordertypeid
from {{ source('athena','LOCALCLINICALLABTEMPLATE') }}
where deletedby is null and deleteddatetime is null
