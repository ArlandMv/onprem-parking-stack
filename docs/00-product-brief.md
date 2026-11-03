# 00 · Product brief

## En una frase
Que salir del estacionamiento sea rápido: validar la boleta, calcular la tarifa y abrir la barrera en menos tiempo, incluso si se cae internet.

## Cliente y modelo de negocio
- **Cliente:** instalador de barreras y cámaras ZK. Actúa como **canal/revendedor**: instala el hardware y ofrece el servicio de software a edificios.
- **Primer caso:** edificio comercial mixto en Santiago.
  - Pisos 1–2: food court (visitas cortas).
  - Pisos 3–8: oficinas (usuarios frecuentes).
  - 120 cupos.

## Problema
La salida es lenta: hay que validar boletas a mano, calcular cuánto cobrar y abrir la barrera. En hora punta se forman filas. Además, en Chile los terremotos e incendios pueden cortar internet por horas o días.

## Reglas de negocio confirmadas
| Regla | Valor | ¿Configurable? |
|---|---|---|
| Boleta del food court sobre cierto monto da minutos gratis | > $10.000 CLP → 30 o 60 min gratis | Sí (monto y minutos) |
| Buffer de sobreventa de reservas | Valor a definir | Sí |
| Rechazo de reserva | Cuando se supera capacidad + buffer + 1 | — |
| Boleta del food court | **No genera DTE** (solo sirve de comprobante para el descuento) | — |
| Cobro de estacionamiento | **Genera DTE** cuando hay cobro | — |
| Operación sin internet | El edificio opera 100% local; la nube se sincroniza después | — |

## Resultado norte (R1)
Reducir el **tiempo de ciclo de salida** (validación de boleta + cálculo de tarifa + apertura de barrera) en **p90 ≥30%** respecto al baseline, medido en un piloto real.

## Qué NO es este proyecto
- No es Odoo Enterprise (descartado).
- Salesforce no es el sistema de producción: es una demo de integración en la nube.
- Este repo no tiene código; es gestión y documentación.

## Equipo
| Persona | Rol | Label |
|---|---|---|
| Arland Michelena | Fullstack, líder | `role:Fullstack` |
| Lorena Navarro | Marketing (junior, ~4 h/semana, en Notion) | `role:LorenaMarketing` |
| Experto ZK | Hardware | `area:hardware` (+ rol a definir) |
| (Roles extra) | QA, Salesforce Developer, Integration & Automation Architect | `role:QA`, `role:SalesforceDeveloper`, `role:IntegrationAutomationArchitect` |

## Plan
3 sprints de 2 semanas (S1–S3). Backlog en el Product Backlog (documento aparte). Validación técnica en [06-poc-plan.md](06-poc-plan.md).
