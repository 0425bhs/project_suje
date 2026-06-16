<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>선물추천</title>

        <!-- 상품 페이지 공통 레이아웃 CSS -->
        <link rel="stylesheet" href="/css/product/product_main.css">

        <!-- 공통 상품 카드 디자인 CSS -->
        <link rel="stylesheet" href="/css/product/product_card.css">

        <!-- 선물추천 페이지 전용 CSS -->
        <link rel="stylesheet" href="/css/product/product_gift.css?v=9">

        <!-- 상품 공통 헤더, 카테고리 메뉴 관련 JS -->
        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <!-- 상품 공통 헤더에서 선물추천 메뉴 활성화 -->
    <jsp:include page="product_header.jsp">
        <jsp:param name="activeMenu" value="gift" />
    </jsp:include>

    <main class="gift-page">

        <!-- 선물 조건 선택 영역 -->
        <section class="gift-finder-section">
            <div class="gift-inner">

                <div class="gift-main-title">
                    <h1>선물추천</h1>
                </div>

                <div class="gift-finder-area">

                    <!-- 상황 선택 -->
                    <div class="gift-finder-group">
                        <div class="gift-finder-label">
                            어떤 선물인가요?
                        </div>

                        <div class="gift-finder-options">

                            <a href="/product_gift.do?target=${selectedTarget}&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${empty selectedOccasion ? 'active' : ''}">
                                전체
                            </a>

                            <a href="/product_gift.do?occasion=birthday&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedOccasion eq 'birthday' ? 'active' : ''}">
                                생일
                            </a>

                            <a href="/product_gift.do?occasion=house&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedOccasion eq 'house' ? 'active' : ''}">
                                집들이·개업
                            </a>

                            <a href="/product_gift.do?occasion=thanks&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedOccasion eq 'thanks' ? 'active' : ''}">
                                감사·답례
                            </a>

                            <a href="/product_gift.do?occasion=couple&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedOccasion eq 'couple' ? 'active' : ''}">
                                커플·기념일
                            </a>

                            <a href="/product_gift.do?occasion=pet&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedOccasion eq 'pet' ? 'active' : ''}">
                                반려동물
                            </a>

                            <a href="/product_gift.do?occasion=self&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedOccasion eq 'self' ? 'active' : ''}">
                                나를 위한 선물
                            </a>

                        </div>
                    </div>


                    <!-- 대상 선택 -->
                    <div class="gift-finder-group">
                        <div class="gift-finder-label">
                            누구에게 선물하나요?
                        </div>

                        <div class="gift-finder-options">

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${empty selectedTarget ? 'active' : ''}">
                                전체
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=friend&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedTarget eq 'friend' ? 'active' : ''}">
                                친구
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=lover&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedTarget eq 'lover' ? 'active' : ''}">
                                연인
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=parents&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedTarget eq 'parents' ? 'active' : ''}">
                                부모님
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=coworker&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedTarget eq 'coworker' ? 'active' : ''}">
                                직장동료
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=petOwner&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedTarget eq 'petOwner' ? 'active' : ''}">
                                반려동물 집사
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=me&amp;priceRange=${selectedPriceRange}"
                            class="gift-finder-chip ${selectedTarget eq 'me' ? 'active' : ''}">
                                나
                            </a>

                        </div>
                    </div>


                    <!-- 예산 선택 -->
                    <div class="gift-finder-group">
                        <div class="gift-finder-label">
                            예산은 어느 정도인가요?
                        </div>

                        <div class="gift-finder-options">

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}"
                            class="gift-finder-chip ${empty selectedPriceRange ? 'active' : ''}">
                                전체
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}&amp;priceRange=under10000"
                            class="gift-finder-chip ${selectedPriceRange eq 'under10000' ? 'active' : ''}">
                                1만원 이하
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}&amp;priceRange=10000"
                            class="gift-finder-chip ${selectedPriceRange eq '10000' ? 'active' : ''}">
                                1만원대
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}&amp;priceRange=20000"
                            class="gift-finder-chip ${selectedPriceRange eq '20000' ? 'active' : ''}">
                                2만원대
                            </a>

                            <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}&amp;priceRange=over30000"
                            class="gift-finder-chip ${selectedPriceRange eq 'over30000' ? 'active' : ''}">
                                3만원 이상
                            </a>

                        </div>
                    </div>

                </div>


                <!-- 선택한 조건 요약 -->
                <div class="gift-selected-box">

                    <div class="gift-selected-tags">

                        <c:choose>
                            <c:when test="${empty selectedOccasionName and empty selectedTargetName and empty selectedPriceRangeName}">
                                <span>전체 선물</span>
                            </c:when>

                            <c:otherwise>
                                <c:if test="${not empty selectedOccasionName}">
                                    <span>${selectedOccasionName}</span>
                                </c:if>

                                <c:if test="${not empty selectedTargetName}">
                                    <span>${selectedTargetName}</span>
                                </c:if>

                                <c:if test="${not empty selectedPriceRangeName}">
                                    <span>${selectedPriceRangeName}</span>
                                </c:if>
                            </c:otherwise>
                        </c:choose>

                    </div>

                    <p>${giftGuideText}</p>

                </div>


                <!-- 인기 선물 키워드 -->
                <div class="gift-keyword-row">
                    <strong>인기 선물 키워드</strong>

                    <div>
                        <a href="/product_gift.do?occasion=thanks&amp;priceRange=10000">수제 디저트</a>
                        <a href="/product_gift.do?occasion=couple">향수</a>
                        <a href="/product_gift.do?target=friend&amp;priceRange=10000">키링</a>
                        <a href="/product_gift.do?occasion=birthday">주얼리</a>
                        <a href="/product_gift.do?occasion=house">생활소품</a>
                        <a href="/product_gift.do?target=petOwner">반려동물 용품</a>
                    </div>
                </div>

            </div>
        </section>


        <!-- 로그인 회원의 구매내역 기반 개인 추천 영역 -->
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

                    <!-- 개인 추천 상품 목록 -->
                    <div class="common-product-wrap">
                        <c:forEach var="vo" items="${personalGiftList}">
                            <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                        </c:forEach>
                    </div>

                </div>
            </section>
        </c:if>


        <!-- 선택 조건에 맞는 선물 추천 결과 -->
        <section class="gift-product-section">
            <div class="gift-inner">

                <div class="gift-section-head">
                    <div>
                        <span>GIFT RESULT</span>

                        <h2>
                            <c:choose>
                                <c:when test="${not empty selectedOccasionName or not empty selectedTargetName or not empty selectedPriceRangeName}">
                                    선택한 조건에 맞는 선물
                                </c:when>

                                <c:otherwise>
                                    지금 선물하기 좋은 작품
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