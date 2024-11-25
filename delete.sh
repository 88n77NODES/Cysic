#!/bin/bash

set -e  

GREEN='\e[38;5;46m'
YELLOW='\e[38;5;226m'
RESET='\e[0m'

echo -e "${YELLOW}Видалення файлу cysic-verifier.db...${RESET}"

cd ~/cysic-verifier/data || { echo -e "${YELLOW}Папка ~/cysic-verifier/data не знайдена. Завершення.${RESET}"; exit 1; }

if [ -f "cysic-verifier.db" ]; then
    rm "cysic-verifier.db"
    echo -e "${GREEN}Файл cysic-verifier.db успішно видалено.${RESET}"
else
    echo -e "${YELLOW}Файл cysic-verifier.db не знайдено.${RESET}"
fi

echo -e "${GREEN}Скрипт завершено.${RESET}"
