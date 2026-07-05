<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <title>HANDMADE - 검색 결과</title>

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_card.css">
        <link rel="stylesheet" href="/css/product/product_new_list.css">

        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="" />
    </jsp:include>

    <main class="new-page">

        <div class="new-page-title">
            <h2>'${keyword}' 검색 결과</h2>
            <p>총 ${rowTotal}개의 상품이 검색되었습니다.</p>
        </div>

        <c:choose>

            <c:when test="${empty list}">
                <div class="new-empty">
                    검색 결과가 없습니다.
                </div>
            </c:when>

            <c:otherwise>

                <div class="common-product-wrap">
                    <c:forEach var="vo" items="${list}">
                        <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                    </c:forEach>
                </div>

            </c:otherwise>

        </c:choose>

        <div class="new-page-menu">
            ${pageMenu}
        </div>

    </main>

    </body>
</html>