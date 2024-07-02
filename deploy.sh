#!/bin/bash
GITHUB_USERNAME="your_github_username"
VERSION="v1"
if [ "$GITHUB_USERNAME" == "your_github_username" ]; then
    echo "you buffoon change your github username in the file."
    exit 1
fi
replace_placeholders() {
    sed -i "s|ghcr.io/informaticker/zli-counter-frontend:v1|ghcr.io/${GITHUB_USERNAME}/zli-counter-frontend:${VERSION}|g" deployment/frontend.yaml
    sed -i "s|ghcr.io/informaticker/zli-counter-backend:v1|ghcr.io/${GITHUB_USERNAME}/zli-counter-backend:${VERSION}|g" deployment/backend.yaml
}
docker build -t ghcr.io/${GITHUB_USERNAME}/zli-counter-backend:${VERSION} counter_kand/backend
docker build -t ghcr.io/${GITHUB_USERNAME}/zli-counter-frontend:${VERSION} counter_kand/frontend
docker push ghcr.io/${GITHUB_USERNAME}/zli-counter-backend:${VERSION}
docker push ghcr.io/${GITHUB_USERNAME}/zli-counter-frontend:${VERSION}
replace_placeholders
oc apply -f deployment/configmap.yaml
oc apply -f deployment/secrets.yaml
oc apply -f deployment/database.yaml
oc apply -f deployment/pvc.yaml
oc apply -f deployment/backend.yaml
oc apply -f deployment/frontend.yaml
oc apply -f deployment/hpa.yaml

echo "Deployment completed successfully! ^w^"