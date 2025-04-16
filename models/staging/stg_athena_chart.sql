select c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.chartid
     , c.enterpriseid
     , c.newchartid
     , c.chartsharinggroupid
     , c.createddatetime
     , c.createdby
     , c.deleteddatetime
     , c.deletedby
     , c.lastupdated

from {{ source('athena','CHART') }} as c
where c.deleteddatetime is null and c.deletedby is null
