select
     c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.chartsnomedicdeventid
     , c.eventauthor
     , c.eventsourceid
     , c.snomedcode
     , c.eventtimestampdatetime
     , c.chartid
     , c.eventsource
     , c.deleteddatetime
     , c.deletedby
     , c.createddatetime
     , c.createdby
     , c.lastmodifieddatetime
     , c.lastmodifiedby
     , c.lastupdated

from {{ source('athena','CHARTSNOMEDICDEVENT') }} as c
where c.deleteddatetime is null and c.deletedby is null
