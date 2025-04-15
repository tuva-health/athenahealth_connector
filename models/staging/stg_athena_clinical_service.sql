select c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.clinicalserviceid
     , c.clinicalencounterid
     , c.documentid
     , c.type
     , c.source
     , c.ordering
     , c.singletonprocedurecodename
     , c.createddatetime
     , c.createdby
     , c.deleteddatetime
     , c.deletedby
     , c.lastupdated

from {{ source('athena','CLINICALSERVICE') }} as c
where c.deleteddatetime is null and c.deletedby is null
