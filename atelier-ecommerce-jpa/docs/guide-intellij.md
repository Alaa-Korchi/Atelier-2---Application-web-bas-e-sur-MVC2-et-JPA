# Déploiement IntelliJ IDEA Ultimate

1. Installer JDK 17+, Maven et Tomcat 10.1.x.
2. Ouvrir le dossier qui contient `pom.xml` et recharger le projet Maven.
3. Créer la base `ecommerce_jpa` avec `database/ecommerce_jpa.sql`, puis créer les tables attendues par les entités. Le script livré ne crée pas les tables et la génération EclipseLink est désactivée (`eclipselink.ddl-generation=none`).
4. Adapter les paramètres JDBC locaux dans `src/main/resources/META-INF/persistence.xml`.
5. Dans **Settings > Build, Execution, Deployment > Application Servers**, ajouter le serveur Tomcat 10.1.x.
6. Dans **Run > Edit Configurations**, créer une configuration **Tomcat Server > Local**.
7. Dans **Deployment**, ajouter `ecommerce-jpa:war exploded` et choisir le contexte `/ecommerce-jpa`.
8. Démarrer, puis ouvrir `http://localhost:8080/ecommerce-jpa/`.

Sous Windows, exécuter `bin\version.bat` pour vérifier la version de Tomcat.
