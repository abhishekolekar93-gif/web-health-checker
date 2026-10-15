
#!/bin/bash

LOG_FILE="/logs/monitor.log"

WEBSITES=(
    "https://example.com"
    "https://www.google.com"
    "https://this-domain-should-not-exist.invalid"
)

rotate_logs() {
    if [[ -f "$LOG_FILE" ]]; then
        LOG_SIZE=$(stat -c%s "$LOG_FILE")

        if (( LOG_SIZE >= 1048576 )); then
            rm -f "$LOG_FILE.1"
            mv "$LOG_FILE" "$LOG_FILE.1"
            echo "Log rotated at $(date)"
        fi
    fi
}

check_websites() {
    echo "===== Website Check: $(date) ====="

    for URL in "${WEBSITES[@]}"; do
        HTTP_CODE=$(curl -L -s -o /dev/null \
            -w "%{http_code}" --max-time 10 "$URL")
        CURL_EXIT=$?

        if [[ "$CURL_EXIT" -ne 0 ]]; then
            echo "DOWN | $URL | curl exit code: $CURL_EXIT"
        elif [[ "$HTTP_CODE" =~ ^[23][0-9][0-9]$ ]]; then
            echo "UP | $URL | HTTP $HTTP_CODE"
        else
            echo "ALERT | $URL | HTTP $HTTP_CODE"
        fi
    done
}

check_server() {
    echo "===== Server Check: $(date) ====="

    LOAD=$(awk '{print $1}' /proc/loadavg)

    MEMORY=$(free | awk '/Mem:/ {
        printf "%.0f", ($3/$2)*100
    }')

    DISK=$(df -P / | awk 'NR==2 {
        gsub("%","",$5); print $5
    }')

    echo "CPU load average: $LOAD"
    echo "Memory usage: ${MEMORY}%"
    echo "Disk usage: ${DISK}%"

    if (( MEMORY >= 80 )); then
        echo "WARNING: Memory usage is high!"
    fi

    if (( DISK >= 80 )); then
        echo "WARNING: Disk usage is high!"
    fi
}

mkdir -p "$(dirname "$LOG_FILE")"

while true; do
    rotate_logs

    {
        check_websites
        check_server
        echo ""
    } 2>&1 | tee -a "$LOG_FILE"

    sleep 60
done
