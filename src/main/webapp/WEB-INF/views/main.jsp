<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>HANDMADE</title>

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_card.css">

        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="main" />
    </jsp:include>

    <section class="home-visual">
        <div class="home-visual-inner">

            <!-- 메인 배너 슬라이드 -->
            <div class="home-main-slider" id="mainHeroSlider">

                <div class="home-slide-track" id="mainHeroTrack">

                    <a href="/product_discovery.do" class="home-main-banner hero-slide"
                    style="background-image: url('/images/banner/main_banner_01.jpg');">
                        <div class="hero-slide-content">
                            <span class="banner-label">HANDMADE MARKET</span>
                            <h1>
                                작가의 취향이 담긴<br>
                                특별한 작품을 만나보세요
                            </h1>
                            <p>
                                일상 속 작은 선물부터 나만의 취향을 담은 소품까지,
                                손으로 만든 상품을 둘러보고 주문할 수 있습니다.
                            </p>
                        </div>
                    </a>

                    <a href="/product_sale.do" class="home-main-banner hero-slide"
                    style="background-image: url('/images/banner/main_banner_02.jpg');">
                        <div class="hero-slide-content">
                            <span class="banner-label">SALE EVENT</span>
                            <h1>
                                지금 진행 중인<br>
                                특별 할인 작품
                            </h1>
                            <p>
                                인기 작가 상품을 합리적인 가격으로 만나보세요.
                                할인 중인 작품들을 한눈에 확인할 수 있습니다.
                            </p>
                        </div>
                    </a>

                    <a href="/product_best.do" class="home-main-banner hero-slide"
                    style="background-image: url('/images/banner/main_banner_03.jpg');">
                        <div class="hero-slide-content">
                            <span class="banner-label">BEST ITEM</span>
                            <h1>
                                지금 가장 인기 있는<br>
                                핸드메이드 작품
                            </h1>
                            <p>
                                많은 사람들이 찾는 베스트 작품을 확인하고,
                                마음에 드는 상품을 바로 주문해보세요.
                            </p>
                        </div>
                    </a>

                </div>

                <button type="button" class="hero-slide-btn hero-prev" id="mainHeroPrev">‹</button>
                <button type="button" class="hero-slide-btn hero-next" id="mainHeroNext">›</button>

                <div class="hero-slide-dots" id="mainHeroDots"></div>
            </div>

            <!-- 오른쪽 작은 배너 -->
            <div class="home-side-banners">
                <a href="/product_discovery.do" class="side-banner peach">
                    <span>오늘의 추천</span>
                    <strong>
                        소중한 사람에게<br>
                        전하기 좋은 선물
                    </strong>
                </a>

                <a href="/all_list.do" class="side-banner yellow">
                    <span>NEW</span>
                    <strong>
                        새롭게 등록된<br>
                        작가 상품
                    </strong>
                </a>
            </div>

        </div>
    </section>

    <main class="product-home">

        <!-- 작가 상품 둘러보기 -->
        <section class="home-section">
            <div class="section-title-row">
                <div>
                    <span>HANDMADE PRODUCTS</span>
                    <h2>작가 상품 둘러보기</h2>
                </div>
            </div>

            <div class="category-tabs">
                <button type="button" class="active"
                        onclick="location.href='/all_list.do'">전체</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=1&sort=new'">패션·주얼리</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=2&sort=new'">홈리빙</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=3&sort=new'">뷰티</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=4&sort=new'">식품</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=5&sort=new'">공예</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=6&sort=new'">반려동물</button>
            </div>

            <c:choose>
                <c:when test="${empty mainProductList}">
                    <p>등록된 상품이 없습니다.</p>
                </c:when>

                <c:otherwise>
                    <div class="common-product-wrap">
                        <c:forEach var="vo" items="${mainProductList}">
                            <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>


        <!-- 추천 작가 상품 -->
        <section class="home-section">
            <div class="section-title-row">
                <div>
                    <span>RECOMMEND</span>
                    <h2>추천 작가 상품</h2>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty recommendList}">
                    <p>추천 상품이 없습니다.</p>
                </c:when>

                <c:otherwise>
                    <div class="common-product-wrap">
                        <c:forEach var="vo" items="${recommendList}" varStatus="st">
                            <c:if test="${st.index < 10}">
                                <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>


        <!-- 카테고리 베스트 -->
        <section class="home-section">
            <div class="section-title-row">
                <div>
                    <span>CATEGORY BEST</span>
                    <h2>카테고리 베스트</h2>
                </div>
            </div>

            <div class="rank-tabs">
                <button type="button" class="active"
                        onclick="location.href='/category_list.do?category_id=23&sort=popular'">비누</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=7&sort=popular'">주얼리</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=26&sort=popular'">키링</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=12&sort=popular'">생활용품</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=22&sort=popular'">베이커리</button>

                <button type="button"
                        onclick="location.href='/category_list.do?category_id=24&sort=popular'">향수</button>
            </div>

            <c:choose>
                <c:when test="${empty categoryBestList}">
                    <p>카테고리 베스트 상품이 없습니다.</p>
                </c:when>

                <c:otherwise>
                    <div class="common-product-wrap">
                        <c:forEach var="vo" items="${categoryBestList}">
                            <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>


        <!-- 취향 발견 -->
        <section class="home-section">
            <div class="section-title-row">
                <div>
                    <span>DISCOVERY</span>
                    <h2>취향 발견의 재미를 느껴보세요</h2>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty discoveryList}">
                    <p>추천할 상품이 없습니다.</p>
                </c:when>

                <c:otherwise>
                    <div class="common-product-wrap">
                        <c:forEach var="vo" items="${discoveryList}">
                            <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

    </main>

    <footer class="product-footer">
        <div class="product-footer-inner">
            <strong>HANDMADE</strong>
        </div>
    </footer>

    </body>
</html>