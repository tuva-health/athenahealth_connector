select
      cast(vs.contextid as {{ dbt.type_string() }}) || '.vital.' || cast(vs.encounterdataid as {{ dbt.type_string() }}) || '.' || cast(vs.clinicalencounterid as {{ dbt.type_string() }}) || '.' || cast(vs.key as {{ dbt.type_string() }}) as observation_id
    , cast(vs.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as person_id
    , cast(vs.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as patient_id
    , cast(vs.contextid as {{ dbt.type_string() }}) || '.' || cast(vs.clinicalencounterid as {{ dbt.type_string() }}) as encounter_id
    , cast(case
    when length(regexp_replace(vs.key, '[^.]*', '')) < 2 then vs.key
    {% if target.type == 'snowflake' %}
    else substring(vs.key, 0, position('.', vs.key, position('.', vs.key) + 1) - 1)
    {% elif target.type == 'bigquery' %}
    else concat(split(vs.key, '.')[safe_offset(0)], '.', split(vs.key, '.')[safe_offset(1)])
    {% endif %}
    end as {{ dbt.type_string() }}) as panel_id
    , coalesce(cast(ce.encounterdate as date), cast(vs.createddatetime as date)) as observation_date
    , cast('vital sign' as {{ dbt.type_string() }}) as observation_type
    , cast(case when vs.key in ('VITALS.BMI', 'VITALS.BLOODPRESSURE.SYSTOLIC', 'VITALS.BLOODPRESSURE.DIASTOLIC') then 'loinc'
                else 'athena-vital-key' end
        as {{ dbt.type_string() }}) as source_code_type
    , cast(case when vs.key = 'VITALS.BMI' then '39156-5'
                when vs.key = 'VITALS.BLOODPRESSURE.SYSTOLIC' then '8480-6'
                when vs.key = 'VITALS.BLOODPRESSURE.DIASTOLIC' then '8462-4'
                else cast(vs.key as {{ dbt.type_string() }}) end
        as {{ dbt.type_string() }}) as source_code
    , cast(vs.key as {{ dbt.type_string() }}) as source_description
    , cast(null as {{ dbt.type_string() }}) as normalized_code_type
    , cast(null as {{ dbt.type_string() }}) as normalized_code
    , cast(null as {{ dbt.type_string() }}) as normalized_description
    , coalesce(cast(vs.displayvalue as {{ dbt.type_string() }}), cast(vs.value as {{ dbt.type_string() }})) as result
    , cast(coalesce(vs.displayunit, vs.dbunit) as {{ dbt.type_string() }}) as source_units
    , cast(null as {{ dbt.type_string() }}) as normalized_units
    , cast(null as {{ dbt.type_string() }}) as source_reference_range_low
    , cast(null as {{ dbt.type_string() }}) as source_reference_range_high
    , cast(null as {{ dbt.type_string() }}) as normalized_reference_range_low
    , cast(null as {{ dbt.type_string() }}) as normalized_reference_range_high
    , cast('athena.' || vs.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime
from {{ ref('stg_athena_vital_sign') }} as vs
inner join {{ ref('stg_athena_clinical_encounter') }} as ce
    on vs.clinicalencounterid = ce.clinicalencounterid and vs.contextid = ce.contextid
inner join {{ ref('stg_athena_patient') }} as p
    on ce.patientid = p.patientid and ce.contextid = p.contextid
