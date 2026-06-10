<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<header class="product-header">

    <!-- 상단 유틸 영역 -->
    <div class="product-util">
        <div class="product-util-inner">
            <span>작가의 손길이 담긴 핸드메이드 마켓</span>

            <div class="product-util-menu">

                <!-- 로그인 전 -->
                <c:if test="${empty sessionScope.user}">
                    <a href="/login.do">로그인</a>
                    <a href="/join.do">회원가입</a>
                </c:if>

                <!-- 로그인 후 -->
                <c:if test="${not empty sessionScope.user}">
                    <span>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.name}">
                                ${sessionScope.user.name}님
                            </c:when>

                            <c:when test="${not empty sessionScope.user.nick_name}">
                                ${sessionScope.user.nick_name}님
                            </c:when>

                            <c:otherwise>
                                회원님
                            </c:otherwise>
                        </c:choose>
                    </span>

                    <a href="#"
                       onclick="alert('로그아웃 기능은 아직 연결되지 않았습니다.'); return false;">
                        로그아웃
                    </a>
                </c:if>

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

            <!-- 로그인 후에만 주문내역 표시 -->
            <c:if test="${not empty sessionScope.user}">
                <a href="/order/my">주문내역</a>
            </c:if>

            <!-- 판매자센터는 현재 그대로 노출 -->
            <a href="/seller_product_list.do">판매자센터</a>

            <a href="#" class="disabled">♡ 관심</a>
            <a href="#" class="disabled">🛒 장바구니</a>
        </div>

    </div>


    <!-- 하단 메뉴 -->
    <nav class="product-nav-bar">
        <div class="product-nav-inner">

            <a href="/product_gift.do" 
               class="${param.activeMenu eq 'gift' ? 'nav-active' : ''}">
                🎁 선물추천
            </a>

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
               class="${param.activeMenu eq 'new' ? 'nav-active' : ''}">
                🆕 최신작품
            </a>

            <a href="#" class="disabled">
                💬 후기
            </a>

        </div>
    </nav>

</header>