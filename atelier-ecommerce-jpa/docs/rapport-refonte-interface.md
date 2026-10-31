# Rapport d’audit et de refonte de l’interface

**Projet :** Atelier Commerce — `atelier-ecommerce-jpa`  
**Périmètre :** audit des sources fournies, refonte des vues et de la feuille de style, amélioration de quelques interactions déjà présentes.  
**Date de l’audit :** 31 octobre 2026

## 1. Résultat en bref

L’application dispose maintenant d’une interface d’administration cohérente et responsive, construite sur le projet existant sans changer de framework. Les écrans produits, clients, panier et commandes partagent une navigation latérale, une barre de contexte, des formulaires structurés, des états vides, des retours de succès/erreur et des composants adaptés à leur contenu.

La refonte s’appuie uniquement sur le modèle et les routes présents dans le dépôt. Elle n’ajoute ni tableau de bord alimenté par des chiffres inventés, ni attribut métier, ni image de produit non disponible dans les entités.

Les actions destructives de suppression et les mises à jour du panier utilisent désormais des formulaires POST. Les suppressions demandent confirmation dans l’interface. Les écritures existantes restent reliées aux servlets et DAO; elles ne sont pas simulées côté navigateur.

## 2. Audit du projet fourni

### 2.1 Architecture technique

- Application Maven empaquetée en WAR.
- Java 17, Jakarta Servlet 6 et pages JSP avec JSTL 3.
- EclipseLink 4 et unité de persistance `ecommercePU` en transactions `RESOURCE_LOCAL`.
- Pilote MySQL Connector/J 8.4.
- Organisation MVC : vues dans `src/main/webapp/WEB-INF/views`, contrôleurs dans `ma.fstt.web`, entités dans `ma.fstt.model`, DAO dans `ma.fstt.dao`.
- La JSP d’accueil redirige vers `/produits`.

### 2.2 Modèle métier confirmé

| Entité | Champs identifiés | Relations |
|---|---|---|
| `Client` | `id`, `nom`, `email` | Un client possède zéro à plusieurs commandes; l’e-mail est unique et requis. |
| `Produit` | `id`, `nom`, `description`, `prix` (`double`), `stock` (`int`) | Référencé par les lignes de commande. |
| `Commande` | `id`, `dateCommande`, `statut` | Référence un client et contient ses lignes. |
| `LigneCommande` | `id`, `quantite`, `prixUnitaire` (`double`) | Référence une commande et un produit. |

Le diagramme PlantUML fourni confirme les cardinalités client–commande, commande–ligne et produit–ligne. Le modèle ne contient ni photo, ni catégorie, ni adresse, ni historique d’évolution des stocks.

### 2.3 Routes et fonctionnalités existantes

| Route | Fonction observée dans le code source |
|---|---|
| `/produits` | Liste et CRUD des produits. |
| `/clients` | Liste et CRUD des clients; suppression refusée si des commandes y sont associées. |
| `/panier` | Panier conservé en session, gestion des quantités et validation d’une commande avec contrôle du stock. |
| `/commandes` | Historique et lignes de commande, avec client et produit chargés par le DAO. |

Le projet ne contient pas de route de tableau de bord, d’authentification, de notification, de pagination serveur ou de catalogue d’images.

### 2.4 Points à surveiller relevés pendant l’audit

1. La configuration JPA définit `eclipselink.ddl-generation=none`, tandis que l’ancien README indiquait que les tables étaient générées automatiquement. Le script SQL fourni crée la base `ecommerce_jpa`, mais pas ses tables. Le schéma doit donc exister avant le démarrage.
2. `persistence.xml` contient une configuration JDBC locale (`root`, mot de passe vide). Elle n’est pas adaptée à un déploiement partagé ou en production.
3. Le projet ne comporte pas d’authentification, d’autorisation ni de protection CSRF.
4. Les prix utilisent `double`, ce qui n’est pas une représentation monétaire fiable pour un système comptable ou un paiement.
5. Aucun jeu de tests automatisés n’est fourni avec l’archive.

Ces limites ne sont pas masquées par des données de démonstration dans la nouvelle interface.

## 3. Direction visuelle appliquée

- Palette issue du brief : bleu nuit `#172554`, bleu d’action `#2563EB`, accent cyan `#06B6D4`, surfaces blanches, fond gris bleuté clair.
- Navigation latérale sombre avec indication de page active; barre supérieure et titres qui contextualisent chaque écran.
- Cartes et tableaux avec bordures discrètes, rayons réguliers, contrastes lisibles et espaces homogènes.
- Icônes SVG intégrées, sans dépendance externe ni ressource d’image distante.
- États de disponibilité fondés sur la valeur réelle de stock.
- Mise en page fluide pour écrans larges, tablettes et téléphones; menu latéral mobile et prise en compte de la préférence de réduction des animations.
- Focus clavier visible, lien d’accès direct au contenu et libellés explicites pour les champs et boutons.

Le nom « Atelier Commerce » sert uniquement à donner une identité à l’interface; les données métier et le schéma ne sont pas modifiés par ce libellé.

## 4. Modifications réalisées

### 4.1 Navigation et structure

- Ajout d’un gabarit JSP commun : `WEB-INF/views/partials/layout-top.jspf` et `layout-bottom.jspf`.
- Navigation pour les quatre routes métier existantes; indication visuelle de la page active.
- Menu mobile ouvrable et refermable au clavier ou par bouton, sans ajout de route fictive.
- Messages flash partagés pour les opérations réussies et les erreurs.

### 4.2 Produits

- Catalogue d’administration en cartes, avec nom, description, identifiant, prix et stock uniquement.
- Indicateurs calculés à partir de la liste chargée : nombre de références, somme des unités en stock et références à stock nul.
- Recherche locale sur les données déjà chargées et filtre « tout / en stock / épuisés ».
- Formulaire de création et de modification, avec champs et types liés à l’entité `Produit`.
- Ajout au panier relié à `/panier`; le bouton est désactivé pour les références dont le stock est nul.
- Suppression par POST avec confirmation. Une erreur de suppression est présentée au lieu d’être simulée.
- État vide explicite quand le catalogue n’a aucun produit.

### 4.3 Clients

- Répertoire tabulaire avec nom, e-mail et identifiant, recherche locale, liens e-mail et actions explicites.
- Formulaire de création/modification basé sur `nom` et `email`.
- Vérification serveur de présence des champs nom et e-mail; les contraintes d’unicité restent celles de la base.
- Suppression par POST avec confirmation; la règle du DAO qui interdit de supprimer un client ayant déjà des commandes est conservée.

### 4.4 Panier et commandes

- Panier lisible avec prix unitaire, quantité, sous-total par ligne et total estimé.
- Modification de quantité et retrait via POST; validation de commande toujours reliée au DAO et à son contrôle de stock.
- Association obligatoire de la commande à un client existant; lien vers la création d’un client lorsque la liste est vide.
- Historique présentant l’identifiant, le statut, le client, la date et les lignes; les totaux sont calculés à partir des quantités et prix unitaires présents.
- États vides adaptés aux paniers sans article et aux historiques sans commande.

### 4.5 Fichiers principaux

| Fichier | Rôle |
|---|---|
| `src/main/webapp/css/style.css` | Système visuel, composants, responsive et états de focus. |
| `src/main/webapp/js/app.js` | Recherche et filtre locaux, menu mobile, confirmation de suppression et état de soumission. |
| `src/main/webapp/WEB-INF/views/partials/layout-top.jspf` | En-tête, navigation et messages communs. |
| `src/main/webapp/WEB-INF/views/partials/layout-bottom.jspf` | Fermeture du gabarit et pied de page commun. |
| `src/main/webapp/WEB-INF/views/produits.jsp` | Catalogue, recherche/filtre, formulaire et actions produit. |
| `src/main/webapp/WEB-INF/views/clients.jsp` | Répertoire, recherche, formulaire et actions client. |
| `src/main/webapp/WEB-INF/views/panier.jsp` | Récapitulatif et validation du panier. |
| `src/main/webapp/WEB-INF/views/commandes.jsp` | Historique et détails des commandes. |
| `src/main/java/ma/fstt/web/ClientServlet.java` | Actions client, contrôles élémentaires et retours flash. |
| `src/main/java/ma/fstt/web/ProduitServlet.java` | Actions produit, vérification du prix/stock et calcul des indicateurs. |
| `src/main/java/ma/fstt/web/PanierServlet.java` | Lecture du panier et traitement POST des mutations et de la commande. |
| `README.md`, `docs/mini-rapport.md`, `docs/guide-intellij.md` | Instructions et descriptions corrigées selon la configuration réellement observée. |

## 5. Validation et limites de vérification

### Contrôles effectués

- Lecture des sources Java, JSP, CSS, du diagramme PlantUML, du `pom.xml`, du SQL et de la configuration JPA avant les changements.
- Contrôle de cohérence entre les champs rendus et les entités disponibles.
- Les formulaires écrivent vers les routes applicatives existantes; les suppressions et mutations du panier sont prises en charge par les nouvelles branches POST des servlets.
- Aucun nouvel endpoint métier, dépendance ou schéma de données n’a été introduit.
- Les textes provenant des données client/produit/commande continuent d’être rendus avec `<c:out>` dans les JSP.
- `mvn -f atelier-ecommerce-jpa/pom.xml clean package` : **BUILD SUCCESS**. Les classes Java ont été compilées avec OpenJDK 19.0.2 pour la cible Java 17 et le WAR `target/ecommerce-jpa.war` a été généré.
- `node --check src/main/webapp/js/app.js` : vérification syntaxique JavaScript réussie.
- Vérification de l’archive WAR : les quatre JSP, les deux fragments de gabarit, `css/style.css` et `js/app.js` sont présents.
- Aucun fichier de test automatisé n’est présent dans `src`.

### À confirmer au déploiement

- Déployer sur Tomcat 10.1 et vérifier le rendu de chaque route dans un navigateur.
- Tester le parcours avec une base MySQL dont les tables correspondent aux entités.
- Vérifier les erreurs attendues : doublon d’e-mail, suppression d’un client lié, stock insuffisant, accès MySQL indisponible.
- Contrôler l’affichage aux largeurs mobile, tablette et ordinateur.

La création du WAR ne compile pas nécessairement les JSP; le rendu réel doit être confirmé par Tomcat. Aucun accès à une base MySQL ou à un serveur Tomcat n’a été fourni dans l’archive. Le rapport ne prétend donc pas qu’un parcours navigateur ou une transaction en base a été exécuté.

## 6. Instructions de lancement

1. Installer JDK 17+, Maven et Tomcat 10.1.x.
2. Créer la base `ecommerce_jpa` en exécutant `database/ecommerce_jpa.sql`.
3. Créer les tables correspondant aux entités : la configuration JPA présente ne les crée pas automatiquement.
4. Adapter les paramètres locaux dans `src/main/resources/META-INF/persistence.xml`.
5. Lancer `mvn clean package`.
6. Déployer `target/ecommerce-jpa.war` sur Tomcat et ouvrir `/ecommerce-jpa/`.

## 7. Recommandations pour la suite

- Définir et versionner le schéma MySQL correspondant au diagramme, puis prévoir des migrations.
- Remplacer la configuration JDBC codée en dur par une configuration d’environnement appropriée.
- Ajouter authentification, contrôle d’accès par rôle et protection CSRF avant toute exposition publique.
- Remplacer `double` par `BigDecimal` pour les montants et couvrir ces calculs par des tests.
- Ajouter des tests d’intégration pour les opérations métier et un contrôle navigateur automatisé des parcours critiques.
- Ajouter la pagination seulement si le volume réel de clients, produits ou commandes le justifie.

## 8. Conclusion

La refonte améliore la hiérarchie de l’information, la navigation, la présentation des données et les retours d’interaction tout en conservant l’architecture Java/JSP/JPA fournie. Les fonctionnalités affichées correspondent aux opérations réellement présentes. Les limites de persistance et de sécurité, ainsi que les vérifications nécessitant Tomcat et MySQL, restent explicitement signalées pour éviter de présenter le projet comme prêt pour la production.
