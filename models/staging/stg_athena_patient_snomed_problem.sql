
select p.contextid
     , p.contextname
     , p.contextparentcontextid
     , p.patientsnomedproblemid
     , p.snomedcode
     , p.status
     , p.resolutionplan
     , p.laterality
     , p.severity
     , p.startdatedatetime
     , p.startdatemask
     , p.enddatedatetime
     , p.endedby
     , p.problemnote
     , p.source
     , p.chartid
     , p.problemlistid
     , p.entereddatetime
     , p.enteredby
     , p.hiddendatetime
     , p.hiddennote
     , p.hiddenby
     , p.versiontoken
     , p.deleteddatetime
     , p.deletedby
     , p.createddatetime
     , p.createdby
     , p.lastmodifieddatetime
     , p.lastmodifiedby
     , p.lastupdated
from {{ source('athena','PATIENTSNOMEDPROBLEM') }} as p
where p.deleteddatetime is null and p.deletedby is null
