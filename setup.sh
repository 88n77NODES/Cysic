#!/bin/bash

set -e  

GREEN='\e[38;5;46m'
YELLOW='\e[38;5;226m'
RED='\e[38;5;196m'
RESET='\e[0m'

echo -e "${YELLOW}Оновлюємо систему...${RESET}"
sudo apt update && sudo apt upgrade -y

echo -e "${YELLOW}Встановлюємо необхідні пакети...${RESET}"
sudo apt install curl -y

echo -e "${YELLOW}Будь ласка, введіть вашу EVM-адресу гаманця:${RESET}"
read -p "EVM-адреса: " wallet_address

echo -e "${GREEN}Завантаження та запуск інсталяційного скрипта...${RESET}"
curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/setup_linux.sh -o ~/setup_linux.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Помилка завантаження setup_linux.sh. Перевірте URL або з'єднання.${RESET}"
    exit 1
fi
bash ~/setup_linux.sh "$wallet_address"

# Збереження адреси гаманця у файл конфігурації
config_file=~/.cysic/config/wallet_address.txt
mkdir -p "$(dirname "$config_file")"  
echo "$wallet_address" > "$config_file"
echo -e "${GREEN}Адресу збережено в: $config_file${RESET}"

LOG_FILE="$HOME/cysic.log"
echo -e "${YELLOW}Запуск верифікатора...${RESET}"
cd ~/cysic-verifier/ && bash start.sh &> "$LOG_FILE" &

echo -e "${YELLOW}Очікування завершення синхронізації...${RESET}"
while true; do
    if grep -q "sync data from server finish" "$LOG_FILE"; then
        echo -e "${GREEN}Синхронізація завершена успішно!${RESET}"
        break
    elif grep -q "network error" "$LOG_FILE"; then
        echo -e "${RED}Помилка мережі в логах. Повторна перевірка через 10 секунд...${RESET}"
        sleep 10
    else
        echo -e "${YELLOW}Синхронізація триває, перевіряємо знову через 5 секунд...${RESET}"
        sleep 5
    fi
done

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
    echo -e "${RED}Файли мнемоніки не знайдено! Перевірте роботу програми.${RESET}"
fi

echo -e "${GREEN}Скрипт завершено.${RESET}"
