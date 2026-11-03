<!-- Borrador de issue (plantilla user-story). Se crea en GitHub con gh-bootstrap.sh. Labels: type:feature, area:backend, area:sync, offline, role:Fullstack, priority:p1 -->
# [HU] Libro de deudas local para salidas sin pago durante cortes

**Historia:** Como operador del estacionamiento, quiero dejar salir a un cliente cuando Webpay o la red no funcionan y registrar su deuda, para no bloquear la salida y cobrarla en su próxima visita.

**Criterios de aceptación**
- [ ] Si Webpay no responde (o no hay red), la caseta ofrece: pagar en efectivo o "salir con deuda".
- [ ] La deuda se guarda localmente con: `debt_id` (UUID), patente y/o usuario ParkHub, monto, estadía, fecha/hora (NTP local), motivo, operador de caseta.
- [ ] En la siguiente salida de esa patente/usuario, la tarifa muestra la deuda pendiente y se cobra junto con la estadía.
- [ ] Al volver la sync, cada deuda y su pago se concilian en Odoo (cuenta por cobrar "Deudas de estacionamiento") con clave de idempotencia; 0 duplicados.
- [ ] Umbral configurable: si la deuda previa supera X, no se permite otra salida con deuda.
- [ ] Anulación de deuda solo con rol admin y audit log.
- [ ] El DTE se emite cuando se cobra la deuda (a confirmar con el contador si corresponde emitir al momento del servicio).

**Métrica ODD:** % de deudas cobradas en ≤30 días; deudas perdidas por error de sistema = 0.
**Sprint:** a asignar según Product Backlog.
**Notas:** relacionado con PoC7 y riesgo R-01/R-02 en `docs/07-risks.md`.
