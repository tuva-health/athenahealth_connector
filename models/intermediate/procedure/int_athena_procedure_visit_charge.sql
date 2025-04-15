select
      cast(vc.contextid as {{ dbt.type_string() }}) ||
        '.visitcharge.' ||
        cast(vc.visitchargeid as {{ dbt.type_string() }}) as procedure_id
    , cast(vc.contextid || '.' || p.enterpriseid as {{ dbt.type_string() }}) as person_id
    , cast(vc.contextid || '.' || p.enterpriseid as {{ dbt.type_string() }}) as patient_id
    , cast(null as {{ dbt.type_string() }}) as encounter_id
    , cast(null as {{ dbt.type_string() }}) as claim_id
    , cast(vc.fromdatedatetime as date) as procedure_date
    , cast(epc.source_code_type as {{ dbt.type_string() }}) as source_code_type
    , cast(case when epc.source_code_type = 'hcpcs' then epc.root_cpt else vc.procedurecode end as {{ dbt.type_string() }}) as source_code
    , cast(epc.procedurecodedescription as {{ dbt.type_string() }}) as source_description
    , cast(null as {{ dbt.type_string() }}) as normalized_code_type
    , cast(null as {{ dbt.type_string() }}) as normalized_code
    , cast(null as {{ dbt.type_string() }}) as normalized_description
    , cast(epc.mod1 as {{ dbt.type_string() }}) as modifier_1
    , cast(epc.mod2 as {{ dbt.type_string() }}) as modifier_2
    , cast(epc.mod3 as {{ dbt.type_string() }}) as modifier_3
    , cast(epc.mod4 as {{ dbt.type_string() }}) as modifier_4
    , cast(epc.mod5 as {{ dbt.type_string() }}) as modifier_5
    , cast(vc.contextid || '.prov.' || vc.providerid as {{ dbt.type_string() }}) as practitioner_id
    , cast('athena.' || vc.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime

from {{ ref('stg_athena_visit_charge') }} as vc
inner join {{ ref('stg_athena_visit') }} as v
    on vc.visitid = v.visitid and vc.contextid = v.contextid
inner join {{ ref('stg_athena_patient') }} as p
    on v.patientid = p.patientid and v.contextid = p.contextid
left outer join {{ ref('enhanced_procedure_code') }} as epc
    on vc.procedurecode = epc.procedurecode and vc.contextid = epc.contextid
where vc.deletedby is null and vc.deleteddatetime is null
