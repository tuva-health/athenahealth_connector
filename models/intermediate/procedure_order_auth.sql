

select
      cast(oac.contextid as {{ dbt.type_string() }} ) || '.orderauth.' || cast(oac.orderauthcptid as {{ dbt.type_string() }} ) as procedure_id
    , cast(oac.contextid as {{ dbt.type_string() }} ) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }} ) as person_id
    , cast(oac.contextid as {{ dbt.type_string() }} ) || '.' || cast(p.enterpriseid as {{ dbt.type_string() }} ) as patient_id
    , cast(d.contextid as {{ dbt.type_string() }} ) || '.' || cast(d.clinicalencounterid as {{ dbt.type_string() }} ) as encounter_id
    , cast(null as {{ dbt.type_string() }} ) as claim_id
    , cast(oa.proceduredatedatetime as date) as procedure_date
    , cast('hcpcs' as {{ dbt.type_string() }} ) as source_code_type
    , cast(case when epc.source_code_type = 'hcpcs' then epc.root_cpt else oac.PROCEDURECODE end  as {{ dbt.type_string() }} ) as source_code
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
    , cast('athena.' || oac.contextname as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime
--select *
From {{  source('athena','dataview_imports__orderauthcpt__v1') }} as oac
inner join {{ source('athena','dataview_imports__orderauth__v1') }} as oa
    on oac.ORDERAUTHID = oa.ORDERAUTHID and oac.contextid = oa.contextid
inner join {{ source('athena','dataview_imports__document__v1') }} as d
    on oa.documentid = d.documentid and oa.contextid = d.contextid
inner join {{  source('athena','dataview_imports__patient__v1') }} as p
    on d.patientid = p.patientid and d.contextid = p.contextid
left join {{ ref('enhanced_procedure_code') }} as epc
    on  oac.procedurecode = epc.procedurecode and oac.contextid = epc.contextid
where oac.deletedby is null and oac.deleteddatetime is null
and d.deleteddatetime is null and d.deletedby is null and d.STATUS <> 'DELETED'
