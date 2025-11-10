# 🤖 WooCommerce AI Service

Lokale KI-gestützte Order-Automatisierung für WooCommerce - ohne Cloud-Dependencies!

## Quick Start

```bash
# 1. Setup ausführen
chmod +x setup.sh
./setup.sh

# 2. .env Datei mit deinen WooCommerce API Keys ausfüllen
nano .env

# 3. Test
source venv/bin/activate
python3 woocommerce_ai_processor.py test-order.txt
```

## Features

- ✅ **100% Lokal** - Keine Daten verlassen deinen Mac
- ✅ **Ollama + Llama 3.1** - Kostenlose, leistungsstarke KI
- ✅ **Intelligentes Parsing** - Email → Strukturierte Order
- ✅ **Produkt-Matching** - AI findet das beste Produkt
- ✅ **macOS Integration** - Als Service nutzbar

## Nutzung

### Als Kommandozeilen-Tool

```bash
# Email-Text via File
python3 woocommerce_ai_processor.py email.txt

# Email-Text via stdin
cat email.txt | python3 woocommerce_ai_processor.py

# Direct input
echo "Kunde: Max Müller..." | python3 woocommerce_ai_processor.py
```

### Als macOS Service

1. Automator öffnen
2. "Schnellaktion" erstellen
3. Script aus WOOCOMMERCE-AI-SERVICE.md kopieren
4. Als "WooCommerce Order erstellen" speichern

**Nutzung:**
- Text markieren → Rechtsklick → Services → "WooCommerce Order erstellen"

## Dokumentation

Vollständige Dokumentation: [WOOCOMMERCE-AI-SERVICE.md](../WOOCOMMERCE-AI-SERVICE.md)

## Struktur

```
woocommerce-service/
├── woocommerce_ai_processor.py  # Haupt-Script
├── .env.example                 # Konfigurations-Template
├── requirements.txt             # Python Dependencies
├── setup.sh                     # Auto-Setup Script
├── test-order.txt              # Test-Email
└── review_queue/               # Manuelle Review Orders
```

## Troubleshooting

**Ollama läuft nicht:**
```bash
ollama serve
```

**Python Errors:**
```bash
source venv/bin/activate
pip install -r requirements.txt
```

**WooCommerce API 401:**
Prüfe API Keys in .env

---

**Erstellt mit ❤️ für macOS**
