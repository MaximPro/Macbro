#!/bin/bash
set -e

echo "🚀 WooCommerce AI Service Setup"
echo "================================"

# Check if Ollama is installed
if ! command -v ollama &> /dev/null; then
    echo "❌ Ollama nicht gefunden. Installiere mit:"
    echo "   brew install ollama"
    exit 1
fi

echo "✅ Ollama gefunden"

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 nicht gefunden"
    exit 1
fi

echo "✅ Python 3 gefunden"

# Create virtual environment
echo "📦 Erstelle Virtual Environment..."
python3 -m venv venv

# Activate and install dependencies
echo "📦 Installiere Dependencies..."
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Create .env if not exists
if [ ! -f .env ]; then
    echo "📝 Erstelle .env Datei..."
    cp .env.example .env
    echo "⚠️  Bitte .env Datei mit deinen WooCommerce API Keys ausfüllen!"
fi

# Make script executable
chmod +x woocommerce_ai_processor.py

# Create review queue directory
mkdir -p review_queue

# Check if Ollama server is running
if ! pgrep -x "ollama" > /dev/null; then
    echo "🔄 Starte Ollama Server..."
    ollama serve &
    sleep 3
fi

# Pull Llama model if not exists
echo "🤖 Prüfe Ollama Model..."
if ! ollama list | grep -q "llama3.1:8b"; then
    echo "📥 Downloading Llama 3.1 Model (4GB)..."
    ollama pull llama3.1:8b
else
    echo "✅ Llama 3.1 Model bereits vorhanden"
fi

echo ""
echo "✅ Setup Complete!"
echo ""
echo "Nächste Schritte:"
echo "1. Bearbeite .env Datei mit deinen WooCommerce API Keys"
echo "2. Test mit: source venv/bin/activate && python3 woocommerce_ai_processor.py test-order.txt"
echo "3. Erstelle macOS Service (siehe WOOCOMMERCE-AI-SERVICE.md)"
