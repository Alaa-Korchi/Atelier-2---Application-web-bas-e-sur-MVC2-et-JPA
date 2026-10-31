# Atelier Commerce — E-commerce MVC 2 + JPA

Projet pédagogique Maven WAR construit avec Java 17, Jakarta Servlet, JSP/JSTL, EclipseLink JPA et MySQL. L’interface d’administration a été refondue pour les quatre parcours présents dans le code : produits, clients, panier et historique des commandes.

## Compatibilité

- JDK 17 ou supérieur.
- Maven 3.8 ou supérieur.
- Tomcat 10.1.x (Servlet 6, packages `jakarta.*`). Tomcat 9, basé sur `javax.*`, n’est pas compatible.
- MySQL compatible avec le pilote Connector/J 8.4 fourni par Maven.

## Préparer la base

1. Exécuter `database/ecommerce_jpa.sql` pour créer la base `ecommerce_jpa`.
2. Créer les tables attendues par les entités avant de démarrer l’application.
3. Vérifier les paramètres JDBC dans `src/main/resources/META-INF/persistence.xml` et les adapter à l’environnement local.

> Le script SQL fourni crée uniquement la base. La configuration EclipseLink actuelle utilise `eclipselink.ddl-generation=none` : elle ne génère donc pas les tables. Le README d’origine indiquait une génération automatique, mais ce n’est pas ce que fait la configuration présente dans le projet.

## Construire et lancer

```bash
mvn clean package
```

Déployer `target/ecommerce-jpa.war` dans Tomcat 10.1.x. Avec le contexte `/ecommerce-jpa`, l’application est accessible à `http://localhost:8080/ecommerce-jpa/`.

Dans IntelliJ IDEA Ultimate, ouvrir le dossier du `pom.xml`, recharger Maven, configurer un serveur Tomcat 10.1 et déployer l’artefact `ecommerce-jpa:war exploded`.

## Parcours existants

- **Produits** : création, modification, suppression, recherche locale, filtre de stock et ajout au panier.
- **Clients** : création, modification, suppression et recherche locale. Un client déjà lié à une commande ne peut pas être supprimé.
- **Panier** : panier de session, modification des quantités, retrait d’articles, sélection du client et validation de commande avec vérification du stock.
- **Commandes** : consultation de l’historique et du détail des lignes.

Les recherches et filtres de l’interface opèrent sur les résultats déjà chargés. Le projet ne contient pas de pagination serveur, d’authentification, de notifications, de tableau de bord métier ni d’images de produits.

## Configuration et limites de sécurité

Tomcat est un conteneur Servlet, pas un serveur Jakarta EE complet : ce projet utilise une `EntityManagerFactory` partagée et des transactions `RESOURCE_LOCAL`. Il n’emploie pas CDI `@Inject` ni `@PersistenceContext`.

La configuration JDBC actuelle est locale et doit être adaptée avant tout partage ou déploiement : elle indique `root` et un mot de passe vide dans `persistence.xml`. L’application n’intègre pas encore d’authentification, d’autorisation ni de jeton CSRF. Les prix sont stockés en `double` dans les entités existantes ; un système de paiement ou un usage comptable nécessiterait un modèle monétaire adapté (`BigDecimal`) et des tests complémentaires.

Le détail de l’audit et de la refonte se trouve dans [`docs/rapport-refonte-interface.md`](docs/rapport-refonte-interface.md).
