#!/bin/bash

set -e  

GREEN='\e[38;5;46m'
YELLOW='\e[38;5;226m'
RESET='\e[0m'

echo -e "${YELLOW}Оновлюємо систему...${RESET}"
sudo apt update && sudo apt upgrade -y

echo -e "${YELLOW}Встановлюємо необхідні пакети...${RESET}"
sudo apt install curl -y

echo -e "${YELLOW}Будь ласка, введіть вашу EVM-адресу гаманця:${RESET}"
read -p "EVM-адреса: " wallet_address

echo -e "${GREEN}Завантаження та запуск інсталяційного скрипта...${RESET}"
curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/setup_linux.sh > ~/setup_linux.sh
bash ~/setup_linux.sh

config_file=~/.cysic/config/wallet_address.txt
mkdir -p "$(dirname "$config_file")"  
echo "$wallet_address" > "$config_file"
echo -e "${GREEN}Адресу збережено в: $config_file${RESET}"

echo -e "${YELLOW}Запуск верифікатора...${RESET}"
cd ~/cysic-verifier/ && bash start.sh

echo -e "${YELLOW}Пошук файлів мнемоніки...${RESET}"
mnemonic_folder="$HOME/.cysic/keys"
if [ -d "$mnemonic_folder" ]; then
    echo -e "${GREEN}Ваші мнемонічні файли знаходяться у папці: ${mnemonic_folder}${RESET}"
    echo -e "${YELLOW}Зміст файлів мнемоніки:${RESET}"
    
    for file in "$mnemonic_folder"/*; do
        echo -e "${GREEN}Файл: ${file}${RESET}"
        cat "$file"
        echo -e "${YELLOW}-----------------------------${RESET}"
    done
    
    echo -e "${YELLOW}Будь ласка, збережіть ці файли, інакше ви не зможете повторно запустити програму.${RESET}"
else
    echo -e "${YELLOW}Файли мнемоніки не знайдено! Перевірте програму верифікатора.${RESET}"
fi

echo -e "${GREEN}Скрипт завершено.${RESET}"
