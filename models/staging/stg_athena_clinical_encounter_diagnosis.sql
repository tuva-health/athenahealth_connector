
select c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.clinicalencounterdxid
     , c.clinicalencounterid
     , c.diagnosiscode
     , c.snomedcode
     , c.status
     , c.laterality
     , c.note
     , c.ordering
     , c.deleteddatetime
     , c.deletedby
     , c.createddatetime
     , c.createdby
     , c.lastupdated

from {{ source('athena','CLINICALENCOUNTERDIAGNOSIS') }} as c
where c.deleteddatetime is null and c.deletedby is null
