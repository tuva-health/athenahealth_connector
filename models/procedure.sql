{{ dbt_utils.union_relations(
    relations=[ ref('procedure_clinical_service'),
                ref('procedure_order_auth'),
                ref('procedure_visit_charge')]
) }}
