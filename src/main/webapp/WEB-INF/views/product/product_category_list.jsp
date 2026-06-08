<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/product/product_card.css">
    <link rel="stylesheet" href="/css/product/product_category_list.css">

    <script src="/js/product_main.js" defer></script>
    <script src="/js/product_category_list.js"></script>
</head>

<body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="new" />
    </jsp:include>

    <div class="category-page-wrap">

        <!-- 왼쪽 카테고리 메뉴 -->
        <aside class="left-category-box">

            <a href="/main.do" class="all-category-link">전체</a>

            <!-- 대분류 반복 -->
            <c:forEach var="big" items="${bigCategoryList}">

                <div class="category-group ${big.category_id == selectedBigCategoryId ? 'open' : ''}">

                    <button type="button" class="category-title-btn">
                        ${big.name}
                        <span>⌄</span>
                    </button>

                    <div class="sub-category">

                        <!-- 해당 대분류 전체 상품 보기 -->
                        <a href="/category_list.do?category_id=${big.category_id}">
                            전체
                        </a>

                        <!-- 소분류 반복 -->
                        <c:forEach var="small" items="${smallCategoryList}">
                            <c:if test="${small.parent_id == big.category_id}">
                                <a href="/category_list.do?category_id=${small.category_id}">
                                    ${small.name}
                                </a>
                            </c:if>
                        </c:forEach>

                    </div>
                </div>

            </c:forEach>

        </aside>

        <!-- 오른쪽 상품 목록 -->
        <main class="category-product-area">

            <h2>${category_name}</h2>

            <div class="common-product-wrap">

                <c:forEach var="vo" items="${list}">

                    <%@ include file="/WEB-INF/views/product/product_card.jspf" %>

                </c:forEach>

            </div>

            <div class="page-menu">
                ${pageMenu}
            </div>

        </main>

    </div>

</body>
</html>