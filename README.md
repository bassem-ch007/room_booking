# Application de Gestion et Réservation de Salles - Jakarta EE

Application web complète de gestion et réservation de salles développée avec Jakarta EE, JPA/Hibernate, PostgreSQL, et JSP/JSTL.

## Fonctionnalités

### Utilisateurs
- **Inscription/Connexion** avec authentification sécurisée (BCrypt)
- **Gestion des favoris** - Ajouter/retirer des salles favorites
- **Réservations** - Créer, consulter et annuler ses réservations

### Administrateurs
- **Gestion des utilisateurs** - CRUD complet
- **Gestion des salles** - CRUD avec upload d'images
- **Gestion des réservations** - Visualiser et annuler toutes les réservations
- **Tableau de bord** - Statistiques du système

### Fonctionnalités Avancées
- **Recherche avancée** avec filtres multiples (type, capacité, prix, localisation, disponibilité)
- **Autocomplétion** pour la localisation (villes tunisiennes)
- **Gestion des conflits** - Prévention des doubles réservations
- **Upload d'images** - Gestion des photos de salles avec redimensionnement

## Technologies

- **Jakarta EE 10** - Framework Java Enterprise
- **JPA/Hibernate 6.2** - ORM pour la persistance
- **PostgreSQL** - Base de données (MySQL également supporté)
- **JSP/JSTL** - Templates pour les vues
- **BCrypt** - Hashage des mots de passe
- **Maven** - Gestion des dépendances

## Prérequis

- Java 21+
- Maven 3.6+
- PostgreSQL 12+ (ou MySQL 8+)
- Serveur d'application Jakarta EE (Tomcat 10+, GlassFish, Payara)

## Installation

### 1. Cloner le projet

```bash
git clone <repository-url>
cd Booking-Room-jakarta/roombooking
```

### 2. Configurer la base de données

Créer une base de données PostgreSQL :

```sql
CREATE DATABASE room_booking;
```

Exécuter le script SQL d'initialisation :

```bash
psql -U postgres -d room_booking -f src/main/resources/database/schema.sql
```

### 3. Configurer la connexion à la base de données

Modifier `src/main/resources/META-INF/persistence.xml` avec vos paramètres :

```xml
<property name="jakarta.persistence.jdbc.url" 
          value="jdbc:postgresql://localhost:5432/room_booking"/>
<property name="jakarta.persistence.jdbc.user" 
          value="postgres"/>
<property name="jakarta.persistence.jdbc.password" 
          value="votre_mot_de_passe"/>
```

### 4. Compiler le projet

```bash
mvn clean package
```

Le fichier WAR sera généré dans `target/roombooking.war`

### 5. Déployer l'application

**Sur Tomcat :**
- Copier `target/roombooking.war` dans le répertoire `webapps` de Tomcat
- Démarrer Tomcat
- Accéder à `http://localhost:8080/roombooking`

**Sur GlassFish/Payara :**
```bash
asadmin deploy target/roombooking.war
```

## Comptes par défaut

Le script SQL crée des comptes de test :

**Administrateur :**
- Email: `admin@example.com`
- Mot de passe: `admin123` (doit être hashé avec BCrypt dans la base)

**Utilisateur :**
- Email: `user@example.com`
- Mot de passe: `user123` (doit être hashé avec BCrypt dans la base)

**Note:** Les mots de passe dans le script SQL sont des placeholders. Vous devez générer les hash BCrypt réels avant de les utiliser en production.

## Structure du projet

```
roombooking/
├── src/main/java/com/roombooking/
│   ├── controller/       # Servlets (contrôleurs)
│   ├── dao/             # Data Access Objects
│   ├── entity/          # Entités JPA
│   ├── exception/       # Exceptions personnalisées
│   ├── filter/          # Filtres (authentification, encoding)
│   ├── service/         # Services métier
│   └── util/            # Utilitaires
├── src/main/resources/
│   ├── META-INF/
│   │   └── persistence.xml  # Configuration JPA
│   └── database/
│       └── schema.sql       # Script SQL
└── src/main/webapp/
    ├── css/             # Feuilles de style
    ├── js/              # JavaScript
    ├── jsp/             # Pages JSP
    ├── images/          # Images statiques
    └── WEB-INF/
        └── web.xml      # Configuration web
```

## Fonctionnalités de sécurité

- **Hashage des mots de passe** avec BCrypt (12 rounds)
- **Filtre d'authentification** pour protéger les pages
- **Validation des entrées** côté serveur et client
- **Protection CSRF** (à implémenter en production)
- **Gestion des sessions** avec timeout

## Fonctionnalités originales

1. **Système de favoris** - Les utilisateurs peuvent marquer leurs salles préférées
2. **Recherche avancée** avec autocomplétion pour la localisation
3. **Gestion des conflits** automatique - Prévention des doubles réservations au niveau base de données et service

## Notes importantes

- Le répertoire d'upload des images est défini dans `ImageUploadService` (par défaut: `~/roombooking/uploads/`)
- Les images sont redimensionnées automatiquement lors de l'upload
- La contrainte d'exclusion PostgreSQL nécessite l'extension `btree_gist`
- En production, configurez un pool de connexions approprié dans `persistence.xml`

## Licence

Ce projet est développé dans le cadre d'un projet académique.

## Support

Pour toute question ou problème, veuillez consulter la documentation ou créer une issue dans le dépôt.

