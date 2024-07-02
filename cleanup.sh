#!/bin/bash
show_progress() {
    local current=$1
    local total=$2
    local width=100
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    
    printf "\rProgress: [%-${width}s] %d%%" "$(printf '#%.0s' $(seq 1 $completed))$(printf ' %.0s' $(seq 1 $remaining))" "$percentage"
}
start_time=$(date +%s)
total_steps=7
current_step=0
oc delete -f deployment/configmap.yaml > /dev/null
((current_step++))
show_progress $current_step $total_steps

oc delete -f deployment/secrets.yaml > /dev/null
((current_step++))
show_progress $current_step $total_steps

oc delete -f deployment/database.yaml > /dev/null
((current_step++))
show_progress $current_step $total_steps

oc delete -f deployment/pvc.yaml > /dev/null
((current_step++))
show_progress $current_step $total_steps

oc delete -f deployment/backend.yaml > /dev/null
((current_step++))
show_progress $current_step $total_steps

oc delete -f deployment/frontend.yaml > /dev/null
((current_step++))
show_progress $current_step $total_steps

oc delete -f deployment/hpa.yaml > /dev/null
((current_step++))
show_progress $current_step $total_steps
end_time=$(date +%s)
duration=$((end_time - start_time))
echo
echo "Cleaned up ^w^"
echo "Execution completed in $duration seconds."
