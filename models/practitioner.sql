{{ dbt_utils.union_relations(
    relations=[ ref('practitioner_clinical_provider'),
                ref('practitioner_provider'),]
) }}
