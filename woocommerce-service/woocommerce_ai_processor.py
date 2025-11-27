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
