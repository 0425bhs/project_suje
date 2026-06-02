<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        
    </head>

    <body>  

        <section class="product-list-page">

            <div class="product-list-header">
                <span>HANDMADE NEW</span>
                <h1>새로 등록된 작가 상품</h1>
                <p>최근 등록된 핸드메이드 작품을 만나보세요.</p>
            </div>

            <div class="product-grid">

                <c:forEach var="product" items="${list}">
                    <div class="product-card">

                        <a href="/product_detail.do?product_id=${product.product_id}" class="product-img-link">
                            <c:choose>
                                <c:when test="${not empty product.image_l and product.image_l ne 'no_file'}">
                                    <img src="${product.image_l}" class="product-img" alt="${product.name}">
                                </c:when>
                                <c:otherwise>
                                    <div class="no-image">이미지 없음</div>
                                </c:otherwise>
                            </c:choose>
                        </a>

                        <div class="product-info">

                            <a href="/product_detail.do?product_id=${product.product_id}" class="product-name">
                                ${product.name}
                            </a>

                            <p class="product-desc">
                                ${product.description}
                            </p>

                            <div class="product-price">
                                <strong>
                                    <fmt:formatNumber value="${product.sale_price > 0 ? product.sale_price : product.price}" pattern="#,###"/>원
                                </strong>
                            </div>

                        </div>

                    </div>
                </c:forEach>

            </div>

            <div class="page-menu">
                ${pageMenu}
            </div>

        </section>
    </body>
</html>