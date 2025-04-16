select
       i.contextid
     , i.contextname
     , i.contextparentcontextid
     , i.icdcodeid
     , i.diagnosiscode
     , i.diagnosiscodedescription
     , i.parentdiagnosiscode
     , i.diagnosiscodeset
     , i.codeclass
     , i.diagnosiscodegroup
     , i.subcategory
     , i.effectivedate
     , i.expirationdate
     , i.unstrippeddiagnosiscode
     , i.lastupdated
     , i.diagnosiscodesetid
     , i.isdeleted

from {{ source('athena','ICDCODEALL') }} as i
where not i.isdeleted
