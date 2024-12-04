#!/usr/bin/env bash
<< 'COMMENT'
    Der äußere Schleife iteriert über die Hauptverzeichnisse (*/).
    Die innere Schleife sucht in jedem Unterverzeichnis nach .conf Dateien.
    Für jede gefundene .conf Datei wird neofetch ausgeführt.
    Nach jeder Ausführung von neofetch wartet der Skript 1.5 Sekunden.

    Dieser Befehl findet .conf Dateien in allen Unterverzeichnissen, nicht nur im Hauptverzeichnis.
    Der Pfad zu den Konfigurationsdateien wird vollständig angegeben, um sicherzustellen, dass neofetch sie finden kann.
    
   
	- Speichert und stellt das ursprüngliche Arbeitsverzeichnis wieder her 
	- Überprüft, ob Neofetch installiert ist 
	- Integriert Verzeichnis- und Dateiexistenzprüfungen 
	- Implementiert den Strg+C-Handler zum sauberen Beenden 
	- Fügt Fehlerbehandlung für den Befehl cd hinzu Überspringt ungültige Verzeichnisse und Dateien

COMMENT


# Store original path
ORIGINAL_PATH=$(pwd)

# Check if neofetch is installed
if ! command -v neofetch >/dev/null 2>&1; then
    echo "${RED}Error: neofetch is not installed. Please install it first.${RESET}"
    exit 1
fi

base_dir="/home/project/neofetch-themes"

# Check if base directory exists
if [ ! -d "$base_dir" ]; then
    echo "${RED}Error: Directory $base_dir not found${RESET}"
    exit 1
fi

# Change to theme directory
cd "$base_dir" || exit 1

# Trap Ctrl+C
trap 'echo -e "\n${SKY}Preview stopped by user${RESET}"; cd "$ORIGINAL_PATH"; exit 0' INT

echo -e "\n${SKY}Abbrechen per CTL+C${RESET}"

for dir in */; do
    # Skip if no directories found
    [ -d "$dir" ] || continue
    
    for file in "$dir"*/*.conf; do
        # Skip if no conf files found
        [ -f "$file" ] || continue
        echo -e  "\t${VIOLET}$file${RESET}"
        neofetch --config "$file"
        sleep 1.5
    done
done

# Return to original path
cd "$ORIGINAL_PATH"
