<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!--
USAGE dans les JSP:
<c:set var="page" value="${page}" />
<jsp:include page="/jsp/includes/pagination.jsp">
    <jsp:param name="baseUrl" value="/admin/users" />
    <jsp:param name="queryParams" value="&status=ACTIVE" />
</jsp:include>
-->

<c:if test="${page.totalPages > 1}">
    <nav aria-label="Pagination" class="mt-5">
        <ul class="pagination justify-content-center">

            <!-- Première -->
            <li class="page-item ${page.firstPage ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}${param.baseUrl}?page=1${param.queryParams}">
                    <i class="bi bi-chevron-double-left"></i>
                </a>
            </li>

            <!-- Précédente -->
            <li class="page-item ${!page.hasPrevious ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}${param.baseUrl}?page=${page.currentPage - 1}${param.queryParams}">
                    <i class="bi bi-chevron-left"></i> Précédent
                </a>
            </li>

            <!-- Numéros de page -->
            <c:forEach begin="1" end="${page.totalPages}" var="p">
                <c:if test="${p >= page.currentPage - 2 && p <= page.currentPage + 2}">
                    <li class="page-item ${p == page.currentPage ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}${param.baseUrl}?page=${p}${param.queryParams}">
                                ${p}
                        </a>
                    </li>
                </c:if>
            </c:forEach>

            <!-- Suivante -->
            <li class="page-item ${!page.hasNext ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}${param.baseUrl}?page=${page.currentPage + 1}${param.queryParams}">
                    Suivant <i class="bi bi-chevron-right"></i>
                </a>
            </li>

            <!-- Dernière -->
            <li class="page-item ${page.lastPage ? 'disabled' : ''}">
                <a class="page-link" href="${pageContext.request.contextPath}${param.baseUrl}?page=${page.totalPages}${param.queryParams}">
                    <i class="bi bi-chevron-double-right"></i>
                </a>
            </li>
        </ul>
    </nav>

    <!-- Info pagination -->
    <div class="text-center text-muted small">
        <p>
            Page <strong>${page.currentPage}</strong> sur <strong>${page.totalPages}</strong> -
            Affichage <strong>${page.firstItemNumber}</strong> à <strong>${page.lastItemNumber}</strong>
            sur <strong>${page.totalItems}</strong> résultat(s)
        </p>
    </div>
</c:if>
