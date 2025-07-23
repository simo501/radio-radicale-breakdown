#!/bin/bash

URL_LIST_DIR="../data/index_processi.txt"
PREFIX_SAVES_DIR="../data/singoli-audio/"

while IFS= read -r url; do
  echo "🔗 URL: $url"
  NOME_PROCESSO=$(echo "$url" | sed -E 's#.*/processi/##')
  # creiamo la cartella
  mkdir -p "$PREFIX_SAVES_DIR$NOME_PROCESSO/"
  FILE_NAME_SAVES="$PREFIX_SAVES_DIR$NOME_PROCESSO/urls.txt"
  > "$FILE_NAME_SAVES"  # svuota il file all'inizio

  base_url="$url"
  page=0

  # while : ; è equivalente a while True
  while : ; do
    if [ "$page" -eq 0 ]; then
      url_to_fetch="$base_url"
    else
      url_to_fetch="${base_url}?page=$page"
    fi

    echo "Scarico pagina: $url_to_fetch"
    html_content=$(curl -s "$url_to_fetch")

    # Controlla se la pagina contiene <ol
    echo "$html_content" | grep -q '<ol'
    if [ $? -ne 0 ]; then
      echo "Nessun <ol> trovato a pagina $page, interrompo."
      break
    fi

    # Estrai solo il blocco <ol>...</ol>
    ol_block=$(echo "$html_content" | sed -n '/<ol[^>]*>/,/<\/ol>/p')

    # Estrai i link <h3><a href="..."> dal blocco <ol>
    links=$(echo "$ol_block" | sed -n 's/.*<h3><a href="\([^"]*\)".*/\1/p')

    # Aggiungi i link estratti al file di salvataggio
    echo "$links" >> "$FILE_NAME_SAVES"

    # Stampa i link estratti per verifica
    echo "$links"

    ((page++))
  done

done < "$URL_LIST_DIR"
