# GitRadar - Getting Started Guide

> **Target audience:** Developers new to Flutter and Serverpod  
> **System:** Mac Mini M4 (Apple Silicon)

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Install Prerequisites](#install-prerequisites)
3. [Install Flutter](#install-flutter)
4. [Install Serverpod CLI](#install-serverpod-cli)
5. [Install PostgreSQL with Docker](#install-postgresql-with-docker)
6. [VS Code Setup](#vs-code-setup)
7. [Mobile Device Setup](#mobile-device-setup)
8. [Create the Project](#create-the-project)
9. [Running the Project](#running-the-project)
10. [Troubleshooting](#troubleshooting)

---

## System Requirements

### Mac Mini M4 Base Specs ✅
| Component | Your Specs |
|-----------|------------|
| Chip | Apple M4 (10-core CPU, 10-core GPU) |
| RAM | 16GB unified memory |
| OS | macOS Sequoia 15.x |

This is an excellent setup for Flutter development. The M4's efficiency means you can even run the iOS Simulator comfortably if needed.

---

## Install Prerequisites

### 1. Homebrew (Package Manager)

Homebrew is essential for macOS development. Install it first:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After installation, add Homebrew to PATH (follow the on-screen instructions, typically):
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Verify:
```bash
brew --version
```

### 2. Xcode Command Line Tools

Required for Flutter and native compilation:

```bash
xcode-select --install
```

Click "Install" when prompted. This takes a few minutes.

### 3. Git

macOS includes Git, but get the latest via Homebrew:
```bash
brew install git
git --version
```

---

## Install Flutter

### Option A: Quick Install via VS Code (Recommended)

1. Install VS Code: `brew install --cask visual-studio-code`
2. Open VS Code → Extensions → Search "Flutter" → Install
3. Press `Cmd+Shift+P` → Type "Flutter: New Project"
4. VS Code will prompt to download Flutter SDK automatically

### Option B: Install via Homebrew

```bash
brew install --cask flutter
```

### Option C: Manual Install

```bash
# Download Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (add to ~/.zshrc for persistence)
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Verify Installation

```bash
flutter --version
flutter doctor
```

### Expected `flutter doctor` Output
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] VS Code
```

---

## Install Serverpod CLI

```bash
dart pub global activate serverpod_cli
```

Add Dart's global bin to PATH:
```bash
echo 'export PATH="$HOME/.pub-cache/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Verify:
```bash
serverpod --help
```

---

## Install PostgreSQL with Docker

### Install Docker Desktop for Mac

```bash
brew install --cask docker
```

Or download from: https://www.docker.com/products/docker-desktop/

After installation:
1. Open Docker Desktop from Applications
2. Complete the setup wizard
3. Docker runs natively on Apple Silicon (very efficient!)

Verify:
```bash
docker --version
docker info
```

> **Tip:** Docker Desktop on M4 is lightweight. You can leave it running.

---

## VS Code Setup

### Install VS Code

```bash
brew install --cask visual-studio-code
```

### Required Extensions

| Extension | Install Command |
|-----------|-----------------|
| **Flutter** | `code --install-extension Dart-Code.flutter` |
| **Serverpod** | `code --install-extension serverpod.serverpod` |

Or install via VS Code UI: Extensions (`Cmd+Shift+X`) → Search → Install

### Recommended Extensions

| Extension | Purpose |
|-----------|---------|
| **Error Lens** | Inline error display |
| **GitLens** | Git integration |
| **Material Icon Theme** | Better file icons |
| **Thunder Client** | API testing |
| **YAML** | YAML syntax support |
| **Docker** | Docker integration |

Install all at once:
```bash
code --install-extension Dart-Code.flutter
code --install-extension serverpod.serverpod
code --install-extension usernamehw.errorlens
code --install-extension eamodio.gitlens
code --install-extension PKief.material-icon-theme
code --install-extension rangav.vscode-thunder-client
code --install-extension redhat.vscode-yaml
code --install-extension ms-azuretools.vscode-docker
```

### VS Code Settings

Press `Cmd+,` → Click the `{}` icon (Open Settings JSON) → Add:

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },
  "dart.previewFlutterUiGuides": true,
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.rulers": [80],
    "editor.tabSize": 2
  }
}
```

---

## Mobile Device Setup

### Option A: iOS Simulator (Recommended for Mac)

Your M4 Mac runs iOS Simulator smoothly!

```bash
# Install Xcode from App Store (required for iOS development)
# Or via command line:
xcode-select --install

# Open iOS Simulator
open -a Simulator

# List available simulators
flutter emulators

# Launch a specific simulator
flutter emulators --launch apple_ios_simulator
```

### Option B: Physical Android Device

Still the fastest option for real device testing.

#### Enable USB Debugging on Phone
1. Go to **Settings → About Phone**
2. Tap **Build Number** 7 times
3. Go to **Settings → Developer Options**
4. Enable **USB Debugging**

#### Install Android Platform Tools
```bash
brew install android-platform-tools
```

#### Connect and Verify
```bash
# Connect phone via USB, accept the debugging prompt
adb devices
flutter devices
```

### Option C: scrcpy (Android Screen Mirror)

Mirror your Android phone to Mac:

```bash
brew install scrcpy
```

Usage:
```bash
# Basic mirror
scrcpy

# Turn off phone screen (saves battery)
scrcpy --turn-screen-off

# Lower resolution for performance
scrcpy --max-size 1024

# Wireless mode (after USB setup)
scrcpy --tcpip
```

### Wireless Android Debugging

```bash
# Connect phone via USB first
adb tcpip 5555
adb connect YOUR_PHONE_IP:5555

# Disconnect cable - now wireless!
flutter devices
scrcpy
```

---

## Create the Project

### Initialize GitRadar

```bash
cd ~/Workspace/gitradar

# Create Serverpod project
serverpod create gitradar

# This creates:
# gitradar/
#   gitradar_server/    → Backend server
#   gitradar_client/    → Generated client library  
#   gitradar_flutter/   → Flutter app
```

### Reorganize for Cleaner Monorepo (Optional)

```bash
mv gitradar_server server
mv gitradar_flutter app
mv gitradar_client client
```

---

## Running the Project

### Terminal 1: Start PostgreSQL

```bash
cd ~/Workspace/gitradar/server
docker compose up -d
```

### Terminal 2: Start Serverpod Backend

```bash
cd ~/Workspace/gitradar/server

# First run - apply migrations
dart run bin/main.dart --apply-migrations

# Subsequent runs
dart run bin/main.dart
```

Server endpoints:
- API: http://localhost:8080
- Web: http://localhost:8082

### Terminal 3: Start Flutter App

**Web (Chrome):**
```bash
cd ~/Workspace/gitradar/app
flutter run -d chrome
```

**iOS Simulator:**
```bash
flutter run -d iPhone
```

**Physical Device:**
```bash
flutter devices  # Get device ID
flutter run -d <device_id>
```

---

## Development Workflow

### After Changing Server Models

```bash
cd server
serverpod generate
cd ../app
flutter pub get
```

### Hot Reload
- **Flutter:** Press `r` in terminal or save file (auto)
- **Hot Restart:** Press `R` (capital)
- **Serverpod:** Restart server after endpoint changes

### Useful Commands

| Command | Purpose |
|---------|---------|
| `flutter doctor` | Check Flutter setup |
| `flutter devices` | List connected devices |
| `flutter clean` | Clear build cache |
| `flutter pub get` | Install dependencies |
| `serverpod generate` | Regenerate Serverpod code |
| `serverpod create-migration` | Create DB migration |
| `docker compose up -d` | Start PostgreSQL |
| `docker compose down` | Stop PostgreSQL |

---

## Troubleshooting

### "flutter: command not found"
```bash
# Check Flutter location
which flutter

# If not found, add to PATH
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### "serverpod: command not found"
```bash
echo 'export PATH="$HOME/.pub-cache/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Xcode license not accepted
```bash
sudo xcodebuild -license accept
```

### CocoaPods issues (iOS)
```bash
sudo gem install cocoapods
cd app/ios
pod install
```

### Docker not starting
1. Open Docker Desktop manually
2. Wait for it to fully start (whale icon stops animating)
3. Try `docker info` again

### PostgreSQL connection failed
```bash
# Check if container is running
docker ps

# If not running
cd server
docker compose up -d

# View logs
docker compose logs
```

### Android device not detected
```bash
# Restart ADB
adb kill-server
adb start-server
adb devices
```

---

## Learning Resources

### Flutter
- [Flutter Docs](https://docs.flutter.dev/)
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)
- [Widget Catalog](https://docs.flutter.dev/ui/widgets)

### Serverpod
- [Serverpod Docs](https://docs.serverpod.dev/)
- [Getting Started Guide](https://docs.serverpod.dev/get-started/creating-endpoints)
- [Discord Community](https://serverpod.dev/discord)

### Dart
- [Dart Language Tour](https://dart.dev/language)
- [Effective Dart](https://dart.dev/effective-dart)

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                  GitRadar Dev Cheatsheet                    │
├─────────────────────────────────────────────────────────────┤
│ START DATABASE      │ cd server && docker compose up -d     │
│ START SERVER        │ dart run bin/main.dart                │
│ START APP (web)     │ cd app && flutter run -d chrome       │
│ START APP (iOS)     │ flutter run -d iPhone                 │
│ START APP (Android) │ flutter run -d <device_id>            │
│ MIRROR ANDROID      │ scrcpy --turn-screen-off              │
│ REGENERATE CODE     │ cd server && serverpod generate       │
│ CHECK SETUP         │ flutter doctor                        │
│ LIST DEVICES        │ flutter devices                       │
│ STOP DATABASE       │ cd server && docker compose down      │
└─────────────────────────────────────────────────────────────┘
```
