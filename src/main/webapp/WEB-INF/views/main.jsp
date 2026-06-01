<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>HANDMADE</title>
    <link rel="stylesheet" href="/css/product.css">
</head>

<body>

<header class="product-header">

    <div class="product-util">
        <div class="product-util-inner">
            <a href="#" class="disabled">핸드메이드 앱 설치하기</a>

            <div class="product-util-menu">
                <a href="#" class="disabled">로그인</a>
                <a href="#" class="disabled">회원가입</a>
                <a href="#" class="disabled">고객센터</a>
            </div>
        </div>
    </div>

    <div class="product-header-inner">
        <a class="product-brand" href="/">
            HAND<span>MADE</span>
        </a>

        <div class="product-search-box disabled">
            찾으시는 작가, 작품이 있나요?
        </div>

        <div class="product-header-actions">
            <a href="/order/my">주문내역</a>
            <a href="#" class="disabled">♡ 관심</a>
            <a href="#" class="disabled">🛒 장바구니</a>
        </div>
    </div>

    <nav class="product-nav-bar">
        <div class="product-nav-inner">
            <a href="#" class="disabled">☰ 전체 카테고리</a>
            
            <div class="category-group">
                <a href="/category_list.do?category_id=1">패션/주얼리</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=7">주얼리</a>
                    <a href="/category_list.do?category_id=8">모자/스카프</a>
                    <a href="/category_list.do?category_id=9">아이웨어</a>
                    <a href="/category_list.do?category_id=10">기타</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=2">홈리빙</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=11">조명</a>
                    <a href="/category_list.do?category_id=12">생활용품</a>
                    <a href="/category_list.do?category_id=13">인테리어 소품</a>
                    <a href="/category_list.do?category_id=14">가구</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=3">뷰티</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=15">틴트/립스틱</a>
                    <a href="/category_list.do?category_id=16">베이스 메이크업</a>
                    <a href="/category_list.do?category_id=17">아이 메이크업</a>
                    <a href="/category_list.do?category_id=18">기타</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=4">식품</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=19">식단관리</a>
                    <a href="/category_list.do?category_id=20">초콜릿/젤리/캔디</a>
                    <a href="/category_list.do?category_id=21">간편식</a>
                    <a href="/category_list.do?category_id=22">베이커리</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=5">공예</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=23">비누</a>
                    <a href="/category_list.do?category_id=24">향수</a>
                    <a href="/category_list.do?category_id=25">도자기</a>
                    <a href="/category_list.do?category_id=26">키링</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=6">반려동물</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=27">의류/악세사리</a>
                    <a href="/category_list.do?category_id=28">사료/간식</a>
                    <a href="/category_list.do?category_id=29">산책용품</a>
                    <a href="/category_list.do?category_id=30">장난감</a>
                </div>
            </div>

            <a href="#" class="disabled">🎁 선물추천</a>
            <a href="/product_sale.do">🏷️ 할인</a>
            <a href="#" class="disabled">🏆 베스트</a>
            <a href="#" class="disabled">💛 취향발견</a>
            <a href="/all_list.do">🆕 최신작품</a>
            <a href="#" class="disabled">💬 후기</a>
        </div>
    </nav>

</header>

<section class="home-visual">
    <div class="home-visual-inner">

        <div class="home-main-banner">
            <span class="banner-label">HANDMADE MARKET</span>
            <h1>작가의 취향이 담긴<br>특별한 작품을 만나보세요</h1>
            <p>
                일상 속 작은 선물부터 나만의 취향을 담은 소품까지,
                손으로 만든 상품을 둘러보고 주문할 수 있습니다.
            </p>
        </div>

        <div class="home-side-banners">
            <div class="side-banner peach">
                <span>오늘의 추천</span>
                <strong>소중한 사람에게<br>전하기 좋은 선물</strong>
            </div>

            <div class="side-banner yellow">
                <span>NEW</span>
                <strong>새롭게 등록된<br>작가 상품</strong>
            </div>
        </div>

    </div>
</section>

<section class="quick-menu-wrap">
    <div class="quick-menu-inner">
        <!-- <button type="button" onclick="location.href='/category_list.do?category_id=1'">패션/악세사리</button>
        <button type="button" onclick="location.href='/category_list.do?category_id=2'">홈리빙</button>
        <button type="button" onclick="location.href='/category_list.do?category_id=3'">뷰티</button>
        <button type="button" onclick="location.href='/category_list.do?category_id=4'">식품</button>
        <button type="button" onclick="location.href='/category_list.do?category_id=5'">공예</button>
        <button type="button" onclick="location.href='/category_list.do?category_id=6'">반려동물</button> -->
    </div>
</section>

<main class="product-home">

    <section class="home-section">
        <div class="section-title-row">
            <div>
                <span>HANDMADE PRODUCTS</span>
                <h2>작가 상품 둘러보기</h2>
            </div>
            <p>마음에 드는 상품을 선택하면 상세 화면에서 주문할 수 있습니다.</p>
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
                        <img class="product-img" src="${vo.image_s}" alt="${vo.name}">
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
                                <c:when test="${vo.sale_price > 0 && vo.sale_price < vo.price}">
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
                <span>REVIEW BEST</span>
                <h2>고객 후기로 증명된 인기 상품</h2>
            </div>
            <p>많이 둘러본 상품을 한 번 더 모아봤습니다.</p>
        </div>

        <div class="review-best-grid">
            <c:forEach var="vo" items="${list}" varStatus="st">
                <c:if test="${st.index < 5}">
                    <a class="review-card" href="/product_detail.do?product_id=${vo.product_id}">
                        <img src="${vo.image_s}" alt="${vo.name}">
                        <div>
                            <span>♡</span>
                            <p>${vo.name}</p>
                            <strong>
                                <c:choose>
                                    <c:when test="${vo.sale_price > 0 && vo.sale_price < vo.price}">
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
            <p>카테고리별 인기 작품을 둘러보세요.</p>
        </div>

        <div class="rank-tabs">
            <button type="button" class="active">베누/클렌징</button>
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
                        <img src="${vo.image_s}" alt="${vo.name}">
                        <p>${vo.name}</p>
                        <strong>
                            <c:choose>
                                <c:when test="${vo.sale_price > 0 && vo.sale_price < vo.price}">
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
            <p>작가의 감성이 담긴 상품을 다시 추천합니다.</p>
        </div>

        <div class="wide-recommend-grid">
            <c:forEach var="vo" items="${list}" varStatus="st">
                <c:if test="${st.index < 4}">
                    <a class="wide-card" href="/product_detail.do?product_id=${vo.product_id}">
                        <img src="${vo.image_l}" alt="${vo.name}">
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
        <p>작가 상품을 둘러보고 마음에 드는 작품을 주문할 수 있습니다.</p>
    </div>
</footer>

</body>

</html>