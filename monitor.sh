
#!/bin/bash

LOG_FILE="/logs/monitor.log"

WEBSITES=(
    "https://example.com"
    "https://www.google.com"
    "https://this-domain-should-not-exist.invalid"
)

check_websites() {
    echo "===== Website Check: $(date) =====" | tee -a "$LOG_FILE"

    for URL in "${WEBSITES[@]}"; do
        HTTP_CODE=$(curl -L -s -o /dev/null \
            -w "%{http_code}" --max-time 10 "$URL")
        CURL_EXIT=$?

        if [ "$CURL_EXIT" -ne 0 ]; then
            echo "DOWN | $URL | Connection failed" | tee -a "$LOG_FILE"
        elif [[ "$HTTP_CODE" =~ ^[23][0-9][0-9]$ ]]; then
            echo "UP | $URL | HTTP $HTTP_CODE" | tee -a "$LOG_FILE"
        else
            echo "ALERT | $URL | HTTP $HTTP_CODE" | tee -a "$LOG_FILE"
        fi
    done
}

while true; do
    check_websites
    sleep 30
done
