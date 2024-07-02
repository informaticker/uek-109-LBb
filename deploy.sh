#!/bin/bash
# IMPORTANT!! 
# Change this to your github username.
# (lowercase or else docker will complain)
GITHUB_USERNAME="informaticker"
#GITHUB_USERNAME="your_github_username"
VERSION="v1"
show_progress() {
    local current=$1
    local total=$2
    local status=$3
    local width=100
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    echo -ne "\r\033[K"
    echo -ne "$status\n"
    printf "Progress: [%-${width}s] %d%%" "$(printf '#%.0s' $(seq 1 $completed))$(printf ' %.0s' $(seq 1 $remaining))" "$percentage"
}
run_command() {
    local command="$1"
    local status="$2"
    tput sc
    
    show_progress $current_step $total_steps "$status"
    if ! eval "$command" > /dev/null 2>&1; then
        echo -e "\nError: Failed to execute: $command"
        exit 1
    fi
    ((current_step++))
    tput rc
}
start_time=$(date +%s)
total_steps=11
current_step=0
clear
tput cup 0 0
if [ "$GITHUB_USERNAME" == "your_github_username" ]; then
    echo "You buffoon, change your github username in the file."
    exit 1
fi
replace_placeholders() {
    run_command "sed -i \"s|ghcr.io/informaticker/zli-counter-frontend:v1|ghcr.io/${GITHUB_USERNAME}/zli-counter-frontend:${VERSION}|g\" deployment/frontend.yaml && \
                 sed -i \"s|ghcr.io/informaticker/zli-counter-backend:v1|ghcr.io/${GITHUB_USERNAME}/zli-counter-backend:${VERSION}|g\" deployment/backend.yaml" \
                "Replacing placeholders in deployment files"
}
run_command "docker build -t ghcr.io/${GITHUB_USERNAME}/zli-counter-backend:${VERSION} counter_kand/backend" "Building backend Docker image"
run_command "docker build -t ghcr.io/${GITHUB_USERNAME}/zli-counter-frontend:${VERSION} counter_kand/frontend" "Building frontend Docker image"
run_command "docker push ghcr.io/${GITHUB_USERNAME}/zli-counter-backend:${VERSION}" "Pushing backend Docker image"
run_command "docker push ghcr.io/${GITHUB_USERNAME}/zli-counter-frontend:${VERSION}" "Pushing frontend Docker image"
replace_placeholders
run_command "oc apply -f deployment/configmap.yaml" "Applying configmap"
run_command "oc apply -f deployment/secrets.yaml" "Applying secrets"
run_command "oc apply -f deployment/database.yaml" "Applying database configuration"
run_command "oc apply -f deployment/pvc.yaml" "Applying PVC"
run_command "oc apply -f deployment/backend.yaml" "Applying backend configuration"
run_command "oc apply -f deployment/frontend.yaml" "Applying frontend configuration"
run_command "oc apply -f deployment/hpa.yaml" "Applying HPA"
end_time=$(date +%s)
duration=$((end_time - start_time))
tput cud 2
tput el

echo "Deployment completed successfully! ^w^"
echo "Total execution time: $duration seconds."

echo "Getting frontend route..."
frontend_route=$(oc get routes -o jsonpath='{.items[?(@.metadata.name=="counter-frontend")].spec.host}')

if [ -n "$frontend_route" ]; then
    echo "Frontend route: https://$frontend_route/"
else
    echo "Error: Could not retrieve frontend route."
fi
echo "Visit the URL to use the application."