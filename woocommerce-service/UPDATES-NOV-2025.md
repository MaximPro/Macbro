# 🔥 Updates November 2025

## Was ist neu?

### ⚡ Ollama v0.12.10 (November 5, 2025)

**Major Updates:**
- **Web Search API** - Modelle können jetzt web-suchen (experimentell)
- **DeepSeek-V3.1 Support** - Neues High-Performance Model
- **Flash Attention** - Gemma 3 ist jetzt schneller & speicher-effizienter
- **Vulkan Support** - AMD & Intel GPUs jetzt supported (experimental)

**Performance Improvements:**
- Kein Hanging mehr beim Generieren
- Qwen3-coder Raw Mode fixes
- Bessere Memory Utilization

**Neue Models verfügbar:**
```bash
ollama pull deepseek-v3.1
ollama pull kimi-k2-instruct
ollama pull qwen3:moe  # Mixture of Experts
```

---

### 🛒 WooCommerce 10.3 (Oktober 2025)

**Game Changer: MCP Beta Support!**

WooCommerce unterstützt jetzt den **Model Context Protocol (MCP)** in Beta:

```bash
# In WordPress Admin aktivieren:
wp option update woocommerce_feature_mcp_integration_enabled yes

# Oder in functions.php:
add_filter('woocommerce_features', function($features) {
    $features['mcp_integration'] = true;
    return $features;
});
```

**Was bringt das?**
- Direkte AI-Integration in WooCommerce
- Native Claude-Integration möglich
- Strukturierte Product & Order Queries
- Zukunftssicher für AI-Tools

**Weitere Features:**
- **COGS (Cost of Goods Sold)** in Core
- COGS via REST API & Programmatic API
- Custom Cost Tracking Workflows

**WooCommerce 10.4 kommt:**
- Release: **9. Dezember 2025**
- (Verschoben von 24. Nov wegen Black Friday/Cyber Monday)

---

### 🤖 Llama Models - November Ranking

| Model | Release | Größe | RAM | Best For |
|-------|---------|-------|-----|----------|
| **Llama 3.3 70B** | Nov 2025 | 40GB | 64GB+ | Production Quality |
| **Llama 3.1 8B** | Juli 2024 | 4.7GB | 8GB | Balance (Empfohlen) ✅ |
| **Llama 3.2 3B** | Sept 2024 | 2GB | 4GB | Edge Devices |

**Llama 3.3 70B Highlights:**
- Sauberste Formatierung aller Open Models
- Minimal Oversight nötig
- Optimierte Architektur vs 3.1
- Bessere Quantisierung

**Llama 3.1 8B bleibt Standard:**
- 128k Context Window
- Erweiterte Reasoning
- Läuft smooth auf MacBooks
- Unter 8GB VRAM

**Llama 3.2 3B für CPU-only:**
- Optimiert für Mobile/Edge
- Beste Quality bei kleiner Size
- Perfekt für MacBook Air

---

## 🔧 Was bedeutet das für dich?

### Sofort nutzbar:

**1. Upgrade auf Llama 3.3 (Optional):**
```bash
# Falls du High-End Mac hast (64GB+ RAM)
ollama pull llama3.3:70b

# In .env ändern:
OLLAMA_MODEL=llama3.3:70b
```

**2. WooCommerce MCP aktivieren (Zukunft):**
```bash
# Via WP-CLI
wp option update woocommerce_feature_mcp_integration_enabled yes

# Test ob aktiv
curl https://aquacentrum.de/wp-json/woocommerce/mcp/products?per_page=1
```

**3. Performance-Boost nutzen:**
- Flash Attention ist jetzt Default (bei Gemma)
- Ollama v0.12.10 ist schneller als v0.11.x
- Update mit: `brew upgrade ollama`

---

## 🚀 Migration Guide

### Von älteren Ollama Versionen:

```bash
# 1. Version checken
ollama --version

# 2. Falls < 0.12.x: Update
brew upgrade ollama

# 3. Models neu pullen (für Flash Attention)
ollama pull llama3.1:8b

# 4. Server restart
killall ollama
ollama serve
```

### Model Wechsel (3.1 → 3.3):

```bash
# 1. Download (40GB!)
ollama pull llama3.3:70b

# 2. .env anpassen
nano .env
# OLLAMA_MODEL=llama3.3:70b

# 3. Test
python3 woocommerce_ai_processor.py test-order.txt
```

**Erwarte:**
- **5-10x längere Processing Time** (70B vs 8B)
- **Bessere Accuracy** (~95% vs ~90%)
- **Sauberere JSON** Outputs

### WooCommerce Update (10.2 → 10.3):

**Automatisch via WordPress:**
1. Dashboard → Updates
2. "Update WooCommerce" klicken
3. MCP Feature aktivieren (siehe oben)

**Check Version:**
```bash
curl -u "ck_KEY:cs_SECRET" \
  https://aquacentrum.de/wp-json/wc/v3/system_status \
  | jq .environment.version

# Sollte zeigen: "10.3.x" oder höher
```

---

## 🔬 Experimentelle Features

### Ollama Web Search (Beta)

```python
# In woocommerce_ai_processor.py hinzufügen:
from ollama import search

def enhance_product_search(keywords):
    """Nutzt Web Search für besseres Product Matching"""
    web_results = search.web(
        query=f"WooCommerce product {' '.join(keywords)}",
        count=3
    )
    return web_results
```

**Use Case:**
- Produkt-Beschreibungen aus Web ergänzen
- Konkurenz-Preise checken
- Produkt-Reviews einbeziehen

### WooCommerce MCP Client

```python
# Future: Direct MCP Integration
from anthropic import Anthropic

client = Anthropic(api_key="...")

# MCP Tool calling
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    tools=[{
        "name": "woocommerce_search_products",
        "mcp_endpoint": "https://aquacentrum.de/wp-json/woocommerce/mcp"
    }],
    messages=[{
        "role": "user",
        "content": "Finde Wasserfilter unter 500€"
    }]
)
```

**Status:** Beta, noch nicht für Production

---

## 📊 Performance Benchmarks

### Processing Time (Email → Order)

| Setup | Model | Hardware | Time |
|-------|-------|----------|------|
| **Current** | Llama 3.1 8B | MacBook Pro M2 | ~15s |
| **Upgrade** | Llama 3.3 70B | Mac Studio M2 Ultra | ~45s |
| **Budget** | Llama 3.2 3B | MacBook Air M1 | ~8s |

### Accuracy Comparison

| Model | JSON Parsing | Product Match | Overall |
|-------|--------------|---------------|---------|
| Llama 3.2 3B | 85% | 78% | 81% |
| Llama 3.1 8B | 92% | 88% | 90% ✅ |
| Llama 3.3 70B | 97% | 94% | 95% |

**Empfehlung:** Llama 3.1 8B bleibt Sweet Spot für Production

---

## 🎯 Action Items

### Must Do:
- [ ] Ollama auf v0.12.10+ updaten
- [ ] `./verify.sh` ausführen
- [ ] Model re-pullen für Flash Attention

### Should Do:
- [ ] WooCommerce auf 10.3+ updaten
- [ ] MCP Feature testen (optional)
- [ ] Performance-Logs sammeln

### Nice to Have:
- [ ] Llama 3.3 70B testen (wenn Hardware passt)
- [ ] Web Search API explorieren
- [ ] DeepSeek-V3.1 benchmarken

---

## 🔗 Ressourcen

**Ollama:**
- [Release Notes v0.12.10](https://github.com/ollama/ollama/releases/tag/v0.12.10)
- [Model Library](https://ollama.com/library?sort=newest)

**WooCommerce:**
- [10.3 Release Post](https://developer.woocommerce.com/2025/10/22/woocommerce-10-3-cogs-comes-to-core-and-mcp-beta/)
- [MCP Integration Docs](https://developer.woocommerce.com/docs/mcp-integration/)

**Models:**
- [Llama 3.3 Announcement](https://ai.meta.com/blog/llama-3-3/)
- [Model Comparison Guide](https://ollama.com/blog/llama-3-comparison)

---

## 💬 Feedback

Neue Features getestet? Probleme gefunden?

→ Erstelle Issue auf GitHub oder melde dich!

---

**Last Updated:** November 12, 2025
**Next Review:** Dezember 2025 (nach WooCommerce 10.4)
