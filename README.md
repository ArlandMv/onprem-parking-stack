# onprem-parking-stack

![Licencia: MIT](https://img.shields.io/badge/licencia-MIT-blue.svg)
![Estado: planificación](https://img.shields.io/badge/estado-planificaci%C3%B3n%20S1-yellow.svg)
![Tipo: gestión y docs](https://img.shields.io/badge/repo-gesti%C3%B3n%20%2B%20docs-lightgrey.svg)

Repositorio de **gestión y documentación** del proyecto de estacionamiento inteligente para un edificio comercial mixto en Santiago (food court pisos 1–2, oficinas pisos 3–8, 120 cupos). El servicio lo ofrece el instalador de barreras y cámaras ZK como canal/revendedor. Aquí viven la arquitectura, el plan de PoC, los issues y el tablero de GitHub Projects v2.

> **Ojo: este repo NO contiene código de la aplicación.** No hay `src/`, `app/` ni `package.json`. ParkHub vive en su repo upstream (`nash87/parkhub-php` o `nash87/parkhub-rust`); Odoo y Salesforce son instancias separadas. Aquí solo hay documentación, plantillas de issues, labels como código y un script de bootstrap.

## ¿Por qué se llama "onprem"?

- **On-premise (en el edificio):** ParkHub + Odoo Community + la **capa de integración** (middleware Python/FastAPI con cola outbox). Todo lo necesario para que la barrera abra, se valide la boleta y se cobre funciona **sin internet**.
- **Cloud:** **Salesforce CRM Developer Edition es cloud, no on-premise.** Se usa solo como **demo de integración** con un CRM externo (no es producción). Se sincroniza cuando hay conectividad.
- Si se corta internet (terremoto, incendio, falla del proveedor), el edificio sigue operando; los eventos quedan en cola local y se envían a la nube al volver la conexión. Ver [docs/01-architecture.md](docs/01-architecture.md#modo-offline-y-sincronización-diferida).

## Arquitectura (vista rápida)

```
            [App móvil / Web]
                   │
                   ▼
   ┌──────────── ON-PREMISE (edificio) ─────────────────────────────┐
   │  [ParkHub PHP o Rust] ◄──REST/webhooks──► [Odoo Community]      │
   │        │        │                          (boleta/DTE: ver 03)│
   │        ▼        ▼                                 │             │
   │  [Hardware ZK] [BD ParkHub]               [PostgreSQL Odoo]     │
   │  (whitelist local)        \                 /                  │
   │                     [Capa de integración FastAPI]              │
   │                     outbox · reintentos · panel sync           │
   └──────────────────────────────┬─────────────────────────────────┘
                                  │ (solo cuando hay internet)
                                  ▼
                 ☁ [Salesforce CRM Developer Edition] (demo)
```

## Componentes

| Componente | Dónde corre | Stack | Licencia |
|---|---|---|---|
| ParkHub PHP (`nash87/parkhub-php`) | On-prem | Laravel 13, PHP 8.4, React 19, Tailwind 4, MySQL (README cita también SQLite/PostgreSQL) | MIT |
| ParkHub Rust (`nash87/parkhub-rust`) | On-prem | Rust Axum, redb embebido, mismo frontend React 19 | MIT |
| Odoo Community | On-prem | Python, PostgreSQL | LGPLv3 |
| Capa de integración | On-prem | Python/FastAPI + cola outbox (PostgreSQL) | MIT (propia, repo aparte) |
| Hardware ZK (barreras, cámaras, paneles C3/inBio) | On-prem | PULL SDK o PUSH/ADMS | Propietario (ZKTeco) |
| Salesforce CRM Developer Edition | **Cloud** | REST API | Gratuita, términos Salesforce |

> Nota: el brief original decía Laravel 12 / PHP 8.2+; el README upstream revisado el 2026-11-03 dice **Laravel 13 / PHP 8.4**. Ver [docs/02](docs/02-parkhub-editions.md).

## Documentación

| Doc | Para quién |
|---|---|
| [00 · Product brief](docs/00-product-brief.md) | Todos (Lorena, cliente) |
| [01 · Arquitectura](docs/01-architecture.md) | Técnico |
| [02 · Ediciones ParkHub](docs/02-parkhub-editions.md) | Técnico / decisión |
| [03 · Odoo y tributación Chile](docs/03-odoo-chile-tax.md) | Técnico / contable |
| [04 · Integración Salesforce](docs/04-salesforce-integration.md) | Técnico / demo |
| [05 · Despliegue on-prem](docs/05-onprem-deployment.md) | Técnico / instalador ZK |
| [06 · Plan de PoC](docs/06-poc-plan.md) | Todos |
| [Sync Notion → GitHub](sync/notion-to-github.md) | Arland, Lorena |

## Cómo usamos GitHub Projects

- Project v2: **`<URL del Project — a completar>`**.
- Campos: Status, Sprint, Size, Priority, Metric (métrica ODD).
- Vistas: Board por Status · Por Sprint · Roadmap · Checkpoints ODD · Para Lorena.
- Responsables por **labels de rol** (`role:*`), no por campo Owner. Labels en [.github/labels.yml](.github/labels.yml).
- Milestones S1, S2, S3 (sprints de 2 semanas). El backlog está definido en el Product Backlog (documento aparte); aquí solo se referencia.
- Resultado norte **R1**: reducir el tiempo de ciclo de salida (validación de boleta + cálculo de tarifa + apertura de barrera) en p90 ≥30% vs. baseline en piloto real.

## Cómo participa Lorena

Lorena **no usa GitHub**. Escribe sus ideas y tareas en Notion, en la base **"Lorena Inbox"** (`<link Notion — a completar>`). Cada lunes Arland las pasa a GitHub con la label `from-lorena` y le deja el link de vuelta. Detalle en [sync/notion-to-github.md](sync/notion-to-github.md).

## Licencia

MIT para la documentación de este repo (archivo LICENSE a agregar al crear el repo en GitHub).
