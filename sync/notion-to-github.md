# Sync Notion → GitHub (Lorena Inbox)

Lorena **nunca** toca GitHub. Ella escribe en Notion; Arland copia a GitHub cada lunes.

## Base de datos "Lorena Inbox" (Notion)
| Campo | Tipo Notion | Uso |
|---|---|---|
| Título | Title | Nombre corto de la idea o tarea |
| Descripción | Text | Qué y para qué, en palabras simples |
| Tipo | Select: Idea, Tarea, Contenido, Campaña, Duda | Define la plantilla de issue |
| Sprint | Select: S1, S2, S3, Sin asignar | Sugerencia de Lorena; Arland confirma |
| Estado | Select: Nuevo, En GitHub, En curso, Hecho, Descartado | Arland lo actualiza |
| Enlace | URL | Link al issue de GitHub (lo pega Arland) |
| Notas | Text | Comentarios de ida y vuelta |

## Rutina de los lunes (Arland, ~30 min)
1. Filtrar Lorena Inbox por Estado = Nuevo.
2. Por cada fila: crear issue con plantilla `marketing.yml` (o la que corresponda al Tipo).
3. Labels: `from-lorena` + `role:LorenaMarketing` + `sprint:*` + `type:*`.
4. Pegar el link del issue en el campo Enlace y cambiar Estado a "En GitHub".
5. Dejar comentario en el issue (plantilla abajo).
6. Revisar issues `from-lorena` cerrados la semana anterior → marcar "Hecho" en Notion y escribir el resultado en Notas.
7. Si algo no es claro: label `needs-clarification` y pregunta en Notas de Notion.

## Reglas
- Lorena nunca necesita cuenta de GitHub.
- Todo issue que nace de Lorena lleva `from-lorena`.
- Notion es la fuente para Lorena; GitHub es la fuente para el equipo técnico. El link en ambos sentidos es obligatorio.
- Considerar su capacidad (~4 h/semana) al asignar sprint.
- No se borra nada en Notion: se marca "Descartado" con el motivo.

## Plantilla de comentario
```
📥 Sincronizado desde Lorena Inbox (Notion) el AAAA-MM-DD.
Origen: <link a la fila de Notion>
Tipo: <Tipo> · Sprint sugerido: <Sprint> · Sprint asignado: <Sprint>
Notas de Lorena: <resumen>
Próxima revisión con Lorena: lunes AAAA-MM-DD.
```
