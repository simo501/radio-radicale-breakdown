# Radio Radicale Breakdown

**non affiliato con Radio Radicale**


### Parser

- ```html_processo_parser.sh``` utilizzato per identificare gli url degli audio di un singolo processo all'interno 
delle pagine html relative

### Scraper 

- ```url_processi_bruteforce.sh``` utilizzato per identificare gli url di tutti i processi

### Come vengono riprodotti gli audio dei processi

Viene utilizzato il protocollo **HTTP Live Streaming (HLS)**  
- Il flusso audio viene spezzettato in piccoli chunk (**.ts**) 
- Scaricati tramite richieste **HTTP** 
- Un file (**.m3u8**) contiene la chunklist.
- Viene ricostruito il file **audio integrale** (dal .m3u8)