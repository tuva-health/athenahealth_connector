select
      cast(dd.contextid as {{ dbt.type_string() }} ) || '.doc_diag.' || cast(dd.documentdiagnosisid as {{ dbt.type_string() }} ) as condition_id --event id?
    , cast(dd.contextid as {{ dbt.type_string() }} ) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as person_id
    , cast(dd.contextid as {{ dbt.type_string() }} ) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as patient_id
    , cast(dd.contextid as {{ dbt.type_string() }} ) || '.' || cast(dd.clinicalencounterid as {{ dbt.type_string() }} ) as encounter_id
    , cast(null as {{ dbt.type_string() }} ) as claim_id
    , cast(dd.createddatetime as date) as recorded_date
    , cast(null as date) as onset_date
    , cast(null as date) as resolved_date
    , cast(null as {{ dbt.type_string() }} ) as status
    , cast('document' as {{ dbt.type_string() }} ) as condition_type
    , cast('snomed-ct' as {{ dbt.type_string() }} ) as source_code_type
    , cast(dd.snomedcode as {{ dbt.type_string() }} ) as source_code
    , cast(null as {{ dbt.type_string() }} ) as source_description
    , cast(null as {{ dbt.type_string() }} ) as normalized_code_type
    , cast(null as {{ dbt.type_string() }} ) as normalized_code
    , cast(null as {{ dbt.type_string() }} ) as normalized_description
    , cast(null as {{ dbt.type_int() }} ) as condition_rank
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_code
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_description
    , cast('athena.' || dd.contextname as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
--    , cast(dd.lastdatasyncdt as {{ dbt.type_timestamp() }} ) as ingest_datetime
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime
-- select top 100 *
from {{source('athena','DOCUMENTDIAGNOSIS')}} as dd
inner join  {{source('athena','DOCUMENT')}} as d
    on dd.documentid = d.documentid and dd.contextid = d.contextid
inner join  {{source('athena','CHART')}} as c
    on d.chartid = c.chartid and dd.contextid = c.contextid
where dd.deleteddatetime is null and dd.deletedby is null
and d.deleteddatetime is null and d.deletedby is null and  d.STATUS <> 'DELETED'
