
select c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.claimdiagnosisid
     , c.claimid
     , c.icdcodeid
     , c.diagnosiscode
     , c.sequencenumber
     , c.diagnosiscodesetname
     , c.createddatetime
     , c.createdby
     , c.deleteddatetime
     , c.deletedby
     , c.lastupdated

from {{ source('athena','CLAIMDIAGNOSIS') }} as c
where c.deletedby is not null and c.deleteddatetime is not null
