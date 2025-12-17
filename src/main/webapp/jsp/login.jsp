<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion - BookingRoom</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">

<jsp:include page="/jsp/includes/header.jsp" />

<main class="flex-grow-1 d-flex align-items-center justify-content-center py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12 col-md-8 col-lg-5">
                <div class="card shadow-sm">
                    <div class="card-body p-4 p-md-5">

                        <h1 class="h4 mb-3 text-center">
                            <i class="bi bi-box-arrow-in-right"></i> Connexion
                        </h1>
                        <p class="text-muted text-center mb-4">
                            Connectez-vous pour accéder à votre espace.
                        </p>

                        <!-- Alertes -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle"></i>
                                    ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Formulaire -->
                        <form method="POST" action="${pageContext.request.contextPath}/login" class="needs-validation" novalidate>
                            <!-- Email -->
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <input type="email"
                                           class="form-control"
                                           id="email"
                                           name="email"
                                           required
                                           value="${param.email}">
                                    <div class="invalid-feedback">
                                        Veuillez saisir une adresse email valide.
                                    </div>
                                </div>
                            </div>

                            <!-- Mot de passe -->
                            <div class="mb-3">
                                <label for="password" class="form-label">Mot de passe</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password"
                                           class="form-control"
                                           id="password"
                                           name="password"
                                           required minlength="4">
                                    <div class="invalid-feedback">
                                        Veuillez saisir votre mot de passe.
                                    </div>
                                </div>
                            </div>

                            <!-- Bouton -->
                            <div class="d-grid gap-2 mt-4 mb-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-box-arrow-in-right"></i> Se connecter
                                </button>
                            </div>

                            <!-- Lien inscription -->
                            <p class="text-center small mb-0">
                                Pas encore de compte ?
                                <a href="${pageContext.request.contextPath}/register">Créer un compte</a>
                            </p>
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/jsp/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html>
