# 🤖 WooCommerce AI Service
> **November 2025 Edition** - Verified & Simplified

Lokale KI-gestützte Order-Automatisierung für WooCommerce - 100% privat, keine Cloud!

---

## ⚡ Super-Quick Start (3 Klicks!)

```bash
# 1. Doppelklick auf INSTALL.command
# 2. Fertig! 🎉
```

**Das war's!** Der Installer macht alles automatisch:
- ✅ Ollama Installation
- ✅ AI Model Download (Llama 3.1/3.3)
- ✅ Python Setup
- ✅ Dependency Installation
- ✅ Konfiguration

---

## 🔍 Verifikation

Nach Installation:

```bash
./verify.sh
```

Prüft:
- System Requirements
- Ollama Server & Models
- Python Environment
- WooCommerce API Connection
- Script Syntax

---

## 🚀 Updates November 2025

### ✨ Neue Features

**Ollama v0.12.10 (Nov 5, 2025):**
- Web Search API Integration
- DeepSeek-V3.1 Support
- Flash Attention (schneller!)
- Bessere Performance

**WooCommerce 10.3 (Aktuell):**
- **MCP Beta Support** - Model Context Protocol!
- COGS API Integration
- REST API v3 stabil

**AI Models:**
- **Llama 3.3 70B** - Beste Qualität (High-End Macs)
- **Llama 3.1 8B** - Beste Balance (Standard) ✅
- **Llama 3.2 3B** - Für schwächere Hardware

---

## 💻 Nutzung

### Option 1: Command Line

```bash
# Virtual Environment aktivieren
source venv/bin/activate

# Test mit Beispiel-Email
python3 woocommerce_ai_processor.py test-order.txt

# Eigene Email verarbeiten
python3 woocommerce_ai_processor.py meine-email.txt
```

### Option 2: macOS Service

**Setup (einmalig):**
1. Automator öffnen
2. "Schnellaktion" wählen
3. Shell-Script Action hinzufügen
4. Script einfügen (siehe WOOCOMMERCE-AI-SERVICE.md)
5. Als "WooCommerce Order" speichern

**Nutzung:**
- Email-Text markieren
- Rechtsklick → Services → "WooCommerce Order"
- Fertig! Order ist erstellt 🎉

---

## 📁 Datei-Struktur

```
woocommerce-service/
├── INSTALL.command              ⭐ One-Click Installer
├── verify.sh                    ⭐ Verification Script
├── woocommerce_ai_processor.py  📜 Haupt-Script
├── .env                         🔐 Deine Konfiguration
├── .env.example                 📋 Template
├── requirements.txt             📦 Dependencies
├── test-order.txt               ✉️ Test-Email
├── venv/                        🐍 Python Environment
└── review_queue/                📥 Manuelle Reviews
```

---

## 🔧 Konfiguration

Die `.env` Datei wird beim ersten Install erstellt. Falls manuell editieren:

```bash
# WooCommerce
WC_URL=https://deine-shop.de
WC_CONSUMER_KEY=ck_xxxxx
WC_CONSUMER_SECRET=cs_xxxxx

# AI Model (wähle eins)
OLLAMA_MODEL=llama3.1:8b      # Standard (empfohlen)
# OLLAMA_MODEL=llama3.2:3b    # Leichter
# OLLAMA_MODEL=llama3.3:70b   # Beste Qualität

# Confidence Threshold
MIN_CONFIDENCE=0.75
```

**API Keys erhalten:**
1. WooCommerce → Settings → Advanced → REST API
2. "Add Key" klicken
3. Description: "macOS AI Service"
4. Permissions: **Read/Write**
5. Keys kopieren → in .env eintragen

---

## 🆘 Troubleshooting

### Ollama startet nicht

```bash
# Manuell starten
ollama serve

# In neuem Terminal: Test
ollama list
```

### Python Import Errors

```bash
source venv/bin/activate
pip install --upgrade -r requirements.txt
```

### WooCommerce 401 Error

```bash
# Test API Keys
curl -u "ck_KEY:cs_SECRET" \
  https://deine-shop.de/wp-json/wc/v3/system_status
```

Wenn 401: Keys in .env prüfen!

### Model zu langsam

**Wechsel zu kleinerem Model:**

```bash
# In .env:
OLLAMA_MODEL=llama3.2:3b

# Model laden
ollama pull llama3.2:3b
```

---

## 📊 Performance

| Model | Size | RAM | Speed | Quality |
|-------|------|-----|-------|---------|
| Llama 3.2 3B | 2GB | 4GB | ⚡⚡⚡ | ⭐⭐⭐ |
| Llama 3.1 8B | 4.7GB | 8GB | ⚡⚡ | ⭐⭐⭐⭐ |
| Llama 3.3 70B | 40GB | 64GB+ | ⚡ | ⭐⭐⭐⭐⭐ |

**Empfehlung:** Llama 3.1 8B für beste Balance

---

## 🎓 Weitere Dokumentation

- **[WOOCOMMERCE-AI-SERVICE.md](../WOOCOMMERCE-AI-SERVICE.md)** - Komplette Anleitung
- **[awesome-macos-automation.md](../awesome-macos-automation.md)** - Alle Automation Resources
- **[SETUP-GUIDE.md](../SETUP-GUIDE.md)** - macOS Automation Basics

---

## ✅ Verification Checklist

Nach Installation sollte `./verify.sh` zeigen:

- [x] Python 3.x installiert
- [x] Ollama v0.12.10+ installiert
- [x] Ollama Server läuft
- [x] Llama Model verfügbar
- [x] Virtual Environment OK
- [x] Python Packages installiert
- [x] .env Datei korrekt
- [x] WooCommerce API erreichbar (HTTP 200)
- [x] Produkte abrufbar
- [x] Script Syntax OK

**Alles grün?** → Production-ready! 🚀

---

## 🔐 Security & Privacy

- ✅ **100% lokal** - Ollama läuft auf deinem Mac
- ✅ **Keine Cloud-Calls** - Kein OpenAI, kein Google
- ✅ **DSGVO-konform** - Alle Daten bleiben lokal
- ✅ **Sichere Keys** - .env mit chmod 600
- ✅ **Read-Only API** - WooCommerce braucht nur Read/Write, kein Admin

---

**Happy Automating! 🚀**

*November 2025 - Verified & Optimized*
