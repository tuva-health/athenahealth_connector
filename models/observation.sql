{{ dbt_utils.union_relations(
    relations=[ ref('int_athena_observation_vital'),
                ref('int_athena_observation_clinical_result')]
) }}
