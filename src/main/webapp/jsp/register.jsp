<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inscription - BookingRoom</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">

<jsp:include page="/jsp/includes/header.jsp" />

<main class="flex-grow-1 d-flex align-items-center justify-content-center py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                <div class="card shadow-sm">
                    <div class="card-body p-4 p-md-5">

                        <h1 class="h4 mb-3 text-center">
                            <i class="bi bi-person-plus"></i> Inscription
                        </h1>
                        <p class="text-muted text-center mb-4">
                            Créez un compte pour réserver des salles.
                        </p>

                        <!-- Alertes -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle"></i>
                                    ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-check-circle"></i>
                                    ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Formulaire -->
                        <form method="POST" action="${pageContext.request.contextPath}/register" class="needs-validation" novalidate>
                            <!-- Nom d'utilisateur -->
                            <div class="mb-3">
                                <label for="username" class="form-label">Nom d'utilisateur</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text"
                                           class="form-control"
                                           id="username"
                                           name="username"
                                           required minlength="3"
                                           value="${param.username}">
                                    <div class="invalid-feedback">
                                        Veuillez saisir un nom d'utilisateur (min. 3 caractères).
                                    </div>
                                </div>
                            </div>

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
                                           required minlength="6">
                                    <div class="invalid-feedback">
                                        Mot de passe requis (min. 6 caractères).
                                    </div>
                                </div>
                            </div>

                            <!-- Confirmation mot de passe (optionnel côté serveur) -->
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirmer le mot de passe</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                                    <input type="password"
                                           class="form-control"
                                           id="confirmPassword"
                                           name="confirmPassword"
                                           required minlength="6">
                                    <div class="invalid-feedback">
                                        Veuillez confirmer votre mot de passe.
                                    </div>
                                </div>
                            </div>

                            <!-- Bouton -->
                            <div class="d-grid gap-2 mt-4 mb-2">
                                <button type="submit" class="btn btn-success">
                                    <i class="bi bi-person-plus"></i> Créer mon compte
                                </button>
                            </div>

                            <!-- Lien connexion -->
                            <p class="text-center small mb-0">
                                Vous avez déjà un compte ?
                                <a href="${pageContext.request.contextPath}/login">Se connecter</a>
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
