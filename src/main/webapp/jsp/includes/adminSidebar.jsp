<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="col-md-3 col-lg-2 bg-light p-4" style="min-height: 600px;">
    <nav class="nav flex-column">

        <!-- Dashboard -->
        <a class="nav-link d-flex align-items-center mb-3 ${pageContext.request.requestURI.contains('/admin') && !pageContext.request.requestURI.contains('/admin/users') && !pageContext.request.requestURI.contains('/admin/rooms') && !pageContext.request.requestURI.contains('/admin/reservations') ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/">
            <i class="bi bi-graph-up me-2"></i> Tableau de bord
        </a>

        <!-- Users -->
        <a class="nav-link d-flex align-items-center mb-3 ${pageContext.request.requestURI.contains('/admin/users') ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/users">
            <i class="bi bi-people me-2"></i> Utilisateurs
        </a>

        <!-- Rooms -->
        <a class="nav-link d-flex align-items-center mb-3 ${pageContext.request.requestURI.contains('/admin/rooms') ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/rooms">
            <i class="bi bi-door-closed me-2"></i> Salles
        </a>

        <!-- Reservations -->
        <a class="nav-link d-flex align-items-center mb-3 ${pageContext.request.requestURI.contains('/admin/reservations') ? 'active' : ''}"
           href="${pageContext.request.contextPath}/admin/reservations">
            <i class="bi bi-calendar-check me-2"></i> Réservations
        </a>

        <hr class="my-4">

        <!-- Logout -->
        <a class="nav-link d-flex align-items-center text-danger"
           href="${pageContext.request.contextPath}/logout">
            <i class="bi bi-box-arrow-right me-2"></i> Déconnexion
        </a>

    </nav>
</aside>
