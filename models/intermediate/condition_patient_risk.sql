select
      cast(prc.contextid as {{ dbt.type_string() }} ) || '.pat_risk.' || cast(prc.patientriskconditionid as {{ dbt.type_string() }} ) as condition_id --event id?
    , cast(prc.contextid as {{ dbt.type_string() }} ) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }} ) as person_id
    , cast(prc.contextid as {{ dbt.type_string() }} ) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }} ) as patient_id
    , cast(null as {{ dbt.type_string() }} ) as encounter_id
    , cast(null as {{ dbt.type_string() }} ) as claim_id
    , cast(prc.createddatetime as date) as recorded_date
    , cast(null as date) as onset_date
    , cast(null as date) as resolved_date
    , cast(rcsn.state as {{ dbt.type_string() }} ) as status
    , cast('risk' as {{ dbt.type_string() }} ) as condition_type
    , cast('icd-10-cm' as {{ dbt.type_string() }} ) as source_code_type
    , cast(prc.icdcode as {{ dbt.type_string() }} ) as source_code
    , cast(null as {{ dbt.type_string() }} ) as source_description
    , cast(null as {{ dbt.type_string() }} ) as normalized_code_type
    , cast(null as {{ dbt.type_string() }} ) as normalized_code
    , cast(null as {{ dbt.type_string() }} ) as normalized_description
    , cast(null as {{ dbt.type_int() }} ) as condition_rank
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_code
    , cast(null as {{ dbt.type_string() }} ) as present_on_admit_description
    , cast('athena.'|| prc.contextname as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime
-- select top 100 *
from {{source('athena','dataview_imports__patientriskcondition__v1') }} as prc
left join {{ source('athena','dataview_imports__riskconditionstatename__v1') }} as rcsn
    on prc.riskconditionstatenameid = rcsn.riskconditionstatenameid and prc.contextid = rcsn.contextid
left join {{source('athena','dataview_imports__patient__v1') }} p
    on prc.patientid = p.patientid and prc.contextid = p.contextid
where prc.deleteddatetime is null and prc.deletedby is null
