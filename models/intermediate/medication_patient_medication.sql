select
      cast(pm.contextid as {{ dbt.type_string() }} ) || '.medication.' || cast(pm.patientmedicationid as {{ dbt.type_string() }} ) as medication_id
    , cast(pm.contextid as {{ dbt.type_string() }} ) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as person_id
    , cast(pm.contextid as {{ dbt.type_string() }} ) || '.' || cast(c.enterpriseid as {{ dbt.type_string() }} ) as patient_id
    , cast(null as {{ dbt.type_string() }} ) as encounter_id
    , cast(pm.filldate as date) as dispensing_date
    , cast(coalesce(d.futuresubmitdatetime, d.orderdatetime) as date) as prescribing_date
    , cast(case when m.ndc is not null then 'ndc'
                when m.rxnorm is not null then 'rxnorm'
                when m.fdbmedid is not null then 'fdb'
                else 'athena_medication_id' end
        as {{ dbt.type_string() }} ) as source_code_type
    , cast(coalesce(m.ndc, m.rxnorm, cast(m.medicationid as {{ dbt.type_string() }} )) as {{ dbt.type_string() }} ) as source_code
    , cast(m.medicationname as {{ dbt.type_string() }} ) as source_description
    , cast(m.ndc as {{ dbt.type_string() }} ) as ndc_code
    , cast(null as {{ dbt.type_string() }} ) as ndc_description
    , cast(m.rxnorm as {{ dbt.type_string() }} ) as rxnorm_code
    , cast(null as {{ dbt.type_string() }} ) as rxnorm_description
    , cast(null as {{ dbt.type_string() }} ) as atc_code
    , cast(null as {{ dbt.type_string() }} ) as atc_description
    , cast(pm.dosageroute as {{ dbt.type_string() }} ) as route
    , cast(pm.dosagestrength as {{ dbt.type_string() }} ) as strength
    , cast(pm.dosagequantity as {{ dbt.type_int() }} ) as quantity
    , cast(pm.displaydosageunits as {{ dbt.type_string() }} ) as quantity_unit
    , cast(pm.lengthofcourse as {{ dbt.type_int() }} ) as days_supply
    , cast(null as {{ dbt.type_string() }} ) as practitioner_id
    , cast('athena.' || pm.contextname as {{ dbt.type_string() }} ) as data_source
    , cast(null as {{ dbt.type_string() }} ) as file_name
    , cast(null as {{ dbt.type_timestamp() }} ) as ingest_datetime

from {{ source('athena','dataview_imports__patientmedication__v1') }} pm
left join {{ source('athena','dataview_imports__chart__v1') }} c
    on pm.chartid = c.chartid and pm.contextid = c.contextid
left join {{ source('athena','dataview_imports__medication__v1') }} m
    on pm.medicationid = m.medicationid and pm.contextid = m.contextid
left join {{ source('athena','dataview_imports__document__v1') }} d
    on pm.documentid = d.documentid and pm.contextid = d.contextid
where
  pm.medicationtype <> 'CLINICALPRESCRIPTION'
  and pm.deactivatedby is null
  and pm.deleteddatetime is null
  and not (
    cast(coalesce(m.ndc, m.rxnorm, cast(m.medicationid as {{ dbt.type_string() }} )) as {{ dbt.type_string() }} ) is null -- source code
    and cast(m.medicationname as {{ dbt.type_string() }} ) is null -- source_description
  )
