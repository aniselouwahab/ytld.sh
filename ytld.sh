#!/bin/bash

# ==========================================================
# AUTO-YTDLP PRO - Édition Stable
# Version 1.6.0 - Fix Permissions & User Folder
# ==========================================================

CONFIG_FILE="$HOME/.auto-ytdlp.conf"
BINARY_PATH="/usr/local/bin/auto-ytdlp"

# --- COULEURS ---
CYAN="\e[36m"
BLUE="\e[34m"
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BOLD="\e[1m"
DIM="\e[2m"
RESET="\e[0m"

# Paramètres par défaut
download_days=5
playlist_end=10

header() {
    clear
    echo -e "${BLUE}${BOLD}"
    echo -e "  █████╗ ██╗   ██╗████████╗ ██████╗     ██╗   ██╗████████╗██████╗ "
    echo -e "  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗    ╚██╗ ██╔╝╚══██╔══╝██╔══██╗"
    echo -e "  ███████║██║   ██║   ██║   ██║   ██║     ╚████╔╝    ██║   ██║  ██║"
    echo -e "  ██╔══██║██║   ██║   ██║   ██║   ██║      ╚██╔╝     ██║   ██║  ██║"
    echo -e "  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝       ██║      ██║   ██████╔╝"
    echo -e "  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝        ╚═╝      ╚═╝   ╚═════╝ "
    echo -e "                      AUTOMATED DOWNLOADER PRO${RESET}"
    echo -e "${CYAN}  ┌──────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${CYAN}  │${RESET}  ${DIM}CONFIG:${RESET} ${YELLOW}$CONFIG_FILE${RESET}      ${DIM}ENGINE:${RESET} ${GREEN}yt-dlp${RESET}  ${CYAN}│${RESET}"
    echo -e "${CYAN}  └──────────────────────────────────────────────────────────────┘${RESET}"
}

# --- 1. VÉRIFICATION SYSTÈME ---
check_system() {
    if ! command -v yt-dlp >/dev/null 2>&1; then
        echo -e "${YELLOW}[!] Installation de yt-dlp...${RESET}"
        sudo apt update && sudo apt install yt-dlp -y
    fi
}

# --- 2. FONCTIONS ---
run_downloads() {
    header
    if [[ ! -s "$CONFIG_FILE" ]]; then
        echo -e "  ${RED}[X] AUCUNE CHAÎNE CONFIGURÉE${RESET}"
        sleep 2; return
    fi

    echo -e "  ${YELLOW}>> DÉMARRAGE DU SCAN (-$download_days jours)${RESET}"
    download_date="$(date -d "$download_days days ago" '+%Y%m%d')"
    
    while IFS='|' read -r name url path; do
        [[ -z "$name" ]] && continue
        echo -e "\n  ${BLUE}┌─── SOURCE : $BOLD$name$RESET"
        echo -e "  ${BLUE}│${RESET}  ${DIM}DOSSIER : $path${RESET}"
        
        # Création auto si besoin (dans le dossier actuel de l'utilisateur)
        mkdir -p "$path"
        
        yt-dlp --geo-bypass \
               --download-archive "$path/.archive" \
               --dateafter "$download_date" \
               --playlist-end "$playlist_end" \
               -o "$path/%(title)s.%(ext)s" \
               --no-warnings \
               "$url"
               
        echo -e "  ${BLUE}└───${RESET} ${GREEN}Terminé.${RESET}"
    done < "$CONFIG_FILE"
    
    echo -e "\n  ${GREEN}[SUCCÈS] Mises à jour terminées.${RESET}"
    read -p "  Appuyez sur Entrée..."
}

add_channel() {
    header
    echo -e "  ${BOLD}AJOUT D'UNE NOUVELLE SOURCE${RESET}"
    echo -e "  ${CYAN}──────────────────────────${RESET}"
    read -p "  1. Nom de la chaine : " name
    read -p "  2. URL YouTube      : " url
    
    # ICI : L'utilisateur tape juste un nom, ex: "video"
    read -p "  3. Nom du dossier de réception : " folder_name
    
    # On définit le chemin complet dans le dossier actuel de l'utilisateur
    full_path="$HOME/$folder_name"
    
    mkdir -p "$full_path"
    echo "$name|$url|$full_path" >> "$CONFIG_FILE"
    
    echo -e "\n  ${GREEN}[OK] Source enregistrée dans : $full_path${RESET}"
    sleep 2
}

manage_channels() {
    while true; do
        header
        echo -e "  ${BOLD}GESTION DES SOURCES${RESET}"
        if [[ ! -s "$CONFIG_FILE" ]]; then
            echo -e "  ${DIM}(Liste vide)${RESET}"; sleep 1; break
        else
            awk -F'|' '{print "  " NR ") " "\033[1;32m" $1 "\033[0m" " -> Folder: " $3}' "$CONFIG_FILE"
        fi
        
        echo -e "\n  ${YELLOW}[num]${RESET} Supprimer | ${YELLOW}[q]${RESET} Retour"
        read -p "  ACTION : " action
        [[ "$action" =~ ^[Qq]$ ]] && break
        if [[ "$action" =~ ^[0-9]+$ ]]; then
            sed -i "${action}d" "$CONFIG_FILE"
            echo -e "  ${RED}Supprimé.${RESET}"
            sleep 1
        fi
    done
}

# --- 3. BOUCLE PRINCIPALE ---
check_system
touch "$CONFIG_FILE"

while true; do
    header
    echo -e "  ${CYAN}[1]${RESET} LANCER LES TÉLÉCHARGEMENTS"
    echo -e "  ${CYAN}[2]${RESET} AJOUTER UNE SOURCE"
    echo -e "  ${CYAN}[3]${RESET} LISTER / SUPPRIMER"
    echo -e "  ${CYAN}[4]${RESET} PARAMÈTRES"
    echo -e ""
    echo -e "  ${RED}[Q] QUITTER${RESET}"
    echo -e "${CYAN}  ──────────────────────────────────────────────────────────────${RESET}"
    read -p "  VOTRE CHOIX : " opt

    case $opt in
        1) run_downloads ;;
        2) add_channel ;;
        3) manage_channels ;;
        4) 
            header
            read -p "  Jours à remonter : " download_days
            read -p "  Max vidéos par chaîne : " playlist_end
            ;;
        q|Q) exit 0 ;;
    esac
done 