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

# Function to run the web enumeration script
run_script() {
    echo -e "\nSelect the type of scan:"
    echo "1: Normal Scan"
    echo "2: Deep Scan"
    read -p "Select (1 or 2): " scan_choice

    if [ "$scan_choice" == "1" ]; then
        echo -e "\nRunning normal scan..."
        echo "Executing command: python3 normal_scan.py"
        python3 Normal_scan.py
    elif [ "$scan_choice" == "2" ]; then
        echo -e "\nRunning deep scan..."
        echo "Executing command: python3 deep_scan.py"
        python3 Deep_scan.py
    else
        echo -e "\nInvalid option! Please enter 1 or 2."
    fi
}

if [ "$choice" == "1" ]; then
    echo "Checking for system updates..."
    sudo apt update && sudo apt upgrade -y
    
    echo -e "\n[Linux 🐉] Preparing to run web enumeration script..."
    run_script

elif [ "$choice" == "2" ]; then
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

    echo -e "\n[Mac 💻] Preparing to run web enumeration script..."
    run_script

else
    echo -e "\nInvalid option! Please enter 1 or 2."
fi
