#!/bin/bash

# ================================
# WooCommerce AI Service Installer
# One-Click Setup für macOS
# ================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║    🤖 WooCommerce AI Service - One-Click Installer      ║"
echo "║    November 2025 Edition (Latest Updates)               ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Change to script directory
cd "$(dirname "$0")"

# Function to print status
print_status() {
    echo -e "${BLUE}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# ================================
# Step 1: Check Prerequisites
# ================================

print_status "Schritt 1/6: Prüfe Voraussetzungen..."

# Check Homebrew
if ! command -v brew &> /dev/null; then
    print_error "Homebrew nicht gefunden!"
    echo "  Installiere Homebrew mit:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi
print_success "Homebrew gefunden"

# Check Python 3
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 nicht gefunden!"
    echo "  Installiere mit: brew install python3"
    exit 1
fi
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
print_success "Python ${PYTHON_VERSION} gefunden"

# ================================
# Step 2: Install Ollama
# ================================

print_status "Schritt 2/6: Installiere Ollama..."

if ! command -v ollama &> /dev/null; then
    print_warning "Ollama nicht gefunden. Installiere..."
    brew install ollama
    if [ $? -eq 0 ]; then
        print_success "Ollama installiert"
    else
        print_error "Ollama Installation fehlgeschlagen"
        exit 1
    fi
else
    OLLAMA_VERSION=$(ollama --version 2>&1 | head -n1)
    print_success "Ollama bereits installiert (${OLLAMA_VERSION})"
fi

# ================================
# Step 3: Start Ollama Server
# ================================

print_status "Schritt 3/6: Starte Ollama Server..."

# Check if Ollama is already running
if pgrep -x "ollama" > /dev/null; then
    print_success "Ollama Server läuft bereits"
else
    print_warning "Starte Ollama Server im Hintergrund..."
    ollama serve > /dev/null 2>&1 &
    sleep 3
    print_success "Ollama Server gestartet"
fi

# ================================
# Step 4: Download AI Model
# ================================

print_status "Schritt 4/6: Prüfe AI Modelle..."

# Check available models
MODELS=$(ollama list 2>&1)

if echo "$MODELS" | grep -q "llama3.3"; then
    print_success "Llama 3.3 gefunden (empfohlen für beste Qualität)"
    DEFAULT_MODEL="llama3.3:latest"
elif echo "$MODELS" | grep -q "llama3.1"; then
    print_success "Llama 3.1 gefunden (gute Balance)"
    DEFAULT_MODEL="llama3.1:8b"
else
    print_warning "Kein Llama Model gefunden. Welches Modell möchtest du installieren?"
    echo ""
    echo "  1) Llama 3.1 8B  (4.7GB) - Beste Balance, empfohlen für die meisten Macs"
    echo "  2) Llama 3.2 3B  (2.0GB) - Für schwächere Hardware"
    echo "  3) Llama 3.3 70B (40GB) - Beste Qualität (nur für High-End Macs)"
    echo ""
    read -p "Wähle (1-3) [Standard: 1]: " MODEL_CHOICE
    MODEL_CHOICE=${MODEL_CHOICE:-1}

    case $MODEL_CHOICE in
        1)
            MODEL_TO_INSTALL="llama3.1:8b"
            print_status "Downloading Llama 3.1 8B (~4.7GB)..."
            ;;
        2)
            MODEL_TO_INSTALL="llama3.2:3b"
            print_status "Downloading Llama 3.2 3B (~2.0GB)..."
            ;;
        3)
            MODEL_TO_INSTALL="llama3.3:70b"
            print_warning "Llama 3.3 70B benötigt ~40GB RAM!"
            read -p "Fortfahren? (y/n): " CONFIRM
            if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
                print_warning "Installation abgebrochen. Nutze Standard-Modell."
                MODEL_TO_INSTALL="llama3.1:8b"
            fi
            ;;
        *)
            MODEL_TO_INSTALL="llama3.1:8b"
            ;;
    esac

    ollama pull "$MODEL_TO_INSTALL"
    if [ $? -eq 0 ]; then
        print_success "Model $MODEL_TO_INSTALL heruntergeladen"
        DEFAULT_MODEL="$MODEL_TO_INSTALL"
    else
        print_error "Model Download fehlgeschlagen"
        exit 1
    fi
fi

# ================================
# Step 5: Setup Python Environment
# ================================

print_status "Schritt 5/6: Setup Python Environment..."

# Create virtual environment
if [ ! -d "venv" ]; then
    python3 -m venv venv
    print_success "Virtual Environment erstellt"
else
    print_success "Virtual Environment existiert bereits"
fi

# Activate and install dependencies
source venv/bin/activate
pip install --upgrade pip --quiet
pip install -r requirements.txt --quiet

if [ $? -eq 0 ]; then
    print_success "Python Dependencies installiert"
else
    print_error "Dependency Installation fehlgeschlagen"
    exit 1
fi

# ================================
# Step 6: Configure Service
# ================================

print_status "Schritt 6/6: Konfiguration..."

# Create .env if not exists
if [ ! -f ".env" ]; then
    print_warning "Erstelle .env Konfiguration..."
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "WooCommerce API Keys benötigt!"
    echo ""
    echo "So erhältst du die Keys:"
    echo "1. WooCommerce Admin → Settings → Advanced → REST API"
    echo "2. 'Add Key' klicken"
    echo "3. Description: 'macOS AI Service'"
    echo "4. Permissions: Read/Write"
    echo "5. Keys kopieren"
    echo "═══════════════════════════════════════════════════════════"
    echo ""

    read -p "WooCommerce Shop URL (z.B. https://aquacentrum.de): " WC_URL
    read -p "Consumer Key (ck_...): " WC_KEY
    read -p "Consumer Secret (cs_...): " WC_SECRET

    cat > .env << EOF
# WooCommerce Configuration
WC_URL=${WC_URL}
WC_CONSUMER_KEY=${WC_KEY}
WC_CONSUMER_SECRET=${WC_SECRET}

# Ollama Configuration
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=${DEFAULT_MODEL}

# Confidence Threshold (0.0 - 1.0)
MIN_CONFIDENCE=0.75

# Review Queue Path
REVIEW_QUEUE_PATH=./review_queue
EOF

    chmod 600 .env
    print_success ".env Datei erstellt (Permissions: 600)"
else
    print_success ".env Datei existiert bereits"
fi

# Create review queue directory
mkdir -p review_queue

# Make scripts executable
chmod +x woocommerce_ai_processor.py
chmod +x verify.sh

# ================================
# Installation Complete!
# ================================

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║    ✅ Installation erfolgreich abgeschlossen!           ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "Nächste Schritte:"
echo ""
echo "1. ${GREEN}Test ausführen:${NC}"
echo "   ./verify.sh"
echo ""
echo "2. ${GREEN}Service erstellen:${NC}"
echo "   - Automator öffnen"
echo "   - 'Schnellaktion' wählen"
echo "   - Script aus WOOCOMMERCE-AI-SERVICE.md kopieren"
echo ""
echo "3. ${GREEN}Erste Order erstellen:${NC}"
echo "   source venv/bin/activate"
echo "   python3 woocommerce_ai_processor.py test-order.txt"
echo ""
echo "📖 Vollständige Doku: WOOCOMMERCE-AI-SERVICE.md"
echo ""

# Ask if user wants to run verification
read -p "Möchtest du jetzt einen Verifikationstest ausführen? (y/n): " RUN_TEST
if [[ $RUN_TEST =~ ^[Yy]$ ]]; then
    ./verify.sh
fi
