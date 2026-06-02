<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <link rel="stylesheet" href="/css/product/product_category_list.css">
    <script src="/js/product_category_list.js"></script>
</head>

<body>

    <div class="category-page-wrap">

        <!-- 왼쪽 카테고리 메뉴 -->
        <aside class="left-category-box">

            <a href="/main.do" class="all-category-link">전체</a>

            <!-- 대분류 반복 -->
            <c:forEach var="big" items="${bigCategoryList}">

                <div class="category-group ${big.category_id == selectedBigCategoryId ? 'open' : ''}">

                    <button type="button" class="category-title-btn">
                        ${big.category_name}
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
                                    ${small.category_name}
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

            <div class="product-grid">

                <c:forEach var="product" items="${list}">

                    <div class="product-card">

                        <img src="${product.image_l}" alt="${product.name}"/>

                        <div class="product-name">
                            <a href="/product_detail.do?product_id=${product.product_id}">
                                ${product.name}
                            </a>
                        </div>

                        <c:if test="${product.sale_price == 0}">
                            <p class="price">
                                <fmt:formatNumber value="${product.price}" pattern="#,###"/>원
                            </p>
                        </c:if>

                        <c:if test="${product.sale_price > 0}">
                            <p class="origin-price">
                                <fmt:formatNumber value="${product.price}" pattern="#,###"/>원
                            </p>

                            <p class="sale-price">
                                <strong>${product.sale_rate}%</strong>
                                <fmt:formatNumber value="${product.sale_price}" pattern="#,###"/>원
                            </p>
                        </c:if>

                        <c:if test="${product.free_shipping > 0}">
                            <p class="delivery-text">
                                <fmt:formatNumber value="${product.free_shipping}" pattern="#,###"/>원 이상 무료배송
                            </p>
                        </c:if>

                        <c:if test="${product.free_shipping == 0}">
                            <p class="delivery-text">무료배송</p>
                        </c:if>

                    </div>

                </c:forEach>

            </div>

            <div class="page-menu">
                ${pageMenu}
            </div>

        </main>

    </div>

</body>
</html>