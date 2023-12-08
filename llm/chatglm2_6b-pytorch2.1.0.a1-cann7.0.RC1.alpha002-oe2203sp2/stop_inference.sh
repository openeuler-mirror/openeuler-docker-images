#!/bin/bash
ports=("21001" "21002" "7860")
for port in "${ports[@]}"
do
    info=$(netstat -tunpl | grep ":$port ")
    pid=$(echo "$info" | awk '{print $7}' | awk -F'/' '{print $1}')
    if [[ -n "$pid" ]]; then
        kill "$pid"
    fi
done
