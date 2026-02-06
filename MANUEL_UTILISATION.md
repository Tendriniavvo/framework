# Manuel d'utilisation du Framework Java Web

Ce framework est une solution légère pour construire des applications web en Java, inspirée par le pattern MVC. Il utilise des annotations pour simplifier la gestion des routes, des paramètres et de la sécurité.

## Table des Matières
1. [Configuration](#configuration)
2. [Contrôleurs](#contrôleurs)
3. [Routage](#routage)
4. [Gestion des Paramètres](#gestion-des-paramètres)
5. [Upload de Fichiers](#upload-de-fichiers)
6. [Gestion de la Session](#gestion-de-la-session)
7. [Sécurité et Autorisation](#sécurité-et-autorisation)
8. [Vues et Réponses](#vues-et-réponses)
9. [Interaction avec une Base de Données](#interaction-avec-une-base-de-données)

---

## Configuration

### 1. Fichier `web.xml`
Vous devez configurer la `FrontServlet` comme dispatcher principal et le `ResourceFilter` pour gérer les fichiers statiques.

```xml
<filter>
    <filter-name>ResourceFilter</filter-name>
    <filter-class>framework.utilitaire.ResourceFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>ResourceFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>

<servlet>
    <servlet-name>FrontServlet</servlet-name>
    <servlet-class>framework.servlet.FrontServlet</servlet-class>
    <multipart-config>
        <location></location>
        <max-file-size>-1</max-file-size>
        <max-request-size>-1</max-request-size>
        <file-size-threshold>0</file-size-threshold>
    </multipart-config>
</servlet>
<servlet-mapping>
    <servlet-name>FrontServlet</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```

### 2. Fichier `config.properties`
Créez un fichier `config.properties` dans votre dossier `resources` pour spécifier le package de base à scanner.

```properties
base.package=com.votreprojet.controller
```

---

## Contrôleurs

Un contrôleur est une classe Java annotée avec `@Controller` ou `@RestController`.

- `@Controller` : Pour les méthodes retournant des vues (JSP).
- `@RestController` : Pour les méthodes retournant des données (JSON).

```java
@Controller
public class MonController {
    // ...
}
```

---

## Routage

Utilisez les annotations `@GetMapping` et `@PostMapping` sur les méthodes de vos contrôleurs.

```java
@GetMapping("/accueil")
public ModelAndView index() {
    return new ModelAndView("index.jsp");
}

@PostMapping("/valider")
public ModelAndView submit() {
    // ...
}
```

---

## Gestion des Paramètres

### 1. Paramètres simples (`@Param`)
Utilisez `@Param` pour lier un paramètre de requête HTTP à un argument de méthode.

```java
@GetMapping("/details")
public ModelAndView details(@Param("id") Integer id) {
    // ...
}
```

### 2. Objets (`@ModelAttribute`)
Utilisez `@ModelAttribute` pour lier automatiquement les paramètres de formulaire aux champs d'un objet.

```java
@PostMapping("/save")
public ModelAndView save(@ModelAttribute Client client) {
    // Les champs du formulaire (ex: nom, email) seront injectés dans l'objet client
}
```

---

## Upload de Fichiers

Le framework gère l'upload de fichiers via la classe `UploadedFile`.

```java
@PostMapping("/upload")
public ModelAndView handleUpload(@Param("photo") UploadedFile file) {
    byte[] content = file.getBytes();
    String fileName = file.getOriginalFilename();
    // Sauvegardez le fichier...
}
```

---

## Gestion de la Session

Vous pouvez accéder à la session en injectant un `Map` (ou `SessionMap`) annoté avec `@Session` dans les paramètres de votre méthode.

```java
@PostMapping("/login")
public String doLogin(@Session Map<String, Object> session) {
    session.put("user", "admin");
    return "success.jsp";
}
```

*Note : Le framework injecte automatiquement une instance de `SessionMap` qui encapsule la session HTTP.*

---

## Sécurité et Autorisation

Le framework propose une gestion simple des accès via `@Authorized` et `@Role`. Ces annotations peuvent être placées sur la **classe** (s'applique à toutes les méthodes) ou sur une **méthode** spécifique.

- `@Authorized` : Restreint l'accès aux utilisateurs connectés.
- `@Role({"ADMIN", "USER"})` : Restreint l'accès à un ou plusieurs rôles spécifiques.

```java
@Authorized
@Controller
public class AdminController {

    @Role("ADMIN")
    @GetMapping("/admin/dashboard")
    public ModelAndView dashboard() {
        // ...
    }
}
```

*Note : Configurez les noms des attributs de session dans `web.xml` via les paramètres de contexte `auth.session.attribute` (défaut: "user") et `role.session.attribute` (défaut: "role").*

---

## Injection de Dépendances Native

En plus des paramètres annotés, vous pouvez injecter directement les objets suivants dans vos méthodes de contrôleur :
- `HttpServletRequest`
- `HttpServletResponse`

```java
@GetMapping("/test")
public void test(HttpServletRequest request, HttpServletResponse response) {
    // Utilisation directe des objets Jakarta Servlet
}
```

---

## Vues et Réponses

### 1. ModelAndView
Utilisé pour renvoyer une JSP avec des données.

```java
ModelAndView mv = new ModelAndView("profil.jsp");
mv.addObject("nom", "Jean");
return mv;
```

### 2. JSON (`@RestController`)
Si le contrôleur est annoté avec `@RestController`, les objets retournés seront automatiquement convertis en JSON.

```java
@RestController
public class ApiController {
    @GetMapping("/api/data")
    public List<String> getData() {
        return Arrays.asList("A", "B", "C");
    }
}
```

---

## Exemple Complet

```java
package com.test.controller;

import framework.annotation.*;
import framework.utilitaire.ModelAndView;

@Controller
public class HelloController {

    @GetMapping("/hello")
    public ModelAndView sayHello(@Param("nom") String name) {
        ModelAndView mv = new ModelAndView("hello.jsp");
        mv.addObject("message", "Bonjour " + name);
        return mv;
    }
}
```

---

## Interaction avec une Base de Données

Ce framework est principalement un framework **Web/MVC** (gestion des routes, sessions, etc.). Il n'inclut pas d'ORM (comme Hibernate) par défaut, mais il est totalement compatible avec n'importe quelle bibliothèque d'accès aux données (JDBC, JPA, MyBatis).

### Exemple d'intégration avec JDBC
Vous pouvez effectuer vos opérations de base de données directement dans vos méthodes de contrôleur (ou mieux, dans des classes de service).

```java
@PostMapping("/client/ajouter")
public ModelAndView ajouterClient(@ModelAttribute Client client) {
    try (Connection conn = MyDbConnection.get()) {
        String sql = "INSERT INTO clients (nom, email) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, client.getNom());
            stmt.setString(2, client.getEmail());
            stmt.executeUpdate();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return new ModelAndView("success.jsp");
}
```
