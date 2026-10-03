# Sentinelle Mali

Application mobile de protection citoyenne contre les fraudes, les faux agents Mobile Money et le phishing au Mali. Conçue selon le principe de **minimisation stricte des données**, Sentinelle Mali effectue toutes ses analyses directement sur l'appareil de l'utilisateur, même hors-ligne, sans jamais envoyer de données personnelles sans accord explicite.

---

## Fonctionnalités Clés

- **Moteur d'analyse locale multi-vecteurs** :
  - **SMS & Messages** : Détection des arnaques de faux gains, fausses tombolas et intimidations.
  - **Liens & Phishing** : Analyse heuristique des domaines suspects et faux sites institutionnels.
  - **Numéros de téléphone** : Vérification des numéros signalés dans la communauté.
  - **Mobile Money** : Questionnaire guidé pour détecter les arnaques d'agents fraudeurs (Orange Money, Moov Money, Wave).
- **Alerte d'urgence plein écran (STOP !)** :
  - Avertissement visuel immédiat en cas de demande frauduleuse de code PIN, OTP ou mot de passe.
- **Support vocal bilingue (Français & Bamanankan)** :
  - Écoute à voix haute des verdicts et des fiches réflexes en Bambara pour une accessibilité maximale.
- **Guide des victimes & Fiches d'arnaques** :
  - Fiches pratiques détaillées avec numéros d'urgence officiels (Orange 133, Moov 133, Wave *115#).
  - Mini-quiz interactif pour tester ses réflexes face aux arnaques.
- **Signalement anonyme & communautaire** :
  - Permet aux citoyens de signaler les tentatives de fraude pour enrichir la base de règles.
- **Protection de la vie privée (Privacy by Design)** :
  - Zéro télémétrie invasive.
  - Historique stocké localement avec possibilité d'effacement ou d'export chiffré.

---

## Architecture du Projet

```text
lib/
├── data/              # Données statiques (quiz, fiches d'arnaques)
├── models/            # Modèles métier (résultats d'analyse, guides, signalements)
├── providers/         # Gestion d'état réactive (AppState via Provider)
├── screens/
│   ├── analyze/       # Écrans d'analyse, radar de scan et résultats (jauge + modale STOP)
│   ├── guide/         # Guide victime, arnaques courantes, données personnelles, mini-quiz
│   ├── profile/       # Paramètres, règles de détection, confidentialité et signalements
│   ├── report/        # Tunnel de signalement citoyen et confirmation
│   ├── access_screen.dart        # Écran d'accueil/accès (connexion, inscription, sans compte)
│   ├── history_screen.dart       # Historique des analyses avec filtres et recherche
│   ├── home_screen.dart          # Tableau de bord principal avec alertes récentes
│   ├── language_screen.dart      # Sélection de la langue (FR / BM)
│   ├── login_screen.dart         # Page de connexion
│   ├── main_screen.dart          # Conteneur principal avec barre de navigation personnalisée
│   ├── onboarding_screen.dart    # 4 étapes d'accueil et sensibilisation
│   ├── permissions_screen.dart   # Demande transparente des autorisations
│   ├── register_screen.dart      # Page de création de compte
│   └── splash_screen.dart        # Écran de démarrage avec emblème Djenné
├── theme/             # Charte graphique (Couleurs Sahel / Mali, typographie)
└── widgets/           # Composants réutilisables (BottomNav, jauges, logo Djenné)
```

---

## Démarrage Rapide

### Prérequis
- Flutter SDK (3.x ou supérieur)
- Dart SDK
- Android Studio / VS Code / Antigravity IDE

### Installation et exécution

```bash
# Cloner le dépôt
git clone https://github.com/amasbarry223/sentinelle_mobile-.git
cd sentinelle_mobile-

# Récupérer les dépendances
flutter pub get

# Lancer sur Chrome (Web)
flutter run -d chrome

# Lancer sur appareil Android
flutter run -d android
```

---

## Licence

Projet développé pour la protection citoyenne au Mali.
