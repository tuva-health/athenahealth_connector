select p.contextid
     , p.contextname
     , p.contextparentcontextid
     , p.patientsnomedicd10id
     , p.snomedcode
     , p.icdcodeallid
     , p.chartid
     , p.clinicalencounterid
     , p.deleteddatetime
     , p.deletedby
     , p.createddatetime
     , p.createdby
     , p.lastmodifieddatetime
     , p.lastmodifiedby
     , p.lastupdated

from {{ source('athena','PATIENTSNOMEDICD10') }} as p
where p.deleteddatetime is null and p.deletedby is null
