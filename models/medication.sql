{{ dbt_utils.union_relations(
    relations=[ ref('int_athena_medication_patient_medication'),
                ref('int_athena_medication_prescription')]
) }}
