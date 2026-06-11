<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>선물추천</title>

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_card.css">
        <link rel="stylesheet" href="/css/product/product_gift.css?v=2">

        <script src="/js/product_main.js" defer></script>
    </head>

    <body>
        <jsp:include page="product_header.jsp">
            <jsp:param name="activeMenu" value="gift" />
        </jsp:include>

        <main class="gift-page">

            <!-- 선물추천 필터 영역 -->
            <section class="gift-filter-section">
                <div class="gift-inner">

                    <div class="gift-filter-card">

                        <div class="gift-filter-title">
                            <strong>선물추천</strong>
                            <p>카테고리와 가격대를 선택해서 선물하기 좋은 작품을 찾아보세요.</p>
                        </div>

                        <!-- 카테고리 필터 -->
                        <div class="gift-filter-row">
                            <div class="gift-filter-label">
                                카테고리
                            </div>

                            <div class="gift-filter-options">

                                <c:url var="allCategoryUrl" value="/product_gift.do">
                                    <c:if test="${not empty selectedPriceRange}">
                                        <c:param name="priceRange" value="${selectedPriceRange}" />
                                    </c:if>
                                </c:url>

                                <a href="${allCategoryUrl}"
                                   class="gift-filter-chip ${empty selectedCategoryId ? 'active' : ''}">
                                    전체
                                </a>

                                <c:forEach var="category" items="${bigCategoryList}">

                                    <c:url var="categoryUrl" value="/product_gift.do">
                                        <c:param name="category_id" value="${category.category_id}" />

                                        <c:if test="${not empty selectedPriceRange}">
                                            <c:param name="priceRange" value="${selectedPriceRange}" />
                                        </c:if>
                                    </c:url>

                                    <a href="${categoryUrl}"
                                       class="gift-filter-chip ${selectedCategoryId eq category.category_id ? 'active' : ''}">
                                        ${category.name}
                                    </a>

                                </c:forEach>

                            </div>
                        </div>


                        <!-- 가격대 필터 -->
                        <div class="gift-filter-row">
                            <div class="gift-filter-label">
                                가격대
                            </div>

                            <div class="gift-filter-options">

                                <c:url var="allPriceUrl" value="/product_gift.do">
                                    <c:if test="${not empty selectedCategoryId}">
                                        <c:param name="category_id" value="${selectedCategoryId}" />
                                    </c:if>
                                </c:url>

                                <a href="${allPriceUrl}"
                                   class="gift-filter-chip ${empty selectedPriceRange ? 'active' : ''}">
                                    전체
                                </a>


                                <c:url var="under10000Url" value="/product_gift.do">
                                    <c:if test="${not empty selectedCategoryId}">
                                        <c:param name="category_id" value="${selectedCategoryId}" />
                                    </c:if>
                                    <c:param name="priceRange" value="under10000" />
                                </c:url>

                                <a href="${under10000Url}"
                                   class="gift-filter-chip ${selectedPriceRange eq 'under10000' ? 'active' : ''}">
                                    1만원 이하
                                </a>


                                <c:url var="price10000Url" value="/product_gift.do">
                                    <c:if test="${not empty selectedCategoryId}">
                                        <c:param name="category_id" value="${selectedCategoryId}" />
                                    </c:if>
                                    <c:param name="priceRange" value="10000" />
                                </c:url>

                                <a href="${price10000Url}"
                                   class="gift-filter-chip ${selectedPriceRange eq '10000' ? 'active' : ''}">
                                    1만원대
                                </a>


                                <c:url var="price20000Url" value="/product_gift.do">
                                    <c:if test="${not empty selectedCategoryId}">
                                        <c:param name="category_id" value="${selectedCategoryId}" />
                                    </c:if>
                                    <c:param name="priceRange" value="20000" />
                                </c:url>

                                <a href="${price20000Url}"
                                   class="gift-filter-chip ${selectedPriceRange eq '20000' ? 'active' : ''}">
                                    2만원대
                                </a>


                                <c:url var="over30000Url" value="/product_gift.do">
                                    <c:if test="${not empty selectedCategoryId}">
                                        <c:param name="category_id" value="${selectedCategoryId}" />
                                    </c:if>
                                    <c:param name="priceRange" value="over30000" />
                                </c:url>

                                <a href="${over30000Url}"
                                   class="gift-filter-chip ${selectedPriceRange eq 'over30000' ? 'active' : ''}">
                                    3만원대 이상
                                </a>

                            </div>
                        </div>

                    </div>

                </div>
            </section>


            <!-- 로그인 회원 구매내역 기반 추천 -->
            <c:if test="${not empty personalGiftList}">
                <section class="gift-personal-section">
                    <div class="gift-inner">

                        <div class="gift-section-head">
                            <div>
                                <span>FOR YOU</span>

                                <h2>
                                    <c:choose>
                                        <c:when test="${not empty loginUserName}">
                                            ${loginUserName}님이 구매한 상품과 비슷한 선물
                                        </c:when>

                                        <c:otherwise>
                                            최근 구매와 비슷한 선물
                                        </c:otherwise>
                                    </c:choose>
                                </h2>

                                <p class="gift-section-desc">
                                    결제 완료한 상품의 카테고리를 기준으로 추천해드려요.
                                </p>
                            </div>
                        </div>

                        <div class="common-product-wrap">

                            <c:forEach var="vo" items="${personalGiftList}">
                                <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                            </c:forEach>

                        </div>

                    </div>
                </section>
            </c:if>


            <!-- 선택 조건 상품 목록 -->
            <section class="gift-product-section">
                <div class="gift-inner">

                    <div class="gift-section-head">
                        <div>
                            <span>GIFT ITEMS</span>

                            <h2>
                                <c:choose>
                                    <c:when test="${not empty selectedCategoryId or not empty selectedPriceRange}">
                                        선택한 조건의 선물 추천
                                    </c:when>

                                    <c:otherwise>
                                        선물하기 좋은 작품
                                    </c:otherwise>
                                </c:choose>
                            </h2>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty giftList}">
                            <div class="gift-ready-box">
                                <strong>상품이 없습니다</strong>
                                <p>선택한 조건에 맞는 상품이 없습니다.</p>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="common-product-wrap">

                                <c:forEach var="vo" items="${giftList}">
                                    <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                                </c:forEach>

                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
            </section>

        </main>
    </body>
</html>