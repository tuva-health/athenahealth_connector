
select c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.clinicalservicediagnosisid
     , c.clinicalserviceproccodeid
     , c.diagnosiscode
     , c.diagnosiscodeset
     , c.ordering
     , c.createddatetime
     , c.createdby
     , c.deleteddatetime
     , c.deletedby
     , c.lastupdated

from {{ source('athena','CLINICALSERVICEDIAGNOSIS') }} as c
where c.deletedby is null and c.deleteddatetime is null
