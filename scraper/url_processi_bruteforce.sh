#!/bin/bash

BASE_URL="https://www.radioradicale.it/processi"
START=0
END=2000
OUTPUT_FILE="index_processi.txt"

# Svuota il file all'inizio
> "$OUTPUT_FILE"

for i in $(seq $START $END); do
    URL="${BASE_URL}/${i}"

    # Fai la richiesta seguendo i redirect, e salva:
    # - codice di stato
    # - URL finale raggiunto
    RESPONSE=$(curl -s -o /dev/null -L -w "%{http_code} %{url_effective}" "$URL")
    STATUS=$(echo "$RESPONSE" | awk '{print $1}')
    FINAL_URL=$(echo "$RESPONSE" | cut -d' ' -f2-)

    echo "[$STATUS] $URL → $FINAL_URL"

    if [ "$STATUS" -ne 404 ]; then
        echo "$FINAL_URL" >> "$OUTPUT_FILE"
    fi

    # per evitare di sovraccaricare il server
    sleep 0.05
done
