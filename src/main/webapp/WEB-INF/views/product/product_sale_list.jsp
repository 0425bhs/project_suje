<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head></head>

    <body>

        <h2>세일 상품</h2>

            <c:forEach var="list" items="${list}">
                <div>
                    <img src="${list.image_l}" alt="${list.name}" width="200"/>

                    <h3>
                        <a href="/product_detail.do?product_id=${list.product_id}">
                            ${list.name}
                        </a>
                    </h3>

                    <p>
                        <span style="text-decoration: line-through; color: gray;">
                            <fmt:formatNumber value="${list.price}" pattern="#,###"/>원
                        </span>
                    </p>

                    <p>
                        <strong>${list.sale_rate}% 할인</strong>
                        <fmt:formatNumber value="${list.sale_price}" pattern="#,###"/>원
                    </p>

                    <c:if test="${list.free_shipping > 0}">
                        <p>
                            <fmt:formatNumber value="${list.free_shipping}" pattern="#,###"/>원 이상 무료배송
                        </p>
                    </c:if>

                    <c:if test="${list.free_shipping == 0}">
                        <p>무료배송</p>
                    </c:if>

                    <input type="button" value="장바구니 담기"
                        onclick="location.href='/cart_insert.do?product_id=${list.product_id}'"/>

                    <input type="button" value="판매자 상품 수정"
                        onclick="location.href='/seller_product_modify.do?product_id=${list.product_id}'"/>
                </div>
            </c:forEach>

            <div>
                ${pageMenu}
            </div>

    </body>
</html>