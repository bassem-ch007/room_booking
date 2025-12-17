<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Utilisateurs - Admin</title>
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
            <div class="d-flex justify-content-between align-items-center mb-5">
                <div>
                    <h1 class="h3">
                        <i class="bi bi-people"></i> Gestion des Utilisateurs
                    </h1>
                    <p class="text-muted small">Total: ${page.totalItems} utilisateur(s)</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> Créer utilisateur
                </a>
            </div>

            <!-- Users Table -->
            <div class="card shadow-sm">
                <div class="card-body">
                    <c:choose>
                        <c:when test="${page.totalItems == 0}">
                            <div class="alert alert-info mb-0">
                                <i class="bi bi-info-circle"></i> Aucun utilisateur trouvé
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Table Responsive -->
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                    <tr>
                                        <th>#ID</th>
                                        <th>Nom d'utilisateur</th>
                                        <th>Email</th>
                                        <th>Rôle</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="user" items="${page.content}">
                                        <tr>
                                            <td><strong>#${user.id}</strong></td>
                                            <td>
                                                <i class="bi bi-person-circle"></i>
                                                <strong>${user.username}</strong>
                                            </td>
                                            <td>${user.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.role == 'ADMIN'}">
                                                        <span class="badge bg-danger">ADMIN</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">USER</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <a href="${pageContext.request.contextPath}/admin/users/edit/${user.id}"
                                                       class="btn btn-outline-primary" title="Modifier">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-outline-danger"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#deleteModal${user.id}"
                                                            title="Supprimer">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- Delete Modal -->
                                        <div class="modal fade" id="deleteModal${user.id}" tabindex="-1">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header bg-danger text-white">
                                                        <h5 class="modal-title">Supprimer l'utilisateur</h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        Êtes-vous sûr de vouloir supprimer <strong>${user.username}</strong> ?
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                                                        <form method="POST" action="${pageContext.request.contextPath}/admin/users/delete/${user.id}" style="display: inline;">
                                                            <button type="submit" class="btn btn-danger">Supprimer</button>
                                                        </form>
                                                    </div>
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
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=1">
                                                <i class="bi bi-chevron-double-left"></i>
                                            </a>
                                        </li>
                                        <li class="page-item ${!page.hasPrevious ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${page.currentPage - 1}">
                                                <i class="bi bi-chevron-left"></i>
                                            </a>
                                        </li>

                                        <c:forEach begin="1" end="${page.totalPages}" var="p">
                                            <c:if test="${p >= page.currentPage - 2 && p <= page.currentPage + 2}">
                                                <li class="page-item ${p == page.currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${p}">
                                                            ${p}
                                                    </a>
                                                </li>
                                            </c:if>
                                        </c:forEach>

                                        <li class="page-item ${!page.hasNext ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${page.currentPage + 1}">
                                                <i class="bi bi-chevron-right"></i>
                                            </a>
                                        </li>
                                        <li class="page-item ${page.lastPage ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${page.totalPages}">
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
