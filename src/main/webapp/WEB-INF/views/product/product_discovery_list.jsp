<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>HANDMADE - 취향발견</title>

        <!-- 메인 상단바 공통 CSS -->
        <link rel="stylesheet" href="/css/product/product_main.css">

        <!-- 취향발견 전용 CSS -->
        <link rel="stylesheet" href="/css/product/product_discovery_list.css">

        <!-- 전체 카테고리 열고 닫는 JS -->
        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="discovery" />
    </jsp:include>


    <main class="discovery-page">

        <!-- 취향발견 상단 소개 영역 -->
        <section class="discovery-hero">

            <span>DISCOVERY</span>
            <h2>취향발견</h2>

            <c:choose>
                <c:when test="${isFallback}">
                    <p>
                        아직 취향 데이터가 부족해서 새롭게 등록된 작품을 먼저 보여드려요.
                        작품을 둘러볼수록 더 어울리는 작품을 추천할 수 있습니다.
                    </p>
                </c:when>

                <c:otherwise>
                    <p>
                        최근 둘러본 작품과 관심 카테고리를 바탕으로 어울리는 작품을 추천했어요.
                    </p>
                </c:otherwise>
            </c:choose>

        </section>


        <!-- 카테고리 바로가기 -->
        <section class="discovery-category-section">

            <div class="discovery-section-title">
                <h3>카테고리로 더 둘러보기</h3>
                <p>관심 있는 카테고리를 선택해 더 많은 작품을 확인해보세요.</p>
            </div>

            <div class="discovery-category-tabs">

                <c:forEach var="big" items="${bigCategoryList}">
                    <a href="/category_list.do?category_id=${big.category_id}">
                        ${big.name}
                    </a>
                </c:forEach>

            </div>

        </section>


        <!-- 추천 상품 목록 -->
        <section class="discovery-list-section">

            <div class="discovery-section-title">
                <h3>추천 작품</h3>

                <c:choose>
                    <c:when test="${isFallback}">
                        <p>취향 기록이 쌓이기 전까지는 최신 작품을 보여드립니다.</p>
                    </c:when>

                    <c:otherwise>
                        <p>최근 본 카테고리와 비슷한 작품을 모았습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>


            <c:choose>

                <c:when test="${empty list}">
                    <div class="discovery-empty">
                        추천할 상품이 없습니다.
                    </div>
                </c:when>

                <c:otherwise>

                    <div class="discovery-product-grid">

                        <c:forEach var="vo" items="${list}">

                            <a class="discovery-product-card"
                            href="/product_detail.do?product_id=${vo.product_id}">

                                <div class="discovery-product-img">

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

                                    <span class="discovery-heart">♡</span>

                                </div>

                                <div class="discovery-product-info">

                                    <div class="discovery-seller">
                                        HANDMADE 작가
                                    </div>

                                    <p class="discovery-product-name">
                                        ${vo.name}
                                    </p>

                                    <c:choose>

                                        <c:when test="${vo.sale_price > 0}">
                                            <p class="discovery-origin-price">
                                                <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                            </p>

                                            <p class="discovery-sale-price">
                                                <span>${vo.sale_rate}%</span>
                                                <strong>
                                                    <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                                </strong>
                                            </p>
                                        </c:when>

                                        <c:otherwise>
                                            <p class="discovery-normal-price">
                                                <strong>
                                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                                </strong>
                                            </p>
                                        </c:otherwise>

                                    </c:choose>


                                    <c:choose>
                                        <c:when test="${vo.delivery_fee == 0}">
                                            <p class="discovery-delivery">무료배송</p>
                                        </c:when>

                                        <c:when test="${vo.free_shipping > 0}">
                                            <p class="discovery-delivery">
                                                <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 무료배송
                                            </p>
                                        </c:when>

                                        <c:otherwise>
                                            <p class="discovery-delivery">
                                                배송비 <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                                            </p>
                                        </c:otherwise>
                                    </c:choose>

                                </div>

                            </a>

                        </c:forEach>

                    </div>

                </c:otherwise>

            </c:choose>

        </section>

    </main>

    </body>
</html>