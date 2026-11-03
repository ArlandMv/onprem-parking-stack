# 06 · Plan de PoC

Cada PoC se vincula a R1 (p90 del ciclo de salida ≥30% mejor que baseline) o a un riesgo. El calendario por sprint está en el Product Backlog (no se repite aquí).

| PoC | Objetivo | Métrica | Éxito | Descarte / fallback |
|---|---|---|---|---|
| PoC1 | Concurrencia ParkHub (50 reservas / 10 cupos) | Dobles reservas | 0 dobles reservas (cero sobreventa) | Desarrollo a medida |
| PoC2 | Concurrencia Odoo (solo referencia) | `reserved_quantity` ≤ `quantity` | Sin sobre-reserva | Descartado como ruta principal |
| PoC3 | ParkHub ↔ Odoo (reserva → boleta → Webpay → confirmación) | % conciliación automática | ≥95% | Adaptador mínimo |
| PoC4 | Validación de boleta (OCR + fallback) | % validada al 1er intento | ≥90% | Priorizar validación manual |
| PoC5 | Apertura de barrera ZK con fallback | Latencia p95 | <2 s + audit log | Botón físico auditado |
| PoC6 | Salesforce ↔ Odoo (Lead → Account → Opportunity) | Flujos end-to-end | 1 flujo end-to-end | Solo demo |
| PoC7 | Sincronización diferida tras corte | Eventos perdidos; tiempo de sync tras reconexión; duplicados | 0 perdidos; sync completa en < **X** min (X a definir); 0 duplicados | Export/import CSV manual auditado |

## PoC7 · Sincronización diferida tras corte
**Escenario:** cortar el enlace a internet (y opcionalmente la energía, simulando el generador) durante una jornada simulada.
1. Generar N eventos (entradas, salidas, cobros, leads) con internet cortado; la operación local sigue.
2. Cortar energía al servidor durante la prueba → verificar auto-arranque (BIOS + Docker) y NTP local.
3. Restaurar internet; medir tiempo hasta outbox vacía.
4. Reenviar eventos a propósito (doble envío) → verificar 0 duplicados en Salesforce/Odoo (idempotencia).
5. Provocar conflicto (editar Account en Salesforce y en Odoo) → aplicar regla "on-prem gana" y registrar.

**Métricas:** eventos perdidos = 0 · duplicados = 0 · tiempo de sync < X min · respeto del límite de 15.000 llamadas/24 h · panel de sync refleja el estado real.
