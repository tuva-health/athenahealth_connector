{{ dbt_utils.union_relations(
    relations=[ ref('int_athena_procedure_clinical_service'),
                ref('int_athena_procedure_order_auth'),
                ref('int_athena_procedure_visit_charge')]
) }}
