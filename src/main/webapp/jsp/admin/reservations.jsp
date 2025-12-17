<%@ page import="com.roombooking.util.DateTimeUtil" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Réservations - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">

<!-- Header -->
<jsp:include page="/jsp/includes/header.jsp" />

<!-- Sidebar + Main -->
<div class="container-fluid flex-grow-1">
    <div class="row">
        <!-- Sidebar -->
        <jsp:include page="/jsp/includes/adminSidebar.jsp" />

        <!-- Main Content -->
        <main class="col-md-9 col-lg-10 px-4 py-5">

            <!-- Alerts -->
            <jsp:include page="/jsp/includes/alerts.jsp" />

            <!-- Page Header -->
            <h1 class="h3 mb-1">
                <i class="bi bi-calendar-check"></i> Gestion des Réservations
            </h1>
            <p class="text-muted small mb-5">Consultez et gérez toutes les réservations de salles</p>

            <!-- Filter Card -->
            <div class="card shadow-sm mb-5">
                <div class="card-header bg-light">
                    <h6 class="mb-0">
                        <i class="bi bi-funnel"></i> Filtrer
                    </h6>
                </div>
                <div class="card-body">
                    <form method="GET" action="${pageContext.request.contextPath}/admin/reservations" class="row g-3">
                        <div class="col-12 col-md-6">
                            <label class="form-label small">Statut</label>
                            <select class="form-select" name="status">
                                <option value="">-- Tous les statuts --</option>
                                <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>En attente</option>
                                <option value="APPROVED" ${selectedStatus == 'APPROVED' ? 'selected' : ''}>Approuvée</option>
                                <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Annulée (Admin)</option>
                                <option value="CLIENT_CANCELLED" ${selectedStatus == 'CLIENT_CANCELLED' ? 'selected' : ''}>Annulée (Client)</option>
                            </select>
                        </div>
                        <div class="col-12 col-md-6 d-flex align-items-end gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Filtrer
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/reservations" class="btn btn-secondary">
                                <i class="bi bi-arrow-clockwise"></i> Réinitialiser
                            </a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Reservations Table -->
            <div class="card shadow-sm">
                <div class="card-body">
                    <c:choose>
                        <c:when test="${page.totalItems == 0}">
                            <div class="alert alert-info mb-0">
                                <i class="bi bi-info-circle"></i> Aucune réservation trouvée
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Table Responsive -->
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>#ID</th>
                                        <th>Utilisateur</th>
                                        <th>Salle</th>
                                        <th>Date début</th>
                                        <th>Date fin</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="res" items="${page.content}">
                                        <tr>
                                            <td><strong>#${res.id}</strong></td>

                                            <td>
                                                <i class="bi bi-person-circle"></i>
                                                    ${res.user.username}
                                            </td>

                                            <td>${res.room.name}</td>

                                            <td>
                                                <%= com.roombooking.util.DateTimeUtil.formatDateTime(
                                                        ((com.roombooking.entity.Reservation) pageContext.findAttribute("res")).getStartDateTime()
                                                ) %>
                                            </td>

                                            <td>
                                                <%= com.roombooking.util.DateTimeUtil.formatDateTime(
                                                        ((com.roombooking.entity.Reservation) pageContext.findAttribute("res")).getEndDateTime()
                                                ) %>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${res.status == 'PENDING'}">
                                                        <span class="badge bg-warning text-dark">En attente</span>
                                                    </c:when>
                                                    <c:when test="${res.status == 'APPROVED'}">
                                                        <span class="badge bg-success">Approuvée</span>
                                                    </c:when>
                                                    <c:when test="${res.status == 'CANCELLED'}">
                                                        <span class="badge bg-danger">Annulée (Admin)</span>
                                                    </c:when>
                                                    <c:when test="${res.status == 'CLIENT_CANCELLED'}">
                                                        <span class="badge bg-secondary">Annulée (Client)</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark">${res.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <!-- Bouton Annuler -->
                                                <c:if test="${res.status == 'PENDING' || res.status == 'APPROVED'}">
                                                    <button type="button"
                                                            class="btn btn-sm btn-outline-danger me-1"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#cancelModal${res.id}"
                                                            title="Annuler">
                                                        <i class="bi bi-x-circle"></i>
                                                    </button>
                                                </c:if>

                                                <!-- Bouton Éditer statut -->
                                                <button type="button"
                                                        class="btn btn-sm btn-outline-primary"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#editStatusModal${res.id}"
                                                        title="Modifier le statut">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                            </td>
                                        </tr>

                                        <!-- Cancel Modal -->
                                        <div class="modal fade" id="cancelModal${res.id}" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header bg-warning">
                                                        <h5 class="modal-title">Annuler la réservation</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        Êtes-vous sûr de vouloir annuler la réservation #${res.id} ?<br>
                                                        <small class="text-muted">
                                                                ${res.room.name} - ${res.user.username}
                                                        </small>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                                                        <form method="POST"
                                                              action="${pageContext.request.contextPath}/admin/reservations/cancel/${res.id}"
                                                              style="display:inline;">
                                                            <button type="submit" class="btn btn-danger">Annuler</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Edit Status Modal -->
                                        <div class="modal fade" id="editStatusModal${res.id}" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <form method="POST"
                                                          action="${pageContext.request.contextPath}/admin/reservations/updateStatus/${res.id}">
                                                        <div class="modal-header bg-primary text-white">
                                                            <h5 class="modal-title">Modifier le statut #${res.id}</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p class="mb-2">
                                                                <strong>Salle :</strong> ${res.room.name}<br>
                                                                <strong>Client :</strong> ${res.user.username}
                                                            </p>
                                                            <div class="mb-3">
                                                                <label class="form-label">Nouveau statut</label>
                                                                <select name="status" class="form-select">
                                                                    <option value="PENDING" ${res.status == 'PENDING' ? 'selected' : ''}>En attente</option>
                                                                    <option value="APPROVED" ${res.status == 'APPROVED' ? 'selected' : ''}>Approuvée</option>
                                                                    <option value="CANCELLED" ${res.status == 'CANCELLED' ? 'selected' : ''}>Annulée (Admin)</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button"
                                                                    class="btn btn-secondary"
                                                                    data-bs-dismiss="modal">Fermer</button>
                                                            <button type="submit" class="btn btn-primary">
                                                                <i class="bi bi-check-circle"></i> Enregistrer
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${page.totalPages > 1}">
                                <nav aria-label="Pagination" class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${page.firstPage ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/reservations?page=1&status=${selectedStatus}">
                                                <i class="bi bi-chevron-double-left"></i>
                                            </a>
                                        </li>
                                        <li class="page-item ${!page.hasPrevious ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/reservations?page=${page.currentPage - 1}&status=${selectedStatus}">
                                                <i class="bi bi-chevron-left"></i>
                                            </a>
                                        </li>

                                        <c:forEach begin="1" end="${page.totalPages}" var="p">
                                            <c:if test="${p >= page.currentPage - 2 && p <= page.currentPage + 2}">
                                                <li class="page-item ${p == page.currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/reservations?page=${p}&status=${selectedStatus}">
                                                            ${p}
                                                    </a>
                                                </li>
                                            </c:if>
                                        </c:forEach>

                                        <li class="page-item ${!page.hasNext ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/reservations?page=${page.currentPage + 1}&status=${selectedStatus}">
                                                <i class="bi bi-chevron-right"></i>
                                            </a>
                                        </li>
                                        <li class="page-item ${page.lastPage ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/reservations?page=${page.totalPages}&status=${selectedStatus}">
                                                <i class="bi bi-chevron-double-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                                <div class="text-center text-muted small">
                                    Page ${page.currentPage} sur ${page.totalPages}
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </main>
    </div>
</div>

<!-- Footer -->
<jsp:include page="/jsp/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
