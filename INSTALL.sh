#!/bin/bash
# Scan Organizer – Vollständige Installationsroutine
# Aufruf: ./INSTALL.sh [--local] [--zip PATH_ZUM_ZIP]

# Farbcodes für Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Standard-ZIP-URL (falls nicht lokal)
DEFAULT_ZIP_URL="https://linux.bit-field.de/downloads/scan_organizer_cli.tar.gz"

# Argument-Parsing
LOCAL=false
ZIP_PATH=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --local)
            LOCAL=true
            shift
            ;;
        --zip)
            ZIP_PATH="$2"
            shift 2
            ;;
        *)
            echo -e "${RED}Unbekanntes Argument: $1${NC}"
            exit 1
            ;;
    esac
done

# Abbruch bei Fehlern
set -e

# 1. Prüfe, ob als root ausgeführt wird (für Systempakete)
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}Warnung: Einige Pakete erfordern root-Rechte.${NC}"
    echo -e "${YELLOW}Passwort für sudo wird später abgefragt.${NC}"
fi

# 2. Systempakete installieren (inkl. Abhängigkeiten für Tesseract, Scanner UND Pillow)
echo -e "${GREEN}==> Installiere Systempakete...${NC}"
sudo apt update
sudo apt install -y \
    tesseract-ocr \
    tesseract-ocr-deu \
    tesseract-ocr-eng \
    libsane1 \
    sane \
    sane-utils \
    python3 \
    python3-pip \
    python3-venv \
    unzip \
    python3-dev \
    libjpeg-dev \
    zlib1g-dev \
    libtiff-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libwebp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libimagequant-dev \
    sqlite3

# 3. Projektverzeichnis erstellen
PROJECT_DIR="$HOME/scan_organizer2"
echo -e "${GREEN}==> Erstelle Projektverzeichnis: $PROJECT_DIR${NC}"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# 4. ZIP-Archiv herunterladen oder lokal nutzen
if [ -n "$ZIP_PATH" ]; then
    # Benutzerdefiniertes ZIP
    echo -e "${GREEN}==> Verwende benutzerdefiniertes ZIP: $ZIP_PATH${NC}"
    cp "$ZIP_PATH" "$PROJECT_DIR/scan_organizer_cli.tar.gz"
elif [ "$LOCAL" = true ]; then
    # Lokales ZIP (wenn --local angegeben)
    echo -e "${GREEN}==> Verwende lokales ZIP-Archiv${NC}"
    if [ ! -f "$PROJECT_DIR/scan_organizer_cli.tar.gz" ]; then
        echo -e "${RED}Fehler: Lokales ZIP-Archiv nicht gefunden!${NC}"
        exit 1
    fi
else
    # Standard-ZIP herunterladen
    echo -e "${GREEN}==> Lade Scan Organizer herunter...${NC}"
    wget -q "$DEFAULT_ZIP_URL" -O "$PROJECT_DIR/scan_organizer_cli.tar.gz" || {
        echo -e "${RED}Fehler: Download fehlgeschlagen.${NC}"
        echo -e "${YELLOW}Versuche, das ZIP manuell herunterzuladen und mit --zip anzugeben.${NC}"
        exit 1
    }
fi

# 5. ZIP-Archiv entpacken
# Neues (sicherer, mit Überprüfung):
if [ -f "$PROJECT_DIR/scan_organizer_cli.tar.gz" ]; then
    echo -e "${GREEN}==> Entpacke Dateien...${NC}"
    # Erstelle einen temporären Ordner fürs Entpacken
    cd "$PROJECT_DIR"
    tar xvzf "$PROJECT_DIR/scan_organizer_cli.tar.gz"  
    cd 
    # Verschiebe die Dateien in PROJECT_DIR (ohne temp_zip)
    #rm "$PROJECT_DIR/scan_organizer_cli.tar.gz"
else
    echo -e "${RED}Fehler: ZIP-Archiv nicht gefunden!${NC}"
    exit 1
fi

# 6. Virtuelle Umgebung einrichten
echo -e "${GREEN}==> Richte Python-Umgebung ein...${NC}"
python3 -m venv venv
source ~/venv/bin/activate

# 7. Python-Pakete installieren
echo -e "${GREEN}==> Installiere Python-Pakete...${NC}"
pip install --upgrade pip
pip install Pillow>=10.0.0 numpy>=1.26.0 pytesseract>=0.3.10 opencv-python>=4.8.0

# 8. Tesseract prüfen
echo -e "${GREEN}==> Prüfe Tesseract-Installation...${NC}"
if ! command -v tesseract &> /dev/null; then
    echo -e "${RED}Fehler: Tesseract nicht gefunden!${NC}"
    echo -e "${YELLOW}Versuche, es manuell zu installieren: sudo apt install tesseract-ocr${NC}"
    exit 1
fi
tesseract --version

# 9. Scanner prüfen
echo -e "${GREEN}==> Prüfe Scanner...${NC}"
if ! command -v scanimage &> /dev/null; then
    echo -e "${RED}Fehler: scanimage (SANE) nicht gefunden!${NC}"
    echo -e "${YELLOW}Versuche, es manuell zu installieren: sudo apt install libsane sane-utils${NC}"
    exit 1
fi
echo -e "Verfügbare Scanner:"
scanimage -L || echo -e "${YELLOW}Kein Scanner gefunden.${NC}"

# 10. pytesseract-Pfad anpassen (falls nötig)
##echo -e "${GREEN}==> Konfiguriere pytesseract...${NC}"
##TESSERACT_PATH=$(which tesseract)
##if [ -n "$TESSERACT_PATH" ]; then
##    echo "pytesseract.pytesseract.tesseract_cmd = '$TESSERACT_PATH'" > venv/lib/python3.*/site-packages/pytesseract/__init__.py
##    echo -e "Tesseract-Pfad gesetzt auf: $TESSERACT_PATH"
##fi

# 11. scan_organizer.py ausführbar machen
echo -e "${GREEN}==> Setze Berechtigungen...${NC}"
chmod +x "$PROJECT_DIR/scan_organizer.py"

# 12. Erfolgsmeldung
echo -e "${GREEN}"
echo "=========================================="
echo "Installation abgeschlossen!"
echo "=========================================="
echo "1. Wechsle in das Projektverzeichnis:"
echo "   cd $PROJECT_DIR"
echo "2. Aktiviere die virtuelle Umgebung:"
echo "   source ~/venv/bin/activate"
echo "3. Starte den Scan Organizer:"
echo "   ./scan_organizer.py file ~/scans/test.jpg --label \"Test\""
echo "=========================================="
echo -e "${NC}"


