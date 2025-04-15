select
      contextid
    , contextname
    , clinicalprescriptionid
    , lastfilldatedatetime
    , writtendatedatetime
    , ndc
    , labelname
    , dosageroute
    , dosagestrength
    , dosagequantity
    , displaydosageunits
    , dayssupply
    , documentid
from {{ source('athena','CLINICALPRESCRIPTION') }}
where deleteddatetime is null and deletedby is null
