
select p.contextid
     , p.contextname
     , p.contextparentcontextid
     , p.patientproblemid
     , p.type
     , p.patientid
     , p.chartid
     , p.diagnosiscode
     , p.snomedcode
     , p.problemlistname
     , p.laterality
     , p.status
     , p.onsetdate
     , p.deactivateddatetime
     , p.deactivatedby
     , p.reactivateddatetime
     , p.reactivatedby
     , p.source
     , p.createddatetime
     , p.createdby
     , p.deleteddatetime
     , p.deletedby
     , p.lastmodifieddatetime
     , p.lastmodifiedby
     , p.note
     , p.lastupdated

from {{ source('athena','PATIENTPROBLEM') }} as p
where p.deleteddatetime is null and p.deletedby is null
