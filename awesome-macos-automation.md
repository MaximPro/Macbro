# 🚀 Awesome macOS Automation & Services
> Die ultimative Sammlung von macOS Automation Tools, Libraries, Workflows und Best Practices

[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

**Zusammengestellt für:** Maxim @ Munich AI Business
**Datum:** November 2025
**Fokus:** macOS Services, Automator, AppleScript, Alfred, Keyboard Maestro, Raycast, BetterTouchTool

---

## 📖 Inhaltsverzeichnis

- [Was sind macOS Services?](#was-sind-macos-services)
- [Quick Start Guide](#quick-start-guide)
- [Automator & Services](#automator--services)
- [AppleScript Libraries](#applescript-libraries)
- [Alfred Workflows](#alfred-workflows)
- [Keyboard Maestro](#keyboard-maestro)
- [Raycast Extensions](#raycast-extensions)
- [BetterTouchTool](#bettertouchtool)
- [Learning Resources](#learning-resources)
- [Best Practices](#best-practices)
- [Pro Setup](#pro-setup)

---

## 🎯 Was sind macOS Services?

**Services** sind systemweite Rechtsklick-Menü-Aktionen für Automatisierung:

```
Input (Text/Dateien) → Verarbeitung → Output
```

### Drei Wege zum Erstellen:

1. **Automator** (Classic) → `.workflow` Files in `~/Library/Services/`
2. **Shortcuts** (Modern) → Visuelle Programmierung, iCloud-Sync
3. **Shell Scripts** → Maximale Kontrolle für Entwickler

### Key Features:
- ✅ Systemweit in jeder App verfügbar
- ✅ Keyboard Shortcuts zuweisbar
- ✅ Chainbar durch Clipboard/Pipes
- ✅ Keine App-Installation nötig

---

## ⚡ Quick Start Guide

### Option 1: Fertige Services installieren (5 Minuten)

```bash
# Clone die besten Automator Workflows
git clone https://github.com/bhagyas/awesome-automator.git
git clone https://github.com/princelundgren/automator-collection.git

# Services installieren
open automator-collection/*.workflow
# Doppelklick auf .workflow Dateien → automatische Installation
```

**Sofort verfügbar via Rechtsklick:**
- PDF zusammenführen
- Bilder konvertieren (JPG, PNG, 720p-3840p)
- Pfad kopieren
- In VSCode öffnen
- Text in neue Datei

### Option 2: Eigene Services erstellen (10 Minuten)

1. **Automator.app** öffnen
2. **Neuer Dienst** wählen
3. **"Ausgewählter Text"** oder **"Ausgewählte Dateien"** als Input
4. Aktionen hinzufügen (Shell Script, AppleScript, etc.)
5. **Datei → Sichern** → Automatisch in `~/Library/Services/`

**Beispiel: Text in UPPERCASE konvertieren**
```applescript
on run {input, parameters}
    return do shell script "echo " & quoted form of (input as text) & " | tr '[:lower:]' '[:upper:]'"
end run
```

### Option 3: Moderne Lösung mit Shortcuts (3 Minuten)

1. **Shortcuts.app** öffnen
2. Neuer Shortcut erstellen
3. **"Schnellaktionen"** als Typ wählen
4. Aktionen per Drag & Drop
5. Automatisch verfügbar im Services-Menü

---

## 🔧 Automator & Services

### Top Repositories

#### 1. awesome-automator ⭐ 11
📦 https://github.com/bhagyas/awesome-automator

**Was:** Kuratierte Sammlung von macOS Automator Workflows

**Highlights:**
- Open Folder in VSCode
- Crypto Address Quick Look
- Translate Services
- GitHub Topic Discovery

**Installation:**
```bash
git clone https://github.com/bhagyas/awesome-automator.git
# Dann einzelne Workflows aus verlinkten Repos installieren
```

---

#### 2. automator-collection ⭐ 30+
📦 https://github.com/princelundgren/automator-collection

**Was:** 30+ praktische Workflows für Alltag

**Kategorien:**

**📄 Document Processing**
- PDF Merge & Compress (3 Quality Levels)
- Image to JPG Conversion (720p-3840p)
- Create Text Files via Right-Click

**📁 File Management**
- Copy Path as Text
- Auto-Open Downloads (.doc, .docx, .ppt)
- Move .app Files to Applications
- Alfred Blocklist Management

**🌐 Browser Automation**
- Private/Incognito Launchers (Safari, Chrome, Firefox)

**🔍 Search Services**
- YouTube, Google, ThePirateBay Context Search

**🎬 Media Tools**
- Subtitle Download (FlixTools Integration)
- Video to 1080p Conversion
- Image Crop to 1080p/720p

**💾 System Utilities**
- Hard Drive Mount/Unmount
- Weekly Trash Emptying (Calendar Integration)
- CS:GO Launcher with CPU Priority

**Installation:**
```bash
git clone https://github.com/princelundgren/automator-collection.git
cd automator-collection
open *.workflow  # Alle Services installieren
```

**⚠️ Wichtig:** Einige Scripts benötigen Anpassung (z.B. Hard Drive Names)

---

#### 3. automator-workflows (mpanighetti) ⭐ Dokumentiert
📦 https://github.com/mpanighetti/automator-workflows

**Was:** Gut dokumentierte Workflows mit Installationsanleitungen

**4 Core Workflows:**

1. **Add AlertTones to Sound Library**
   - Extrahiert System-Sounds aus `/System/Library/PrivateFrameworks/ToneLibrary.framework/`
   - Kopiert nach `~/Library/Sounds`
   - Verbesserte Namensgebung

2. **Count Characters**
   - Zählt Zeichen in selektiertem Text
   - Notification Center Output

3. **Scale Images to 50%**
   - Erstellt Duplikate mit 50% Größe
   - Suffix: `-half`

4. **Show Unix File Permissions**
   - Zeigt Dateirechte in Dialog Box

**Installation:**
```bash
git clone https://github.com/mpanighetti/automator-workflows.git
cd automator-workflows
# Jeder Ordner enthält .workflow Datei und Doku
```

---

#### 4. automator-workflows (yeutterg) ⭐ Designer-Fokus
📦 https://github.com/yeutterg/automator-workflows

**Was:** Workflows für Designer/Developer

**Kategorien:**

**🖼️ Image Services**
- Resize to Pixel Width
- Rotate Clockwise/Counterclockwise
- Convert to PNG/JPG

**📑 PDF Operations**
- Split PDF to Pages
- PDF to Images (Custom Settings)
- Combine PDFs
- Extract Text to .txt

**📝 File Management**
- New File Creation
- Date Prefix (YYYY-MM-DD)

**📚 Text Tools**
- Word Count Dialog
- Dictionary Lookup

**Installation:**
```bash
git clone https://github.com/yeutterg/automator-workflows.git
# Workflows in ~/Library/Services/ → erscheinen im Rechtsklick-Menü
```

---

#### 5. macos-services (agurod) ⭐ Niche aber Kraftvoll
📦 https://github.com/agurod42/macos-services

**Was:** Spezialisierte Services

**2 Services:**

1. **Crypto Address Quick Look**
   - Zeigt Krypto-Wallet Balance
   - Super-schnell ohne Browser

2. **Translate Service**
   - Google Translate Popup
   - Direkter Text-Context

**Installation:**
```bash
git clone https://github.com/agurod42/macos-services.git ~/Library/Services/
```

**⚠️ Status:** Archived (Read-Only seit März 2023)

---

## 📜 AppleScript Libraries

### Top Repositories

#### 6. AppleScripts (abbeycode) ⭐ 20+ Jahre Erfahrung
📦 https://github.com/abbeycode/AppleScripts

**Was:** 20+ Jahre AppleScript Library mit Service-Integration

**Highlights:**
- **Library Loader System** für wiederverwendbare Code-Module
- **iTunes Automation** (einige Scripts benötigen `.scpt` Format)
- **Services Integration** via Automator

**Library Loading Pattern:**
```applescript
property LibLoader : load script file ((path to scripts folder from user domain as text) & "Libraries:Library Loader.scpt")
property StringsLib : LibLoader's loadScript("Libraries:Strings.applescript")
```

**Installation:**
```bash
git clone https://github.com/abbeycode/AppleScripts.git ~/Library/
# Wichtig: Pfad-Struktur beibehalten für FastScripts Integration
```

**Struktur:**
- `Scripts/` - Haupt-Scripts
- `Scripts/Libraries/` - Wiederverwendbare Module
- `Services/` - Automator-ready Scripts
- `iTunes/Scripts/` - iTunes-spezifisch

**Testing:**
- Test Suite in `Scripts/Libraries/Library Tests.applescript`
- Migration zu ASUnit geplant

---

#### 7. AppleScripts (kevin-funderburg) ⭐ Educational + Production
📦 https://github.com/kevin-funderburg/AppleScripts

**Was:** Best Practices Collection mit Keyboard Maestro & Alfred Integration

**App-Specific Scripts:**
- **Alfred**: Recent Files, Workflow Browser
- **Finder**: Path Copy, iTerm Integration
- **Safari**: Tab Management, JavaScript Execution
- **Mail**: Text Formatting, URL Generation
- **Keyboard Maestro**: Macro Editing, Action Collapsing
- **OmniFocus**: Due Dates, Duration Setting
- **Script Debugger**: Tab Duplication, Handler Testing

**Global Scripts:**
- Document Closing (with/without save)
- System Control (WiFi, Bluetooth, Menu Bar)
- Screen Recording (QuickTime)
- Zoom Meeting Controls

**Setup:**

1. **Library Installation:**
```bash
git clone https://github.com/kevin-funderburg/AppleScripts.git
cp -R "AppleScripts/Kevin's Library" ~/Library/Script\ Libraries/
```

2. **Sync Setup (Dropbox):**
```bash
# Erstelle Alias für Cloud Sync
ln -s ~/Dropbox/Library/Scripts ~/Library/Scripts
```

3. **Hyperkey Setup:**
- Karabiner-Elements installieren
- Caps Lock → ⌘⌃⌥⇧ remappen
- Unbegrenzte Shortcut-Kombinationen

**Recommended Tools:**
- **Script Debugger** (Paid) - Pro IDE
- **UI Browser** - UI Scripting Simplified
- **Dash** (Free) - API Documentation

**Learning Resources:**
- MacScripter.net Forum
- Late Night Software Tutorials
- Official AppleScript Language Guide

**Key Influencers:**
- Shane Staley
- Mark Alldritt
- Christopher Stone
- JMichaelTX

---

#### 8. applescript (unforswearing) ⭐ 522 Stars
📦 https://github.com/unforswearing/applescript

**Was:** Snippets, Applets & Resources

**14 Kategorien:**
1. Application Services
2. Battery Monitor
3. Display Settings
4. File and Folder Actions
5. Location Helper Scripts
6. Markdown Tools
7. Notational Velocity
8. Pandoc and Textutils
9. Reminders App
10. Snippets
11. Sound Scripts
12. Temperature Conversion
13. Terminal
14. Time and Date

**Development Tools:**

**Free:**
- Location Helper (Core Location Integration)
- Twitter Scripter
- **Platypus** - Scripts → Native Apps

**Paid:**
- Script Debugger (IDE)
- CursorCoordinates
- Dialog Maker

**Educational Resources:**
- **"Basics of AppleScript"** (Free eBook, 2014)
- MacOSX Automation (by Sal Soghoian - Ex-Apple)
- JavaScript for Automation Cookbook (JXA)

**Installation:**
```bash
git clone https://github.com/unforswearing/applescript.git
# Getestet: OS X Lion → High Sierra
```

---

## 📚 macOS Automation Resources

### Comprehensive Guides

#### 9. macOS-Automation-Resources (SKaplanOfficial) ⭐ Die Bibliothek
📦 https://github.com/SKaplanOfficial/macOS-Automation-Resources

**Was:** THE comprehensive directory für ALLE macOS Automation Technologien

**11 Automation Technologies:**

1. **AppleScript & ASObjC** - Native macOS Scripting
2. **AppScript** - Python-based Automation
3. **Automator** - GUI Workflow Builder
4. **Hammerspoon** - Lua Desktop Automation
5. **JXA** - JavaScript for Automation
6. **PyObjC** - Python-Objective-C Bridge
7. **Raycast** - Command Launcher
8. **Shortcuts** - Visual Workflows
9. **SwiftAutomation** - Swift Scripting
10. **Alfred** - Application Launcher
11. **URL Schemes** - Inter-App Communication

**Resource Types:**
- 📖 Official Apple Documents
- 📚 Books (Paid + Archive.org)
- 🎥 Videos (YouTube + WWDC)
- 🎓 Courses (Udemy, etc.)
- 📝 Blog Posts
- 💬 Forums (MacScripter, Alfred Forum)
- 📧 Mailing Lists
- 💻 Code Samples
- 📦 Libraries

**Key Books:**
- "AppleScript: The Definitive Guide"
- "Everyday AppleScriptObjC"

**App-Specific Documentation:**
- iTunes, Fantastical, Things, Terminal

---

#### 10. mac-scripting (extracts) ⭐ 87 Stars - Academic Focus
📦 https://github.com/extracts/mac-scripting

**Was:** Papers 3, Bookends Automation + JXA Intro

**Key Scripts:**

**Papers 3 Integration:**
- Export to Bookends (PDFs + Metadata)
- Export to DEVONthink (Annotations + Data)

**Bookends:**
- Update Publications from Filenames

**DEVONthink:**
- Create Markdown Notes from PDF Annotations
- Color-Matched Labels
- Deep Linking

**Learning Resources:**
- Getting Started with AppleScript (Papers 3 + Bookends)
- NSConference 2015: "JavaScript For Automation: Quick Intro"

**Installation:**
```bash
git clone https://github.com/extracts/mac-scripting.git
# Libraries nach ~/Library/Script Libraries/
# Pre-compiled .app und .scptd Versionen enthalten Dependencies
```

**Use Case:** Research Workflows zwischen Reference Management (Papers 3, Bookends) und Knowledge Management (DEVONthink)

---

## 🔮 Alfred Workflows

### Top Collections

#### 11. awesome-alfred-workflows ⭐ 3.2k Stars
📦 https://github.com/alfred-workflows/awesome-alfred-workflows

**Was:** Die ultimative Alfred Workflow Collection

**⚠️ Status:** Archived August 2024 → Nutze jetzt [Alfred Gallery](https://alfred.app)

**Kategorien:**

**💬 Communication**
- Slack, Mail, Temp Email Services

**💻 Developer Tools**
- **Documentation**: Dash, DevDocs, caniuse
- **Package Management**: NPM, Packagist, CDN Lookup
- **Version Control**: GitHub Command Bar, Git Search
- **IDEs**: JetBrains, VSCode Integration
- **Icons**: Bootstrap Icons, Font Awesome, Material Design, Tailwind CSS

**✍️ Text Manipulation**
- Base64, HTML, URL, UTF-8 Encode/Decode
- Syntax Highlighting
- Unicode Symbol Search

**🔬 Scientific Tools**
- Unit Conversion
- DOI Resolution
- LaTeX Support
- PDF Viewer Controls

**📊 Productivity**
- Calendar Integration
- Spreadsheet Workflows
- PDF Manipulation
- Todoist, Things 3

**⚙️ System Management**
- Process Control (Kill Process)
- SSH Autocomplete
- Bluetooth Management
- Terminal/Finder Switching

**🔐 Security**
- Password Generation
- VPN Management
- LastPass Integration
- MAC Address Randomization

**🎵 Multimedia**
- Spotify Library Control

**🎨 Miscellaneous**
- Emoji/Kaomoji Search
- Lorem Ipsum Generator
- Screenshot Tools

**🌐 Web**
- Browser Switching
- Reddit Search
- Incognito Mode

**Installation:**
```bash
# Besuche Alfred Gallery oder Packal
# https://alfred.app → Browse Workflows
# https://www.packal.org → "The biggest place to find Workflows"
```

---

#### 12. alfred-workflows (zenorocha) ⭐ Developer Collection
📦 https://github.com/zenorocha/alfred-workflows

**Was:** 18 Rock-Solid Developer Workflows

**Highlights:**

1. **Colors** (v2.0.2)
   - HEX ↔ RGB ↔ HSL Conversion
   - Commands: `#`, `rgb`, `hsl`, `c`

2. **Package Managers** (v3.16.0)
   - 15+ Ecosystems (npm, brew, pip, composer)
   - Quick Package Lookup

3. **Kill Process** (v1.2.0)
   - Find & Kill ohne Terminal

4. **GitHub** (v1.6.0)
   - Open Repos, Issues, PRs im Browser
   - Login Required

5. **DevDocs** (v1.2.0)
   - 40+ Languages & Frameworks
   - Unified Documentation Search

6. **Encode/Decode** (v1.8.0)
   - Base64, HTML, URL, UTF-8

**Additional:**
- Terminal ↔ Finder
- Stack Overflow Search
- Sublime Text Integration
- IP Address Lookup

**Installation:**
```bash
git clone https://github.com/zenorocha/alfred-workflows.git
cd alfred-workflows
# Doppelklick auf .alfredworkflow Dateien
```

---

#### 13. alfred-workflows (learn-anything) ⭐ 2.7k Stars
📦 https://github.com/learn-anything/alfred-workflows

**Was:** Modern Curated List mit LLM Integration

**Bleeding-Edge Features:**

**🤖 AI Integration:**
- **Text to Calendar** - LLM converts unstructured text → Calendar Events

**☁️ Cloud Platforms:**
- AWS Console Services
- Docker Management
- GCP & Azure Tools

**💻 Developer Tools:**
- Rust Development (Rustdoc, alfred-crates)
- GitHub Jump (Search Starred Repos)
- Notion Search
- Things Integration

**🌐 Network Tools:**
- DNS Lookups
- SSH Connections
- Network Commands Collection

**Installation:**
```bash
git clone https://github.com/learn-anything/alfred-workflows.git
# 18+ Categories
# 2,419+ Community Workflows
```

**Contribution:**
- Review Guidelines at `manual.raycast.com/community-guidelines`
- Submit via Pull Request

---

## ⌨️ Keyboard Maestro

### Essential Macro Collections

#### 14. Keyboard-Maestro-Macros (monfresh) ⭐ 22 Stars
📦 https://github.com/monfresh/Keyboard-Maestro-Macros

**Was:** 7 Production-Ready Macros mit Blog Tutorials

**Macros:**

1. **Paste URL and title as Markdown**
   - Webpage → `[Title](URL)` Format

2. **Type Command Symbol** (⌘)
3. **Type Control Symbol** (⌃)
4. **Type Option Symbol** (⌥)

5. **Email URL and Title**
   - Send Current Page Info

6. **Folders over 500MB**
   - Find Storage Hogs

**Installation:**

**Method 1: No Command Line**
```
1. Two-Finger Tap on .kmmacros File
2. "Download Linked File As..."
3. Double-Click in Finder
```

**Method 2: Homebrew**
```bash
brew install --cask keyboard-maestro
git clone https://github.com/monfresh/Keyboard-Maestro-Macros.git
cd Keyboard-Maestro-Macros
open *.kmmacros
```

**Updates:**
```bash
git checkout master && git pull
```

**Blog:** https://www.moncefbelyamani.com/categories/keyboard-maestro/

---

#### 15. KeyboardMaestro (patrickwelker) ⭐ 146 Stars
📦 https://github.com/patrickwelker/KeyboardMaestro

**Was:** OmniFocus, Markdown, Path Finder - Power User Suite

**Key Components:**

**🎯 OmniFocus Integration:**

1. **Perspectives Palette**
   - Global Hotkey → Favorite Perspectives
   - Opens OmniFocus if not running

2. **Scripts Palette**
   - Keyboard Maestro ↔ OmniFocus Scripts
   - Credits to Original Authors

**✍️ Markdown & Writing:**
- **Ultimate Markdown Maestro Bundle** (Template Library + Video)
- **Brett Terpstra Services Wrappers** (Markdown Service Tools, SearchLink)
- **QuickCursor** (External Editor Integration)

**📁 System & Finder:**
- **Path Finder → Finder** Transfer
- **Screenshot Palette** (Comprehensive Utils)
- **Caffeinate Replacement**
- **Function Key Toggles**

**🔄 Synchronization:**
- **Sync Keyboard Maestro** via Hazel + Dropbox

**Installation:**
```bash
git clone https://github.com/patrickwelker/KeyboardMaestro.git
# Import .kmmacros Files via Keyboard Maestro
```

**Blog:** RocketINK (Detailed Documentation)

---

#### 16. km-macros (Zettt) ⭐ 211 Stars
📦 https://github.com/Zettt/km-macros

**Was:** Clipboard Magic, Window Management, Emoji Insert

**Primary Categories:**

**📋 Clipboard Management:**
- **Append Selection** - Combine with Previous Copy
- **Manipulate Clipboard** - Direct Editing
- **Filter Clipboard** - Character/Word Count, HTML Entities, Case Conversion

**🪟 Window Control:**
- Resize, Move, Position
- **"Where's my mouse?"** Locator

**⌨️ Text Processing:**
- **Emoji Insert**
- **Control Characters** (⌘, ⌃, ⇧)

**🎬 Application-Specific:**
- **Final Cut Pro X**: Media Switching, Effects Browser
- **Mail**: URL Copy, PDF Print
- **OmniFocus**: URL Management, Day Projects
- **TextExpander**: Expansion Mode Shortcuts

**🛠️ System Utilities:**
- **Keyboard Cleaner Maestro** (🔥 Genial! Blockiert Input für sicheres Keyboard Cleaning)
- **Timer System** (Activity Tracking)
- **Symbolic Link Creation** via Finder

**Installation:**
```bash
git clone https://github.com/Zettt/km-macros.git
# 86 Commits | 211 Stars | 17 Forks
```

---

## 🚀 Raycast Extensions

### Modern Alfred Alternative

#### 17. raycast/extensions ⭐ 6.8k Stars - Official Store
📦 https://github.com/raycast/extensions

**Was:** 1000+ Extensions (React-based, TypeScript)

**Tech Stack:**
- **Primary:** TypeScript (88.3%)
- **Styling:** CSS (8.4%)
- **Supporting:** JavaScript, MDX, AppleScript, Swift
- **Framework:** React

**Stats:**
- **6.8k Stars** | **4.7k Forks**
- **15,381 Commits**
- **2,661 Contributors**
- Used by **4,900+ Projects**

**Getting Started:**
- Official Portal: [developers.raycast.com](https://developers.raycast.com)
- Documentation: React Examples + Templates

**Submission Requirements:**
- Review Community Guidelines: `manual.raycast.com/community-guidelines`
- Follow Extension Guidelines: `manual.raycast.com/extensions`
- GitHub Issues for API Feedback

**Support:**
- **Technical:** GitHub Issues
- **Community:** Slack at `raycast.com/community`

---

#### 18. awesome-raycast ⭐ Automated Catalog
📦 https://github.com/j3lte/awesome-raycast

**Was:** Auto-Updated List (Nightly GitHub Actions)

**Stats:**
- **2,419 Packages** across **15 Categories**
- **26 Swift Extensions**
- **1,579 Authors** | **959 Contributors**
- **Top Author:** xmok (88 Extensions)

**15 Categories:**
1. Applications
2. Communication
3. Data
4. Design Tools
5. Developer Tools
6. Documentation
7. Finance
8. Fun
9. Media
10. News
11. Other
12. Productivity
13. Security
14. System
15. Web

**Notable Extensions:**

**AI/Coding:**
- ChatGPT Integrations
- GitHub Copilot Tools

**Project Management:**
- Linear, Notion, Height, Jira

**Cloud Services:**
- GitHub, cPanel, Hetzner, Coolify

**Productivity:**
- Apple Mail, Drafts, Fantastical, Goodlinks

**Development:**
- Gradle Plugins, Datawrapper, Browser History

**Utilities:**
- Color Management, PDF Compression, File Conversion

**Discovery:**
- Official Raycast Store
- This Automated Community List

---

## 🎛️ BetterTouchTool

### TouchBar & Gesture Control

#### 19. btt-touchbar-presets (vas3k) ⭐ TouchBar Widgets
📦 https://github.com/vas3k/btt-touchbar-presets

**Was:** Customizable TouchBar Presets

**⚠️ Status:** Archived March 2020 (BTT hat jetzt viele Features eingebaut)

**Widget Types:**
- 🎵 Media Controls (Play/Pause, Volume, Brightness)
- 🎶 Now Playing (Spotify, iTunes, YouTube)
- 🌦️ Weather (Location Integration)
- 📅 Calendar & Reminders
- 🔋 Battery Status
- 🕐 Clock & Date
- 🔄 App Switcher
- 😊 Emoji Picker

**Notable Presets:**

**GoldenChaos:**
- Kompletter Stock Touch Bar Replacement
- Contextual Buttons per App
- Requires: Location Helper, JSON Helper

**ng-vu:**
- Pomodoro Clock via Background Commands

**Setup Requirements:**

**Helper Apps:**
- High Sierra Media Key Enabler
- Location Helper + JSON Helper (Weather)
- **icalBuddy** (Calendar - extra config needed)

**Gesture Controls:**
- Two-Finger Swipe: Volume
- Three-Finger Swipe: Brightness

**License:** WTFPL (Do What The F*** You Want)

---

#### 20. btt-presets (andrewchidden) ⭐ Developer Setup
📦 https://github.com/andrewchidden/btt-presets

**Was:** Professional Dev Preset mit Git Stats

**Key Features:**

**🔧 Git Integration:**
- Monitor via `BTT_GIT_WORKING_DIR`
- Diff Statistics
- Macro-Triggered Operations

**📅 Calendar Display:**
- EventKit Integration
- `BTT_EVENTKIT_CALENDAR_NAMES` Config
- `BTT_EVENTKIT_MAXLENGTH` (Default: 40 chars)

**🌐 Web Server Communication:**
- BTT Built-in Web Server
- `BTT_WEBSERVER_URL`
- `BTT_WEBSERVER_SHAREDSECRET` (Optional Auth)

**Installation:**
- Requires: **BetterTouchTool v2.536**
- Controllers: https://github.com/andrewchidden/btt-controllers
- Two Variants: Basic Controls | Full Settings

**Critical Fix:**
> "Shell scripts run through BetterTouchTool do not receive environment variables."

**Solution:** Controllers source `~/.bash_profile` at runtime

**Essential Variables:**
- `BTT_USR_ROOT`: Script Directory (Default: `~/bettertouchtool`)
- `BTT_SYS_ROOT`: State Storage (Default: `~/.btt`)

**License:** MIT © 2018 CarbonTech Software LLC

---

## 📚 Learning Resources

### Books

#### Essential Reading
1. **"AppleScript: The Definitive Guide"** - O'Reilly
2. **"Everyday AppleScriptObjC"** - Advanced Techniques
3. **"Basics of AppleScript"** (Free eBook, 2014) - Foundations

### Online Courses
- **Udemy**: AppleScript for Automation
- **WWDC Sessions**: Shortcuts, AppleScript, Automation

### Community Forums
- **MacScripter.net** - AppleScript Community
- **Late Night Software** - Script Debugger Tutorials
- **Alfred Forum** - Workflow Support
- **Keyboard Maestro Forum** - Macro Help
- **MacRumors Programming Forum**

### Mailing Lists
- Apple Users List
- MACSCRPT@LISTSERV

### Blogs & Experts

#### Key Influencers
- **Shane Staley** (AppleScript Guru)
- **Mark Alldritt** (Script Debugger Creator)
- **Christopher Stone** (Keyboard Maestro Expert)
- **JMichaelTX** (Forum Legend)
- **Sal Soghoian** (Ex-Apple Automation Manager) - MacOSX Automation

#### Notable Blogs
- Dr. Dang (Automation Tutorials)
- Rob Griffiths (macOS Hints)
- Brett Terpstra (Markdown & Services)
- Moncef Belyamani (Keyboard Maestro)
- Patrick Welker (RocketINK)

### Video Resources
- **YouTube**: macOS Automation Tutorials
- **NSConference 2015**: "JavaScript For Automation: Quick Intro"
- **WWDC Archives**: Automation Sessions

### Development Tools

#### Free
- **Xcode** - AppleScript Editor
- **Dash** - API Documentation Browser
- **Location Helper** - Core Location Integration
- **Platypus** - Scripts → Native Apps

#### Paid
- **Script Debugger** - Pro AppleScript IDE
- **UI Browser** - UI Scripting Tool
- **Keyboard Maestro** ($36 Lifetime)
- **Alfred Powerpack** ($34 Lifetime)
- **BetterTouchTool** ($22)

---

## 🎯 Best Practices

### Service Development

#### 1. Input/Output Design
```bash
# Immer klare Input-Typen definieren
✅ "Ausgewählter Text in jedem Programm"
✅ "Ausgewählte Dateien und Ordner im Finder"
❌ "Keine Eingabe" (nicht für Services!)
```

#### 2. Error Handling
```applescript
on run {input, parameters}
    try
        -- Your code here
        return input
    on error errMsg
        display dialog "Error: " & errMsg buttons {"OK"} default button 1
        return input
    end try
end run
```

#### 3. Performance
- ⚡ Shell Scripts sind schneller als AppleScript für Text Processing
- 🐌 Avoid UI Scripting wo möglich (fragil & langsam)
- 🚀 Cache Ergebnisse mit Temporary Files

#### 4. User Feedback
```bash
# Notification für lange Operationen
osascript -e 'display notification "Processing..." with title "Service Name"'
# Deine Operation
osascript -e 'display notification "Done!" with title "Service Name"'
```

### Keyboard Shortcuts

#### Best Shortcuts für Services
```
⌘⌥⇧ + Buchstabe  - Primäre Services
⌃⌥ + Buchstabe    - Sekundäre Services
Caps Lock         - Via Karabiner zu ⌘⌃⌥⇧ (Hyperkey)
```

**Setup Hyperkey:**
```bash
# Install Karabiner-Elements
brew install --cask karabiner-elements

# Caps Lock → ⌘⌃⌥⇧
# Settings → Simple Modifications → Caps Lock → F18
# Complex Modifications → Import "Hyperkey" Rule
```

### Library Organization

#### Sync via Dropbox
```bash
# Services
ln -s ~/Dropbox/Library/Services ~/Library/Services

# Scripts
ln -s ~/Dropbox/Library/Scripts ~/Library/Scripts

# Keyboard Maestro
ln -s ~/Dropbox/Library/Application\ Support/Keyboard\ Maestro ~/Library/Application\ Support/

# Alfred
ln -s ~/Dropbox/Alfred ~/Library/Application\ Support/Alfred
```

### Testing & Debugging

#### Automator Debugging
1. **Log Actions** hinzufügen zwischen Steps
2. **View Results** nach jedem Step
3. **Run** in Automator vor Installation

#### AppleScript Debugging
```applescript
-- Use log statements
log "Step 1: Starting process"
log "Input: " & input

-- Script Debugger: Breakpoints & Variable Inspector
```

#### Shell Script Debugging
```bash
set -x  # Print all commands
set -e  # Exit on error

# Or manually
echo "Debug: Processing file $1" >&2
```

---

## 🏆 Pro Setup

### The Ultimate macOS Automation Stack

#### Level 1: Foundation (Free)
```bash
# Basics
✅ Automator (Built-in)
✅ Shortcuts (Built-in)
✅ AppleScript Editor (Built-in)
✅ Platypus (Free) - Scripts → Apps
```

#### Level 2: Power User ($34-50)
```bash
brew install --cask alfred
# Powerpack: $34 Lifetime
# → Workflows, Clipboard History, Snippets

# OR

brew install --cask raycast
# Free Core, Paid Pro ($8/mo)
# → Modern, React-based, AI Integration
```

#### Level 3: Automation Pro ($100-150)
```bash
brew install --cask keyboard-maestro
# $36 Lifetime
# → Visual Macro Editor, Trigger System

brew install --cask bettertouchtool
# $22
# → Gestures, TouchBar, Window Snapping

brew install --cask hazel
# $42
# → Automated File Management
```

#### Level 4: Developer Elite ($150+)
```bash
brew install --cask script-debugger
# $200
# → Professional AppleScript IDE

brew install --cask ui-browser
# $55
# → UI Scripting Simplified
```

### Recommended Combination

**For Developers (€100):**
```
Keyboard Maestro + Alfred + BetterTouchTool
= $36 + $34 + $22 = $92
```

**For Business/Productivity (€70):**
```
Alfred + Keyboard Maestro
= $34 + $36 = $70
```

**For Budget Conscious (€0):**
```
Automator + Shortcuts + Raycast (Free)
= $0 (aber viel manuelle Arbeit)
```

---

## 🚀 Quick Action Plan für Maxim

### Heute (30 Min)
```bash
# 1. Clone Top Repos
git clone https://github.com/bhagyas/awesome-automator.git
git clone https://github.com/princelundgren/automator-collection.git

# 2. Install 3 Must-Have Services
open automator-collection/Copy\ path\ as\ text.workflow
open automator-collection/Open\ in\ Visual\ Studio\ Code.workflow
open automator-collection/Image\ to\ JPG\ 1080p.workflow

# 3. Test with Right-Click
# → Select File → Right-Click → Services → Copy path as text
```

### Diese Woche
```bash
# 1. Entscheide: Alfred vs Raycast
brew install --cask alfred         # Classic, Stable
brew install --cask raycast        # Modern, Free Core

# 2. Install Top Workflows
git clone https://github.com/zenorocha/alfred-workflows.git
# OR
# Browse Raycast Store: raycast.com/store

# 3. Setup 10 Essential Workflows
# - Kill Process
# - DevDocs Search
# - Package Manager Lookup
# - GitHub Integration
# - Emoji Search
```

### Diesen Monat
```bash
# 1. Buy Keyboard Maestro
# → $36 Lifetime: keyboardmaestro.com

# 2. Clone Macro Libraries
git clone https://github.com/monfresh/Keyboard-Maestro-Macros.git
git clone https://github.com/Zettt/km-macros.git

# 3. Build Custom Macro Library
mkdir ~/Dropbox/Keyboard\ Maestro\ Macros
# → Start creating your own!

# 4. Setup Sync
# → Hazel + Dropbox Auto-Sync
```

---

## 💡 Pro-Tipp für Munich AI Business

### Services für AI Demos

**Instant AI Services:**
```bash
# 1. Erstelle Service "Analyze with Claude"
# Input: Selected Text
# Output: API Call zu Claude
# → Right-Click → Sofortanalyse

# 2. Kombiniere mit n8n
# Service → Webhook → n8n → Claude API → Response
# → Live Demo für Kunden

# 3. Custom Services für Sales
# - "Generate Marketing Copy"
# - "Translate to German"
# - "Extract Key Points"
# - "Create Social Media Post"

# → Jeder macOS User kann instant AI nutzen!
```

### Prototyping Power
```applescript
-- Rapid Prototyping: Service → API → Result
-- 5 Minuten von Idee zu Working Demo

on run {input, parameters}
    set selectedText to input as text

    -- API Call (z.B. Claude)
    set apiKey to "YOUR_API_KEY"
    set prompt to "Analyze this: " & selectedText

    do shell script "curl -X POST https://api.anthropic.com/v1/messages \\
        -H 'x-api-key: " & apiKey & "' \\
        -H 'Content-Type: application/json' \\
        -d '{\"model\":\"claude-3-5-sonnet-20241022\",\"messages\":[{\"role\":\"user\",\"content\":\"" & prompt & "\"}]}'"

    return result
end run
```

---

## 🎓 Learning Path

### Beginner (Week 1-2)
1. ✅ Install 5 Automator Workflows
2. ✅ Create First Custom Service
3. ✅ Setup Alfred or Raycast
4. ✅ Learn Basic AppleScript

**Resources:**
- Official AppleScript Guide
- YouTube: "AppleScript Basics"
- awesome-automator Repo

### Intermediate (Month 1-2)
1. ✅ Master Automator + Shortcuts
2. ✅ Create 10 Custom Services
3. ✅ Learn Advanced AppleScript
4. ✅ Setup Keyboard Maestro

**Resources:**
- "AppleScript: The Definitive Guide"
- MacScripter.net Forum
- Keyboard Maestro Tutorials

### Advanced (Month 3-6)
1. ✅ Build Custom Library System
2. ✅ Integrate APIs (n8n, Claude, etc.)
3. ✅ Create Workflow Suites
4. ✅ Share on GitHub

**Resources:**
- Script Debugger
- PyObjC Documentation
- Swift for Automation

### Expert (Month 6+)
1. ✅ Publish Frameworks
2. ✅ Contribute to Open Source
3. ✅ Build Commercial Tools
4. ✅ Teach & Create Content

---

## 🔗 Essential Links

### Official Documentation
- [AppleScript Language Guide](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/)
- [Automator Help](https://support.apple.com/guide/automator/)
- [Shortcuts User Guide](https://support.apple.com/guide/shortcuts-mac/)

### Tools
- [Alfred](https://www.alfredapp.com) - Application Launcher
- [Raycast](https://www.raycast.com) - Modern Alternative
- [Keyboard Maestro](https://www.keyboardmaestro.com) - Macro Tool
- [BetterTouchTool](https://folivora.ai) - Gestures & TouchBar
- [Hazel](https://www.noodlesoft.com) - File Automation
- [Script Debugger](https://latenightsw.com) - AppleScript IDE

### Communities
- [MacScripter.net](https://www.macscripter.net)
- [Alfred Forum](https://www.alfredforum.com)
- [Keyboard Maestro Forum](https://forum.keyboardmaestro.com)
- [Raycast Community](https://raycast.com/community)

### GitHub Topics
- [#automator-workflow](https://github.com/topics/automator-workflow)
- [#applescript](https://github.com/topics/applescript)
- [#alfred-workflow](https://github.com/topics/alfred-workflow)
- [#keyboard-maestro](https://github.com/topics/keyboard-maestro)
- [#raycast-extension](https://github.com/topics/raycast-extension)

---

## 🤝 Contributing

Haben Sie weitere awesome macOS Automation Resources? PRs willkommen!

**Kriterien:**
- ⭐ Aktive Entwicklung oder historisch bedeutsam
- 📚 Gute Dokumentation
- 🧪 Getestet & funktional
- 🎯 Klarer Use Case

---

## 📜 License

Diese Liste: MIT License

Einzelne Projekte: Siehe jeweilige Repos

---

## 🙏 Credits

**Kuratiert von:** Maxim @ Munich AI Business
**Inspiriert von:** awesome-automator, kevin-funderburg, SKaplanOfficial und der gesamten macOS Automation Community

**Special Thanks:**
- Sal Soghoian (Ex-Apple Automation Manager)
- Mark Alldritt (Script Debugger)
- The Alfred Team
- The Raycast Team
- Keyboard Maestro Community

---

*"Die besten Tools sind die, die man nicht als Tools wahrnimmt, sondern als natürliche Erweiterung des eigenen Denkens."*
— **Douglas Engelbart**, Erfinder der Maus

**💡 Tipp:** Services sind genau das - unsichtbare Werkzeuge, die zu natürlichen Gesten werden. Ein Rechtsklick, und die Magie geschieht.

---

**Last Updated:** November 2025
**Stars:** ⭐ this repo if useful!
