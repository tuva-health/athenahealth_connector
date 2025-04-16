
select c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.clinicalencounterdxicd10id
     , c.clinicalencounterdxid
     , c.icdcodeid
     , c.ordering
     , c.deleteddatetime
     , c.deletedby
     , c.createddatetime
     , c.createdby
     , c.lastupdated

from {{ source('athena','CLINICALENCOUNTERDXICD10') }} as c
where c.deleteddatetime is null and c.deletedby is null
and c.icdcodeid <> -1
