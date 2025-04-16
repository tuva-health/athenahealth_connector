
select c.contextid
     , c.contextname
     , c.contextparentcontextid
     , c.clinicalordertypeid
     , c.parentclinicalordertypeid
     , c.clinicalordertypegroupid
     , c.clinicalordergenusid
     , c.ordercodetype
     , c.ordercode
     , c.detailordercodetype
     , c.detailordercode
     , c.detailname
     , c.subcategoryname
     , c.name
     , c.plcname
     , c.description
     , c.displayquantityunits
     , c.orderableflag
     , c.defaultalarmdays
     , c.defaultpriority
     , c.ordering
     , c.ordertypeclass
     , c.incomingdocumentclass
     , c.panelyn
     , c.compounddeaschedule
     , c.discontinueddatetime
     , c.replacedbyid
     , c.loinc
     , c.documentsubclass
     , c.forpainyn
     , c.deleteddatetime
     , c.deletedby
     , c.createddatetime
     , c.createdby
     , c.lastmodifieddatetime
     , c.lastmodifiedby
     , c.lastupdated

from {{ source('athena', 'CLINICALORDERTYPE' ) }} as c
where c.deleteddatetime is null and c.deletedby is null
