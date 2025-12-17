<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.roombooking.util.DateTimeUtil" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes réservations - BookingRoom</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="d-flex flex-column" style="min-height: 100vh;">

<jsp:include page="/jsp/includes/header.jsp" />

<main class="flex-grow-1 py-5">
    <div class="container">

        <h1 class="h3 mb-3">
            <i class="bi bi-calendar-check"></i> Mes réservations
        </h1>
        <p class="text-muted small mb-4">
            Vous avez ${page.totalItems} réservation(s).
        </p>

        <!-- Alerts -->
        <jsp:include page="/jsp/includes/alerts.jsp" />

        <c:choose>
            <c:when test="${empty page.content}">
                <div class="alert alert-info">
                    <i class="bi bi-info-circle"></i>
                    Vous n'avez pas encore de réservation.
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive mb-4">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>#ID</th>
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
                                <td>${res.room.name}</td>
                                <td>
                                    <%= DateTimeUtil.formatDateTime(((com.roombooking.entity.Reservation) pageContext.findAttribute("res")).getStartDateTime()) %>
                                </td>
                                <td>
                                    <%= DateTimeUtil.formatDateTime(((com.roombooking.entity.Reservation) pageContext.findAttribute("res")).getEndDateTime()) %>
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
                                            <span class="badge bg-secondary">Annulée (Vous)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-light text-dark">${res.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${res.status == 'PENDING' || res.status == 'APPROVED'}">
                                            <form method="POST"
                                                  action="${pageContext.request.contextPath}/reservations/cancel/${res.id}"
                                                  style="display:inline;">
                                                <button type="submit"
                                                        class="btn btn-sm btn-outline-danger"
                                                        onclick="return confirm('Annuler cette réservation ?');">
                                                    <i class="bi bi-x-circle"></i> Annuler
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination simple -->
                <c:if test="${page.totalPages > 1}">
                    <nav aria-label="Pagination">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${page.currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/reservations?page=${page.currentPage - 1}">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>

                            <c:forEach begin="1" end="${page.totalPages}" var="p">
                                <c:if test="${p >= page.currentPage - 2 && p <= page.currentPage + 2}">
                                    <li class="page-item ${p == page.currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                           href="${pageContext.request.contextPath}/reservations?page=${p}">
                                                ${p}
                                        </a>
                                    </li>
                                </c:if>
                            </c:forEach>

                            <li class="page-item ${page.currentPage == page.totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/reservations?page=${page.currentPage + 1}">
                                    <i class="bi bi-chevron-right"></i>
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
</main>

<jsp:include page="/jsp/includes/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
