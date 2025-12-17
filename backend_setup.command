#!/bin/bash

# ===========================================
#   Charlie Tool Backend Setup (Auto-Install)
# ===========================================

# --- 1. Fix Directory Context ---
cd "$(dirname "$0")"
cd Server || { echo "❌ Server directory not found! Make sure this script is next to the 'Server' folder."; exit 1; }

echo "=========================================="
echo "   Charlie Tool - Backend Launcher"
echo "=========================================="
echo "📂 Working in: $(pwd)"

# --- 2. Define Version Settings ---
PYTHON_VERSION="3.13"
EXACT_VERSION="3.13.4"
# Official Python macOS Installer URL
INSTALLER_URL="https://www.python.org/ftp/python/${EXACT_VERSION}/python-${EXACT_VERSION}-macos11.pkg"

# --- 3. Function to Check & Install Python ---
ensure_python() {
    echo
    echo "[1] Checking for Python $PYTHON_VERSION..."

    # Check if python3.13 command exists
    if command -v python$PYTHON_VERSION &>/dev/null; then
        echo "✅ Python $PYTHON_VERSION is already installed."
        PY_CMD="python$PYTHON_VERSION"
        return
    fi

    echo "❌ Python $PYTHON_VERSION not found."
    echo "⚙️  Initiating automatic installation for Python $EXACT_VERSION..."

    # Check for Homebrew
    if command -v brew &>/dev/null; then
        echo "🍺 Homebrew detected. Installing via Homebrew..."
        brew install python@$PYTHON_VERSION
        
        # Link it so it's available
        brew link python@$PYTHON_VERSION
    else
        echo "🌐 Homebrew not found. Downloading official installer..."
        INSTALLER_PATH="/tmp/python-$EXACT_VERSION.pkg"
        
        # Download the pkg
        curl -o "$INSTALLER_PATH" "$INSTALLER_URL"
        
        if [ -f "$INSTALLER_PATH" ]; then
            echo "📦 Opening installer..."
            open "$INSTALLER_PATH"
            echo "⚠️  PLEASE COMPLETE THE INSTALLATION WINDOW THAT JUST OPENED."
            echo "👉 Press [ENTER] here once you have finished installing Python."
            read -r
        else
            echo "❌ Failed to download python installer. Please check your internet."
            exit 1
        fi
    fi

    # Verify installation succeeded
    if command -v python$PYTHON_VERSION &>/dev/null; then
        echo "✅ Python $PYTHON_VERSION successfully installed!"
        PY_CMD="python$PYTHON_VERSION"
    else
        echo "❌ Installation check failed. Please install Python $EXACT_VERSION manually."
        exit 1
    fi
}

# Run the check/install logic
ensure_python

# --- 4. Clean & Setup Virtual Environment ---
echo
echo "[2] Setting up Virtual Environment..."

# If venv exists, check if it's the wrong version
if [ -d "venv" ]; then
    VENV_VER=$(venv/bin/python --version 2>&1)
    if [[ "$VENV_VER" != *"$PYTHON_VERSION"* ]]; then
        echo "⚠️  Old venv detected ($VENV_VER). Removing to upgrade to $PYTHON_VERSION..."
        rm -rf venv
    fi
fi

# Create new venv if missing
if [ ! -d "venv" ]; then
    echo "📦 Creating venv using $PY_CMD..."
    $PY_CMD -m venv venv
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create venv. Make sure Python is working correctly."
        exit 1
    fi
fi

# --- 5. Install Dependencies & Launch ---
echo
echo "[3] Activating & Launching..."
source venv/bin/activate

# Ensure pip is up to date
pip install --upgrade pip &>/dev/null

# Install requirements if needed (silently check if uvicorn exists)
if ! pip show uvicorn &>/dev/null; then
    echo "📥 Installing dependencies (this may take a moment)..."
    pip install -r requirements.txt 2>/dev/null || pip install uvicorn fastapi
fi

# Kill old process if running
PID=$(lsof -ti:8000)
if [ -n "$PID" ]; then
    kill -9 $PID
fi

echo "🚀 Starting FastAPI Server with Python $PYTHON_VERSION..."
echo "-----------------------------------------------------"
# Run Server
python -m uvicorn Main:app --reload --port 8000