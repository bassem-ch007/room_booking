<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Erreurs -->
<c:if test="${not empty requestScope.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle"></i>
        <strong>Erreur!</strong> ${requestScope.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Succès -->
<c:if test="${not empty requestScope.success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle"></i>
        <strong>Succès!</strong> ${requestScope.success}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Info -->
<c:if test="${not empty requestScope.info}">
    <div class="alert alert-info alert-dismissible fade show" role="alert">
        <i class="bi bi-info-circle"></i>
            ${requestScope.info}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<!-- Warning -->
<c:if test="${not empty requestScope.warning}">
    <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-circle"></i>
            ${requestScope.warning}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>
