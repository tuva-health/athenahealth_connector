{{ dbt_utils.union_relations(
    relations=[ ref('int_athena_condition_chart'),
                ref('int_athena_condition_claim'),
                ref('int_athena_condition_clinicalservice'),
                ref('int_athena_condition_document_diagnosis'),
                ref('int_athena_condition_encounter'),
                ref('int_athena_condition_patient_problem'),
                ref('int_athena_condition_patient_snomed_icd'),
                ref('int_athena_condition_patient_snomed_problem')]
) }}
