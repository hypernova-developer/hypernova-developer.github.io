#!/bin/bash

CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo " ######################################################"
echo " #                                                    #"
echo " #        GLOBAL GENESIS: THE POWER TRIAD             #"
echo " #      (Jenny | CompileX | SyntaX Library)           #"
echo " #          --------------------------------          #"
echo " #          Deployment of the Power Ecosystem         #"
echo " #                                                    #"
echo " ######################################################"
echo -e "${NC}"

if [ "$EUID" -ne 0 ]; then 
  echo -e "${CYAN}[X] ERROR: System changes require Administrator privileges.${NC}"
  echo -e "${CYAN}[!] Please run with 'sudo'.${NC}"
  exit 1
fi

echo -e "${CYAN}[*] Checking for Core Tools (Git & Python)...${NC}"
command -v git >/dev/null 2>&1 || { apt update && apt install -y git; }
command -v python3 >/dev/null 2>&1 || { apt update && apt install -y python3; }

echo -e "${CYAN}[*] Initializing Directory Structures...${NC}"
mkdir -p $HOME/Tools/Jenny_for_Linux
mkdir -p $HOME/Tools/SyntaX

echo -e "${CYAN}[*] Deploying Jenny Engine (inc. CompileX)...${NC}"
if [ ! -d "$HOME/Tools/Jenny_for_Linux/.git" ]; then
    git clone https://github.com/hypernova-developer/Jenny_for_Linux $HOME/Tools/Jenny_for_Linux
else
    cd "$HOME/Tools/Jenny_for_Linux" && git pull
fi

echo -e "${CYAN}[*] Deploying SyntaX Library Collection...${NC}"
if [ ! -d "$HOME/Tools/SyntaX/.git" ]; then
    git clone https://github.com/hypernova-developer/SyntaX $HOME/Tools/SyntaX
else
    cd "$HOME/Tools/SyntaX" && git pull
fi

echo -e "${CYAN}[*] Optimizing Compiler Suite (GCC/G++)...${NC}"
apt install -y g++ gcc gfortran mono-devel xdpyinfo

echo -e "${CYAN}[*] Installing Python requirements for Jenny...${NC}"
pip3 install psutil --break-system-packages --quiet

chmod +x $HOME/Tools/Jenny_for_Linux/*.sh

echo -e "${CYAN}[*] Optimizing System Environment Variables...${NC}"
PROFILE_FILE="$HOME/.zshrc"
if ! grep -q "Jenny_for_Linux" "$PROFILE_FILE"; then
    echo -e "\n# --- SyntaX Ecosystem ---" >> "$PROFILE_FILE"
    echo "export PATH=\$PATH:\$HOME/Tools/Jenny_for_Linux" >> "$PROFILE_FILE"
    echo "export SYNTAX_HOME=\$HOME/Tools/SyntaX" >> "$PROFILE_FILE"
    echo "alias jenny='python3 \$HOME/Tools/Jenny_for_Linux/main.py'" >> "$PROFILE_FILE"
    echo "alias compilex='\$HOME/Tools/Jenny_for_Linux/compilex.sh'" >> "$PROFILE_FILE"
fi

echo -e "${CYAN}"
echo " ======================================================"
echo "    [SUCCESS] GENESIS DEPLOYMENT COMPLETE!"
echo " ======================================================"
echo "    - Jenny: Ready (jenny --help)"
echo "    - CompileX: Ready (compilex --help)"
echo "    - SyntaX: Auto-Include Active (.h & .hpp)"
echo "    - Linux GCC: Ready (gcc --version)"
echo " ======================================================"
echo -e "${NC}"

echo "Press Enter to exit..."
read
