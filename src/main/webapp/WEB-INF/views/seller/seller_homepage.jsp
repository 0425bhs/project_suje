<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>판매자 홈페이지</title>

        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="/css/seller/seller_homepage.css">

        <script src="/js/seller_homepage.js"></script>
    </head>

    <body>

    <div class="seller-board">

        <jsp:include page="seller_sidebar.jsp">
            <jsp:param name="activeMenu" value="homepage"/>
            <jsp:param name="sidebarTitle" value="판매자 홈페이지" />
        </jsp:include>

        <main class="seller-main">

            <header class="seller-main-header">
                <div>
                    <span class="page-label">판매자 페이지</span>
                    <h1>판매자 홈페이지</h1>
                </div>
            </header>

            <section class="seller-homepage-box">

                <div class="sort-box">

                    <a href="/seller_homepage.do?seller_id=${seller_id}&sort=rank"
                       class="${sort eq 'rank' or empty sort ? 'active' : ''}">
                        랭킹순
                    </a>

                    <span>|</span>

                    <a href="/seller_homepage.do?seller_id=${seller_id}&sort=lowPrice"
                       class="${sort eq 'lowPrice' ? 'active' : ''}">
                        낮은가격순
                    </a>

                    <span>|</span>

                    <a href="/seller_homepage.do?seller_id=${seller_id}&sort=highPrice"
                       class="${sort eq 'highPrice' ? 'active' : ''}">
                        높은가격순
                    </a>

                    <span>|</span>

                    <a href="/seller_homepage.do?seller_id=${seller_id}&sort=sales"
                       class="${sort eq 'sales' ? 'active' : ''}">
                        판매량순
                    </a>

                    <span>|</span>

                    <a href="/seller_homepage.do?seller_id=${seller_id}&sort=new"
                       class="${sort eq 'new' ? 'active' : ''}">
                        최신순
                    </a>

                </div>

                <div class="seller-product-grid">

                    <c:forEach var="vo" items="${list}">
                        <div class="product-card" data-product-id="${vo.product_id}">

                            <a href="/product_detail.do?product_id=${vo.product_id}">
                                <img src="${vo.image_l}" alt="${vo.name}">
                            </a>

                            <div class="product-card-name">
                                <a href="/product_detail.do?product_id=${vo.product_id}">
                                    ${vo.name}
                                </a>
                            </div>

                            <c:if test="${vo.sale_price == 0}">
                                <p class="product-price">
                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                </p>
                            </c:if>

                            <c:if test="${vo.sale_price > 0 and vo.sale_price < vo.price}">
                                <p class="origin-price">
                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                </p>

                                <p class="sale-price">
                                    <strong>${vo.sale_rate}% 할인</strong>
                                    <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                </p>
                            </c:if>

                            <c:choose>
                                <c:when test="${vo.delivery_fee == 0}">
                                    <p class="delivery-info">무료배송</p>
                                </c:when>

                                <c:when test="${vo.free_shipping > 0}">
                                    <p class="delivery-info">
                                        <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 무료배송
                                    </p>
                                </c:when>

                                <c:otherwise>
                                    <p class="delivery-info">
                                        배송비 <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                                    </p>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </c:forEach>

                </div>

            </section>

        </main>

    </div>

    </body>
</html>