# 05 · Despliegue on-premise

> **Salesforce no se despliega on-prem**: es cloud y se conecta vía API a través de la capa de integración cuando hay internet.

## Servicios (Docker Compose, referencial)
| Servicio | Imagen / origen | Notas |
|---|---|---|
| `parkhub` | Compose upstream de `nash87/parkhub-php` (+ `mysql`) **o** `nash87/parkhub-rust` (binario con redb) | Uno de los dos |
| `odoo` | `odoo:17` o versión elegida (Community) | Versión según módulo DTE (ver 03) |
| `postgres` | `postgres:16` | Odoo + outbox de la capa |
| `integration` | Imagen propia FastAPI (repo aparte) | API, workers outbox, panel sync, conector ZK |
| `queue` | Tabla outbox en PostgreSQL (recomendado) o Redis/RabbitMQ | Outbox transaccional evita perder eventos |
| `proxy` | Caddy o Traefik | TLS interno |

Todos con `restart: unless-stopped` y healthchecks.

```yaml
# Esqueleto ilustrativo, no probado
services:
  postgres: { image: postgres:16, restart: unless-stopped, volumes: [pg:/var/lib/postgresql/data] }
  odoo:     { image: odoo:17, restart: unless-stopped, depends_on: [postgres] }
  parkhub:  { build: ./upstream/parkhub-rust, restart: unless-stopped }
  integration: { image: local/integration:latest, restart: unless-stopped, depends_on: [postgres] }
  proxy:    { image: caddy:2, restart: unless-stopped, ports: ["443:443"] }
volumes: { pg: {} }
```

## Coolify (opcional)
PaaS auto-hospedado con UI para desplegar los mismos Compose. Útil si el instalador ZK quiere operar sin terminal. Requiere su propio servidor/recursos.

## Hardware mínimo (estimación, a validar en piloto)
| Recurso | Mínimo | Recomendado |
|---|---|---|
| CPU | 4 núcleos x86_64 | 8 núcleos |
| RAM | 8 GB | 16 GB |
| Disco | 256 GB SSD | 2× 512 GB SSD en RAID1 |
| Red | LAN gigabit, VLAN separada para ZK | + router 4G/5G de respaldo |

## Resiliencia de energía y comunicaciones
- **UPS** online para servidor, switch, router y paneles ZK; apagado ordenado por NUT si la batería baja.
- **BIOS "power on after AC loss"** + Docker con `restart: unless-stopped` → auto-arranque cuando vuelve el generador.
- **NTP local:** servidor NTP en la LAN (chrony) con GPS o RTC; los paneles ZK y servidores se sincronizan localmente. Sin hora correcta no hay tarifas ni audit logs confiables.
- **Paneles ZK con whitelist local:** siguen abriendo si cae el servidor.
- **Outbox:** eventos hacia la nube esperan en disco; ver PoC7.
- **Enlace de respaldo** (4G/5G) opcional; si también cae, se opera offline.

## Backups
- `pg_dump` diario de Odoo y outbox + filestore de Odoo; dump MySQL o copia de redb (con servicio detenido o snapshot) de ParkHub.
- Regla 3-2-1: copia local, disco externo, copia fuera del edificio (cifrada) cuando hay internet.
- Prueba de restauración mensual.

## Logs y monitoreo
- Logs de contenedores con rotación (`json-file` max-size) o Loki.
- Uptime Kuma o similar local: Odoo, ParkHub, capa, paneles ZK (ping), antigüedad de outbox.
- Alertas por correo/SMS cuando hay conectividad; panel local siempre.

## Seguridad
- TLS en proxy (CA interna o certificados públicos si hay dominio).
- Firewall: solo 443 hacia usuarios; VLAN ZK aislada; sin puertos de admin expuestos a internet.
- Usuarios nominativos, mínimo privilegio; **2FA en Odoo** (TOTP disponible en Community — confirmar en versión elegida) y TOTP en ParkHub.
- Secretos en `.env` fuera del repo; rotación de credenciales Salesforce/Transbank.
