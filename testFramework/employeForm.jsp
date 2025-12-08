<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employé - Formulaire</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        label { display: block; margin-top: 10px; }
        input { width: 320px; padding: 6px; }
        button { margin-top: 12px; padding: 8px 12px; }
    </style>
</head>
<body>
<h1>Employé - Formulaire</h1>
<form action="/testFramework/employe/save" method="post">
    <label for="nom">Nom</label>
    <input type="text" id="nom" name="nom" />

    <label for="prenom">Prénom</label>
    <input type="text" id="prenom" name="prenom" />

    <label for="age">Âge</label>
    <input type="number" id="age" name="age" />

    <label for="poste">Poste</label>
    <input type="text" id="poste" name="poste" />

    <button type="submit">Enregistrer</button>
</form>
</body>
</html>
