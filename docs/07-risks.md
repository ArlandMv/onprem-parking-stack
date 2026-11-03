# 07 · Riesgos

| ID | Riesgo | Impacto | Mitigación | Dueño (label) |
|---|---|---|---|---|
| R-01 | **Deudas incobrables:** clientes que salen sin pagar en un corte y no vuelven | Pérdida de ingresos | Límite de monto/cantidad de deudas por patente; bloqueo de salida sin pago si hay deuda previa > umbral (configurable); reporte de antigüedad; política del operador para castigo | `role:Fullstack` |
| R-02 | Patente mal leída → deuda asignada a otra persona | Reclamos, datos personales | Foto de la patente en el registro; confirmación manual antes de cobrar; anulación auditada | `role:QA` |
| R-03 | DTE emitido tarde por corte (plazos SII) | Multas | Cola de DTE; plazos **a verificar** con contador | `role:Fullstack` |
| R-04 | Módulo DTE de terceros sin soporte (dependencia de una persona) | Sin DTE | Fijar versión 17.0, fork interno, contacto comercial con el mantenedor | `role:IntegrationAutomationArchitect` |
| R-05 | ParkHub poco maduro (0 estrellas) | Fallos en PoC1 | Fallback desarrollo a medida | `role:Fullstack` |
| R-06 | Fuga de datos de cliente en el **repo público** | Legal, reputación | Reglas del README, checklist de PR, revisión antes de cada push | `role:Fullstack` |
| R-07 | Efectivo en caseta durante cortes | Descuadre | Arqueo y cierre de caja registrados en Odoo al volver la sync | `role:QA` |
