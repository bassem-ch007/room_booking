<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>404 - Page Non Trouvée</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <header>
            <h1>Réservation de Salles</h1>
        </header>
        
        <main style="text-align: center; padding: 50px;">
            <h1 style="font-size: 72px; color: #e74c3c;">404</h1>
            <h2>Page Non Trouvée</h2>
            <p>Désolé, la page que vous recherchez n'existe pas.</p>
            <a href="${pageContext.request.contextPath}/" class="btn">Retour à l'accueil</a>
        </main>
    </div>
</body>
</html>

