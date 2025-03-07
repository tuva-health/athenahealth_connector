{{ dbt_utils.union_relations(
    relations=[ ref('observation_vital'),
                ref('observation_clinical_result')]
) }}
