# Documentation des Vues - Application de Réservation de Salles

Ce document décrit toutes les vues (pages JSP) de l'application de gestion et réservation de salles.

## Structure des Répertoires

```
webapp/
├── index.jsp                    # Page d'accueil
├── jsp/
│   ├── login.jsp               # Page de connexion
│   ├── register.jsp            # Page d'inscription
│   ├── rooms/                  # Pages liées aux salles
│   │   ├── list.jsp           # Liste des salles
│   │   ├── details.jsp        # Détails d'une salle
│   │   └── search.jsp         # Recherche avancée
│   ├── reservations/           # Pages liées aux réservations
│   │   ├── create.jsp         # Créer une réservation
│   │   └── myReservations.jsp # Mes réservations
│   ├── favorites/              # Pages liées aux favoris
│   │   └── list.jsp           # Liste des favoris
│   ├── admin/                  # Pages d'administration
│   │   ├── dashboard.jsp      # Tableau de bord admin
│   │   ├── users.jsp          # Gestion des utilisateurs
│   │   ├── rooms.jsp          # Gestion des salles
│   │   ├── roomForm.jsp       # Formulaire salle (créer/modifier)
│   │   └── reservations.jsp   # Gestion des réservations
│   └── error/                  # Pages d'erreur
│       ├── 404.jsp            # Page non trouvée
│       └── 500.jsp            # Erreur serveur
├── css/
│   └── style.css              # Feuille de style principale
├── js/
│   ├── validation.js          # Validation côté client
│   └── autocomplete.js        # Autocomplétion localisation
└── images/                     # Images statiques
```

---

## Pages Publiques

### `index.jsp`
**URL:** `/`  
**Accès:** Public  
**Description:** Page d'accueil de l'application

**Fonctionnalités:**
- Redirection automatique selon le rôle (Admin → Dashboard, User → Liste des salles)
- Navigation conditionnelle selon l'état de connexion
- Boutons d'actions rapides personnalisés selon le rôle

**Affichage conditionnel:**
- Si **connecté en tant qu'admin**: Liens vers gestion utilisateurs, salles, réservations
- Si **connecté en tant qu'utilisateur**: Liens vers réservations, favoris, liste des salles
- Si **non connecté**: Liens vers connexion et inscription

---

### `jsp/login.jsp`
**URL:** `/login`  
**Accès:** Public (redirige si déjà connecté)  
**Description:** Page de connexion

**Fonctionnalités:**
- Formulaire de connexion (email + mot de passe)
- Validation côté client
- Affichage des messages d'erreur
- Lien vers la page d'inscription
- Redirection automatique après connexion selon le rôle

**Champs:**
- Email (requis)
- Mot de passe (requis)

---

### `jsp/register.jsp`
**URL:** `/register`  
**Accès:** Public  
**Description:** Page d'inscription

**Fonctionnalités:**
- Formulaire d'inscription avec validation
- Validation JavaScript côté client (confirmation mot de passe, longueur minimale)
- Validation serveur (unicité email/username)
- Messages d'erreur détaillés
- Redirection vers login après inscription réussie

**Champs:**
- Nom d'utilisateur (minimum 5 caractères, requis)
- Email (format valide, requis)
- Mot de passe (minimum 8 caractères, requis)
- Confirmation mot de passe (requis)

---

## Pages Utilisateur - Salles

### `jsp/rooms/list.jsp`
**URL:** `/rooms`  
**Accès:** Public (fonctionnalités favoris pour utilisateurs connectés)  
**Description:** Liste de toutes les salles disponibles

**Fonctionnalités:**
- Affichage en grille (cartes) de toutes les salles actives
- Informations affichées: nom, type, capacité, taille, prix, localisation
- Image de la salle (ou image par défaut)
- Bouton "Voir détails" pour chaque salle
- Ajout/retrait des favoris (si connecté)
- Lien vers la recherche avancée

**Données affichées:**
- Photo de la salle (thumbnail 300x200px)
- Nom et type de salle
- Capacité (nombre de personnes)
- Taille en m²
- Prix en euros
- Localisation

---

### `jsp/rooms/details.jsp`
**URL:** `/rooms/details/{id}`  
**Accès:** Public (fonctionnalités favoris pour utilisateurs connectés)  
**Description:** Détails complets d'une salle

**Fonctionnalités:**
- Affichage de l'image haute résolution (800x600px)
- Toutes les informations de la salle
- Bouton "Réserver maintenant" (si connecté et salle active)
- Ajout/retrait des favoris
- Navigation vers la liste des salles

**Données affichées:**
- Image haute résolution
- Type de salle
- Capacité
- Taille (m²)
- Prix
- Localisation
- Statut (ACTIVE/INACTIVE)

---

### `jsp/rooms/search.jsp`
**URL:** `/rooms/search`  
**Accès:** Public  
**Description:** Recherche avancée de salles avec filtres multiples

**Fonctionnalités:**
- Formulaire de recherche avec plusieurs critères optionnels
- Autocomplétion pour la localisation (villes tunisiennes)
- Filtres disponibles:
  - Type de salle (dropdown)
  - Capacité minimale
  - Taille minimale (m²)
  - Fourchette de prix (min/max)
  - Localisation (avec autocomplétion)
  - Disponibilité (date/heure début et fin)
- Affichage des résultats en grille (même format que list.jsp)
- Bouton de réinitialisation

**Critères de recherche (tous optionnels):**
- Type: BANQUET_HALL, EVENT_HALL, WEDDING_HALL
- Capacité minimale: Entier
- Taille minimale: Nombre décimal (m²)
- Prix min/max: Nombre décimal (€)
- Localisation: Texte avec autocomplétion
- Disponibilité: DateTime picker (début et fin)

---

## Pages Utilisateur - Réservations

### `jsp/reservations/create.jsp`
**URL:** `/reservations/create?roomId={id}`  
**Accès:** Utilisateurs connectés  
**Description:** Formulaire de création de réservation

**Fonctionnalités:**
- Formulaire simple avec date/heure de début et fin
- Validation des dates (début < fin, pas dans le passé)
- ID de la salle pré-rempli (paramètre)
- Messages d'erreur si conflit ou validation échoue
- Redirection vers "Mes réservations" après succès

**Champs:**
- Salle (pré-rempli, non modifiable)
- Date et heure de début (datetime-local, requis)
- Date et heure de fin (datetime-local, requis)

**Validations:**
- Vérification de disponibilité en temps réel
- Prévention des doubles réservations
- Vérification que l'utilisateur n'a pas déjà une réservation au même créneau

---

### `jsp/reservations/myReservations.jsp`
**URL:** `/reservations`  
**Accès:** Utilisateurs connectés  
**Description:** Liste des réservations de l'utilisateur connecté

**Fonctionnalités:**
- Affichage de toutes les réservations de l'utilisateur
- Tableau avec colonnes: Salle, Date début, Date fin, Statut, Actions
- Bouton d'annulation pour les réservations futures avec statut APPROVED
- Messages de succès/erreur
- Tri par date (plus récentes en premier)

**Colonnes:**
- Nom de la salle
- Date et heure de début
- Date et heure de fin
- Statut (APPROVED, CANCELLED, CLIENT_CANCELLED)
- Actions (Annuler si possible)

**Règles:**
- Les réservations passées ne peuvent pas être annulées
- Seules les réservations APPROVED peuvent être annulées par l'utilisateur
- Les réservations annulées affichent leur statut

---

## Pages Utilisateur - Favoris

### `jsp/favorites/list.jsp`
**URL:** `/favorites`  
**Accès:** Utilisateurs connectés  
**Description:** Liste des salles favorites de l'utilisateur

**Fonctionnalités:**
- Affichage en grille de toutes les salles favorites
- Même format d'affichage que la liste des salles
- Bouton "Voir détails" pour chaque salle
- Bouton "Réserver" pour réserver directement depuis les favoris
- Bouton "Retirer des favoris" pour chaque salle
- Message si aucun favori

**Actions disponibles:**
- Voir les détails
- Réserver la salle
- Retirer des favoris

---

## Pages Administration

### `jsp/admin/dashboard.jsp`
**URL:** `/admin/dashboard`  
**Accès:** Administrateurs uniquement  
**Description:** Tableau de bord administratif

**Fonctionnalités:**
- Statistiques globales du système
- Cartes de statistiques: nombre d'utilisateurs, salles, réservations
- Liste des réservations récentes (10 dernières)
- Navigation rapide vers les sections d'administration

**Statistiques affichées:**
- Nombre total d'utilisateurs
- Nombre total de salles
- Nombre total de réservations
- Liste des réservations récentes avec détails

---

### `jsp/admin/users.jsp`
**URL:** `/admin/users`  
**Accès:** Administrateurs uniquement  
**Description:** Gestion des utilisateurs (liste)

**Fonctionnalités:**
- Tableau listant tous les utilisateurs
- Colonnes: ID, Nom d'utilisateur, Email, Rôle, Actions
- Bouton "Créer un utilisateur"
- Actions: Modifier, Supprimer
- Messages d'erreur si nécessaire

**Actions:**
- Créer un nouvel utilisateur
- Modifier un utilisateur existant
- Supprimer un utilisateur (avec confirmation)

---

### `jsp/admin/roomForm.jsp`
**URL:** `/admin/rooms/create` ou `/admin/rooms/edit/{id}`  
**Accès:** Administrateurs uniquement  
**Description:** Formulaire de création/modification de salle

**Fonctionnalités:**
- Formulaire réutilisable pour créer et modifier
- Tous les champs de la salle modifiables
- Upload d'image (optionnel)
- Prévisualisation de l'image actuelle lors de modification
- Validation des champs
- Statut modifiable uniquement en édition

**Champs:**
- Type de salle (dropdown, requis)
- Nom (texte, requis, unique)
- Capacité (nombre, min 1, requis)
- Taille en m² (décimal, requis)
- Localisation (texte, requis)
- Prix en euros (décimal, requis)
- Statut ACTIVE/INACTIVE (uniquement en édition)
- Image (fichier, optionnel, formats: jpg, png, webp, max 5MB)

**Comportement:**
- En création: tous les champs sont vides sauf statut (ACTIVE par défaut)
- En modification: tous les champs sont pré-remplis avec les valeurs actuelles
- L'image actuelle est affichée lors de la modification

---

### `jsp/admin/rooms.jsp`
**URL:** `/admin/rooms`  
**Accès:** Administrateurs uniquement  
**Description:** Gestion des salles (liste)

**Fonctionnalités:**
- Tableau listant toutes les salles
- Colonnes: ID, Nom, Type, Capacité, Taille, Prix, Localisation, Statut, Actions
- Bouton "Créer une salle"
- Actions: Modifier, Supprimer
- Affichage du statut (ACTIVE/INACTIVE)

**Actions:**
- Créer une nouvelle salle
- Modifier une salle existante
- Supprimer une salle (annule les réservations futures)

---

### `jsp/admin/reservations.jsp`
**URL:** `/admin/reservations`  
**Accès:** Administrateurs uniquement  
**Description:** Gestion de toutes les réservations du système

**Fonctionnalités:**
- Tableau listant toutes les réservations
- Colonnes: ID, Utilisateur, Salle, Date début, Date fin, Statut, Actions
- Bouton d'annulation pour les réservations APPROVED
- Tri par date (plus récentes en premier)

**Actions:**
- Voir toutes les réservations
- Annuler n'importe quelle réservation (statut → CANCELLED)

---

## Pages d'Erreur

### `jsp/error/404.jsp`
**URL:** Automatique pour les erreurs 404  
**Accès:** Public  
**Description:** Page d'erreur "Page non trouvée"

**Fonctionnalités:**
- Message d'erreur explicite
- Code d'erreur 404 affiché
- Bouton de retour à l'accueil
- Design cohérent avec le reste de l'application

---

### `jsp/error/500.jsp`
**URL:** Automatique pour les erreurs 500  
**Accès:** Public  
**Description:** Page d'erreur "Erreur serveur"

**Fonctionnalités:**
- Message d'erreur générique
- Code d'erreur 500 affiché
- Affichage du message d'exception (si disponible)
- Bouton de retour à l'accueil
- Design cohérent avec le reste de l'application

---

## Ressources Statiques

### `css/style.css`
**Description:** Feuille de style principale de l'application

**Contenu:**
- Styles globaux (reset, typographie)
- Layout et grilles
- Composants (boutons, formulaires, cartes)
- Styles pour tableaux
- Styles pour alertes (succès, erreur)
- Styles responsive (grille adaptative)
- Styles pour navigation
- Styles pour cartes de salles
- Styles pour autocomplétion

**Classes principales:**
- `.container` - Conteneur principal
- `.btn`, `.btn-primary`, `.btn-danger` - Boutons
- `.form-container`, `.form-group` - Formulaires
- `.alert`, `.alert-error`, `.alert-success` - Messages
- `.room-grid`, `.room-card` - Affichage des salles
- `.search-form` - Formulaire de recherche

---

### `js/validation.js`
**Description:** Scripts de validation côté client

**Fonctionnalités:**
- Validation du formulaire d'inscription
- Vérification de la correspondance des mots de passe
- Vérification de la longueur minimale des champs
- Prévention de la soumission si validation échoue

---

### `js/autocomplete.js`
**Description:** Script d'autocomplétion pour la localisation

**Fonctionnalités:**
- Autocomplétion lors de la saisie de localisation
- Liste des villes tunisiennes prédéfinies:
  - Tunis, Ariana, Ben Arous, Manouba
  - Sousse, Sfax, Gabès, Bizerte
  - Nabeul, Kairouan
- Affichage dynamique des suggestions
- Sélection par clic
- Fermeture automatique au clic extérieur

---

## Technologies Utilisées

### JSP/JSTL
- **JSTL Core** (`<c:if>`, `<c:forEach>`, `<c:set>`)
- **JSTL Format** (`<fmt:formatNumber>`, `<fmt:formatDate>`)
- **Expression Language (EL)** pour l'accès aux données

### CSS
- CSS Grid pour les layouts
- Flexbox pour les alignements
- Media queries pour le responsive (via grid auto-fill)

### JavaScript
- Vanilla JavaScript (pas de frameworks)
- DOM manipulation pour l'autocomplétion
- Event listeners pour la validation

---

## Flux de Navigation

### Utilisateur Non Connecté
```
index.jsp → login.jsp → (après connexion) → rooms/list.jsp
          → register.jsp → login.jsp
          → rooms/list.jsp
          → rooms/details.jsp
          → rooms/search.jsp
```

### Utilisateur Connecté
```
index.jsp → rooms/list.jsp
         → rooms/details.jsp → reservations/create.jsp
         → rooms/search.jsp
         → reservations/myReservations.jsp
         → favorites/list.jsp
```

### Administrateur
```
index.jsp → admin/dashboard.jsp
         → admin/users.jsp → (créer/modifier)
         → admin/rooms.jsp → admin/roomForm.jsp
         → admin/reservations.jsp
```

---

## Variables de Session Utilisées

Les vues utilisent les attributs de session suivants:

- `sessionScope.user` - Objet User complet
- `sessionScope.userId` - ID de l'utilisateur (Long)
- `sessionScope.userRole` - Rôle de l'utilisateur (String: "ADMIN" ou "USER")

---

## Attributs de Requête Courants

Les pages reçoivent généralement ces attributs de requête:

- `error` - Message d'erreur (String)
- `success` - Message de succès (String)
- `rooms` - Liste des salles (List<Room>)
- `room` - Une salle (Room)
- `reservations` - Liste des réservations (List<Reservation>)
- `reservation` - Une réservation (Reservation)
- `favorites` - Liste des favoris (List<Room>)
- `users` - Liste des utilisateurs (List<User>)
- `user` - Un utilisateur (User)
- `totalUsers`, `totalRooms`, `totalReservations` - Statistiques (Integer)
- `recentReservations` - Réservations récentes (List<Reservation>)
- `isFavorite` - Si une salle est en favoris (Boolean)
- `searchPerformed` - Si une recherche a été effectuée (Boolean)

---

## Notes Importantes

1. **Sécurité:** Les pages d'administration sont protégées par `AuthFilter` qui vérifie le rôle ADMIN.

2. **Images:** 
   - Les images sont servies via `RoomImageServlet` à l'URL `/uploads/*`
   - Les images manquantes utilisent `/images/default-room.jpg` (fallback via `onerror`)

3. **Format de Dates:**
   - Les dates sont formatées pour l'affichage en français (dd/MM/yyyy HH:mm)
   - Les inputs utilisent `datetime-local` pour les réservations

4. **Responsive:**
   - Les grilles utilisent `grid-template-columns: repeat(auto-fill, minmax(300px, 1fr))`
   - Adaptation automatique selon la largeur d'écran

5. **Validation:**
   - Validation côté client (JavaScript) pour une meilleure UX
   - Validation côté serveur (Java) pour la sécurité

---

## Améliorations Futures Possibles

- Pagination pour les listes longues
- Tri et filtrage avancés dans les tableaux admin
- Prévisualisation d'image avant upload
- Calendrier visuel pour les disponibilités
- Notifications en temps réel
- Export PDF des réservations
- Interface mobile optimisée

---

**Dernière mise à jour:** 2024

