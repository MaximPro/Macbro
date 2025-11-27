# 🚀 macOS Automation Setup Guide
> Schritt-für-Schritt Anleitung zum perfekten Automation-Setup

---

## 📋 Inhaltsverzeichnis

- [Quick Start (30 Minuten)](#quick-start-30-minuten)
- [Grundlagen Setup](#grundlagen-setup)
- [Services erstellen](#services-erstellen)
- [Alfred/Raycast Setup](#alfredraycast-setup)
- [Keyboard Maestro Setup](#keyboard-maestro-setup)
- [Advanced Setup](#advanced-setup)
- [Troubleshooting](#troubleshooting)

---

## ⚡ Quick Start (30 Minuten)

### Schritt 1: Automator Services installieren (10 Min)

```bash
# Terminal öffnen (⌘ + Space → "Terminal")

# Erstelle Arbeitsverzeichnis
mkdir -p ~/Automation
cd ~/Automation

# Clone Best Repos
git clone https://github.com/princelundgren/automator-collection.git
git clone https://github.com/yeutterg/automator-workflows.git

# Services installieren
cd automator-collection
open "Copy path as text.workflow"
open "Image to JPG 1080p.workflow"
open "Open in Visual Studio Code.workflow"
```

**✅ Test:**
1. Finder öffnen
2. Rechtsklick auf beliebige Datei
3. Services → "Copy path as text"
4. ⌘V zum Einfügen → Du solltest den vollständigen Pfad sehen

---

### Schritt 2: Ersten eigenen Service erstellen (10 Min)

**Ziel:** Service "Text to UPPERCASE"

1. **Automator öffnen** (⌘ + Space → "Automator")

2. **"Dienst" (Service) wählen**

3. **Input konfigurieren:**
   - "Dienst empfängt ausgewählten": **Text**
   - "in": **jedem Programm**

4. **Aktion hinzufügen:**
   - Suche: "Shell-Skript ausführen"
   - Code eingeben:
   ```bash
   tr '[:lower:]' '[:upper:]'
   ```

5. **Speichern:** ⌘S → Name: "Text to UPPERCASE"

**✅ Test:**
1. Safari/Notes öffnen
2. Text markieren (z.B. "hello world")
3. Rechtsklick → Services → "Text to UPPERCASE"
4. Text sollte zu "HELLO WORLD" werden

---

### Schritt 3: Keyboard Shortcut zuweisen (10 Min)

1. **Systemeinstellungen** öffnen
2. **Tastatur** → **Shortcuts** (links)
3. **Services** (links auswählen)
4. Scrolle zu "Text to UPPERCASE"
5. Klicke rechts auf "keine" → Shortcut eingeben: **⌘⌥U**

**✅ Test:**
- Text markieren
- ⌘⌥U drücken
- Text wird zu UPPERCASE

---

## 🛠️ Grundlagen Setup

### System Permissions

**Wichtig:** Services benötigen Berechtigungen!

1. **Systemeinstellungen** → **Datenschutz & Sicherheit**
2. **Automation** (links)
3. Erlaube **Automator** Zugriff auf:
   - Finder
   - Terminal
   - Alle Apps die du automieren willst

### Services Directory

```bash
# Services werden gespeichert in:
~/Library/Services/

# Liste alle installierten Services:
ls -la ~/Library/Services/

# Service löschen:
rm -rf ~/Library/Services/"Service Name.workflow"

# Backup erstellen:
cp -R ~/Library/Services ~/Dropbox/Backup/Services
```

### Services neu laden

```bash
# Falls Services nicht erscheinen:
/System/Library/CoreServices/pbs -flush
killall Finder
```

---

## 📝 Services erstellen

### Template 1: Text Manipulation

**Use Case:** Text formatieren, konvertieren, verarbeiten

```applescript
on run {input, parameters}
    try
        set selectedText to input as text

        -- Deine Verarbeitung hier
        set processedText to do shell script "echo " & quoted form of selectedText & " | your_command"

        return processedText
    on error errMsg
        display notification errMsg with title "Error"
        return input
    end try
end run
```

**Beispiele:**
- Text to Lowercase: `tr '[:upper:]' '[:lower:]'`
- Remove Line Breaks: `tr -d '\n'`
- URL Encode: `python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read()))"`
- Count Words: `wc -w`

---

### Template 2: File Operations

**Use Case:** Dateien verarbeiten, konvertieren, umbenennen

```applescript
on run {input, parameters}
    try
        repeat with theFile in input
            set filePath to POSIX path of theFile

            -- Deine Verarbeitung hier
            do shell script "your_command " & quoted form of filePath
        end repeat

        display notification "Processing complete!" with title "File Service"
        return input
    on error errMsg
        display notification errMsg with title "Error"
        return input
    end try
end run
```

**Beispiele:**
- Convert Image: `sips -s format png INPUT -o OUTPUT.png`
- Resize Image: `sips -Z 1920 INPUT`
- PDF to Text: `pdftotext INPUT OUTPUT.txt`
- Create ZIP: `zip -r archive.zip INPUT`

---

### Template 3: API Integration

**Use Case:** Daten an externe APIs senden

```applescript
on run {input, parameters}
    try
        set selectedText to input as text

        -- API Call (Beispiel: Claude)
        set apiKey to "YOUR_API_KEY"
        set apiUrl to "https://api.anthropic.com/v1/messages"

        set curlCommand to "curl -X POST " & apiUrl & " \\
            -H 'x-api-key: " & apiKey & "' \\
            -H 'Content-Type: application/json' \\
            -d '{\"model\":\"claude-3-5-sonnet-20241022\",\"max_tokens\":1024,\"messages\":[{\"role\":\"user\",\"content\":\"Analyze: " & selectedText & "\"}]}'"

        set apiResponse to do shell script curlCommand

        -- Response anzeigen
        display dialog apiResponse buttons {"OK"} default button 1

        return selectedText
    on error errMsg
        display notification errMsg with title "API Error"
        return input
    end try
end run
```

---

### Template 4: Clipboard Operations

**Use Case:** Mit Clipboard arbeiten

```applescript
on run {input, parameters}
    try
        -- Get Clipboard
        set clipboardContent to the clipboard

        -- Set Clipboard
        set the clipboard to "New content"

        -- Append to Clipboard
        set the clipboard to clipboardContent & linefeed & "Appended text"

        return input
    on error errMsg
        display notification errMsg with title "Clipboard Error"
        return input
    end try
end run
```

---

## 🔮 Alfred/Raycast Setup

### Option A: Alfred Setup

#### 1. Installation

```bash
# Homebrew Installation
brew install --cask alfred

# Powerpack kaufen: alfredapp.com ($34 Lifetime)
```

#### 2. Basic Configuration

1. **Alfred öffnen:** ⌥ + Space (standard)
2. **Preferences** → **General**
3. **Alfred Hotkey** setzen (z.B. ⌘ + Space)
4. **Where are you:** Germany (für Web Searches)

#### 3. Workflows installieren

```bash
# Workflows herunterladen
cd ~/Downloads
git clone https://github.com/zenorocha/alfred-workflows.git
cd alfred-workflows

# Installation
open Kill-Process.alfredworkflow
open Package-Managers.alfredworkflow
open Colors.alfredworkflow
```

**Post-Installation:**
1. Alfred öffnen
2. Preferences → Workflows
3. Jeder Workflow hat eigene Keywords (siehe Description)

#### 4. Custom Workflow erstellen

1. **Alfred Preferences** → **Workflows** → **+** (unten links)
2. **Templates** → **Essentials** → **Keyword to Script**
3. **Keyword eingeben:** (z.B. "uuid")
4. **Script:**
```bash
#!/bin/bash
uuidgen | tr '[:upper:]' '[:lower:]'
```
5. **Output:** "Copy to Clipboard"

**✅ Test:** Alfred → "uuid" → UUID wird kopiert

---

### Option B: Raycast Setup

#### 1. Installation

```bash
brew install --cask raycast

# Erste Öffnung
open -a Raycast
```

#### 2. Basic Configuration

1. **Raycast öffnen:** ⌘ + Space
2. **Settings** → **General**
3. **Hotkey:** ⌘ + Space (ersetzt Spotlight)
4. **Import Alfred Workflows:** Optional

#### 3. Extensions installieren

**Via UI:**
1. Raycast öffnen
2. "Store" eingeben
3. Browse Extensions
4. Install (z.B. "GitHub", "Notion", "Spotify")

**Via Command Line:**
```bash
# Extension entwickeln (Advanced)
npm install -g @raycast/api
mkdir my-extension
cd my-extension
npm init @raycast
```

#### 4. Custom Script Command

1. **Raycast** → **Settings** → **Extensions** → **+** (Add Script Command)
2. **Name:** "Generate UUID"
3. **Script:**
```bash
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Generate UUID
# @raycast.mode silent

uuidgen | tr '[:upper:]' '[:lower:]' | pbcopy
echo "UUID copied to clipboard"
```
4. **Save:** `~/Raycast/Scripts/uuid.sh`
5. `chmod +x ~/Raycast/Scripts/uuid.sh`

**✅ Test:** Raycast → "Generate UUID" → UUID in Clipboard

---

## ⌨️ Keyboard Maestro Setup

### 1. Installation

```bash
brew install --cask keyboard-maestro

# Lizenz kaufen: keyboardmaestro.com ($36 Lifetime)
```

### 2. Basic Configuration

1. **Keyboard Maestro öffnen**
2. **License** eingeben
3. **Preferences:**
   - Start at Login: ✅
   - Show icon in Menu Bar: ✅
   - Global Macro Hotkey: ⌃⌥⌘K

### 3. Erste Macro erstellen

**Ziel:** Screenshot → Clipboard → Upload → URL kopieren

1. **New Macro Group:** "Screenshots"
2. **New Macro:** "Upload Screenshot"
3. **Trigger:** Hot Key Trigger → ⌘⌃⇧4
4. **Actions:**

```
1. Pause 0.5 seconds (für Screenshot Tool)
2. Execute Shell Script:
   curl -F "file=@-" https://0x0.st < $(osascript -e 'the clipboard as «class PNGf»' | xxd -r -p)
3. Set Clipboard to Text: %Variable%Result%
4. Display Notification: "URL copied!" title "Screenshot"
```

**✅ Test:** ⌘⌃⇧4 → Screenshot → URL in Clipboard

---

### 4. Import Macro Libraries

```bash
# Download Macro Collections
cd ~/Automation
git clone https://github.com/monfresh/Keyboard-Maestro-Macros.git
git clone https://github.com/Zettt/km-macros.git

# Import in Keyboard Maestro:
# File → Import Macros → Select .kmmacros files
```

---

### 5. Sync via Dropbox

1. **Keyboard Maestro** → **Preferences** → **General**
2. **Macro Sync:**
   - Sync Macros: ✅
   - Folder: `~/Dropbox/Keyboard Maestro`

**Manual Sync:**
```bash
# Create Symlink
mkdir -p ~/Dropbox/Keyboard\ Maestro
ln -s ~/Dropbox/Keyboard\ Maestro ~/Library/Application\ Support/Keyboard\ Maestro/Keyboard\ Maestro\ Macros.kmsync
```

---

## 🔧 Advanced Setup

### Hyperkey Setup (Game Changer!)

**Was ist Hyperkey?**
Caps Lock → ⌘⌃⌥⇧ (alle Modifier gleichzeitig)
= Hunderte neue Shortcut-Kombinationen!

#### Installation

```bash
# Install Karabiner-Elements
brew install --cask karabiner-elements

# Starten und Permissions gewähren
open -a "Karabiner-Elements"
```

#### Configuration

1. **Karabiner-Elements** → **Simple Modifications**
2. **Add item:**
   - From key: **caps_lock**
   - To key: **f18** (temporary mapping)

3. **Complex Modifications** → **Add rule:**
   - **"Change caps_lock to command+control+option+shift"**
   - Import from: https://ke-complex-modifications.pqrs.org/

#### Testing

```bash
# Hyperkey (Caps Lock) + H sollte nichts machen (noch nicht assigned)
```

#### Usage mit Keyboard Maestro

1. **Keyboard Maestro** → **New Macro**
2. **Trigger:** Hot Key → Drücke Caps Lock + H
3. Macro wird getriggert mit ⌘⌃⌥⇧H

**Vorteile:**
- ✅ Keine Konflikte mit System/App Shortcuts
- ✅ Hunderte neue Kombinationen (A-Z = 26 neue Shortcuts!)
- ✅ Ergonomisch (Caps Lock statt 4 Tasten)

---

### BetterTouchTool Setup

#### 1. Installation

```bash
brew install --cask bettertouchtool

# 45-Tage Trial, dann $22 Lifetime
```

#### 2. Basic Configuration

1. **BetterTouchTool** öffnen
2. **Permissions gewähren:**
   - Accessibility
   - Input Monitoring

3. **Touch Bar (falls vorhanden):**
   - Preferences → Touch Bar → Enable BTT Touch Bar

#### 3. Import Presets

```bash
cd ~/Automation
git clone https://github.com/vas3k/btt-touchbar-presets.git
git clone https://github.com/andrewchidden/btt-presets.git

# Import in BTT:
# Preferences → Gestures → Import → Select .bttpreset files
```

#### 4. Custom Gestures

**Beispiel: Three-Finger Tap → Clipboard History**

1. **Trackpad Tab** → **Add New Gesture**
2. **Gesture:** Three Finger Tap
3. **Action:** Show Clipboard History
4. **Save**

**✅ Test:** Three-Finger Tap → Clipboard History erscheint

---

### Hazel Setup (File Automation)

#### 1. Installation

```bash
brew install --cask hazel

# $42 - https://www.noodlesoft.com
```

#### 2. Auto-Organize Downloads

1. **Hazel** → **Folders** → **+** → `~/Downloads`
2. **New Rule:** "Move Images to Pictures"
3. **Conditions:**
   - Kind is Image
4. **Actions:**
   - Move to folder: `~/Pictures/Downloads`
   - Sort into subfolder: `%created_month%`

#### 3. Auto-Open Apps

**Rule:** "Open .app files from Downloads"
1. **Conditions:**
   - Extension is app
2. **Actions:**
   - Run Shell Script:
   ```bash
   open "$1"
   ```
   - Move to Trash

---

### Shell Script Integration

#### AppleScript → Shell Script

```applescript
on run {input, parameters}
    repeat with theFile in input
        set filePath to POSIX path of theFile
        do shell script "python3 ~/scripts/process.py " & quoted form of filePath
    end repeat
    return input
end run
```

#### Shell Script → AppleScript

```bash
#!/bin/bash

osascript <<EOF
tell application "Finder"
    set theFolder to choose folder with prompt "Select a folder:"
    return POSIX path of theFolder
end tell
EOF
```

---

## 🚨 Troubleshooting

### Services erscheinen nicht im Menü

**Lösung 1: Services neu laden**
```bash
/System/Library/CoreServices/pbs -flush
killall Finder
```

**Lösung 2: Preferences löschen**
```bash
rm ~/Library/Preferences/pbs.plist
/System/Library/CoreServices/pbs -flush
```

**Lösung 3: Permissions prüfen**
```bash
# Systemeinstellungen → Datenschutz & Sicherheit → Automation
# Erlaube Automator Zugriff auf alle benötigten Apps
```

---

### Keyboard Shortcuts funktionieren nicht

**Problem:** Konflikt mit System/App Shortcuts

**Lösung:**
1. **Systemeinstellungen** → **Tastatur** → **Shortcuts**
2. Prüfe alle Kategorien auf Konflikte
3. Deaktiviere ungenutzte System Shortcuts

**Best Practices:**
- ✅ Use Hyperkey (Caps Lock) → keine Konflikte
- ✅ ⌘⌥⇧ + Key → meist frei
- ❌ ⌘C, ⌘V, ⌘S → System Reserved

---

### AppleScript Permission Denied

**Problem:** Script hat keine Rechte für Finder/Apps

**Lösung:**
```bash
# Systemeinstellungen → Datenschutz & Sicherheit
# Automation → Script Editor / Automator
# ✅ Finder
# ✅ System Events
# ✅ [Deine App]
```

**Alternative (Terminal Script):**
```bash
# Add to sudoers (VORSICHT!)
sudo visudo
# Füge hinzu: your_user ALL=(ALL) NOPASSWD: /path/to/script.sh
```

---

### Shell Script läuft nicht in Service

**Problem:** Environment Variables fehlen

**Lösung:**
```bash
#!/bin/bash

# Source Profile für Environment
source ~/.zshrc  # oder ~/.bash_profile

# Explicit PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Dein Script
your_command
```

---

### Keyboard Maestro Macro triggert nicht

**Problem 1: Global Macro Palette disabled**
```
Preferences → Global Macro Palette → Enable
```

**Problem 2: Macro Group nicht aktiv**
```
Macro Group → Available in: All Applications
```

**Problem 3: Conflict mit anderem Tool**
```
Deaktiviere temporär: Alfred, Raycast, BetterTouchTool
Teste Macro isoliert
```

---

### BTT Touch Bar leer

**Problem:** System Touch Bar Override

**Lösung:**
```
Systemeinstellungen → Keyboard → Touch Bar
Touch Bar shows: App Controls with Control Strip
```

**BTT Configuration:**
```
BetterTouchTool → Advanced → Touch Bar
Show BTT Touch Bar: Always
```

---

## 📊 Testing Checklist

### Service Testing

```bash
# 1. Service erscheint im Menü?
# Finder → Rechtsklick → Services → [Dein Service]

# 2. Input Type korrekt?
# Text Service: Markiere Text in Safari → Rechtsklick
# File Service: Selektiere Datei im Finder → Rechtsklick

# 3. Output korrekt?
# Check Console.app für Errors:
# /Applications/Utilities/Console.app
# Filter: "Service"

# 4. Keyboard Shortcut funktioniert?
# Systemeinstellungen → Tastatur → Shortcuts → Services
```

### Performance Testing

```bash
# Time your Service
time /usr/bin/osascript /path/to/service.scpt

# Monitor CPU usage
top -l 1 | grep "Automator"

# Memory usage
ps aux | grep "Automator"
```

---

## 🎯 Next Steps

### Woche 1-2: Basics
- ✅ 10 Automator Services installiert
- ✅ 3 eigene Services erstellt
- ✅ Alfred oder Raycast Setup
- ✅ 5 Workflows/Extensions installiert

### Woche 3-4: Intermediate
- ✅ Keyboard Maestro gekauft & Setup
- ✅ 10 Macros erstellt
- ✅ Hyperkey Setup
- ✅ Sync via Dropbox eingerichtet

### Monat 2-3: Advanced
- ✅ BetterTouchTool Setup
- ✅ Hazel Automation Rules
- ✅ API Integration (n8n, Claude)
- ✅ Custom Workflow Suites

### Monat 3+: Expert
- ✅ GitHub Repository für eigene Tools
- ✅ Share & Contribute to Community
- ✅ Build Commercial Solutions
- ✅ Teach & Create Content

---

## 💡 Pro Tips

### Productivity Hacks

**1. Clipboard History (Alfred/Raycast):**
```
⌘⌥C → Zeigt alle kopierten Inhalte
Snippets für oft-genutzte Texte
```

**2. Quick File Actions:**
```
Rechtsklick auf Datei im Finder
→ Services für schnelle Aktionen
→ Keine App öffnen nötig
```

**3. Text Expansion:**
```
;email → maxim@munich-ai.com
;addr → Munich, Germany
;sig → Best regards, Maxim
```

**4. Window Management:**
```
Hyperkey + H/J/K/L → Window Positioning
Hyperkey + F → Fullscreen
Hyperkey + M → Minimize
```

### Backup Strategy

```bash
# Automated Backup Script
#!/bin/bash

BACKUP_DIR=~/Dropbox/Backup/Automation
DATE=$(date +%Y%m%d)

# Services
cp -R ~/Library/Services "$BACKUP_DIR/Services-$DATE"

# Alfred
cp -R ~/Library/Application\ Support/Alfred "$BACKUP_DIR/Alfred-$DATE"

# Keyboard Maestro
cp -R ~/Library/Application\ Support/Keyboard\ Maestro "$BACKUP_DIR/KM-$DATE"

# Scripts
cp -R ~/Library/Scripts "$BACKUP_DIR/Scripts-$DATE"

echo "Backup completed: $DATE"
```

**Schedule mit Keyboard Maestro:**
1. New Macro: "Daily Backup"
2. Trigger: Time of Day → 23:00
3. Execute Shell Script: [above script]

---

## 📚 Further Reading

- [awesome-macos-automation.md](./awesome-macos-automation.md) - Vollständige Library Liste
- [Official AppleScript Guide](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/)
- [Keyboard Maestro Wiki](https://wiki.keyboardmaestro.com/)
- [Alfred Documentation](https://www.alfredapp.com/help/)
- [Raycast API Docs](https://developers.raycast.com/)

---

**Happy Automating! 🚀**

*Bei Fragen oder Problemen: Check [awesome-macos-automation.md](./awesome-macos-automation.md) oder Community Forums!*
