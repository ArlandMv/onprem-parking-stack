# 03 · Odoo Community y tributación chilena

**Decisión (Arland, 2026-11-03):** el DTE y la boleta electrónica se emiten con un **módulo de terceros dentro de Odoo Community, on-prem**. Odoo Enterprise sigue descartado.
**Emisor tributario:** el **operador del estacionamiento** (su RUT, certificado, resolución SII y CAF).

## Lo que trae (y no trae) Odoo Community
- `l10n_cl` (plan contable, IVA 19%): **sí** está en Community (`odoo/odoo`).
- `l10n_cl_edi` (DTE) y `l10n_cl_boletas` (boleta electrónica): aparecen en la doc oficial de Odoo para Chile, pero **no están en el repo Community** → son **Enterprise**.
- `l10n_cl_transbank_webpay`: **no existe** en Odoo oficial ni en OCA.

## ¿Y el plan "One App Free" de Odoo?
- Es **gratis, una app, usuarios ilimitados**, pero **solo en Odoo Online** (nube de Odoo, código Enterprise). Fuente: https://www.odoo.com/pricing
- Según el blog de Odoo, la localización chilena (incluida "Chile - Electronic Invoicing", `l10n_cl_edi`) es de instalación gratuita; que quede cubierta por el plan gratuito al elegir Facturación/Contabilidad lo afirman fuentes secundarias → **a verificar** con Odoo. Fuente: https://www.odoo.com/blog/business-hacks-1/electronic-invoicing-for-chilean-companies-with-odoo-2282
- **No sirve para este proyecto:** es cloud (no opera en un corte), no admite módulos propios y, según la página de precios, el acceso a la API externa corresponde al plan Custom (**a verificar**), lo que bloquearía la capa de integración. Queda documentado como alternativa descartada.

## Módulos de terceros evaluados (revisado 2026-11-03)
| Módulo | Licencia | Versiones Odoo | Boletas (39/41) | Último commit | Estado |
|---|---|---|---|---|---|
| **`l10n_cl_fe`** — Daniel Santibáñez / Cooperativa OdooCoop ([gitlab.com/dansanti/l10n_cl_fe](https://gitlab.com/dansanti/l10n_cl_fe)) | AGPL-3 (manifest) | 11.0–17.0 (sin rama 18.0) | **Sí** (BEL 39, BNA 41, consumo de folios; PdV en `l10n_cl_dte_point_of_sale`) | 17.0: 2026-09-14 · 16.0: 2026-10-31 | **Recomendado** |
| `dansanti/l10n_cl_fe` en GitHub | sin licencia declarada | 11.0 | — | 2018-06 | Espejo antiguo, ignorar |
| `tf_dte_cl` — TuringForge SpA ([github.com/TuringForgeSpA/tf_dte_cl](https://github.com/TuringForgeSpA/tf_dte_cl)) | LGPL-3.0 | 18.0 | **No** (README: boletas fuera de alcance) | 2026-09-28 | Solo facturas; no cubre el caso |
| `addons-konos` — Konos ([github.com/KonosCL/addons-konos](https://github.com/KonosCL/addons-konos)) | GPL-3.0 | 9.0–16.0 | a verificar | 2024-04 (repo **archivado**) | Descartado |
| `odoo-chile` — BMyA ([github.com/bmya/odoo-chile](https://github.com/bmya/odoo-chile)) | AGPL-3.0 | sin ramas por versión | a verificar | 2017-01 | Descartado (sin mantención pública); repos actuales de BMyA **a verificar** |
| `l10n_cl_fe` — Cesar250101 ([github.com/Cesar250101/l10n_cl_fe](https://github.com/Cesar250101/l10n_cl_fe)) | AGPL-3.0 | 16.0 | a verificar (fork del anterior) | 2026-10-26 | Fork; no aporta 17/18 |
| OCA `l10n-chile` ([github.com/OCA/l10n-chile](https://github.com/OCA/l10n-chile)) | AGPL-3.0 | Módulos SII solo en 12.0 | a verificar | ramas 16–18 sin módulos | Descartado |

### Recomendación
**`l10n_cl_fe` de Daniel Santibáñez sobre Odoo Community 17.0, on-prem.** Es el único con mantención activa en 17.0 que declara soporte de boleta electrónica (39/41) y factura.

**A verificar antes de comprometerlo:**
- Que instale y funcione sobre **Community puro** (sus dependencias incluyen `base`, `base_address_extended`, `account`; revisar el resto del manifest y `requirements.txt`).
- Si alguna función depende del servicio externo de globalresponse.cl (el manifest remite ahí) o requiere suscripción.
- Archivo LICENSE: el manifest dice AGPL-3. Como se usa on-prem y no se distribuye, no hay obligaciones prácticas; si se modifica y se ofrece por red a terceros, aplican las de AGPL.
- Sin rama 18.0 → fijamos Odoo **17.0**.
- Envío de boletas al SII y "consumo de folios" según las reglas vigentes del SII.

## Boleta vs factura en este edificio
| Documento | Emisor | ¿DTE de nuestro sistema? |
|---|---|---|
| Boleta del food court | El local de comida | **No.** Solo sirve para aplicar minutos gratis |
| Boleta electrónica (39) de estacionamiento, IVA 19% incluido | **Operador** | **Sí**, cuando hay cobro |
| Factura electrónica (33) a empresa arrendataria | **Operador** | **Sí** |

## Configuración mínima (Odoo Community 17.0)
1. Instalar `l10n_cl` + `l10n_cl_fe` (y dependencias del manifest).
2. Empresa = **operador**: RUT, giro, actividad económica, dirección.
3. Certificado digital del operador y CAF por tipo (33, 39, 61 al menos).
4. Producto "Servicio de estacionamiento", IVA 19%.
5. Diarios: boletas, facturas; diario de caja (efectivo) y Webpay.
6. Clientes: "Consumidor final" + arrendatarios con RUT.
7. Cuenta por cobrar "Deudas de estacionamiento" para el libro de deudas local (ver [01](01-architecture.md#libro-de-deudas-local)).

## Requisitos SII
- Certificado digital del representante del operador.
- Resolución SII como emisor electrónico (set de pruebas).
- Folios (CAF) por tipo de documento.
- Envío al SII requiere internet: en corte los DTE quedan en cola. Plazos legales y contingencia: **a verificar** con el contador del operador.

## Cobro durante cortes (Webpay o red caída)
Decisión: **efectivo**, o **dejar salir y registrar una deuda** que se cobra en la siguiente salida. Ver [01](01-architecture.md#libro-de-deudas-local) y riesgos en [07](07-risks.md).

## Transbank Webpay
Sin módulo oficial en Community. La capa de integración usa el SDK oficial de Transbank y registra el pago en Odoo por XML-RPC (módulo de terceros en Odoo: **a verificar**).
