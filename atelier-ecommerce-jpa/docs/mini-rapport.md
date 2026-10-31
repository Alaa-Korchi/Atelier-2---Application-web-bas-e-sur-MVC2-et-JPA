# Mini-rapport — E-commerce MVC 2 et JPA

Application pédagogique de gestion e-commerce : catalogue de produits, répertoire client, panier de session et historique des commandes.

## Architecture

Les JSP sous `src/main/webapp/WEB-INF/views` constituent les vues, les servlets les contrôleurs, et les entités/DAO forment le modèle et la couche de persistance. La configuration est basée sur Jakarta Servlet/JSP, EclipseLink JPA, MySQL et des transactions `RESOURCE_LOCAL`.

## Modèle métier

Un client peut posséder plusieurs commandes. Une commande référence un client et contient plusieurs lignes. Chaque ligne référence un produit et conserve une quantité ainsi qu’un prix unitaire. Les champs d’entités sont détaillés dans `docs/diagramme-classes.puml`.

## Fonctionnalités

`ClientServlet` gère le CRUD des clients, `ProduitServlet` le catalogue et son CRUD, `PanierServlet` les modifications du panier et la validation de commande, et `CommandeServlet` l’historique. Les formulaires et tables utilisent JSTL. Le détail de la refonte de l’interface et les points de vigilance sont documentés dans `docs/rapport-refonte-interface.md`.

## Vérification métier manuelle

Après préparation de la base, le parcours nominal à vérifier est : créer un client, créer un produit, l’ajouter au panier, ajuster la quantité, valider la commande et vérifier la commande, ses lignes et le stock décrémenté.

## Limites connues

La configuration EclipseLink actuelle a `eclipselink.ddl-generation=none`; le script SQL fourni crée la base, mais pas les tables. Une authentification, des autorisations, une protection CSRF, des tests automatisés et une représentation monétaire adaptée restent nécessaires avant un usage de production. Tomcat seul ne fournit pas CDI ni un `EntityManager` géré par conteneur.
