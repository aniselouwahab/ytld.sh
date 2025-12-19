
# AUTO-YTDLP PRO

Gestionnaire automatisé et interactif de téléchargements YouTube basé sur yt-dlp. Ce projet permet de suivre des chaînes YouTube et de télécharger automatiquement les nouvelles vidéos, avec une configuration simple via un menu en ligne de commande.

![image alt](https://github.com/aniselouwahab/ytld.sh/blob/507d0aebc5ee6e260eff995e32869636d1f60972/Capture%20d'%C3%A9cran%202025-12-18%20223013.png)

## Fonctionnalités
 Téléchargement automatique avec yt-dlp

  . Téléchargement des vidéos récentes (X derniers jours)

  . Dossier personnalisé par chaîne

  . Historique des vidéos déjà téléchargées (pas de doublons)

  . Interface interactive (menu CLI)

  . Paramètres modifiables à la volée

  . Installation système automatique

## Prérequis
  .Linux (Ubuntu / Debian recommandé)

  .Bash

  .Accès sudo

  .Connexion Internet

    -> yt-dlp est installé automatiquement si nécessaire.



## Installation
 ### 1️-Cloner le dépôt


```bash
 git clone https://github.com/aniselouwahab/ytld.sh.git
 cd ytld.sh
```

### 2-Corriger le format du script (IMPORTANT)
   Si le script a été modifié sous Windows, il faut corriger les fins de lignes :
  ```bash
 sudo apt install dos2unix -y
 dos2unix ytld.sh
```

### 3️-Rendre le script exécutable

```bash
 chmod +x ytld.sh
```

### 4️-Lancer le script

```bash
 ./ytld.sh
```

NB:

  -Au premier lancement, le script proposera une installation système :    Voulez-vous installer ce script dans votre système pour l'utiliser partout ? [Y/n]

  -Si vous acceptez :

     .le script est copié dans /usr/local/bin/auto-ytdlp
     .il devient accessible globalement avec :  auto-ytdlp 



# Utilisation
 ## 1-Menu principal

 [1] Lancer tous les téléchargements

[2] Ajouter une nouvelle chaîne

[3] Voir / Supprimer des chaînes

[4] Paramètres

[q] Quitter

 ## 2-Ajouter une chaîne

  Informations demandées :

   .Nom de la chaîne

   .URL (chaîne ou playlist YouTube)

   .Dossier de téléchargement (ex: ~/Videos/Youtube)

->Les chaînes sont stockées dans :  ~/.auto-ytdlp.conf


## 3-Téléchargements

  .Télécharge uniquement les vidéos récentes

  .Ignore les vidéos déjà téléchargées

  .Limite configurable du nombre de vidéos analysées

Chaque dossier contient : .archive qui Empêche le re-téléchargement des mêmes vidéos.

## 4-Paramètres

   .Nombre de jours à remonter

  .Nombre maximum de vidéos par chaîne

Configurables depuis le menu principal.


# Structure du projet

 ```bash
 Youtube/

├── ytld.sh

├── README.md

└── .gitattributes
```

```bash
~/.auto-ytdlp.conf
```

```bash
/usr/local/bin/auto-ytdlp
```

# Dépannage


```bash
Erreur : /bin/bash^M

Solution : dos2unix ytld.sh

Permission refusée: chmod +x ytld.sh
```
   
# Auteur

 Anis El Ouwahab

   GitHub : https://github.com/aniselouwahab

## License

[MIT](https://choosealicense.com/licenses/mit/)



  
