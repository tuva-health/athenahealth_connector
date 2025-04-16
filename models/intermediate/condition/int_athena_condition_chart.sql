select
      cast(csi.contextid as {{ dbt.type_string() }}) || '.chart.' || cast(csi.chartsnomedicdid as {{ dbt.type_string() }}) as condition_id
    , cast(csi.contextid as {{ dbt.type_string() }}) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }}) as person_id
    , cast(csi.contextid as {{ dbt.type_string() }}) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }}) as patient_id
    , cast(null as {{ dbt.type_string() }}) as encounter_id
    , cast(null as {{ dbt.type_string() }}) as claim_id
    , cast(csie.createddatetime as date) as recorded_date
    , cast(null as date) as onset_date
    , cast(null as date) as resolved_date
    , cast(null as {{ dbt.type_string() }}) as status
    , cast('chart' as {{ dbt.type_string() }}) as condition_type
    , cast('icd-10-cm' as {{ dbt.type_string() }}) as source_code_type
    , cast(ica.diagnosiscode as {{ dbt.type_string() }}) as source_code
    , cast(ica.diagnosiscodedescription as {{ dbt.type_string() }}) as source_description
    , cast(null as {{ dbt.type_string() }}) as normalized_code_type
    , cast(null as {{ dbt.type_string() }}) as normalized_code
    , cast(null as {{ dbt.type_string() }}) as normalized_description
    , cast(null as {{ dbt.type_int() }}) as condition_rank
    , cast(null as {{ dbt.type_string() }}) as present_on_admit_code
    , cast(null as {{ dbt.type_string() }}) as present_on_admit_description
    , cast('athena.' || csi.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime

from {{ ref('stg_athena_chart_snomed_icd') }} as csi
inner join {{ ref('stg_athena_chart_snomed_icd_event') }} as csie
    on csi.chartsnomedicdeventid = csie.chartsnomedicdeventid and csi.contextid = csie.contextid
inner join {{ ref('stg_athena_chart') }} as c
    on csie.chartid = c.chartid and csi.contextid = c.contextid
inner join {{ ref('stg_athena_icd_code_all') }} as ica
    on csi.icdcodeallid = ica.icdcodeid and csi.contextid = ica.contextid
