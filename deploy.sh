#!/bin/bash

GITHUB_USERNAME="informaticker"
VERSION="v1"

# Function to display progress bar and status
show_progress() {
    local current=$1
    local total=$2
    local status=$3
    local width=100
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    
    # Move cursor to the beginning of the line and clear it
    echo -ne "\r\033[K"
    
    # Print status and progress bar
    echo -ne "$status\n"
    printf "Progress: [%-${width}s] %d%%" "$(printf '#%.0s' $(seq 1 $completed))$(printf ' %.0s' $(seq 1 $remaining))" "$percentage"
}

# Function to run command and check for errors
run_command() {
    local command="$1"
    local status="$2"
    
    # Save cursor position
    tput sc
    
    show_progress $current_step $total_steps "$status"
    if ! eval "$command" > /dev/null 2>&1; then
        echo -e "\nError: Failed to execute: $command"
        exit 1
    fi
    ((current_step++))
    
    # Restore cursor position
    tput rc
}

# Start timing
start_time=$(date +%s)

# Total number of steps
total_steps=11
current_step=0

# Clear screen and move cursor to top-left
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

# End timing
end_time=$(date +%s)

# Calculate duration
duration=$((end_time - start_time))

# Move cursor down and clear the progress bar
tput cud 2
tput el

echo "Deployment completed successfully! ^w^"
echo "Total execution time: $duration seconds."