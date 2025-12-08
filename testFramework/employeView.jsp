<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="testFramework.com.testframework.model.Employe" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employé - Détails</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .card { border: 1px solid #ddd; border-radius: 8px; padding: 16px; max-width: 500px; }
        .item { margin: 6px 0; }
        .label { font-weight: bold; }
    </style>
</head>
<body>
<%
    Employe emp = (Employe) request.getAttribute("emp");
%>
<h1>Employé - Détails</h1>
<% if (emp == null) { %>
    <p>Aucun employé fourni.</p>
<% } else { %>
    <div class="card">
        <div class="item"><span class="label">Nom:</span> <%= emp.getNom() %></div>
        <div class="item"><span class="label">Prénom:</span> <%= emp.getPrenom() %></div>
        <div class="item"><span class="label">Âge:</span> <%= emp.getAge() %></div>
        <div class="item"><span class="label">Poste:</span> <%= emp.getPoste() %></div>
    </div>
<% } %>
</body>
</html>
