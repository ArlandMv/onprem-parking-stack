# 02 · Ediciones de ParkHub (open source)

> No confundir con **ParkHub comercial (parkhub.com)**, producto distinto y no open source.
> Revisado contra los README de GitHub el 2026-11-03. Todo lo no confirmado allí está marcado **a verificar**.

## Comparación
| | `nash87/parkhub-php` | `nash87/parkhub-rust` |
|---|---|---|
| Backend | Laravel 13, PHP 8.4 (el brief decía Laravel 12 / PHP 8.2+; README actual dice 13 / 8.4) | Rust, Axum |
| Frontend | Astro 6 + React 19 + Tailwind 4 | Astro 6 + React 19 + Tailwind 4 (embebido en el binario) |
| Base de datos | MySQL (README menciona también SQLite/PostgreSQL) | redb 2 embebido (clave-valor) |
| Licencia | MIT (confirmado en API de GitHub) | MIT (confirmado) |
| Despliegue | Docker Compose, Laravel Sail, hosting compartido, Helm | Binario único, Docker Compose, Helm |
| API | REST (documentación de endpoints **a verificar**) | REST con OpenAPI 3.0 / Swagger UI |

Ambas dicen compartir el mismo modelo de producto y superficie REST ("feature-equivalent", según README de Rust). Madurez: repos con 0 estrellas al revisarlos → **riesgo de mantenimiento a evaluar**.

## Funcionalidades (según README)
| Función | Estado |
|---|---|
| Reservas recurrentes | Confirmado (ambos) |
| Invitados / pases de invitado | Confirmado ("guest bookings", "Guest and Pass Contract") |
| Listas de espera | Confirmado |
| Check-in QR | Confirmado |
| RBAC (4 niveles) | Confirmado |
| 2FA/TOTP | Confirmado |
| Passkeys | "WebAuthn" en la descripción del repo; detalle **a verificar** |
| SSO/SAML | Descrito como **opcional y "runtime-sensitive"** → **a verificar** |
| Audit log | Confirmado |
| Export CSV | Confirmado |
| Webhooks | Confirmado (Rust: HMAC-SHA256 con reintentos) |
| iCal | Confirmado (Rust: suscripción a reservas; PHP: import/export de ausencias — sync de reservas **a verificar**) |
| GDPR | Confirmado ("GDPR compliant"; obligaciones dependen del despliegue) |
| Integración nativa ZK / barreras | **No encontrada** → se hace vía capa de integración |
| Buffer de sobreventa configurable | **A verificar** (se prueba en PoC1) |

## Cuándo elegir cada una
- **PHP:** el equipo maneja Laravel, se quiere MySQL/PostgreSQL estándar, backups SQL conocidos, más fácil de extender.
- **Rust:** servidor único y pequeño (incluso Raspberry Pi según README), menos piezas, arranque rápido tras corte de energía. Contra: redb es clave-valor embebido; reportes vía API/CSV.
- **Decisión 2026-11-03: PoC1 parte con ParkHub PHP.** Rust queda como alternativa; decisión final tras PoC1.

## Despliegue on-prem
Ver [05](05-onprem-deployment.md). Ambas traen `docker-compose.yml` en su repo. Coolify opcional.

## Integración con hardware ZK
ParkHub no habla con ZK directamente. La capa de integración:
1. **PULL SDK (C3/inBio):** la capa sincroniza la whitelist (patentes/tarjetas) hacia el panel y lee eventos. El panel decide localmente aunque la capa caiga.
2. **PUSH/ADMS:** el panel envía eventos a un servidor local (la capa) por HTTP.
3. **Relé:** salida digital para abrir la barrera ante orden de la capa; fallback **botón físico auditado** (PoC5).
Modelos exactos y versión de firmware: **a verificar** con el experto ZK.
