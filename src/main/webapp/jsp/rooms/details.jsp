<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Détail salle - BookingRoom</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">

<jsp:include page="/jsp/includes/header.jsp" />

<main class="flex-grow-1 py-5">
    <div class="container">
        <c:if test="${room == null}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle"></i>
                Salle introuvable.
            </div>
        </c:if>

        <c:if test="${room != null}">
            <!-- Fil d'Ariane -->
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/rooms">Salles</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">
                            ${room.name}
                    </li>
                </ol>
            </nav>

            <div class="row g-4">
                <!-- Image + infos principales -->
                <div class="col-12 col-lg-7">
                    <div class="card shadow-sm mb-4">
                        <c:choose>
                            <c:when test="${room.imagePath != null && !empty room.imagePath}">
                                <img src="${pageContext.request.contextPath}/uploads/rooms/${room.imagePath}"
                                     class="card-img-top img-fluid"
                                     style="max-height: 320px; object-fit: cover;"
                                     alt="${room.name}">
                            </c:when>
                            <c:otherwise>
                                <div class="card-img-top bg-secondary d-flex align-items-center justify-content-center"
                                     style="height: 260px;">
                                    <i class="bi bi-image text-white" style="font-size: 3rem;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div>
                                    <h1 class="h4 mb-1">${room.name}</h1>
                                    <p class="text-muted mb-0">
                                        <i class="bi bi-geo-alt"></i>
                                            ${room.location}
                                    </p>
                                </div>
                                <div class="text-end">
                                    <div class="h5 mb-0 text-primary">
                                        <fmt:formatNumber value="${room.pricing}"
                                                          type="currency"
                                                          currencySymbol="€"
                                                          maxFractionDigits="0"/>
                                        <span class="small text-muted">/ jour</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${room.roomType == 'BANQUET_HALL'}">
                                            <span class="badge bg-info mt-2">Salle Banquet</span>
                                        </c:when>
                                        <c:when test="${room.roomType == 'EVENT_HALL'}">
                                            <span class="badge bg-warning text-dark mt-2">Salle Événement</span>
                                        </c:when>
                                        <c:when test="${room.roomType == 'WEDDING_HALL'}">
                                            <span class="badge bg-success mt-2">Salle Mariage</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>

                            <hr>

                            <div class="row text-center small">
                                <div class="col-4">
                                    <i class="bi bi-people fs-5"></i><br>
                                    <strong>${room.capacity}</strong><br>
                                    <span class="text-muted">Personnes</span>
                                </div>
                                <div class="col-4">
                                    <i class="bi bi-rulers fs-5"></i><br>
                                    <strong>${room.size}</strong><br>
                                    <span class="text-muted">m²</span>
                                </div>
                                <div class="col-4">
                                    <i class="bi bi-check-circle fs-5"></i><br>
                                    <c:choose>
                                        <c:when test="${room.availabilityStatus == 'ACTIVE'}">
                                            <span class="badge bg-success mt-1">Disponible</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger mt-1">Indisponible</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Panneau réservation -->
                <div class="col-12 col-lg-5">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header bg-light">
                            <h2 class="h6 mb-0">
                                <i class="bi bi-calendar-plus"></i> Réserver cette salle
                            </h2>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${sessionScope.user == null}">
                                    <div class="alert alert-info">
                                        <i class="bi bi-info-circle"></i>
                                        Vous devez être connecté pour réserver.
                                        <a href="${pageContext.request.contextPath}/login"
                                           class="alert-link">Se connecter</a>.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <form method="GET"
                                          action="${pageContext.request.contextPath}/reservations/create"
                                          class="row g-3">
                                        <!-- roomId hidden -->
                                        <input type="hidden" name="roomId" value="${room.id}"/>

                                        <!-- Date début -->
                                        <div class="col-12">
                                            <label for="startDateTime" class="form-label">
                                                Date & heure de début
                                            </label>
                                            <input type="datetime-local"
                                                   class="form-control"
                                                   id="startDateTime"
                                                   name="startDateTime"
                                                   value="${param.startDateTime}">
                                        </div>

                                        <!-- Date fin -->
                                        <div class="col-12">
                                            <label for="endDateTime" class="form-label">
                                                Date & heure de fin
                                            </label>
                                            <input type="datetime-local"
                                                   class="form-control"
                                                   id="endDateTime"
                                                   name="endDateTime"
                                                   value="${param.endDateTime}">
                                        </div>

                                        <div class="col-12 d-grid gap-2">
                                            <button type="submit" class="btn btn-success">
                                                <i class="bi bi-calendar-plus"></i> Continuer la réservation
                                            </button>
                                        </div>
                                    </form>
                                    <p class="small text-muted mt-2 mb-0">
                                        Vous pourrez confirmer vos dates sur l'écran suivant.
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Bloc info supplémentaire (optionnel) -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-light">
                            <h2 class="h6 mb-0">
                                <i class="bi bi-info-circle"></i> Informations
                            </h2>
                        </div>
                        <div class="card-body small text-muted">
                            <ul class="mb-0">
                                <li>Tarif par jour, hors services additionnels.</li>
                                <li>Les réservations sont soumises à validation.</li>
                                <li>Annulation possible sous conditions depuis la page "Mes réservations".</li>
                            </ul>
                        </div>
                    </div>

                </div>
            </div>

        </c:if>

    </div>
</main>

<jsp:include page="/jsp/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
