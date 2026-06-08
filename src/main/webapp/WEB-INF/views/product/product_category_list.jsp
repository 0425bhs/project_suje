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

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_category_list.css">

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="new" />
    </jsp:include>

    <div class="category-page-wrap">

    <body>

        <jsp:include page="/WEB-INF/views/product/product_header.jsp">
            <jsp:param name="activeMenu" value="category" />
        </jsp:include>

        <div class="category-page-wrap">

            <!-- 왼쪽 카테고리 메뉴 -->
            <aside class="left-category-box">

                <a href="/all_list.do" class="all-category-link">전체</a>

                <c:forEach var="big" items="${bigCategoryList}">

                    <div class="category-group ${big.category_id == selectedBigCategoryId ? 'open' : ''}">

                        <button type="button" class="category-title-btn">
                            ${big.name}
                            <span>⌄</span>
                        </button>

                        <div class="sub-category">

                            <a href="/category_list.do?category_id=${big.category_id}${empty sort ? '' : '&sort='}${sort}"
                            class="${category_id == big.category_id ? 'active' : ''}">
                                전체
                            </a>

                            <c:forEach var="small" items="${smallCategoryList}">
                                <c:if test="${small.parent_id == big.category_id}">
                                    <a href="/category_list.do?category_id=${small.category_id}${empty sort ? '' : '&sort='}${sort}"
                                    class="${category_id == small.category_id ? 'active' : ''}">
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

                <!-- 경로 표시 -->
                <div class="category-breadcrumb">
                    <a href="/main.do">홈</a>
                    <span>›</span>

                    <c:forEach var="big" items="${bigCategoryList}">
                        <c:if test="${big.category_id == selectedBigCategoryId}">
                            <a href="/category_list.do?category_id=${big.category_id}">
                                ${big.name}
                            </a>
                            <span>›</span>
                        </c:if>
                    </c:forEach>

                    <strong>${category_name}</strong>
                </div>

                <div class="category-title-row">
                    <h2>${category_name}</h2>
                </div>

                <!-- 필터 버튼: 아직 기능 연결 전, UI만 표시 -->
                <div class="category-filter-row">
                    <button type="button">쿠폰/할인 <span>⌄</span></button>
                    <button type="button">예상출발일 <span>⌄</span></button>
                    <button type="button">가격대 <span>⌄</span></button>
                    <button type="button">작품 특징 <span>⌄</span></button>
                    <button type="button">상세옵션 <span>⌄</span></button>
                </div>

                <c:set var="currentSort" value="${empty sort ? 'popular' : sort}" />

                <!-- 정렬 메뉴 -->
                <div class="category-sort-row">
                    <div class="category-sort-list">
                        <a href="/category_list.do?category_id=${category_id}&sort=popular"
                        class="${currentSort eq 'popular' ? 'active' : ''}">인기순 ⓘ</a>
                        <span>|</span>

                        <a href="/category_list.do?category_id=${category_id}&sort=new"
                        class="${currentSort eq 'new' ? 'active' : ''}">최신순(NEW)</a>
                        <span>|</span>

                        <a href="/category_list.do?category_id=${category_id}&sort=discount"
                        class="${currentSort eq 'discount' ? 'active' : ''}">할인율 높은순</a>
                        <span>|</span>

                        <a href="/category_list.do?category_id=${category_id}&sort=lowPrice"
                        class="${currentSort eq 'lowPrice' ? 'active' : ''}">낮은 가격순</a>
                        <span>|</span>

                        <a href="/category_list.do?category_id=${category_id}&sort=highPrice"
                        class="${currentSort eq 'highPrice' ? 'active' : ''}">높은 가격순</a>
                    </div>

                </div>

                <p class="category-count-text">
                    총 ${rowTotal}개
                </p>

                <c:choose>
                    <c:when test="${empty list}">
                        <div class="category-empty">
                            등록된 상품이 없습니다.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="product-grid">

                            <c:forEach var="product" items="${list}">

                                <div class="product-card">

                                    <a class="product-image-link"
                                    href="/product_detail.do?product_id=${product.product_id}">

                                        <c:choose>
                                            <c:when test="${not empty product.image_l and product.image_l ne 'no_file'}">
                                                <img src="${product.image_l}" alt="${product.name}">
                                            </c:when>

                                            <c:when test="${not empty product.image_s and product.image_s ne 'no_file'}">
                                                <img src="${product.image_s}" alt="${product.name}">
                                            </c:when>

                                            <c:otherwise>
                                                <img src="/images/no_image.png" alt="이미지 없음">
                                            </c:otherwise>
                                        </c:choose>
                                    </a>

                                    <div class="product-info-box">

                                        <div class="product-name">
                                            <a href="/product_detail.do?product_id=${product.product_id}">
                                                ${product.name}
                                            </a>
                                        </div>

                                        <c:choose>
                                            <c:when test="${product.sale_price > 0 and product.sale_price < product.price}">
                                                <p class="origin-price">
                                                    <fmt:formatNumber value="${product.price}" pattern="#,###"/>원
                                                </p>

                                                <p class="sale-price">
                                                    <strong>${product.sale_rate}%</strong>
                                                    <span>
                                                        <fmt:formatNumber value="${product.sale_price}" pattern="#,###"/>원
                                                    </span>
                                                </p>
                                            </c:when>

                                            <c:otherwise>
                                                <p class="price">
                                                    <fmt:formatNumber value="${product.price}" pattern="#,###"/>원
                                                </p>
                                            </c:otherwise>
                                        </c:choose>

                                        <p class="delivery-text">
                                            <c:choose>
                                                <c:when test="${product.delivery_fee == 0}">
                                                    무료배송
                                                </c:when>

                                                <c:when test="${product.free_shipping > 0}">
                                                    <fmt:formatNumber value="${product.free_shipping}" pattern="#,###"/>원 이상 무료배송
                                                </c:when>

                                                <c:otherwise>
                                                    배송비 <fmt:formatNumber value="${product.delivery_fee}" pattern="#,###"/>원
                                                </c:otherwise>
                                            </c:choose>
                                        </p>

                                    </div>

                                </div>

                            </c:forEach>

                        </div>

                        <div class="page-menu">
                            ${pageMenu}
                        </div>
                    </c:otherwise>
                </c:choose>

            </main>

        </div>

    </body>
</html>