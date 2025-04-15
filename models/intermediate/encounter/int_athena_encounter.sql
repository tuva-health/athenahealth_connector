with primary_dx as (
    select ced0.contextid, ced0.clinicalencounterid, ced0.snomedcode, sno0.description as snomed_description
           , row_number() over (partition by clinicalencounterid
order by ordering) as rw
    from {{ ref('stg_athena_clinical_encounter_diagnosis') }} as ced0
    left outer join {{ ref('terminology__snomed_ct') }} as sno0
        on cast(ced0.snomedcode as {{ dbt.type_string() }}) = cast(sno0.snomed_ct as {{ dbt.type_string() }})
    where deletedby is null and deleteddatetime is null
)

select
      cast(ce.contextid as {{ dbt.type_string() }}) || '.' || cast(ce.clinicalencounterid as {{ dbt.type_string() }}) as encounter_id
    , cast(ce.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as person_id
    , cast(ce.contextid as {{ dbt.type_string() }}) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }}) as patient_id
    , cast(case when ce.clinicalencountertype = 'VISIT' then 'office visit' else 'other' end as {{ dbt.type_string() }}) as encounter_type
    , cast(ce.encounterdate as date) as encounter_start_date
    , cast(case when ce.clinicalencountertype = 'VISIT' then encounter_start_date else null end as date) as encounter_end_date
    , cast(null as {{ dbt.type_int() }}) as length_of_stay
    , cast(null as {{ dbt.type_string() }}) as admit_source_code
    , cast(null as {{ dbt.type_string() }}) as admit_source_description
    , cast(null as {{ dbt.type_string() }}) as admit_type_code
    , cast(null as {{ dbt.type_string() }}) as admit_type_description
    , cast(null as {{ dbt.type_string() }}) as discharge_disposition_code
    , cast(null as {{ dbt.type_string() }}) as discharge_disposition_description
    , cast(ce.contextid || '.prov.' || ce.providerid as {{ dbt.type_string() }}) as attending_provider_id
    , cast(provider.providerfirstname || ' ' || provider.providerlastname || ' ' || provider.providertype as {{ dbt.type_string() }}) as attending_provider_name
    , cast(ce.contextid || '.' || d.departmentid as {{ dbt.type_string() }}) as facility_id
    , cast(d.departmentname as {{ dbt.type_string() }}) as facility_name
    , cast(case when primary_dx.snomedcode is not null then 'snomed' end as {{ dbt.type_string() }}) as primary_diagnosis_code_type
    , cast(primary_dx.snomedcode as {{ dbt.type_string() }}) as primary_diagnosis_code
    , cast(primary_dx.snomed_description as {{ dbt.type_string() }}) as primary_diagnosis_description
    , cast(null as {{ dbt.type_string() }}) as drg_code_type
    , cast(null as {{ dbt.type_string() }}) as drg_code
    , cast(null as {{ dbt.type_string() }}) as drg_description
    , cast(null as {{ dbt.type_numeric() }}) as paid_amount
    , cast(null as {{ dbt.type_numeric() }}) as allowed_amount
    , cast(null as {{ dbt.type_numeric() }}) as charge_amount
    , cast('athena.' || ce.contextname as {{ dbt.type_string() }}) as data_source
    , cast(null as {{ dbt.type_string() }}) as file_name
    , cast(null as {{ dbt.type_timestamp() }}) as ingest_datetime

from {{ ref('stg_athena_clinical_encounter') }} as ce
inner join {{ ref('stg_athena_patient') }} as p
    on ce.patientid = p.patientid and ce.contextid = p.contextid
left outer join primary_dx
on ce.contextid = primary_dx.contextid and ce.clinicalencounterid = primary_dx.clinicalencounterid and primary_dx.rw = 1
left outer join {{ ref('stg_athena_department') }} as d
    on ce.departmentid = d.departmentid and ce.contextid = d.contextid
left outer join {{ ref('stg_athena_provider') }} as provider
    on ce.contextid = provider.contextid and ce.providerid = provider.providerid
