<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm sticky-top">
    <div class="container-fluid">

        <!-- Logo -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/rooms">
            <i class="bi bi-door-closed"></i> BookingRoom
        </a>

        <!-- Toggle Button (Mobile) -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navigation -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">

                <!-- ===== PUBLIC LINKS (NON CONNECTÉ) ===== -->
                <c:if test="${sessionScope.user == null}">

                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/rooms">
                            <i class="bi bi-door-closed"></i> Salles
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">
                            <i class="bi bi-box-arrow-in-right"></i> Connexion
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/register">
                            <i class="bi bi-person-plus"></i> Inscription
                        </a>
                    </li>

                </c:if>

                <!-- ===== AUTHENTICATED LINKS ===== -->
                <c:if test="${sessionScope.user != null}">

                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/rooms">
                            <i class="bi bi-door-closed"></i> Salles
                        </a>
                    </li>



                    <!-- ===== ADMIN MENU ===== -->
                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-gear"></i> Admin
                            </a>
                            <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end" aria-labelledby="adminDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/">
                                    <i class="bi bi-graph-up"></i> Dashboard
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/users">
                                    <i class="bi bi-people"></i> Utilisateurs
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/rooms">
                                    <i class="bi bi-door-closed"></i> Salles
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reservations">
                                    <i class="bi bi-calendar-check"></i> Réservations
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right"></i> Déconnexion
                                </a></li>
                            </ul>
                        </li>
                    </c:if>

                    <!-- ===== USER DROPDOWN ===== -->
                    <c:if test="${sessionScope.user.role != 'ADMIN'}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle"></i> ${sessionScope.user.username}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="bi bi-person"></i> Mon profil
                                </a></li>
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/reservations">
                                        <i class="bi bi-calendar-check"></i> Mes réservations
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                    <i class="bi bi-box-arrow-right"></i> Déconnexion
                                </a></li>
                            </ul>
                        </li>
                    </c:if>

                </c:if>

            </ul>
        </div>

    </div>
</header>
