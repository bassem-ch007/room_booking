<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Nouvelle réservation - BookingRoom</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">

<jsp:include page="/jsp/includes/header.jsp" />

<main class="flex-grow-1 py-5">
    <div class="container" style="max-width: 600px;">

        <h1 class="h4 mb-3">
            <i class="bi bi-calendar-plus"></i> Nouvelle réservation
        </h1>
        <p class="text-muted small mb-4">
            Salle ID: <strong>${roomId}</strong>
        </p>

        <!-- Alertes -->
        <jsp:include page="/jsp/includes/alerts.jsp" />

        <div class="card shadow-sm">
            <div class="card-body">

                <form method="POST"
                      action="${pageContext.request.contextPath}/reservations/create"
                      class="row g-3 needs-validation"
                      novalidate>

                    <!-- roomId en hidden -->
                    <input type="hidden" name="roomId" value="${roomId}"/>

                    <!-- Date début -->
                    <div class="col-12">
                        <label for="startDateTime" class="form-label">
                            Date et heure de début <span class="text-danger">*</span>
                        </label>
                        <input type="datetime-local"
                               class="form-control"
                               id="startDateTime"
                               name="startDateTime"
                               required
                               value="${param.startDateTime}">
                        <div class="invalid-feedback">
                            Veuillez renseigner la date et l'heure de début.
                        </div>
                    </div>

                    <!-- Date fin -->
                    <div class="col-12">
                        <label for="endDateTime" class="form-label">
                            Date et heure de fin <span class="text-danger">*</span>
                        </label>
                        <input type="datetime-local"
                               class="form-control"
                               id="endDateTime"
                               name="endDateTime"
                               required
                               value="${param.endDateTime}">
                        <div class="invalid-feedback">
                            Veuillez renseigner la date et l'heure de fin.
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="col-12 d-flex gap-2 mt-3">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-circle"></i> Valider la réservation
                        </button>
                        <a href="${pageContext.request.contextPath}/rooms/details/${roomId}"
                           class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Retour à la salle
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
