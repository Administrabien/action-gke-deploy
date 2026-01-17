#!/bin/bash
set -e

EXTERNAL_TOKEN=$1
YAML_PATH=$2
VERSION_PATH=$3
VERSION=$4
REPOSITORY=$5

# 1. Configuración de variables
# Usamos el token para construir la URL de autenticación
REPO_URL="https://x-access-token:${EXTERNAL_TOKEN}@github.com/${REPOSITORY}.git"
TEMP_DIR="repo_externo"

echo "Iniciando clonación de $REPOSITORY..."

# 2. Clonar el repositorio externo en una carpeta temporal
git clone "$REPO_URL" "$TEMP_DIR"
cd "$TEMP_DIR"

# 3. Configurar la identidad de Git (necesario para el commit)
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

# 4. Modificar el valor en el archivo YAML
# Aquí ajusta la ruta del archivo según tu estructura de carpetas en el repo de infra

echo "Actualizando versión a $VERSION en $YAML_PATH"
ls -la $YAML_PATH
# Comando yq para buscar el parámetro y actualizar el valor
yq -i "${VERSION_PATH} = \"${VERSION}\"" $YAML_PATH

echo "Entrando al If"

# 5. Commit y Push
if [[ -n $(git status -s) ]]; then
  git add "$YAML_PATH"
  git commit -m "chore: update appVersion to $VERSION in $YAML_PATH"
  git push origin main
  echo "Cambios cargados exitosamente."
else
  echo "No hay cambios detectados, saltando commit."
fi