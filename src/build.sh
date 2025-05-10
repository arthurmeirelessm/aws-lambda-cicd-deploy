#!/bin/bash
set -e

# Definindo os diretórios relativos a partir de src/
LOCAL_BUILD_DIR="../local_build"
INFRASTRUCTURE_DIR="../infrastructure"
VENV_DIR="./venv/lib/python3.12/"

echo "[INFO] Copiando lambda_function.py para $LOCAL_BUILD_DIR/..."
mkdir -p "$LOCAL_BUILD_DIR"
cp lambda/lambda_function.py "$LOCAL_BUILD_DIR/"

# Gera o arquivo requirements.txt dentro de src/
echo "[INFO] Gerando requirements.txt em src/..."
pip freeze > "lambda/requirements.txt"

echo "[INFO] Copiando pacotes da venv para $LOCAL_BUILD_DIR/..."

# Busca por site-packages dentro da venv
VENV_SITE_PACKAGES=$(find "$VENV_DIR" -type d -path "*/site-packages" | head -n 1)

if [ -z "$VENV_SITE_PACKAGES" ]; then
  echo "[ERRO] site-packages não encontrado. Verifique se a venv foi criada corretamente."
  exit 1
fi

cp -r "$VENV_SITE_PACKAGES/"* "$LOCAL_BUILD_DIR/"

echo "[INFO] Rodando SAM build com hook Terraform..."
cd "$INFRASTRUCTURE_DIR"
sam build --hook-name terraform
