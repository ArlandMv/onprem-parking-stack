#!/usr/bin/env bash
# Bootstrap de onprem-parking-stack con GitHub CLI. NO se ha ejecutado.
# Requisitos: gh >= 2.40, `gh auth login` con scopes repo + project, yq (mikefarah v4).
# Uso: OWNER=<usuario_u_org> REPO=onprem-parking-stack ./scripts/gh-bootstrap.sh
set -euo pipefail
OWNER="${OWNER:?define OWNER}"
REPO="${REPO:-onprem-parking-stack}"
FULL="$OWNER/$REPO"

# 0. Repo PÚBLICO (decisión 2026-11-03). Crear si no existe (descomentar):
# gh repo create "$FULL" --public --license mit --description "Gestión y documentación de onprem-parking-stack (sin código, sin datos de clientes)"
vis=$(gh repo view "$FULL" --json visibility -q .visibility)
[ "$vis" = "PUBLIC" ] || { echo "Se esperaba repo PUBLIC, es $vis"; exit 1; }
echo "AVISO: repo público. No crear issues con datos del cliente, IPs ni números de serie."

# 1. Labels desde .github/labels.yml (crea o actualiza)
count=$(yq 'length' .github/labels.yml)
for i in $(seq 0 $((count - 1))); do
  name=$(yq -r ".[$i].name" .github/labels.yml)
  color=$(yq -r ".[$i].color" .github/labels.yml)
  desc=$(yq -r ".[$i].description" .github/labels.yml)
  gh label create "$name" --repo "$FULL" --color "$color" --description "$desc" --force
done

# 2. Milestones S1–S3 (fechas: completar según Product Backlog, formato ISO 8601)
for s in S1 S2 S3; do
  gh api "repos/$FULL/milestones" -f title="$s" -f description="Sprint $s (2 semanas)" \
    # -f due_on="2026-11-30T23:59:59Z"
done

# 3. Project v2
PROJECT_NUMBER=$(gh project create --owner "$OWNER" --title "onprem-parking-stack" --format json | yq -r '.number')
gh project link "$PROJECT_NUMBER" --owner "$OWNER" --repo "$FULL"

# 4. Campos personalizados
# "Status" ya existe por defecto en todo Project v2 (Todo / In Progress / Done).
#   Cambiar sus opciones (p. ej. Backlog, Listo, En curso, En revisión, Hecho) NO es posible con `gh project field-create`;
#   hacerlo en la UI del Project.
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" --name "Sprint" \
  --data-type SINGLE_SELECT --single-select-options "S1,S2,S3"
# Alternativa: campo nativo "Iteration" (2 semanas) — no se puede crear con gh; solo UI.
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" --name "Size" \
  --data-type SINGLE_SELECT --single-select-options "XS,S,M,L,XL"
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" --name "Priority" \
  --data-type SINGLE_SELECT --single-select-options "P0,P1,P2"
gh project field-create "$PROJECT_NUMBER" --owner "$OWNER" --name "Metric" --data-type TEXT

# 5. Vistas (Board por Status, Por Sprint, Roadmap, Checkpoints ODD, Para Lorena)
#   NO se pueden crear con gh ni con la API pública: crear en la UI.
#   "Para Lorena": filtro `label:from-lorena,role:LorenaMarketing`.

# 6. Issues del backlog: se crean desde el Product Backlog (documento aparte). Ejemplo:
# gh issue create --repo "$FULL" --title "[HU] ..." --body-file backlog/hu-01.md \
#   --label "type:feature,role:Fullstack,sprint:s1" --milestone S1
# gh project item-add "$PROJECT_NUMBER" --owner "$OWNER" --url <issue_url>

# 7. Historia del libro de deudas local (borrador en backlog-drafts/):
gh issue create --repo "$FULL" --title "[HU] Libro de deudas local para salidas sin pago durante cortes" \
  --body-file backlog-drafts/hu-libro-deudas-local.md \
  --label "type:feature,area:backend,area:sync,offline,role:Fullstack,priority:p1"

echo "Listo. Revisa vistas y opciones de Status en la UI del Project."
