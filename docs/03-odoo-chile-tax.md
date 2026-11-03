# 03 · Odoo Community y tributación chilena

> **Hallazgo importante (revisado 2026-11-03):** los módulos que pedía el brief **no están en Odoo Community**.
> - `l10n_cl` (plan contable, impuestos chilenos) **sí** está en Community (`odoo/odoo`, rama 17.0).
> - `l10n_cl_edi` (DTE facturas) y `l10n_cl_boletas` (boleta electrónica) aparecen en la documentación oficial de Odoo para Chile, pero **no existen en el repo Community `odoo/odoo`** → son del repositorio **Enterprise** (descartado).
> - `l10n_cl_transbank_webpay`: **no encontrado** ni en Odoo oficial ni en OCA. Existen integraciones de terceros (p. ej. `haular/odoo-transbank` en GitHub) → **a verificar** (versión, licencia, mantenimiento).
> - OCA `l10n-chile`: tiene módulos SII/DTE (`l10n_cl_sii`, `l10n_cl_sii_folio`, `l10n_cl_etd*`) solo en la rama **12.0**; ramas 16.0–18.0 vacías al revisar.
>
> La decisión "solo Community" se mantiene. Lo que queda abierto es **de dónde sale la emisión de DTE** (ver opciones abajo).

## Opciones para emitir DTE/boleta con Odoo Community
| Opción | Pros | Contras | Estado |
|---|---|---|---|
| A. Módulos de terceros para Community (localización chilena comunitaria) | Todo dentro de Odoo | Calidad y versión variable | **A verificar** (identificar módulo, versión de Odoo, licencia) |
| B. Proveedor DTE externo vía API (facturador electrónico certificado SII), invocado desde la capa de integración | El proveedor gestiona CAF, timbre y envío SII | Costo mensual; depende de internet → cola outbox | **A verificar** proveedor |
| C. OCA 12.0 | Comunitario, LGPL/AGPL | Odoo 12 obsoleto | No recomendado |

## Boleta vs factura en este edificio
| Documento | ¿Quién lo emite? | ¿DTE de nuestro sistema? |
|---|---|---|
| Boleta del food court | El local de comida | **No.** Solo es comprobante para aplicar minutos gratis |
| Boleta electrónica de estacionamiento (consumidor final, IVA 19% incluido) | Operador del estacionamiento | **Sí**, cuando hay cobro |
| Factura electrónica de estacionamiento (empresa arrendataria, p. ej. convenio mensual) | Operador del estacionamiento | **Sí** |

## Configuración mínima en Odoo Community (independiente de la opción)
1. Instalar `l10n_cl` (Contabilidad + plan contable chileno, IVA 19%).
2. Datos de la empresa: RUT, giro, dirección, actividad económica.
3. Producto "Servicio de estacionamiento" con IVA 19%.
4. Diarios de venta: boletas y facturas.
5. Medio de pago / diario Webpay para conciliación.
6. Clientes: "Consumidor final" genérico + arrendatarios con RUT.
7. Módulo/conector DTE según opción A o B (**a verificar**).

## Requisitos SII
- **Certificado digital** (firma electrónica) del representante/usuario autorizado.
- **Resolución SII** de autorización como emisor electrónico (incluye certificación/set de pruebas).
- **Folios (CAF)** por tipo de documento (p. ej. boleta electrónica y factura electrónica), solicitados en el sitio del SII.
- Envío al SII: requiere internet; en corte, los documentos quedan en cola. Plazos y contingencia: **a verificar** con contador.

## Transbank Webpay
Ciclo esperado: crear transacción → redirección/pago → confirmación → conciliación en Odoo → reembolso si aplica. El módulo concreto para Community es **a verificar**; alternativa: la capa de integración usa el SDK oficial de Transbank y registra el pago en Odoo vía XML-RPC. Webpay requiere internet: en corte, cobro con medio local (efectivo/POS offline) — **a verificar** política.
