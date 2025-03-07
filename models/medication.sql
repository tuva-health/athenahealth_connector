{{ dbt_utils.union_relations(
    relations=[ ref('medication_patient_medication'),
                ref('medication_prescription')]
) }}
