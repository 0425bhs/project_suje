<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <link rel="stylesheet" href="/css/seller/seller_homepage.css">
    <link rel="stylesheet" href="/css/seller/seller_product_list.css">
    <script src="/js/seller_homepage.js"></script>
</head>

<body>



    <div class="seller-board">

        <jsp:include page="seller_sidebar.jsp">
            <jsp:param name="activeMenu" value="homepage"/>
            <jsp:param name="sidebarTitle" value="판매자 홈페이지" />
        </jsp:include>

        <h2>홈페이지</h2>
            
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

        <c:forEach var="list" items="${list}">
            <div class="product-card" data-product-id="${list.product_id}">
                <img src="${list.image_l}" alt="${list.name}"/>

                <div>
                    <a href="/product_detail.do?product_id=${list.product_id}">
                        ${list.name}
                    </a>
                </div>

                <c:if test="${list.sale_price==0}">
                    <p>
                        <fmt:formatNumber value="${list.price}" pattern="#,###"/>원
                    </p>
                </c:if>

                <c:if test="${list.sale_price>0}">
                    <p>
                        <span style="text-decoration: line-through; color: gray;">
                            <fmt:formatNumber value="${list.price}" pattern="#,###"/>원
                        </span>
                    </p>

                    <p>
                        <strong>${list.sale_rate}% 할인</strong>
                        <fmt:formatNumber value="${list.sale_price}" pattern="#,###"/>원
                    </p>
                </c:if>

                <c:if test="${list.free_shipping>0}">
                    <p>
                        <fmt:formatNumber value="${list.free_shipping}" pattern="#,###"/>원 이상 무료배송
                    </p>
                </c:if>

                <c:if test="${list.free_shipping==0}">
                    <p>무료배송</p>
                </c:if>
            </div>
        </c:forEach>
    </div>
</body>
</html>