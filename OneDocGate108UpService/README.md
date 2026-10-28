# OneDocGate108UpService

Projet WINDEV 2025 de type **Service Windows 64 bits** chargé d'envoyer vers
NexAPI les fichiers JSON produits par Winlogie.

## Fonctionnement retenu

Le service ne dépend pas d'une fenêtre et n'utilise pas
`fSurveilleRépertoire`. À chaque cycle, il parcourt les fichiers `*.json` du
dossier configuré, les trie par nom et les traite séquentiellement. Cette
approche reprend naturellement les fichiers déposés pendant un arrêt ou un
plantage.

Un fichier n'est supprimé qu'après une réponse HTTP confirmant le succès de
l'opération :

- création : HTTP 201 ;
- modification : HTTP 200 ;
- suppression : HTTP 204 ;
- corrélation déjà absente lors d'une modification ou suppression : HTTP 404.

En cas d'erreur réseau, HTTP ou JSON, le fichier reste dans le dossier pour le
cycle suivant.

## Configuration

Copier `settings.ini.example` sous le nom `settings.ini` à côté de
l'exécutable. `settings.ini` est ignoré par Git.

```ini
[NEXAPI]
URI=https://onedoc-dev.nexapi.ch
AUTHORIZATION=BASE64_LOGIN_COLON_PASSWORD

[UP]
DIRECTORY=C:\Data\Public\OneDoc
INTERVAL_MS=1000
```

## Éléments WINDEV à créer

1. Créer un projet `OneDocGate108UpService` de type Service Windows 64 bits.
2. Ajouter une collection de procédures globales `COL_Service`.
3. Importer les procédures de `Procedures_Service.wl`.
4. Copier les trois blocs de `Code_Service.wl` dans les événements
   Initialisation, Exécution et Arrêt du service.
5. Compiler puis tester avec un JSON de développement.

## Validation attendue

- le service démarre sans interface utilisateur ;
- un JSON déjà présent au démarrage est traité ;
- un JSON ajouté pendant l'exécution est traité au cycle suivant ;
- un échec API conserve le fichier ;
- les traces ne contiennent jamais l'autorisation Basic Auth ni les données du
  patient.
