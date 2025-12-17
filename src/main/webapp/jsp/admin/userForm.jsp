<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>
        Admin –
        <c:choose>
            <c:when test="${usern == null}">Créer un utilisateur</c:when>
            <c:otherwise>Modifier un utilisateur</c:otherwise>
        </c:choose>
    </title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">

<jsp:include page="/jsp/includes/header.jsp" />

<div class="container-fluid flex-grow-1">
    <div class="row">
        <!-- Sidebar admin -->
        <jsp:include page="/jsp/includes/adminSidebar.jsp" />

        <!-- Main content -->
        <main class="col-md-9 col-lg-10 px-4 py-5">

            <!-- Alerts (error, success, ...) -->
            <jsp:include page="/jsp/includes/alerts.jsp" />

            <!-- Titre + contexte -->
            <div class="mb-4">
                <h1 class="h3">
                    <i class="bi bi-people"></i> Administration – Utilisateurs
                </h1>
                <p class="text-muted small mb-1">
                    Cette page permet à un <strong>administrateur</strong> de créer ou modifier des comptes.
                </p>
            </div>

            <div class="card shadow-sm" style="max-width: 600px;">
                <div class="card-body">
                    <h2 class="h5 mb-3">
                        <c:choose>
                            <c:when test="${usern == null}">
                                <i class="bi bi-person-plus"></i> Créer un nouvel utilisateur
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-pencil-square"></i> Modifier l'utilisateur : ${usern.username}
                            </c:otherwise>
                        </c:choose>
                    </h2>

                    <form method="POST"
                          action="${
                              usern == null
                                  ? pageContext.request.contextPath.concat('/admin/users/create')
                                  : pageContext.request.contextPath.concat('/admin/users/update/').concat(usern.id)
                          }"
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
                                   value="${usern != null ? usern.username : ''}">
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
                                   value="${usern != null ? usern.email : ''}">
                            <div class="invalid-feedback">
                                Veuillez saisir une adresse email valide.
                            </div>
                        </div>

                        <!-- Mot de passe -->
                        <div class="col-12">
                            <label class="form-label">
                                Mot de passe
                                <span class="text-danger">*</span>
                                <c:if test="${usern != null}">
                                    <span class="small text-muted">
                                        (laisser vide pour conserver le mot de passe actuel)
                                    </span>
                                </c:if>
                            </label>
                            <input type="password"
                                   name="password"
                                   class="form-control"
                                   <c:if test="${usern == null}">required minlength="6"</c:if>>
                            <c:if test="${usern == null}">
                                <div class="invalid-feedback">
                                    Veuillez saisir un mot de passe (min. 6 caractères).
                                </div>
                            </c:if>
                        </div>

                        <!-- Rôle -->
                        <div class="col-12">
                            <input type="hidden" name="role" value="USER">
                        </div>

                        <!-- Boutons -->
                        <div class="col-12 d-flex gap-2 mt-3">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i>
                                <c:choose>
                                    <c:when test="${usern == null}">Créer</c:when>
                                    <c:otherwise>Mettre à jour</c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/users"
                               class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Retour à la liste
                            </a>
                        </div>

                    </form>
                </div>
            </div>

        </main>
    </div>
</div>

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
