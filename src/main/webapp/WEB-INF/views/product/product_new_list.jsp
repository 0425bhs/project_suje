<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <title>HANDMADE - 신제품</title>

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_new_list.css">

        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="new" />
    </jsp:include>


    <main class="new-page">

        <div class="new-page-title">
            <h2>신제품</h2>
            <p>새롭게 등록된 상품을 최신순으로 확인할 수 있습니다.</p>
        </div>

        <c:choose>

            <c:when test="${empty list}">
                <div class="new-empty">
                    등록된 신제품이 없습니다.
                </div>
            </c:when>

            <c:otherwise>

                <div class="new-product-wrap">

                    <c:forEach var="vo" items="${list}">

                        <div class="new-product-card">

                            <a href="/product_detail.do?product_id=${vo.product_id}"
                            class="new-image-link">

                                <c:choose>
                                    <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                        <img src="${vo.image_l}" alt="${vo.name}">
                                    </c:when>

                                    <c:when test="${not empty vo.image_s and vo.image_s ne 'no_file'}">
                                        <img src="${vo.image_s}" alt="${vo.name}">
                                    </c:when>

                                    <c:otherwise>
                                        <img src="/images/no_image.png" alt="이미지 없음">
                                    </c:otherwise>
                                </c:choose>

                            </a>

                            <div class="new-product-info">

                                <div class="new-product-name">
                                    <a href="/product_detail.do?product_id=${vo.product_id}">
                                        ${vo.name}
                                    </a>
                                </div>

                                <c:choose>

                                    <c:when test="${vo.sale_price == 0}">
                                        <p class="new-price">
                                            <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                        </p>
                                    </c:when>

                                    <c:otherwise>
                                        <p class="new-origin-price">
                                            <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                        </p>

                                        <p class="new-sale-price">
                                            <span>${vo.sale_rate}%</span>
                                            <strong>
                                                <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                            </strong>
                                        </p>
                                    </c:otherwise>

                                </c:choose>

                                <c:choose>
                                    <c:when test="${vo.free_shipping > 0}">
                                        <p class="new-delivery">
                                            <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 무료배송
                                        </p>
                                    </c:when>

                                    <c:otherwise>
                                        <p class="new-delivery">
                                            무료배송
                                        </p>
                                    </c:otherwise>
                                </c:choose>

                            </div>

                        </div>

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