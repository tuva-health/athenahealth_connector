select
    c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.chartsnomedicdid
     , c.chartsnomedicdeventid
     , c.ordering
     , c.icdcodeallid
     , c.deleteddatetime
     , c.deletedby
     , c.createddatetime
     , c.createdby
     , c.lastmodifieddatetime
     , c.lastmodifiedby
     , c.lastupdated

from {{ source('athena','CHARTSNOMEDICD') }} as c
where c.deleteddatetime is null and c.deletedby is null
