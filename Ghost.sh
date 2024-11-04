#!/bin/bash

# Display ASCII art and welcome message
echo -e "
  ▄████  ██░ ██   ▒█████  ██████ ▄▄▄█████▓
 ██▒ ▀█▒▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓  ██▒ ▓▒
▒██░▄▄▄░▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒ ▓██░ ▒░
░▓█  ██▓░▓█ ░██ ▒██   ██░  ▒   ██▒░ ▓██▓ ░
░▒▓███▀▒░▓█▒░██▓░ ████▓▒░▒██████▒▒  ▒██▒ ░
 ░▒   ▒  ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░  ▒ ░░
  ░   ░  ▒ ░▒░ ░  ░ ▒ ▒░ ░ ░▒  ░ ░    ░
░ ░   ░  ░  ░░ ░░ ░ ░ ▒  ░  ░  ░    ░
      ░  ░  ░  ░    ░ ░        ░
"
echo -e "\nWelcome to the Professional Web Enumeration Tool"
echo -e "This tool will assist you with web enumeration on Linux or macOS\n"

# Prompt user for platform selection
echo "Please select your operating system:"
echo "1: Linux 🐉"
echo "2: Mac 💻"
read -p "Select (1 or 2): " choice

if [ "$choice" == "1" ]; then
    echo "Checking for system updates..."
    sudo apt update && sudo apt upgrade -y
    
    echo -e "\n[Linux 🐉] Running web enumeration script..."
    echo "Executing command: python3 web_enum.py"
    python3 web_enum.py

elif [ "$choice" == "2" ]; then
    python3 -m venv myenv
    source myenv/bin/activate
    echo "Checking for Homebrew updates..."
    brew update

    echo "Checking for required tools..."
    if command -v python3 &>/dev/null; then
        echo "Python3 is installed."
    else
        echo "Python3 is not installed. Please install it using Homebrew: brew install python."
        exit 1
    fi

    echo "Setting up virtual environment..."
    venv_dir="venv"
    if [ ! -d "$venv_dir" ]; then
        python3 -m venv $venv_dir
        echo "Virtual environment created at $venv_dir."
    fi

    echo "Activating virtual environment..."
    source $venv_dir/bin/activate

    echo "Checking for required Python packages..."
    if [ ! -f requirements.txt ]; then
        echo "requirements.txt file not found!"
        exit 1
    fi

    # Update pip and install requirements
    python3 -m pip install --upgrade pip
    python3 -m pip install -r requirements.txt

    echo -e "\n[Mac 💻] Running web enumeration script..."
    echo "Executing command: python3 web_enum.py"
    python3 web_enum.py

else
    echo -e "\nInvalid option! Please enter 1 or 2."
fi
