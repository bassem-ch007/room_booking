<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon profil - BookingRoom</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">

<jsp:include page="/jsp/includes/header.jsp" />

<main class="flex-grow-1 py-5">
    <div class="container" style="max-width: 600px;">

        <h1 class="h3 mb-3">
            <i class="bi bi-person-circle"></i> Mon profil
        </h1>
        <p class="text-muted small mb-4">
            Gérez vos informations personnelles
        </p>

        <!-- Alerts -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i>
                    ${sessionScope.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                <c:set var="temp" value="${sessionScope.remove('success')}" />
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i>
                    ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                <c:set var="temp" value="${sessionScope.remove('error')}" />
            </div>
        </c:if>

        <div class="card shadow-sm">
            <div class="card-body">
                <form method="POST"
                      action="${pageContext.request.contextPath}/profile"
                      class="row g-3 needs-validation"
                      novalidate>

                    <!-- Nom d'utilisateur -->
                    <div class="col-12">
                        <label class="form-label">
                            Nom d'utilisateur <span class="text-danger">*</span>
                        </label>
                        <input type="text"
                               name="username"
                               class="form-control"
                               required
                               minlength="3"
                               value="${user.username}">
                        <div class="invalid-feedback">
                            Veuillez saisir un nom d'utilisateur (min. 3 caractères).
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="col-12">
                        <label class="form-label">
                            Email <span class="text-danger">*</span>
                        </label>
                        <input type="email"
                               name="email"
                               class="form-control"
                               required
                               value="${user.email}">
                        <div class="invalid-feedback">
                            Veuillez saisir une adresse email valide.
                        </div>
                    </div>

                    <!-- Rôle (lecture seule) -->
                    <div class="col-12">
                        <label class="form-label">Rôle</label>
                        <input type="text"
                               class="form-control"
                               disabled
                               value="${user.role == 'ADMIN' ? 'Administrateur' : 'Utilisateur'}">
                        <small class="text-muted">Votre rôle ne peut pas être modifié ici.</small>
                    </div>

                    <!-- Mot de passe -->
                    <div class="col-12">
                        <label class="form-label">
                            Mot de passe
                            <span class="small text-muted">(optionnel, laisser vide pour conserver l'actuel)</span>
                        </label>
                        <input type="password"
                               name="password"
                               class="form-control"
                               minlength="6">
                        <small class="text-muted">Min. 6 caractères</small>
                    </div>

                    <!-- Boutons -->
                    <div class="col-12 d-flex gap-2 mt-3">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-circle"></i> Enregistrer les modifications
                        </button>
                        <a href="${pageContext.request.contextPath}/rooms"
                           class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Retour
                        </a>
                    </div>

                </form>
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
