

select
      cast(cspc.contextid as {{ dbt.type_string() }} ) || '.clinserv.' || cast(cspc.clinicalserviceproccodeid as {{ dbt.type_string() }} ) as procedure_id
    , cast(cs.contextid as {{ dbt.type_string() }} ) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }} ) as person_id
    , cast(cs.contextid as {{ dbt.type_string() }} ) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }} ) as patient_id
    , cast(cs.contextid as {{ dbt.type_string() }} ) || '.' || cast(ce.clinicalencounterid as {{ dbt.type_string() }} ) as encounter_id
    , cast(null as {{ dbt.type_string() }} ) as claim_id
    , cast(ce.encounterdate as date) as procedure_date
    , cast('hcpcs' as {{ dbt.type_string() }} ) as source_code_type
    , cast(case when epc.source_code_type = 'hcpcs' then epc.root_cpt else cspc.PROCEDURECODE end  as {{ dbt.type_string() }} ) as source_code
    , cast(null as {{ dbt.type_string() }} ) as source_description
    , cast(null as {{ dbt.type_string() }} ) as normalized_code_type
    , cast(null as {{ dbt.type_string() }} ) as normalized_code
    , cast(null as {{ dbt.type_string() }} ) as normalized_description
    , cast(epc.mod1 as {{ dbt.type_string() }} ) as modifier_1
    , cast(epc.mod2 as {{ dbt.type_string() }} ) as modifier_2
    , cast(epc.mod3 as {{ dbt.type_string() }} ) as modifier_3
    , cast(epc.mod4 as {{ dbt.type_string() }} ) as modifier_4
    , cast(epc.mod5 as {{ dbt.type_string() }} ) as modifier_5
    , cast(null as {{ dbt.type_string() }} ) as practitioner_id
    , cast('athena.' || cs.contextname as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime
--select *
From {{ source('athena','dataview_imports__clinicalservice__v1') }} as  cs
inner join {{ source('athena','dataview_imports__clinicalserviceprocedurecode__v1') }} as cspc
    on cs.CLINICALSERVICEID = cspc.CLINICALSERVICEID and cs.contextid = cspc.contextid
inner join {{ source('athena','dataview_imports__clinicalencounter__v1') }} as ce
    on cs.CLINICALENCOUNTERID = ce.CLINICALENCOUNTERID and cs.contextid = ce.contextid
inner join {{ source('athena','dataview_imports__patient__v1') }} as p
    on ce.PATIENTID = p.patientid  and cs.contextid = p.contextid
left join {{ ref('enhanced_procedure_code') }}  as epc
    on  cspc.procedurecode = epc.procedurecode and cs.contextid = epc.contextid
where cspc.deletedby is null and cspc.deleteddatetime is null
