
select
    contextid,
    pc0.procedurecode,
    procedurecodedescription,
    case
    {% if target.type == 'snowflake' %}
        when len(procedurecode) = 5 or substr(procedurecode,6,1) = ',' then 'hcpcs'
        else contextname || '.procedure_code'
    {% elif target.type == 'bigquery' %}
        when length(cast(procedurecode as {{ dbt.type_string() }} ) ) = 5 or substr(procedurecode,6,1) = ',' then 'hcpcs'
        else concat(contextname, '.procedure_code')
    {% endif %}
        end as source_code_type,
    nullif({{dbt.split_part(string_text='pc0.procedurecode',delimiter_text="','",part_number=1)}},'') as root_cpt,
    nullif({{dbt.split_part(string_text='pc0.procedurecode',delimiter_text="','",part_number=2)}},'') as mod1,
    nullif({{dbt.split_part(string_text='pc0.procedurecode',delimiter_text="','",part_number=3)}},'') as mod2,
    nullif({{dbt.split_part(string_text='pc0.procedurecode',delimiter_text="','",part_number=4)}},'') as mod3,
    nullif({{dbt.split_part(string_text='pc0.procedurecode',delimiter_text="','",part_number=5)}},'') as mod4,
    nullif({{dbt.split_part(string_text='pc0.procedurecode',delimiter_text="','",part_number=6)}},'') as mod5
from {{ source('athena','PROCEDURECODE' ) }} pc0
qualify row_number() over (partition by contextid,procedurecode order by case when deleteddatetime is null then 0 else 1 end, coalesce(lastmodifieddatetime,createddatetime) desc ) = 1
