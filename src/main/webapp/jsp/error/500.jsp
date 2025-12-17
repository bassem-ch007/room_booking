<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>500 - Erreur Serveur</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Réservation de Salles</h1>
        </header>
        
        <main style="text-align: center; padding: 50px;">
            <h1 style="font-size: 72px; color: #e74c3c;">500</h1>
            <h2>Erreur Serveur</h2>
            <p>Une erreur s'est produite sur le serveur.</p>
            <%
                if (exception != null) {
            %>
                <p style="color: #666; font-size: 14px; margin-top: 20px;">
                    Message: <%= exception.getMessage() != null ? exception.getMessage() : "Erreur inconnue" %>
                </p>
            <%
                }
            %>
            <a href="${pageContext.request.contextPath}/" class="btn">Retour à l'accueil</a>
        </main>
    </div>
</body>
</html>

