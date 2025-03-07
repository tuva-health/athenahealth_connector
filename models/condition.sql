{{ dbt_utils.union_relations(
    relations=[ ref('condition_chart'),
                ref('condition_claim'),
                ref('condition_clinicalservice'),
                ref('condition_document_diagnosis'),
                ref('condition_encounter'),
                ref('condition_patient_problem'),
                ref('condition_patient_risk'),
                ref('condition_patient_snomed_icd'),
                ref('condition_patient_snomed_problem')]
) }}
