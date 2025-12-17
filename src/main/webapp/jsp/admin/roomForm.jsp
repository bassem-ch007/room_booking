<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${room == null ? 'Créer' : 'Modifier'} une Salle - Admin</title>
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
                <i class="bi bi-door-closed"></i>
                <c:choose>
                    <c:when test="${room == null}">
                        Créer une salle
                    </c:when>
                    <c:otherwise>
                        Modifier la salle: ${room.name}
                    </c:otherwise>
                </c:choose>
            </h1>
            <p class="text-muted small mb-5">Remplissez le formulaire ci-dessous</p>

            <!-- Form Card -->
            <div class="card shadow-sm">
                <div class="card-body">
                    <form method="POST"
                          action="${room == null ? pageContext.request.contextPath.concat('/admin/rooms/create') : pageContext.request.contextPath.concat('/admin/rooms/update/').concat(room.id)}"
                          enctype="multipart/form-data" class="row g-4">

                        <!-- Type de Salle -->
                        <div class="col-12 col-md-6">
                            <label class="form-label">Type de salle <span class="text-danger">*</span></label>
                            <select class="form-select" name="roomType" required>
                                <option value="">-- Sélectionner --</option>
                                <option value="BANQUET_HALL" ${room != null && room.roomType == 'BANQUET_HALL' ? 'selected' : ''}>Salle Banquet</option>
                                <option value="EVENT_HALL" ${room != null && room.roomType == 'EVENT_HALL' ? 'selected' : ''}>Salle Événement</option>
                                <option value="WEDDING_HALL" ${room != null && room.roomType == 'WEDDING_HALL' ? 'selected' : ''}>Salle Mariage</option>
                            </select>
                        </div>

                        <!-- Nom -->
                        <div class="col-12 col-md-6">
                            <label class="form-label">Nom <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="name"
                                   value="${room != null ? room.name : ''}" required>
                        </div>

                        <!-- Capacité -->
                        <div class="col-12 col-md-6">
                            <label class="form-label">Capacité (personnes) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="capacity" min="1"
                                   value="${room != null ? room.capacity : ''}" required>
                        </div>

                        <!-- Taille -->
                        <div class="col-12 col-md-6">
                            <label class="form-label">Taille (m²) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="size" step="0.1" min="0"
                                   value="${room != null ? room.size : ''}" required>
                        </div>

                        <!-- Localisation -->
                        <div class="col-12 col-md-6">
                            <label class="form-label">Localisation <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="location" placeholder="Ex: Paris, Île-de-France"
                                   value="${room != null ? room.location : ''}" required>
                        </div>

                        <!-- Prix -->
                        <div class="col-12 col-md-6">
                            <label class="form-label">Prix (€/jour) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="pricing" step="0.01" min="0"
                                   value="${room != null ? room.pricing : ''}" required>
                        </div>

                        <!-- Image -->
                        <div class="col-12">
                            <label class="form-label">Image</label>
                            <input type="file"
                                   class="form-control"
                                   name="image"
                                   accept="image/*">
                            <small class="text-muted">Max 5MB. Formats: JPG, PNG, GIF, WebP</small>

                            <!-- Image actuelle -->
                            <c:if test="${room != null && room.imagePath != null}">
                                <div class="mt-3 p-3 bg-light rounded">
                                    <p class="small text-muted mb-2">
                                        <i class="bi bi-image"></i> Image actuelle:
                                    </p>
                                    <img src="${pageContext.request.contextPath}/uploads/rooms/${room.imagePath}"
                                         alt="${room.name}"
                                         style="max-width: 200px; max-height: 200px; border-radius: 5px; object-fit: cover;">

                                    <!-- Option supprimer image -->
                                    <div class="mt-2">
                                        <div class="form-check">
                                            <input type="checkbox"
                                                   class="form-check-input"
                                                   id="deleteImage"
                                                   name="deleteImage"
                                                   value="true">
                                            <label class="form-check-label" for="deleteImage">
                                                Supprimer cette image
                                            </label>
                                        </div>
                                        <small class="text-muted">
                                            Si cochée, l'image sera supprimée et remplacée par celle téléchargée ci-dessus.
                                        </small>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Info création -->
                            <c:if test="${room == null}">
                                <small class="d-block mt-2 text-muted">
                                    Vous pouvez ajouter une image lors de la création ou la laisser vide pour ajouter ultérieurement.
                                </small>
                            </c:if>
                        </div>


                        <!-- Statut (pour modification) -->
                        <c:if test="${room != null}">
                            <div class="col-12 col-md-6">
                                <label class="form-label">Statut</label>
                                <select class="form-select" name="status">
                                    <option value="ACTIVE" ${room.availabilityStatus == 'ACTIVE' ? 'selected' : ''}>Actif</option>
                                    <option value="INACTIVE" ${room.availabilityStatus == 'INACTIVE' ? 'selected' : ''}>Inactif</option>
                                </select>
                            </div>
                        </c:if>

                        <!-- Buttons -->
                        <div class="col-12 d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i>
                                <c:choose>
                                    <c:when test="${room == null}">Créer</c:when>
                                    <c:otherwise>Mettre à jour</c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Retour
                            </a>
                        </div>
                    </form>
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
