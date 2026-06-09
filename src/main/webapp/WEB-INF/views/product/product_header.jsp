<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<header class="product-header">

    <!-- 상단 작은 유틸 영역 -->
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


    <!-- 로고 / 전체 카테고리 / 검색창 / 우측 메뉴 -->
    <div class="product-header-inner">

        <a class="product-brand" href="/">
            HAND<span>MADE</span>
        </a>


        <!-- 전체 카테고리 -->
        <div class="all-category-wrap">

            <button type="button" class="all-category-btn">
                ☰ 전체 카테고리
            </button>

            <div class="all-category-panel">

                <c:forEach var="big" items="${bigCategoryList}">

                    <div class="all-category-item">

                        <a href="/category_list.do?category_id=${big.category_id}"
                           class="all-category-big">
                            ${big.name}
                        </a>

                        <div class="all-category-small-list">

                            <a href="/category_list.do?category_id=${big.category_id}">
                                전체
                            </a>

                            <c:forEach var="small" items="${smallCategoryList}">
                                <c:if test="${small.parent_id == big.category_id}">
                                    <a href="/category_list.do?category_id=${small.category_id}">
                                        ${small.name}
                                    </a>
                                </c:if>
                            </c:forEach>

                        </div>

                    </div>

                </c:forEach>

            </div>
        </div>


        <!-- 검색창 -->
        <form class="product-search-box" action="/product_search.do" method="get">

            <input type="text" 
                   name="keyword" 
                   value="${param.keyword}"
                   placeholder="찾으시는 작가, 작품이 있나요?"
                   autocomplete="off" />

            <button type="submit" aria-label="검색">🔍</button>

        </form>


        <!-- 우측 메뉴 -->
        <div class="product-header-actions">
            <a href="/order/my">주문내역</a>
            <a href="/seller_product_list.do">판매자센터</a>
            <a href="#" class="disabled">♡ 관심</a>
            <a href="/cart_list.do">🛒 장바구니</a>
        </div>

    </div>


    <!-- 하단 메뉴 -->
    <nav class="product-nav-bar">
        <div class="product-nav-inner">

            <a href="#" class="disabled">🎁 선물추천</a>

            <a href="/product_sale.do"
               class="${param.activeMenu eq 'sale' ? 'nav-active' : ''}">
                🏷️ 할인
            </a>

            <a href="/product_best.do"
               class="${param.activeMenu eq 'best' ? 'nav-active' : ''}">
                🏆 베스트
            </a>
            
            <a href="/product_discovery.do"
               class="${param.activeMenu eq 'discovery' ? 'nav-active' : ''}">
                💛 취향발견
            </a>

            <a href="/all_list.do"
               class="${param.activeMenu eq 'new' ? '   ' : ''}">
                🆕 최신 작품
            </a>

            <a href="/live_review_list.do"
               class="${param.activeMenu eq 'live' ? 'nav-active' : ''}">
               💬 실시간 후기
            </a>

        </div>
    </nav>

</header>