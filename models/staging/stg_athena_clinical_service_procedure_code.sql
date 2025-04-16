
select c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.clinicalserviceproccodeid
     , c.clinicalserviceid
     , c.procedurecode
     , c.units
     , c.billforserviceyn
     , c.ordering
     , c.createddatetime
     , c.createdby
     , c.deleteddatetime
     , c.deletedby
     , c.lastupdated

from {{ source('athena','CLINICALSERVICEPROCEDURECODE') }} as c
where c.deleteddatetime is null and c.deletedby is null
