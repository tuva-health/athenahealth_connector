select
    contextid
    , localclinicallabtemplatelistid
    , localclinicallabtemplateid
    , name
from {{ source('athena','LOCALCLINICALLABTEMPLATELIST') }}
where deletedby is null and deleteddatetime is null
