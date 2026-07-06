<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>선물추천</title>

    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/product/product_card.css">
    <link rel="stylesheet" href="/css/product/product_gift.css?v=11">

    <script src="/js/product_main.js" defer></script>
</head>

<body>

<jsp:include page="product_header.jsp">
    <jsp:param name="activeMenu" value="gift" />
</jsp:include>

<main class="gift-page">
    <div class="gift-inner">

        <div class="gift-title-row">
            <div>
                <h1>선물추천</h1>
                <p>소중한 사람을 위한 선물을 조건에 맞춰 찾아보세요.</p>
            </div>

            <a class="gift-reset-link" href="/product_gift.do#giftResult">조건 초기화</a>
        </div>

        <div class="gift-layout">

            <aside class="gift-side-panel">
                <div class="gift-side-title">
                    <strong>선물 조건</strong>
                    <span>🎁</span>
                </div>

                <div class="gift-selected-summary">
                    <div class="gift-summary-item">
                        <span>어떤 선물인가요?</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty selectedOccasionName}">${selectedOccasionName}</c:when>
                                <c:otherwise>전체</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                    <div class="gift-summary-item">
                        <span>누구에게 선물하나요?</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty selectedTargetName}">${selectedTargetName}</c:when>
                                <c:otherwise>전체</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                    <div class="gift-summary-item">
                        <span>예산은 어느 정도인가요?</span>
                        <strong>
                            <c:choose>
                                <c:when test="${not empty selectedPriceRangeName}">${selectedPriceRangeName}</c:when>
                                <c:otherwise>전체 예산</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>
                </div>

                <div class="gift-filter-group">
                    <div class="gift-filter-label">1. 어떤 선물인가요?</div>

                    <div class="gift-filter-options">
                        <a href="/product_gift.do?target=${selectedTarget}&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${empty selectedOccasion ? 'active' : ''}">전체</a>

                        <a href="/product_gift.do?occasion=birthday&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedOccasion eq 'birthday' ? 'active' : ''}">생일</a>

                        <a href="/product_gift.do?occasion=house&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedOccasion eq 'house' ? 'active' : ''}">집들이·개업</a>

                        <a href="/product_gift.do?occasion=thanks&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedOccasion eq 'thanks' ? 'active' : ''}">감사·답례</a>

                        <a href="/product_gift.do?occasion=couple&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedOccasion eq 'couple' ? 'active' : ''}">커플·기념일</a>

                        <a href="/product_gift.do?occasion=pet&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedOccasion eq 'pet' ? 'active' : ''}">반려동물</a>

                        <a href="/product_gift.do?occasion=self&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedOccasion eq 'self' ? 'active' : ''}">나를 위한 선물</a>
                    </div>
                </div>

                <div class="gift-filter-group">
                    <div class="gift-filter-label">2. 누구에게 선물하나요?</div>

                    <div class="gift-filter-options">
                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${empty selectedTarget ? 'active' : ''}">전체</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=friend&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedTarget eq 'friend' ? 'active' : ''}">친구</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=lover&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedTarget eq 'lover' ? 'active' : ''}">연인</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=parents&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedTarget eq 'parents' ? 'active' : ''}">부모님</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=coworker&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedTarget eq 'coworker' ? 'active' : ''}">직장동료</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=petOwner&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedTarget eq 'petOwner' ? 'active' : ''}">반려동물 집사</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=me&amp;priceRange=${selectedPriceRange}#giftResult"
                           class="gift-filter-chip ${selectedTarget eq 'me' ? 'active' : ''}">나</a>
                    </div>
                </div>

                <div class="gift-filter-group">
                    <div class="gift-filter-label">3. 예산은 어느 정도인가요?</div>

                    <div class="gift-filter-options">
                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}#giftResult"
                           class="gift-filter-chip ${empty selectedPriceRange ? 'active' : ''}">전체</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}&amp;priceRange=under10000#giftResult"
                           class="gift-filter-chip ${selectedPriceRange eq 'under10000' ? 'active' : ''}">1만원 이하</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}&amp;priceRange=10000#giftResult"
                           class="gift-filter-chip ${selectedPriceRange eq '10000' ? 'active' : ''}">1만원대</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}&amp;priceRange=20000#giftResult"
                           class="gift-filter-chip ${selectedPriceRange eq '20000' ? 'active' : ''}">2만원대</a>

                        <a href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}&amp;priceRange=over30000#giftResult"
                           class="gift-filter-chip ${selectedPriceRange eq 'over30000' ? 'active' : ''}">3만원 이상</a>
                    </div>
                </div>

                <a class="gift-submit-btn"
                   href="/product_gift.do?occasion=${selectedOccasion}&amp;target=${selectedTarget}&amp;priceRange=${selectedPriceRange}#giftResult">
                    추천 선물 보기
                </a>
            </aside>

            <section class="gift-content-area" id="giftResult">

                <div class="gift-guide-box">
                    <div>
                        <span class="gift-guide-label">추천 안내</span>
                        <p>${giftGuideText}</p>
                    </div>
                </div>

                <div class="gift-keyword-row">
                    <strong>인기 키워드</strong>

                    <div>
                        <a href="/product_gift.do?occasion=thanks&amp;priceRange=10000#giftResult">수제 디저트</a>
                        <a href="/product_gift.do?occasion=couple#giftResult">향수</a>
                        <a href="/product_gift.do?target=friend&amp;priceRange=10000#giftResult">키링</a>
                        <a href="/product_gift.do?occasion=birthday#giftResult">주얼리</a>
                        <a href="/product_gift.do?occasion=house#giftResult">생활소품</a>
                        <a href="/product_gift.do?target=petOwner#giftResult">반려동물 용품</a>
                    </div>
                </div>

                <c:if test="${not empty personalGiftList}">
                    <section class="gift-personal-section">
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
                    </section>
                </c:if>

                <section class="gift-product-section">
                    <div class="gift-section-head">
                        <div>
                            <span>GIFT RESULT</span>

                            <h2>
                                추천 선물
                                <c:if test="${not empty giftList}">
                                    <em>${fn:length(giftList)}개</em>
                                </c:if>
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
                </section>

            </section>
        </div>
    </div>
</main>

</body>
</html>