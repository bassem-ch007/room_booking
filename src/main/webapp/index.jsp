<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.roombooking.entity.User" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <% String pageTitle="Accueil" ; User user=(User) session.getAttribute("user"); %>
                <!DOCTYPE html>
                <html lang="fr">

                <head>
                    <title>
                        <%= pageTitle %> - BookingRoom
                    </title>
                    <jsp:include page="/jsp/includes/head.jsp" />
                </head>

                <body>

                    <jsp:include page="/jsp/includes/header.jsp" />

                    <div class="main-content-wrapper">
                        <div class="container">
                            <%-- Simple Landing Page Content (Moved back from home.jsp) --%>
                                <div class="transition-fade" style="text-align: center; padding: 4rem 0;">
                                    <jsp:include page="/jsp/includes/alerts.jsp" />

                                    <% if (user !=null) { %>
                                        <h1 style="font-size: 2.5rem; margin-bottom: 1rem;">Bienvenue, <%=
                                                user.getUsername() %> !</h1>
                                        <p
                                            style="font-size: 1.25rem; color: var(--text-secondary); margin-bottom: 3rem;">
                                            Que souhaitez-vous faire aujourd'hui ?</p>

                                        <% if ("ADMIN".equals(user.getRole().toString())) { %>
                                            <div
                                                style="display: flex; gap: 2rem; justify-content: center; flex-wrap: wrap;">
                                                <a href="${pageContext.request.contextPath}/admin/dashboard"
                                                    class="card room-card"
                                                    style="padding: 2rem; text-decoration: none; color: inherit; width: 250px;">
                                                    <div style="font-size: 3rem; margin-bottom: 1rem;">📊</div>
                                                    <h3>Tableau de bord</h3>
                                                    <p>Voir les statistiques</p>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/users"
                                                    class="card room-card"
                                                    style="padding: 2rem; text-decoration: none; color: inherit; width: 250px;">
                                                    <div style="font-size: 3rem; margin-bottom: 1rem;">👥</div>
                                                    <h3>Utilisateurs</h3>
                                                    <p>Gérer les comptes</p>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/rooms"
                                                    class="card room-card"
                                                    style="padding: 2rem; text-decoration: none; color: inherit; width: 250px;">
                                                    <div style="font-size: 3rem; margin-bottom: 1rem;">🏢</div>
                                                    <h3>Salles</h3>
                                                    <p>Gérer les espaces</p>
                                                </a>
                                            </div>
                                            <% } else { %>
                                                <div
                                                    style="display: flex; gap: 2rem; justify-content: center; flex-wrap: wrap;">
                                                    <a href="${pageContext.request.contextPath}/rooms"
                                                        class="card room-card"
                                                        style="padding: 2rem; text-decoration: none; color: inherit; width: 250px;">
                                                        <div style="font-size: 3rem; margin-bottom: 1rem;">🔍</div>
                                                        <h3>Réserver</h3>
                                                        <p>Trouver une salle</p>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/reservations"
                                                        class="card room-card"
                                                        style="padding: 2rem; text-decoration: none; color: inherit; width: 250px;">
                                                        <div style="font-size: 3rem; margin-bottom: 1rem;">📅</div>
                                                        <h3>Mes Réservations</h3>
                                                        <p>Voir mon historique</p>
                                                    </a>
                                                </div>
                                                <% } %>
                                                    <% } else { %>
                                                        <h1
                                                            style="font-size: 3rem; color: var(--primary-color); margin-bottom: 1.5rem;">
                                                            BookingRoom</h1>
                                                        <p
                                                            style="font-size: 1.5rem; color: var(--text-secondary); max-width: 600px; margin: 0 auto 3rem;">
                                                            La solution professionnelle pour gérer vos espaces de
                                                            travail simplement et efficacement.
                                                        </p>
                                                        <div style="display: flex; gap: 1rem; justify-content: center;">
                                                            <a href="${pageContext.request.contextPath}/login"
                                                                class="btn btn-primary btn-lg"
                                                                style="padding: 1rem 2rem; font-size: 1.25rem;">Se
                                                                connecter</a>
                                                            <a href="${pageContext.request.contextPath}/register"
                                                                class="btn btn-secondary btn-lg"
                                                                style="padding: 1rem 2rem; font-size: 1.25rem; background: white; color: var(--text-primary); border: 1px solid var(--border-color);">Créer
                                                                un compte</a>
                                                        </div>
                                                        <% } %>
                                </div>
                        </div>
                    </div>

                    <jsp:include page="/jsp/includes/footer.jsp" />

                </body>

                </html>