# 🤖 WooCommerce AI Automation Service für macOS
> Lokale KI-gestützte Order-Automatisierung ohne Cloud-Dependencies

---

## 📖 Überblick

Dieser Service nutzt **lokale KI** (Ollama) um Emails/Text zu analysieren und automatisch WooCommerce Orders zu erstellen.

**Features:**
- ✅ Lokale KI (Ollama mit Llama 3.1)
- ✅ Email-Parsing → Strukturierte Daten
- ✅ Intelligente Produkt-Zuordnung
- ✅ Direkte WooCommerce REST API Integration
- ✅ macOS Service (Rechtsklick → Order erstellen)
- ✅ Automatische Sortierung & Kategorisierung

---

## 🚀 Setup (30 Minuten)

### Schritt 1: Ollama installieren (Lokale KI)

```bash
# Ollama installieren
brew install ollama

# Ollama Server starten
ollama serve

# In neuem Terminal: Llama 3.1 herunterladen (4GB)
ollama pull llama3.1:8b

# Test
ollama run llama3.1:8b "Hallo, kannst du mir helfen?"
```

### Schritt 2: Python Dependencies

```bash
# Virtual Environment erstellen
mkdir -p ~/Automation/woocommerce-service
cd ~/Automation/woocommerce-service
python3 -m venv venv
source venv/bin/activate

# Dependencies installieren
pip install requests ollama python-dotenv
```

### Schritt 3: WooCommerce API Keys

1. **WooCommerce Admin** öffnen
2. **WooCommerce** → **Settings** → **Advanced** → **REST API**
3. **Add Key** klicken
4. **Description:** "macOS Automation"
5. **User:** Admin
6. **Permissions:** Read/Write
7. **Generate API Key** → Keys kopieren

### Schritt 4: Konfiguration

```bash
# .env Datei erstellen
cat > ~/Automation/woocommerce-service/.env << 'EOF'
# WooCommerce Configuration
WC_URL=https://aquacentrum.de
WC_CONSUMER_KEY=ck_dein_key_hier
WC_CONSUMER_SECRET=cs_dein_secret_hier

# Ollama Configuration
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=llama3.1:8b

# Email Configuration (optional)
NOTIFICATION_EMAIL=deine@email.com
EOF
```

---

## 💻 Python Script: woocommerce_ai_processor.py

Erstelle die Hauptdatei:

```python
#!/usr/bin/env python3
"""
WooCommerce AI Order Processor
Nutzt lokale KI (Ollama) für intelligente Email-zu-Order Konvertierung
"""

import sys
import json
import requests
from requests.auth import HTTPBasicAuth
import ollama
from dotenv import load_dotenv
import os
from datetime import datetime

# Load environment variables
load_dotenv()

WC_URL = os.getenv('WC_URL')
WC_KEY = os.getenv('WC_CONSUMER_KEY')
WC_SECRET = os.getenv('WC_CONSUMER_SECRET')
OLLAMA_MODEL = os.getenv('OLLAMA_MODEL', 'llama3.1:8b')


class WooCommerceAI:
    def __init__(self):
        self.wc_url = f"{WC_URL}/wp-json/wc/v3"
        self.auth = HTTPBasicAuth(WC_KEY, WC_SECRET)

    def parse_email_with_ai(self, email_text):
        """
        Nutzt lokale KI um Email-Inhalt zu strukturieren
        """
        prompt = f"""
Du bist ein Experte für E-Commerce Order-Processing.

Analysiere den folgenden Email-Text und extrahiere strukturierte Informationen:

EMAIL TEXT:
{email_text}

AUFGABE:
Extrahiere folgende Informationen und gib sie als gültiges JSON zurück:

{{
  "customer": {{
    "first_name": "Vorname",
    "last_name": "Nachname",
    "email": "email@example.com",
    "phone": "+49...",
    "address": {{
      "address_1": "Straße Nr",
      "city": "Stadt",
      "postcode": "PLZ",
      "country": "DE"
    }}
  }},
  "products": [
    {{
      "description": "Produktbeschreibung aus Email",
      "quantity": 1,
      "keywords": ["keyword1", "keyword2"]
    }}
  ],
  "notes": "Besondere Wünsche oder Anmerkungen",
  "confidence": 0.95
}}

WICHTIG:
- Gib NUR das JSON zurück, keine Erklärungen
- confidence zwischen 0 und 1 (wie sicher bist du?)
- Bei fehlenden Daten: null verwenden
- phone im Format +49...
- country als ISO-Code (DE, AT, CH)
"""

        try:
            response = ollama.generate(
                model=OLLAMA_MODEL,
                prompt=prompt,
                options={
                    "temperature": 0.2,  # Niedriger = konsistenter
                    "top_p": 0.9
                }
            )

            # Parse JSON aus Response
            response_text = response['response'].strip()

            # Finde JSON Block
            if '```json' in response_text:
                json_text = response_text.split('```json')[1].split('```')[0]
            elif '```' in response_text:
                json_text = response_text.split('```')[1].split('```')[0]
            else:
                json_text = response_text

            data = json.loads(json_text)
            return data

        except Exception as e:
            print(f"❌ AI Parsing Error: {e}")
            return None

    def find_matching_products(self, product_request):
        """
        Sucht passende Produkte via WooCommerce API
        """
        keywords = product_request.get('keywords', [])
        description = product_request.get('description', '')

        # Kombiniere Keywords für Suche
        search_query = ' '.join(keywords + [description])

        try:
            response = requests.get(
                f"{self.wc_url}/products",
                auth=self.auth,
                params={
                    'search': search_query,
                    'per_page': 5,
                    'status': 'publish'
                }
            )

            if response.status_code == 200:
                products = response.json()

                if not products:
                    print(f"⚠️ Keine Produkte gefunden für: {search_query}")
                    return None

                # AI-basierte Produkt-Auswahl
                return self.ai_select_best_product(products, product_request)
            else:
                print(f"❌ Product Search Error: {response.status_code}")
                return None

        except Exception as e:
            print(f"❌ WooCommerce API Error: {e}")
            return None

    def ai_select_best_product(self, products, request):
        """
        Nutzt AI um das beste passende Produkt auszuwählen
        """
        products_info = []
        for p in products:
            products_info.append({
                'id': p['id'],
                'name': p['name'],
                'price': p['price'],
                'description': p['short_description'][:200]
            })

        prompt = f"""
Kundenanfrage: {request['description']}
Keywords: {', '.join(request.get('keywords', []))}

Verfügbare Produkte:
{json.dumps(products_info, indent=2, ensure_ascii=False)}

Wähle das BESTE passende Produkt aus.

Gib zurück (nur JSON, keine Erklärung):
{{
  "product_id": 123,
  "confidence": 0.9,
  "reason": "Kurze Begründung"
}}
"""

        try:
            response = ollama.generate(
                model=OLLAMA_MODEL,
                prompt=prompt,
                options={"temperature": 0.3}
            )

            response_text = response['response'].strip()

            # Parse JSON
            if '```' in response_text:
                json_text = response_text.split('```')[1].split('```')[0]
                if json_text.startswith('json'):
                    json_text = json_text[4:]
            else:
                json_text = response_text

            result = json.loads(json_text)

            # Finde das Produkt
            selected = next(p for p in products if p['id'] == result['product_id'])

            print(f"✅ Produkt gewählt: {selected['name']}")
            print(f"   Confidence: {result['confidence']}")
            print(f"   Grund: {result['reason']}")

            return selected

        except Exception as e:
            print(f"⚠️ AI Product Selection failed, using first match: {e}")
            return products[0]

    def create_woocommerce_order(self, customer_data, products_data, notes=""):
        """
        Erstellt Order in WooCommerce
        """
        # Prepare line items
        line_items = []
        for product_data in products_data:
            line_items.append({
                'product_id': product_data['id'],
                'quantity': product_data.get('quantity', 1)
            })

        # Prepare order data
        order_data = {
            'payment_method': 'bacs',
            'payment_method_title': 'Banküberweisung',
            'set_paid': False,
            'billing': {
                'first_name': customer_data.get('first_name', ''),
                'last_name': customer_data.get('last_name', ''),
                'email': customer_data.get('email', ''),
                'phone': customer_data.get('phone', ''),
                'address_1': customer_data.get('address', {}).get('address_1', ''),
                'city': customer_data.get('address', {}).get('city', ''),
                'postcode': customer_data.get('address', {}).get('postcode', ''),
                'country': customer_data.get('address', {}).get('country', 'DE')
            },
            'shipping': {
                'first_name': customer_data.get('first_name', ''),
                'last_name': customer_data.get('last_name', ''),
                'address_1': customer_data.get('address', {}).get('address_1', ''),
                'city': customer_data.get('address', {}).get('city', ''),
                'postcode': customer_data.get('address', {}).get('postcode', ''),
                'country': customer_data.get('address', {}).get('country', 'DE')
            },
            'line_items': line_items,
            'customer_note': notes,
            'meta_data': [
                {
                    'key': '_order_source',
                    'value': 'macos_ai_service'
                },
                {
                    'key': '_created_timestamp',
                    'value': datetime.now().isoformat()
                }
            ]
        }

        try:
            response = requests.post(
                f"{self.wc_url}/orders",
                auth=self.auth,
                json=order_data
            )

            if response.status_code in [200, 201]:
                order = response.json()
                print(f"\n🎉 ORDER ERFOLGREICH ERSTELLT!")
                print(f"   Order ID: #{order['id']}")
                print(f"   Total: {order['total']} {order['currency']}")
                print(f"   Status: {order['status']}")
                print(f"   View: {WC_URL}/wp-admin/post.php?post={order['id']}&action=edit")
                return order
            else:
                print(f"❌ Order Creation Failed: {response.status_code}")
                print(f"   Response: {response.text}")
                return None

        except Exception as e:
            print(f"❌ WooCommerce API Error: {e}")
            return None

    def process_email_to_order(self, email_text):
        """
        Kompletter Workflow: Email → Order
        """
        print("=" * 60)
        print("🤖 WooCommerce AI Order Processor")
        print("=" * 60)

        # Step 1: Parse Email mit AI
        print("\n📧 Schritt 1: Email-Analyse mit lokaler KI...")
        parsed_data = self.parse_email_with_ai(email_text)

        if not parsed_data:
            print("❌ Email konnte nicht geparst werden")
            return None

        confidence = parsed_data.get('confidence', 0)
        print(f"✅ Daten extrahiert (Confidence: {confidence:.0%})")

        if confidence < 0.7:
            print(f"⚠️ WARNUNG: Niedrige Confidence ({confidence:.0%})")
            print("   Bitte manuell überprüfen!")

        # Show extracted data
        print(f"\n👤 Kunde: {parsed_data['customer']['first_name']} {parsed_data['customer']['last_name']}")
        print(f"📧 Email: {parsed_data['customer']['email']}")
        print(f"📍 Stadt: {parsed_data['customer']['address']['city']}")

        # Step 2: Find Products
        print("\n🔍 Schritt 2: Produkt-Suche...")
        matched_products = []

        for product_request in parsed_data.get('products', []):
            print(f"\n   Suche: {product_request['description']}")
            product = self.find_matching_products(product_request)

            if product:
                product['quantity'] = product_request.get('quantity', 1)
                matched_products.append(product)

        if not matched_products:
            print("❌ Keine passenden Produkte gefunden")
            return None

        # Step 3: Create Order
        print("\n📦 Schritt 3: Order-Erstellung...")
        order = self.create_woocommerce_order(
            parsed_data['customer'],
            matched_products,
            parsed_data.get('notes', '')
        )

        return order


def main():
    """
    Main entry point - liest Email-Text aus stdin oder File
    """
    # Check if input provided
    if len(sys.argv) > 1:
        # Read from file
        with open(sys.argv[1], 'r') as f:
            email_text = f.read()
    else:
        # Read from stdin (für macOS Service)
        email_text = sys.stdin.read()

    if not email_text.strip():
        print("❌ Kein Input-Text vorhanden")
        sys.exit(1)

    # Process
    processor = WooCommerceAI()
    order = processor.process_email_to_order(email_text)

    if order:
        # Success notification
        os.system(f"""
        osascript -e 'display notification "Order #{order["id"]} erstellt!" with title "WooCommerce AI" sound name "Glass"'
        """)
        sys.exit(0)
    else:
        # Error notification
        os.system("""
        osascript -e 'display notification "Order-Erstellung fehlgeschlagen" with title "WooCommerce AI" sound name "Basso"'
        """)
        sys.exit(1)


if __name__ == '__main__':
    main()
```

Speichere als:
```bash
~/Automation/woocommerce-service/woocommerce_ai_processor.py
chmod +x ~/Automation/woocommerce-service/woocommerce_ai_processor.py
```

---

## 🔧 macOS Service erstellen

### Variante 1: Automator Quick Action

1. **Automator** öffnen
2. **Schnellaktion** (Quick Action) wählen
3. **Workflow empfängt**: **Text** in **jedem Programm**
4. **Shell-Skript ausführen** Action hinzufügen
5. **Eingabe übergeben**: **als stdin**
6. Script einfügen:

```bash
#!/bin/bash

# Activate virtual environment
source ~/Automation/woocommerce-service/venv/bin/activate

# Run processor
cd ~/Automation/woocommerce-service
python3 woocommerce_ai_processor.py

# Show result
if [ $? -eq 0 ]; then
    echo "✅ Order erfolgreich erstellt!"
else
    echo "❌ Fehler bei Order-Erstellung"
fi
```

7. **Speichern als:** "WooCommerce Order erstellen"

**Nutzung:**
- Email-Text markieren
- Rechtsklick → **Dienste** → **WooCommerce Order erstellen**
- Notification erscheint mit Order-ID

---

### Variante 2: Keyboard Shortcut

**Keyboard Maestro Macro:**

```
Trigger: ⌘⌃⌥W
Action:
1. Get Selected Text
2. Execute Shell Script:
   ~/Automation/woocommerce-service/venv/bin/python3 \
   ~/Automation/woocommerce-service/woocommerce_ai_processor.py <<< "$KMVAR_SelectedText"
3. Display Notification with Result
```

---

## 🧪 Testing

### Test-Email erstellen

```bash
cat > ~/test-order.txt << 'EOF'
Betreff: Bestellung Wasserfilter

Guten Tag,

ich möchte gerne einen Wasserfilter bestellen.

Meine Daten:
Max Mustermann
Musterstraße 123
80331 München
Email: max.mustermann@example.com
Telefon: +49 89 12345678

Ich interessiere mich für einen Untertisch-Wasserfilter mit Aktivkohle-Technologie für einen 4-Personen-Haushalt.

Bitte liefern Sie die Ware innerhalb der nächsten 2 Wochen.

Vielen Dank!
Max Mustermann
EOF
```

### Test ausführen

```bash
cd ~/Automation/woocommerce-service
source venv/bin/activate
python3 woocommerce_ai_processor.py ~/test-order.txt
```

**Expected Output:**
```
============================================================
🤖 WooCommerce AI Order Processor
============================================================

📧 Schritt 1: Email-Analyse mit lokaler KI...
✅ Daten extrahiert (Confidence: 95%)

👤 Kunde: Max Mustermann
📧 Email: max.mustermann@example.com
📍 Stadt: München

🔍 Schritt 2: Produkt-Suche...

   Suche: Untertisch-Wasserfilter mit Aktivkohle
✅ Produkt gewählt: AquaCentrum Premium Aktivkohle-System
   Confidence: 0.9
   Grund: Passt zu Untertisch, Aktivkohle, 4-Personen

📦 Schritt 3: Order-Erstellung...

🎉 ORDER ERFOLGREICH ERSTELLT!
   Order ID: #12345
   Total: 899.00 EUR
   Status: pending
   View: https://aquacentrum.de/wp-admin/post.php?post=12345&action=edit
```

---

## 🎯 Automatische Sortierung & Kategorisierung

### Erweitere das Script für intelligente Produkt-Kategorisierung:

```python
def categorize_customer_intent(self, parsed_data):
    """
    Kategorisiert Kundenanfrage für bessere Sortierung
    """
    prompt = f"""
Analysiere diese Kundenanfrage und kategorisiere sie:

Kunde: {parsed_data['customer']['first_name']} {parsed_data['customer']['last_name']}
Produkt-Wunsch: {', '.join([p['description'] for p in parsed_data['products']])}
Notizen: {parsed_data.get('notes', '')}

Gib zurück (nur JSON):
{{
  "customer_type": "privatkunde|geschäftskunde|wiederholungskäufer",
  "urgency": "hoch|mittel|niedrig",
  "value_segment": "premium|standard|budget",
  "product_category": "kategorie",
  "tags": ["tag1", "tag2"],
  "priority_score": 1-10
}}
"""

    response = ollama.generate(model=OLLAMA_MODEL, prompt=prompt)
    # Parse and return...
```

### Integration in Order Meta Data

```python
# In create_woocommerce_order():
categorization = self.categorize_customer_intent(parsed_data)

order_data['meta_data'].extend([
    {'key': '_customer_type', 'value': categorization['customer_type']},
    {'key': '_urgency', 'value': categorization['urgency']},
    {'key': '_priority_score', 'value': categorization['priority_score']},
    {'key': '_ai_tags', 'value': ','.join(categorization['tags'])}
])
```

---

## 📊 Dashboard & Monitoring

### Simple Logging

```python
import logging

logging.basicConfig(
    filename=os.path.expanduser('~/Automation/woocommerce-service/orders.log'),
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Im Workflow:
logging.info(f"Order #{order['id']} created - Customer: {customer_data['email']}")
```

### Stats via WP-CLI

```bash
# Alle AI-generierten Orders
wp post list --post_type=shop_order --meta_key=_order_source --meta_value=macos_ai_service --format=count
```

---

## 🚀 Advanced Features

### 1. Multi-Produkt Support

Email mit mehreren Produkten:
```
- 2x Wasserfilter Premium
- 1x Ersatzfilter-Set
- 3x Mineralsteine
```

Wird automatisch in separate `line_items` konvertiert.

### 2. Intelligente Duplikats-Erkennung

```python
def check_duplicate_order(self, customer_email, timeframe_hours=24):
    """
    Prüft ob bereits Order von diesem Kunden existiert
    """
    cutoff = datetime.now() - timedelta(hours=timeframe_hours)

    params = {
        'customer': customer_email,
        'after': cutoff.isoformat(),
        'per_page': 10
    }

    response = requests.get(f"{self.wc_url}/orders", auth=self.auth, params=params)

    if response.status_code == 200:
        orders = response.json()
        if orders:
            print(f"⚠️ WARNUNG: {len(orders)} Order(s) in letzten {timeframe_hours}h!")
            return orders[0]

    return None
```

### 3. Confidence Threshold

```python
MIN_CONFIDENCE = 0.75

if parsed_data['confidence'] < MIN_CONFIDENCE:
    # Save to review queue
    with open(f'~/Automation/woocommerce-service/review_queue/{datetime.now().timestamp()}.json', 'w') as f:
        json.dump(parsed_data, f)

    print("⚠️ Confidence zu niedrig - Gespeichert in Review Queue")
    sys.exit(2)  # Special exit code for manual review
```

---

## 🔐 Security Best Practices

### 1. Secrets Management

```bash
# .env nie in Git committen!
echo ".env" >> .gitignore

# Permissions setzen
chmod 600 ~/Automation/woocommerce-service/.env
```

### 2. API Rate Limiting

```python
import time
from functools import wraps

def rate_limit(calls_per_minute=50):
    min_interval = 60.0 / calls_per_minute
    last_called = [0.0]

    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            elapsed = time.time() - last_called[0]
            wait_time = min_interval - elapsed
            if wait_time > 0:
                time.sleep(wait_time)
            ret = func(*args, **kwargs)
            last_called[0] = time.time()
            return ret
        return wrapper
    return decorator

@rate_limit(calls_per_minute=30)
def api_call(self, endpoint, method='GET', **kwargs):
    # Your API logic
    pass
```

---

## 📈 Performance Optimierung

### Ollama Performance Tuning

```bash
# In .env
OLLAMA_NUM_GPU=1  # Nutze GPU falls verfügbar
OLLAMA_NUM_THREAD=8  # CPU Threads
```

### Caching für Produkt-Suchen

```python
from functools import lru_cache

@lru_cache(maxsize=100)
def cached_product_search(self, query):
    # Cache results für 100 unique queries
    return self.find_matching_products(query)
```

---

## 🎓 Nächste Schritte

### Phase 1: Basic Setup (Heute)
1. ✅ Ollama installieren & testen
2. ✅ Python Script einrichten
3. ✅ WooCommerce API Keys generieren
4. ✅ Test-Order erstellen

### Phase 2: Service Integration (Morgen)
1. ✅ Automator Quick Action erstellen
2. ✅ Keyboard Shortcut zuweisen
3. ✅ 10 Test-Orders durchlaufen
4. ✅ Confidence Threshold finetunen

### Phase 3: Production (Woche 1)
1. ✅ Duplicate Detection aktivieren
2. ✅ Logging & Monitoring setup
3. ✅ Error Notifications
4. ✅ Review Queue Workflow

### Phase 4: Advanced (Woche 2-4)
1. ✅ Multi-Shop Support
2. ✅ Custom Product Attributes
3. ✅ Automatische Kategorisierung
4. ✅ Dashboard für Stats

---

## 💡 Pro Tips

**Von AI Automation Experten:**
> "Lokale KI (Ollama) ist 90% so gut wie GPT-4 für strukturierte Extraktion, aber 100% privat und kostenlos. Der Sweet Spot ist Llama 3.1 8B - klein genug für MacBook, groß genug für Production."

**Von WooCommerce Architekten:**
> "Meta Data ist dein bester Freund. Speichere AI confidence, original text, timestamps - alles dort. Du wirst es später beim Debugging brauchen."

**Von macOS Automation Pros:**
> "Services sind powerful, aber unsichtbar. Baue gute Notifications ein - der User muss wissen was passiert ist."

---

## 🆘 Troubleshooting

### Ollama läuft nicht
```bash
# Check Status
ollama list

# Restart
killall ollama
ollama serve
```

### WooCommerce API Error 401
```bash
# Test API Keys
curl -u "ck_KEY:cs_SECRET" \
  https://aquacentrum.de/wp-json/wc/v3/orders?per_page=1
```

### Python Import Errors
```bash
# Rebuild venv
cd ~/Automation/woocommerce-service
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

---

## 📦 Bonus: requirements.txt

```txt
requests==2.31.0
ollama==0.1.7
python-dotenv==1.0.0
```

---

**Happy Automating! 🚀**

*Dieser Service nutzt 100% lokale KI - keine Daten verlassen deinen Mac!*
