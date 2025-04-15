select
      cast(cp.contextid as {{ dbt.type_string() }}) || '.prescription.' || cast(cp.clinicalprescriptionid as {{ dbt.type_string() }}) as medication_id
    , cast(cp.contextid as {{ dbt.type_string() }}) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }}) as person_id
    , cast(cp.contextid as {{ dbt.type_string() }}) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }}) as patient_id
    , cast(d.contextid as {{ dbt.type_string() }}) || '.' || cast(d.clinicalencounterid as {{ dbt.type_string() }}) as encounter_id
    , cast(cp.lastfilldatedatetime as date) as dispensing_date
    , cast(coalesce(cp.writtendatedatetime, d.orderdatetime) as date) as prescribing_date
    , cast(case when cp.ndc is not null then 'ndc'
                when d.fbdmedid is not null then 'fbd-med-id'
                end as {{ dbt.type_string() }}) as source_code_type
    , cast(coalesce(cp.ndc, d.fbdmedid) as {{ dbt.type_string() }}) as source_code
    , cast(coalesce(cp.labelname, d.clinicalordertype) as {{ dbt.type_string() }}) as source_description
    , cast(cp.ndc as {{ dbt.type_string() }}) as ndc_code
    , cast(null as {{ dbt.type_string() }}) as ndc_description
    , cast(null as {{ dbt.type_string() }}) as rxnorm_code
    , cast(null as {{ dbt.type_string() }}) as rxnorm_description
    , cast(null as {{ dbt.type_string() }}) as atc_code
    , cast(null as {{ dbt.type_string() }}) as atc_description
    , cast(cp.dosageroute as {{ dbt.type_string() }}) as route
    , cast(cp.dosagestrength as {{ dbt.type_string() }}) as strength
    , cast(cp.dosagequantity as {{ dbt.type_int() }}) as quantity
    , cast(cp.displaydosageunits as {{ dbt.type_string() }}) as quantity_unit
    , cast(cp.dayssupply as {{ dbt.type_int() }}) as days_supply
    , cast(d.contextid || '.clinprov.' || d.clinicalproviderid as {{ dbt.type_string() }}) as practitioner_id
    , cast('athena.' || cp.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime

from {{ ref('stg_athena_clinical_prescription') }} as cp
inner join {{ ref('stg_athena_document') }} as d
    on cp.documentid = d.documentid and cp.contextid = d.contextid
inner join {{ ref('stg_athena_chart') }} as c
    on d.chartid = c.chartid and d.contextid = c.contextid
