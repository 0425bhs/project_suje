    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

    <!DOCTYPE html>
    <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>HANDMADE</title>
            <link rel="stylesheet" href="/css/product/product_main.css">
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
                                    오늘만 만나는<br>
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

            <section class="home-section">
                <div class="section-title-row">
                    <div>
                        <span>HANDMADE PRODUCTS</span>
                        <h2>작가 상품 둘러보기</h2>
                    </div>
                </div>

                <div class="category-tabs">
                    <button type="button" class="active">전체</button>
                    <button type="button" class="disabled">액세서리</button>
                    <button type="button" class="disabled">생활소품</button>
                    <button type="button" class="disabled">선물추천</button>
                    <button type="button" class="disabled">인기상품</button>
                </div>

                <div class="product-grid compact">
                    <c:forEach var="vo" items="${list}">
                        <div class="product-card">
                            <a class="product-image-link" href="/product_detail.do?product_id=${vo.product_id}">
                                <c:choose>
                                    <c:when test="${not empty vo.image_s and vo.image_s ne 'no_file'}">
                                        <img class="product-img" src="${vo.image_s}" alt="${vo.name}">
                                    </c:when>
                                    <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                        <img class="product-img" src="${vo.image_l}" alt="${vo.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img class="product-img" src="/images/no_image.png" alt="이미지 없음">
                                    </c:otherwise>
                                </c:choose>
                            </a>

                            <div class="product-info">
                                <div class="product-label">작가 상품</div>

                                <h3>
                                    <a href="/product_detail.do?product_id=${vo.product_id}">
                                        ${vo.name}
                                    </a>
                                </h3>

                                <p class="product-desc">${vo.description}</p>

                                <div class="product-price">
                                    <c:choose>
                                        <c:when test="${vo.sale_price > 0 and vo.sale_price < vo.price}">
                                            <span>
                                                <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                            </span>
                                            <strong>${vo.sale_rate}% 할인</strong>
                                            <strong>
                                                <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                            </strong>
                                        </c:when>

                                        <c:otherwise>
                                            <strong>
                                                <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                            </strong>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="product-meta">
                                    <span>재고 ${vo.stock}개</span>

                                    <c:choose>
                                        <c:when test="${vo.delivery_fee == 0}">
                                            <span>무료배송</span>
                                        </c:when>

                                        <c:when test="${vo.free_shipping > 0}">
                                            <span>
                                                <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 무료배송
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span>
                                                배송비 <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="product-page-menu">
                    ${pageMenu}
                </div>
            </section>

            <section class="home-section">
                <div class="section-title-row">
                    <div>
                        <span>RECOMMEND</span>
                        <h2>추천 작가 상품</h2>
                    </div>
                </div>

                <div class="review-best-grid">
                    <c:forEach var="vo" items="${list}" varStatus="st">
                        <c:if test="${st.index < 5}">
                            <a class="review-card" href="/product_detail.do?product_id=${vo.product_id}">
                                <c:choose>
                                    <c:when test="${not empty vo.image_s and vo.image_s ne 'no_file'}">
                                        <img src="${vo.image_s}" alt="${vo.name}">
                                    </c:when>
                                    <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                        <img src="${vo.image_l}" alt="${vo.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/images/no_image.png" alt="이미지 없음">
                                    </c:otherwise>
                                </c:choose>

                                <div>
                                    <span>♡</span>
                                    <p>${vo.name}</p>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${vo.sale_price > 0 and vo.sale_price < vo.price}">
                                                <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
            </section>

            <section class="home-section">
                <div class="section-title-row">
                    <div>
                        <span>CATEGORY BEST</span>
                        <h2>카테고리 베스트</h2>
                    </div>
                </div>

                <div class="rank-tabs">
                    <button type="button" class="active">비누/클렌징</button>
                    <button type="button" class="disabled">반지</button>
                    <button type="button" class="disabled">키링</button>
                    <button type="button" class="disabled">주방용품</button>
                    <button type="button" class="disabled">디저트</button>
                    <button type="button" class="disabled">카드/편지지</button>
                </div>

                <div class="rank-grid">
                    <c:forEach var="vo" items="${list}" varStatus="st">
                        <c:if test="${st.index < 8}">
                            <a class="rank-card" href="/product_detail.do?product_id=${vo.product_id}">
                                <div class="rank-number">${st.index + 1}</div>

                                <c:choose>
                                    <c:when test="${not empty vo.image_s and vo.image_s ne 'no_file'}">
                                        <img src="${vo.image_s}" alt="${vo.name}">
                                    </c:when>
                                    <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                        <img src="${vo.image_l}" alt="${vo.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/images/no_image.png" alt="이미지 없음">
                                    </c:otherwise>
                                </c:choose>

                                <p>${vo.name}</p>
                                <strong>
                                    <c:choose>
                                        <c:when test="${vo.sale_price > 0 and vo.sale_price < vo.price}">
                                            <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
            </section>

            <section class="home-section">
                <div class="section-title-row">
                    <div>
                        <span>DISCOVERY</span>
                        <h2>취향 발견의 재미를 느껴보세요</h2>
                    </div>
                </div>

                <div class="wide-recommend-grid">
                    <c:forEach var="vo" items="${list}" varStatus="st">
                        <c:if test="${st.index < 4}">
                            <a class="wide-card" href="/product_detail.do?product_id=${vo.product_id}">
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

                                <div>
                                    <span>작가 상품</span>
                                    <p>${vo.name}</p>
                                </div>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
            </section>

        </main>

        <footer class="product-footer">
            <div class="product-footer-inner">
                <strong>HANDMADE</strong>
            </div>
        </footer>

        </body>

    </html>