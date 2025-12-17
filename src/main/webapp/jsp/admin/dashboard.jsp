<%@ page import="com.roombooking.util.DateTimeUtil" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Admin</title>
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

            <!-- Page Title -->
            <div class="mb-5">
                <h1 class="h3">
                    <i class="bi bi-graph-up"></i> Tableau de Bord
                </h1>
                <p class="text-muted">Vue d'ensemble de l'activité de la plateforme</p>
            </div>

            <!-- KPI Cards -->
            <div class="row g-4 mb-5">

                <!-- Total Utilisateurs -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="card border-left-primary shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="text-muted small mb-1">Utilisateurs</p>
                                    <h3 class="text-primary">${totalUsers}</h3>
                                </div>
                                <i class="bi bi-people-fill text-primary" style="font-size: 2rem;"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Salles -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="card border-left-success shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="text-muted small mb-1">Salles</p>
                                    <h3 class="text-success">${totalRooms}</h3>
                                </div>
                                <i class="bi bi-door-closed text-success" style="font-size: 2rem;"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Réservations -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="card border-left-info shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="text-muted small mb-1">Réservations</p>
                                    <h3 class="text-info">${totalReservations}</h3>
                                </div>
                                <i class="bi bi-calendar-check text-info" style="font-size: 2rem;"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Annulées (Client) -->
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="card border-left-warning shadow-sm">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <p class="text-muted small mb-1">Annulées</p>
                                    <h3 class="text-warning">
                                        <c:set var="cancelledCount" value="${0}" />
                                        <c:forEach var="res" items="${recentReservations}">
                                            <c:if test="${res.status == 'CLIENT_CANCELLED'}">
                                                <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${cancelledCount}
                                    </h3>
                                </div>
                                <i class="bi bi-x-circle text-warning" style="font-size: 2rem;"></i>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Réservations Récentes -->
            <div class="card shadow-sm">
                <div class="card-header bg-light">
                    <h6 class="mb-0">
                        <i class="bi bi-clock-history"></i> Réservations Récentes
                    </h6>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty recentReservations}">
                            <div class="alert alert-info mb-0">
                                <i class="bi bi-info-circle"></i> Aucune réservation récente
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                    <tr>
                                        <th>#ID</th>
                                        <th>Utilisateur</th>
                                        <th>Salle</th>
                                        <th>Date début</th>
                                        <th>Statut</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="res" items="${recentReservations}">
                                        <tr>
                                            <td><strong>#${res.id}</strong></td>
                                            <td>${res.user.username}</td>
                                            <td>${res.room.name}</td>
                                            <td>
                                                <%= DateTimeUtil.formatDateTime(((com.roombooking.entity.Reservation) pageContext.findAttribute("res")).getStartDateTime()) %>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${res.status == 'APPROVED'}">
                                                        <span class="badge bg-success">Approuvée</span>
                                                    </c:when>
                                                    <c:when test="${res.status == 'PENDING'}">
                                                        <span class="badge bg-warning">En attente</span>
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
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
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
