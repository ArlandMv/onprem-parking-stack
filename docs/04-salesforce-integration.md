# 04 · Integración con Salesforce CRM Developer Edition

> **Salesforce Developer Edition es CLOUD.** No forma parte del stack on-prem operativo y **no es producción**: es una **demo** para mostrar que el stack se integra con un CRM externo. Convive con Odoo; no lo reemplaza.

## Objetos
| Objeto | Uso en la demo |
|---|---|
| `Lead` | Operador de estacionamiento interesado (desde landing de Lorena) |
| `Account` | Arrendatario / empresa del edificio (espejo de partner en Odoo) |
| `Contact` | Persona de contacto del arrendatario |
| `Opportunity` | Venta del servicio (espejo de Sale Order en Odoo) |

## Flujos
1. **Landing → Lead:** formulario de la landing → capa de integración → outbox → `Lead` (upsert por External ID).
2. **Odoo ↔ Account:** partner de Odoo → `Account`/`Contact`. Odoo es dueño de los datos maestros (RUT, razón social).
3. **Opportunity ↔ Sale Order:** Salesforce es dueño de la etapa comercial; al ganar, la capa crea la Sale Order en Odoo. Odoo es dueño de montos facturados.

## Mecanismo
- Salesforce **REST API** (OAuth 2.0, External App/Connected App).
- Odoo **XML-RPC / JSON-RPC**.
- **Middleware Python/FastAPI on-prem** con **outbox**:
  - Tabla `outbox(event_id, aggregate_id, seq, target, payload, status, attempts, next_attempt_at, last_error)`.
  - Idempotencia: `event_id` + campo External ID en Salesforce (`Onprem_Id__c`, nombre a definir) → upsert.
  - Reintentos exponenciales con jitter; respeta `REQUEST_LIMIT_EXCEEDED` esperando.
  - Conflictos: on-prem gana en datos operativos y maestros; Salesforce gana en campos comerciales propios.
  - Panel de sync (pendientes, fallidos, antigüedad, último OK).
- Tras un corte, el drenado de la cola respeta el límite diario de API (agrupar con Composite/Bulk si hace falta — **a verificar** en diseño).

## Límites de Developer Edition (docs Salesforce, revisado 2026-11-03)
| Límite | Valor | Fuente |
|---|---|---|
| Llamadas API totales | 15.000 por 24 h móviles (todo el org) | Salesforce Developer Limits Quick Reference |
| Requests concurrentes largas (≥20 s) | 5 | Ídem |
| Almacenamiento de datos | 5 MB | Salesforce Help (Partner Dev vs Dev org) |
| Almacenamiento de archivos | 20 MB | Ídem |
| Expiración | Tras 1 año de inactividad | Ídem |
| Usuarios | 2 licencias Salesforce (según fuentes secundarias) | **a verificar** |

Implicancia: 5 MB alcanza para pocos miles de registros → no enviar eventos de cada estadía; enviar solo agregados (cuentas, leads, oportunidades, resúmenes).

Fuentes: https://developer.salesforce.com/docs/atlas.en-us.salesforce_app_limits_cheatsheet.meta/salesforce_app_limits_cheatsheet/salesforce_app_limits_platform_api.htm · https://help.salesforce.com/s/articleView?id=000391959&language=en_US&type=1
