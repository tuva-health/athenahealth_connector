{{ dbt_utils.union_relations(
    relations=[ ref('int_athena_practitioner_clinical_provider'),
                ref('int_athena_practitioner_provider'),]
) }}
