select
      cast(csi.contextid as {{ dbt.type_string() }} ) ||'.chart.' || cast(csi.chartsnomedicdid as {{ dbt.type_string() }} ) as condition_id --event id?
    , cast(csi.contextid as {{ dbt.type_string() }} ) ||'.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as person_id
    , cast(csi.contextid as {{ dbt.type_string() }} ) ||'.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as patient_id
    , cast(null as {{ dbt.type_string() }} ) as encounter_id
    , cast(null as {{ dbt.type_string() }} ) as claim_id
    , cast(csie.createddatetime as date) as recorded_date
    , cast(null as date) as onset_date
    , cast(null as date) as resolved_date
    , cast(null as {{ dbt.type_string() }} ) as status
    , cast('chart' as {{ dbt.type_string() }} ) as condition_type
    , cast('icd-10-cm' as {{ dbt.type_string() }} ) as source_code_type
    , cast(i.diagnosiscode as {{ dbt.type_string() }} ) as source_code
    , cast(i.diagnosiscodedescription as {{ dbt.type_string() }} ) as source_description
    , cast(null as {{ dbt.type_string() }} ) as normalized_code_type
    , cast(null as {{ dbt.type_string() }} ) as normalized_code
    , cast(null as {{ dbt.type_string() }} ) as normalized_description
    , cast(null as {{ dbt.type_int() }} ) as condition_rank
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_code
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_description
    , cast('athena.' || csi.contextname as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime
-- select top 100 *
from {{source('athena','CHARTSNOMEDICD')}} as csi
inner join  {{source('athena','CHARTSNOMEDICDEVENT')}} as csie
    on csi.chartsnomedicdeventid = csie.chartsnomedicdeventid and csi.contextid = csie.contextid
inner join {{source('athena','CHART')}} as c
    on csie.chartid = c.chartid and csi.contextid = c.contextid
inner join {{source('athena','ICDCODEALL')}} as i
    on csi.icdcodeallid = i.icdcodeid and csi.contextid = i.contextid
where csi.deletedby is null and csi.deleteddatetime is null

