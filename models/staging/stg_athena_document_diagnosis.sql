
select d.contextid
     , d.contextname
     , d.contextparentcontextid
     , d.documentdiagnosisid
     , d.documentid
     , d.clinicalencounterid
     , d.clinicalencounterdxid
     , d.diagnosiscode
     , d.snomedcode
     , d.createddatetime
     , d.createdby
     , d.deleteddatetime
     , d.deletedby
     , d.lastupdated

from {{ source('athena','DOCUMENTDIAGNOSIS') }} as d
where d.deleteddatetime is null and d.deletedby is null
