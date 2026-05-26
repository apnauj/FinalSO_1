#!/bin/bash

# Terminar el script inmediatamente si algún comando falla
set -e

# ==========================================
# CONFIGURACIÓN (Modifica estos valores)
# ==========================================
AWS_REGION="us-east-1"                     
AWS_ACCOUNT_ID="970547334655"             
REPO_NAME="repositorio-final-so"                 
IMAGE_TAG="latest"

# Variables derivadas
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
FULL_IMAGE_NAME="${ECR_REGISTRY}/${REPO_NAME}:${IMAGE_TAG}"

echo "========================================="
echo "🚀 Iniciando proceso de despliegue a ECR"
echo "========================================="

# i. Construir la imagen de Docker
echo "📦 1. Construyendo la imagen de Docker..."
# --pull asegura que descargue la versión más reciente de la imagen base de AWS
docker build --pull -t "${REPO_NAME}:${IMAGE_TAG}" .

# ii. Asignar la etiqueta (tag) para ECR
echo "🏷️  2. Asignando etiqueta de ECR a la imagen..."
docker tag "${REPO_NAME}:${IMAGE_TAG}" "${FULL_IMAGE_NAME}"

# Autenticación en AWS ECR
echo "🔐 3. Autenticando Docker con AWS ECR..."
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ECR_REGISTRY}"

# iii. Subir la imagen al container registry de AWS
echo "📤 4. Subiendo la imagen a AWS ECR..."
docker push "${FULL_IMAGE_NAME}"

echo "========================================="
echo "✅ ¡Despliegue completado con éxito!"
echo "Imagen disponible en: ${FULL_IMAGE_NAME}"
echo "========================================="