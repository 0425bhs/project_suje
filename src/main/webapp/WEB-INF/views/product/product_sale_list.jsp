<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>할인 상품</title>

        <!-- 메인 헤더 공통 CSS -->
        <link rel="stylesheet" href="/css/product/product.css">

        <!-- 할인 페이지 전용 CSS -->
        <link rel="stylesheet" href="/css/product/product_sale_list.css">
    </head>

    <body>

    <header class="product-header">

        <div class="product-util">
            <div class="product-util-inner">
                <span>작가의 손길이 담긴 핸드메이드 마켓</span>

                <div class="product-util-menu">
                    <a href="#" class="disabled">로그인</a>
                    <a href="#" class="disabled">회원가입</a>
                    <a href="#" class="disabled">고객센터</a>
                </div>
            </div>
        </div>

        <div class="product-header-inner">
            <a class="product-brand" href="/main.do">
                HAND<span>MADE</span>
            </a>

            <div class="product-search-box disabled">
                찾으시는 작가, 작품이 있나요?
            </div>

            <div class="product-header-actions">
                <a href="/order/my">주문내역</a>
                <a href="/seller_product_list.do">판매자센터</a>
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
                <a href="/product_sale.do" class="active">🏷️ 할인</a>
                <a href="#" class="disabled">🏆 베스트</a>
                <a href="#" class="disabled">💛 취향발견</a>
                <a href="/all_list.do">🆕 최신작품</a>
                <a href="#" class="disabled">💬 후기</a>
            </div>
        </nav>

    </header>

    <section class="sale-page">

        <!-- 할인 분류 탭 -->
        <div class="sale-tab-area">
            <button type="button" class="sale-tab active">전체</button>
            <button type="button" class="sale-tab">깜짝할인</button>
            <button type="button" class="sale-tab">d+할인</button>
            <button type="button" class="sale-tab">월할인</button>
            <button type="button" class="sale-tab">오늘만할인</button>
            <button type="button" class="sale-tab">시즌할인</button>
        </div>

        <!-- 필터 버튼 -->
        <div class="filter-chip-area">
            <button type="button" class="filter-chip">쿠폰/할인</button>
            <button type="button" class="filter-chip">예상출발일</button>
            <button type="button" class="filter-chip">가격대</button>
            <button type="button" class="filter-chip">작품 특징</button>
            <button type="button" class="filter-chip">카테고리</button>
        </div>

        <!-- 정렬 -->
        <div class="sort-row">
            <div class="sort-area">
                <button type="button" class="sort-btn active">인기순</button>
                <button type="button" class="sort-btn">최신순(NEW)</button>
                <button type="button" class="sort-btn">찜 많은순</button>
                <button type="button" class="sort-btn">구매후기 많은순</button>
                <button type="button" class="sort-btn">판매수 많은순</button>
                <button type="button" class="sort-btn">할인율 높은순</button>
                <button type="button" class="sort-btn">낮은 가격순</button>
                <button type="button" class="sort-btn">높은 가격순</button>
            </div>

            <label class="image-only-check">
                <input type="checkbox">
                이미지만 볼래요
            </label>
        </div>

        <div class="sale-total">
            총 <strong>${empty list ? 0 : list.size()}</strong>개
        </div>

        <div class="product-grid">

            <c:forEach var="product" items="${list}">
                <c:if test="${product.sale_price > 0 and product.sale_price < product.price}">
                    <div class="product-card">

                        <a href="/product_detail.do?product_id=${product.product_id}" class="product-img-link">
                            <c:choose>
                                <c:when test="${not empty product.image_l and product.image_l ne 'no_file'}">
                                    <img src="${product.image_l}" class="product-img" alt="${product.name}">
                                </c:when>

                                <c:when test="${not empty product.image_s and product.image_s ne 'no_file'}">
                                    <img src="${product.image_s}" class="product-img" alt="${product.name}">
                                </c:when>

                                <c:otherwise>
                                    <div class="no-image">이미지 없음</div>
                                </c:otherwise>
                            </c:choose>

                            <span class="discount-badge">
                                <fmt:formatNumber value="${(product.price - product.sale_price) * 100 / product.price}" maxFractionDigits="0"/>%
                            </span>

                            <span class="wish-btn">♡</span>
                        </a>

                        <div class="product-info">

                            <a href="/product_detail.do?product_id=${product.product_id}" class="product-name">
                                ${product.name}
                            </a>

                            <div class="product-price">
                                <span class="discount-rate">
                                    <fmt:formatNumber value="${(product.price - product.sale_price) * 100 / product.price}" maxFractionDigits="0"/>%
                                </span>

                                <strong class="sale-price">
                                    <fmt:formatNumber value="${product.sale_price}" pattern="#,###"/>원
                                </strong>
                            </div>

                            <div class="origin-price">
                                <fmt:formatNumber value="${product.price}" pattern="#,###"/>원
                            </div>

                        </div>

                    </div>
                </c:if>
            </c:forEach>

        </div>

        <div class="page-menu">
            ${pageMenu}
        </div>

    </section>

    <footer class="product-footer">
        <div class="product-footer-inner">
            <strong>HANDMADE</strong>
            <p>작가 상품을 둘러보고 마음에 드는 작품을 주문할 수 있습니다.</p>
        </div>
    </footer>

    </body>
</html>