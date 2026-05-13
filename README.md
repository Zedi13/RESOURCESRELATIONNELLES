# (RE)Sources Relationnelles

Plateforme de ressources relationnelles — application Flutter mobile + API REST Spring Boot.

---

## Lancer l'API Spring Boot

### Prérequis

- [Java 17+](https://adoptium.net/)
- [Maven 3.8+](https://maven.apache.org/download.cgi) (ou utiliser le wrapper `mvnw`)
- [WAMP](https://www.wampserver.com/) (ou tout serveur MySQL local)
- [Postman](https://www.postman.com/) ou [Swagger UI](http://localhost:8080/swagger-ui.html) pour tester

---

### 1. Créer la base de données

Ouvre phpMyAdmin (`http://localhost/phpmyadmin`) et exécute dans l'ordre :

1. `api/docs/schema.sql` — crée la base et les tables
2. `api/docs/seed_data.sql` — insère les données de test

---

### 2. Configurer la connexion

Ouvre `api/src/main/resources/application.properties` et vérifie :

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/ressources_relationnelles
spring.datasource.username=root
spring.datasource.password=
```

Adapte `username` et `password` selon ta config WAMP (par défaut : `root` / mot de passe vide).

---

### 3. Lancer l'API

```bash
cd api
mvn spring-boot:run
```

L'API démarre sur `http://localhost:8080`.  
Au premier démarrage, les mots de passe des utilisateurs de test sont automatiquement initialisés.

---

### 4. Tester avec Swagger

Ouvre `http://localhost:8080/swagger-ui.html` dans ton navigateur.

**Se connecter :**

1. `POST /api/auth/login` avec :
   ```json
   {
     "email": "admin@ressources-relationnelles.fr",
     "motDePasse": "Admin@2025"
   }
   ```
2. Copie le `token` de la réponse
3. Clique sur **Authorize** (cadenas en haut à droite)
4. Colle le token et valide

Tu peux maintenant tester tous les endpoints authentifiés.

---

### Comptes de test

| Email | Mot de passe | Rôle |
|-------|-------------|------|
| admin@ressources-relationnelles.fr | Admin@2025 | admin |
| moderateur@ressources-relationnelles.fr | password123 | moderateur |
| sophie.bernard@email.fr | password123 | citoyen |
| lucas.petit@email.fr | password123 | citoyen |

---

## Application Flutter

```bash
flutter pub get
flutter run
```

- [Documentation Flutter](https://docs.flutter.dev/)
