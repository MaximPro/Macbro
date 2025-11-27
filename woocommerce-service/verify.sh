#!/bin/bash

# ================================
# WooCommerce AI Service Verification
# Prüft ob alles korrekt installiert ist
# ================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║    🔍 WooCommerce AI Service - Verification             ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

ERRORS=0
WARNINGS=0

# Change to script directory
cd "$(dirname "$0")"

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

# ================================
# 1. Check System Requirements
# ================================

echo -e "${BLUE}━━━ System Requirements ━━━${NC}"

# Python
if command -v python3 &> /dev/null; then
    VERSION=$(python3 --version | cut -d' ' -f2)
    check_pass "Python ${VERSION}"
else
    check_fail "Python 3 nicht gefunden"
fi

# Ollama
if command -v ollama &> /dev/null; then
    VERSION=$(ollama --version 2>&1 | head -n1)
    check_pass "Ollama ${VERSION}"
else
    check_fail "Ollama nicht gefunden"
fi

# ================================
# 2. Check Ollama Server
# ================================

echo -e "\n${BLUE}━━━ Ollama Server ━━━${NC}"

if pgrep -x "ollama" > /dev/null; then
    check_pass "Ollama Server läuft"

    # Test Ollama connection
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        check_pass "Ollama API erreichbar"

        # Check models
        MODELS=$(ollama list 2>&1)
        if echo "$MODELS" | grep -q "llama"; then
            MODEL_COUNT=$(echo "$MODELS" | grep -c "llama")
            check_pass "${MODEL_COUNT} Llama Model(s) gefunden"

            # Show models
            echo "    Verfügbare Models:"
            echo "$MODELS" | grep "llama" | sed 's/^/    → /'
        else
            check_warn "Keine Llama Models gefunden"
        fi
    else
        check_fail "Ollama API nicht erreichbar"
    fi
else
    check_fail "Ollama Server läuft nicht"
    echo "    Starte mit: ollama serve"
fi

# ================================
# 3. Check Python Environment
# ================================

echo -e "\n${BLUE}━━━ Python Environment ━━━${NC}"

if [ -d "venv" ]; then
    check_pass "Virtual Environment existiert"

    # Activate and check packages
    source venv/bin/activate

    # Check requirements
    REQUIRED_PACKAGES=("requests" "ollama" "python-dotenv")
    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        if python3 -c "import $pkg" 2>/dev/null; then
            VERSION=$(python3 -c "import $pkg; print($pkg.__version__)" 2>/dev/null || echo "unknown")
            check_pass "Package '$pkg' installiert (${VERSION})"
        else
            check_fail "Package '$pkg' fehlt"
        fi
    done
else
    check_fail "Virtual Environment nicht gefunden"
fi

# ================================
# 4. Check Configuration
# ================================

echo -e "\n${BLUE}━━━ Konfiguration ━━━${NC}"

if [ -f ".env" ]; then
    check_pass ".env Datei existiert"

    # Check permissions
    PERMS=$(stat -f "%OLp" .env 2>/dev/null || stat -c "%a" .env 2>/dev/null)
    if [ "$PERMS" = "600" ]; then
        check_pass "Permissions korrekt (600)"
    else
        check_warn "Permissions nicht optimal (${PERMS}, sollte 600 sein)"
        echo "    Fix mit: chmod 600 .env"
    fi

    # Check required variables
    source .env
    if [ -n "$WC_URL" ]; then
        check_pass "WC_URL gesetzt: ${WC_URL}"
    else
        check_fail "WC_URL fehlt in .env"
    fi

    if [ -n "$WC_CONSUMER_KEY" ]; then
        if [[ $WC_CONSUMER_KEY == ck_* ]]; then
            check_pass "WC_CONSUMER_KEY gesetzt (Format OK)"
        else
            check_warn "WC_CONSUMER_KEY Format ungültig (sollte mit 'ck_' beginnen)"
        fi
    else
        check_fail "WC_CONSUMER_KEY fehlt"
    fi

    if [ -n "$WC_CONSUMER_SECRET" ]; then
        if [[ $WC_CONSUMER_SECRET == cs_* ]]; then
            check_pass "WC_CONSUMER_SECRET gesetzt (Format OK)"
        else
            check_warn "WC_CONSUMER_SECRET Format ungültig (sollte mit 'cs_' beginnen)"
        fi
    else
        check_fail "WC_CONSUMER_SECRET fehlt"
    fi

    if [ -n "$OLLAMA_MODEL" ]; then
        check_pass "OLLAMA_MODEL: ${OLLAMA_MODEL}"
    else
        check_warn "OLLAMA_MODEL nicht gesetzt, nutze Default"
    fi
else
    check_fail ".env Datei nicht gefunden"
    echo "    Erstelle mit: cp .env.example .env"
fi

# ================================
# 5. Check WooCommerce API
# ================================

echo -e "\n${BLUE}━━━ WooCommerce API Test ━━━${NC}"

if [ -f ".env" ]; then
    source .env

    if [ -n "$WC_URL" ] && [ -n "$WC_CONSUMER_KEY" ] && [ -n "$WC_CONSUMER_SECRET" ]; then
        # Test API connection
        RESPONSE=$(curl -s -u "$WC_CONSUMER_KEY:$WC_CONSUMER_SECRET" \
            "$WC_URL/wp-json/wc/v3/system_status" \
            -w "\n%{http_code}" 2>/dev/null)

        HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

        if [ "$HTTP_CODE" = "200" ]; then
            check_pass "WooCommerce API verbunden (HTTP 200)"

            # Get WooCommerce version
            WC_VERSION=$(echo "$RESPONSE" | head -n-1 | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('environment', {}).get('version', 'unknown'))" 2>/dev/null || echo "unknown")
            check_pass "WooCommerce Version: ${WC_VERSION}"

        elif [ "$HTTP_CODE" = "401" ]; then
            check_fail "WooCommerce API Auth fehlgeschlagen (HTTP 401)"
            echo "    Prüfe Consumer Key/Secret in .env"
        elif [ "$HTTP_CODE" = "404" ]; then
            check_fail "WooCommerce API nicht gefunden (HTTP 404)"
            echo "    Prüfe WC_URL in .env"
        elif [ -z "$HTTP_CODE" ]; then
            check_fail "Keine Verbindung zu WooCommerce möglich"
            echo "    Prüfe Internet-Verbindung und WC_URL"
        else
            check_warn "Unerwarteter HTTP Code: ${HTTP_CODE}"
        fi

        # Test products endpoint
        PRODUCTS_RESPONSE=$(curl -s -u "$WC_CONSUMER_KEY:$WC_CONSUMER_SECRET" \
            "$WC_URL/wp-json/wc/v3/products?per_page=1" \
            -w "\n%{http_code}" 2>/dev/null)

        PRODUCTS_HTTP_CODE=$(echo "$PRODUCTS_RESPONSE" | tail -n1)

        if [ "$PRODUCTS_HTTP_CODE" = "200" ]; then
            PRODUCT_COUNT=$(echo "$PRODUCTS_RESPONSE" | head -n-1 | python3 -c "import sys, json; print(len(json.load(sys.stdin)))" 2>/dev/null || echo "0")
            if [ "$PRODUCT_COUNT" -gt 0 ]; then
                check_pass "Produkte abrufbar (${PRODUCT_COUNT} gefunden)"
            else
                check_warn "Keine Produkte im Shop gefunden"
            fi
        else
            check_warn "Products Endpoint nicht erreichbar"
        fi
    else
        check_warn "WooCommerce API Test übersprungen (Keys fehlen)"
    fi
else
    check_warn "WooCommerce API Test übersprungen (.env fehlt)"
fi

# ================================
# 6. Check Scripts
# ================================

echo -e "\n${BLUE}━━━ Scripts ━━━${NC}"

if [ -f "woocommerce_ai_processor.py" ]; then
    check_pass "woocommerce_ai_processor.py gefunden"

    if [ -x "woocommerce_ai_processor.py" ]; then
        check_pass "Script ist ausführbar"
    else
        check_warn "Script nicht ausführbar"
        echo "    Fix mit: chmod +x woocommerce_ai_processor.py"
    fi

    # Syntax check
    if python3 -m py_compile woocommerce_ai_processor.py 2>/dev/null; then
        check_pass "Python Syntax OK"
    else
        check_fail "Python Syntax Fehler"
    fi
else
    check_fail "woocommerce_ai_processor.py nicht gefunden"
fi

if [ -f "test-order.txt" ]; then
    check_pass "test-order.txt gefunden"
else
    check_warn "test-order.txt nicht gefunden"
fi

# ================================
# Summary
# ================================

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║    📊 Verification Summary                               ║"
echo "║                                                          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ Alle Tests bestanden!${NC}"
    echo ""
    echo "Das System ist bereit für Production. 🎉"
    echo ""
    echo "Nächste Schritte:"
    echo "  1. Test-Order erstellen: python3 woocommerce_ai_processor.py test-order.txt"
    echo "  2. macOS Service einrichten (siehe WOOCOMMERCE-AI-SERVICE.md)"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ ${WARNINGS} Warning(s)${NC}"
    echo ""
    echo "Das System funktioniert, aber einige Optimierungen sind möglich."
    echo "Siehe Warnungen oben für Details."
    exit 0
else
    echo -e "${RED}✗ ${ERRORS} Error(s), ${WARNINGS} Warning(s)${NC}"
    echo ""
    echo "Bitte behebe die Fehler bevor du fortfährst."
    echo "Siehe Error-Meldungen oben für Details."
    exit 1
fi
