<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Salles - BookingRoom</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">

<!-- Header -->
<jsp:include page="/jsp/includes/header.jsp" />

<!-- Main Content -->
<main class="flex-grow-1 py-5">
    <div class="container">

        <!-- TITRE -->
        <div class="row mb-4">
            <div class="col">
                <h2><i class="bi bi-door-closed"></i> Nos salles</h2>
                <p class="text-muted small">
                    <c:choose>
                        <c:when test="${filterApplied}">
                            ${page.totalItems} salle(s) trouvée(s)
                        </c:when>
                        <c:otherwise>
                            ${page.totalItems} salle(s) disponible(s)
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </div>

        <!-- FILTRES (Collapsible) -->
        <div class="row mb-4">
            <div class="col">
                <button class="btn btn-outline-secondary btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#filterPanel">
                    <i class="bi bi-funnel"></i> Filtrer les salles
                    <c:if test="${filterApplied}">
                        <span class="badge bg-primary">Actif</span>
                    </c:if>
                </button>
            </div>
        </div>

        <!-- Formulaire Filtrage -->
        <div class="collapse mb-4" id="filterPanel">
            <div class="card shadow-sm">
                <div class="card-body">
                    <form method="GET" action="${pageContext.request.contextPath}/rooms" class="row g-3">

                        <!-- Type de Salle -->
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label small">Type de salle</label>
                            <select class="form-select" name="roomType">
                                <option value="">-- Tous les types --</option>
                                <option value="BANQUET_HALL" ${selectedRoomType == 'BANQUET_HALL' ? 'selected' : ''}>Salle Banquet</option>
                                <option value="EVENT_HALL" ${selectedRoomType == 'EVENT_HALL' ? 'selected' : ''}>Salle Événement</option>
                                <option value="WEDDING_HALL" ${selectedRoomType == 'WEDDING_HALL' ? 'selected' : ''}>Salle Mariage</option>
                            </select>
                        </div>

                        <!-- Capacité Min -->
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label small">Capacité minimum</label>
                            <input type="number" class="form-control" name="minCapacity" placeholder="Ex: 10" value="${selectedMinCapacity}">
                        </div>

                        <!-- Taille Min -->
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label small">Taille min (m²)</label>
                            <input type="number" class="form-control" name="minSize" placeholder="Ex: 50" step="0.1" value="${selectedMinSize}">
                        </div>

                        <!-- Localisation -->
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label small">Localisation</label>
                            <input type="text" class="form-control" name="location" placeholder="Ex: Paris" value="${selectedLocation}">
                        </div>

                        <!-- Prix Min -->
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label small">Prix minimum (€)</label>
                            <input type="number" class="form-control" name="minPrice" placeholder="Ex: 100" step="0.01" value="${selectedMinPrice}">
                        </div>

                        <!-- Prix Max -->
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label small">Prix maximum (€)</label>
                            <input type="number" class="form-control" name="maxPrice" placeholder="Ex: 500" step="0.01" value="${selectedMaxPrice}">
                        </div>

                        <!-- Date Début -->
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label small">Date & Heure début</label>
                            <input type="datetime-local" class="form-control" name="startDateTime" value="${selectedStartDateTime}">
                        </div>

                        <!-- Date Fin -->
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label small">Date & Heure fin</label>
                            <input type="datetime-local" class="form-control" name="endDateTime" value="${selectedEndDateTime}">
                        </div>

                        <!-- Boutons -->
                        <div class="col-12 d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Rechercher
                            </button>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-secondary">
                                <i class="bi bi-arrow-clockwise"></i> Réinitialiser
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- RÉSULTATS -->
        <c:choose>
            <c:when test="${page.totalItems == 0}">
                <div class="alert alert-info text-center">
                    <i class="bi bi-info-circle"></i>
                    <c:choose>
                        <c:when test="${filterApplied}">
                            Aucune salle ne correspond à vos critères. Essayez d'autres filtres.
                        </c:when>
                        <c:otherwise>
                            Aucune salle disponible pour le moment.
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Grille Salles -->
                <div class="row g-4 mb-5">
                    <c:forEach var="room" items="${page.content}">
                        <div class="col-12 col-md-6 col-lg-4">
                            <div class="card h-100 shadow-sm">

                                <!-- Image -->
                                <c:choose>
                                    <c:when test="${room.imagePath != null && !empty room.imagePath}">
                                        <img src="${pageContext.request.contextPath}/uploads/rooms/${room.imagePath}" class="card-img-top" style="height: 200px; object-fit: cover;" alt="${room.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-top bg-secondary d-flex align-items-center justify-content-center" style="height: 200px;">
                                            <i class="bi bi-image text-white" style="font-size: 2rem;"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <!-- Badge -->
                                <div class="position-absolute top-0 end-0 p-2">
                                        <span class="badge bg-success">
                                            <i class="bi bi-check-circle"></i> Disponible
                                        </span>
                                </div>

                                <!-- Corps -->
                                <div class="card-body">
                                    <h5 class="card-title">${room.name}</h5>
                                    <p class="card-text small text-muted">
                                        <i class="bi bi-geo-alt"></i> ${room.location}
                                    </p>

                                    <!-- Infos -->
                                    <div class="row text-center small mb-3">
                                        <div class="col-4">
                                            <i class="bi bi-people"></i><br>
                                            <strong>${room.capacity}</strong> pers
                                        </div>
                                        <div class="col-4">
                                            <i class="bi bi-rulers"></i><br>
                                            <strong>${room.size}</strong> m²
                                        </div>
                                        <div class="col-4">
                                            <i class="bi bi-tag"></i><br>
                                            <strong>
                                                <fmt:formatNumber value="${room.pricing}" type="currency" currencySymbol="€" maxFractionDigits="0"/>
                                            </strong>
                                        </div>
                                    </div>

                                    <!-- Bouton -->
                                    <a href="${pageContext.request.contextPath}/rooms/details/${room.id}" class="btn btn-sm btn-primary w-100">
                                        <i class="bi bi-eye"></i> Voir détails
                                    </a>
                                    <a href="${pageContext.request.contextPath}/reservations/create?roomId=${room.id}"
                                       class="btn btn-sm btn-outline-success w-100 mt-2">
                                        <i class="bi bi-calendar-plus"></i> Réserver
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- PAGINATION -->
                <c:if test="${page.totalPages > 1}">
                    <nav aria-label="Navigation pages">
                        <ul class="pagination justify-content-center">
                            <!-- Première -->
                            <li class="page-item ${page.firstPage ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/rooms?page=1">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                            </li>

                            <!-- Précédente -->
                            <li class="page-item ${page.hasPrevious ? '' : 'disabled'}">
                                <a class="page-link" href="${pageContext.request.contextPath}/rooms?page=${page.currentPage - 1}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>

                            <!-- Numéros pages -->
                            <c:forEach begin="1" end="${page.totalPages}" var="p">
                                <c:if test="${p >= page.currentPage - 2 && p <= page.currentPage + 2}">
                                    <li class="page-item ${p == page.currentPage ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/rooms?page=${p}">
                                                ${p}
                                        </a>
                                    </li>
                                </c:if>
                            </c:forEach>

                            <!-- Suivante -->
                            <li class="page-item ${page.hasNext ? '' : 'disabled'}">
                                <a class="page-link" href="${pageContext.request.contextPath}/rooms?page=${page.currentPage + 1}">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>

                            <!-- Dernière -->
                            <li class="page-item ${page.lastPage ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/rooms?page=${page.totalPages}">
                                    <i class="bi bi-chevron-double-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>

                    <!-- Info page -->
                    <div class="text-center text-muted small">
                        Affichage ${page.firstItemNumber} à ${page.lastItemNumber} sur ${page.totalItems}
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<!-- Footer -->
<jsp:include page="/jsp/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
