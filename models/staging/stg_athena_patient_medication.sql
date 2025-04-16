select
      pm.contextid
    , pm.patientmedicationid
    , pm.filldate
    , pm.dosageroute
    , pm.dosagestrength
    , pm.dosagequantity
    , pm.displaydosageunits
    , pm.lengthofcourse
    , pm.contextname
    , pm.medicationtype
    , pm.chartid
    , pm.medicationid
    , pm.documentid
from {{ source('athena','PATIENTMEDICATION') }} as pm
where pm.deactivatedby is null and pm.deleteddatetime is null
