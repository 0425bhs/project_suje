<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">

    <head>
        <script src="/js/cart.js"></script>
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/product/product_header.jsp">
            <jsp:param name="activeMenu" value="cart" />
        </jsp:include>

        <div>
            <h2>장바구니</h2>

            <c:if test="${empty list}">
                <p>장바구니에 담긴 상품이 없습니다.</p>
            </c:if>

            <c:if test="${not empty list}">

                <table border="1">
                    <thead>
                        <tr>
                            <th>이미지</th>
                            <th>상품명</th>
                            <th>가격</th>
                            <th>수량</th>
                            <th>상품 합계</th>
                            <th>배송비</th>
                        </tr>
                    </thead>

                    <tbody>
                        
                        <c:forEach var="cart" items="${list}">
                            <tr>
                                <td>
                                    <img src="/images/product/${cart.image_s}"
                                        width="80"
                                        height="80"
                                        onerror="this.src='/images/no_image.png'">
                                </td>

                                <td>
                                    ${cart.product_name}
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${cart.sale_price > 0 and cart.sale_price < cart.price}">
                                            <del>
                                                <fmt:formatNumber value="${cart.price}" pattern="#,###" />원
                                            </del>
                                            <br>
                                            <strong>
                                                <fmt:formatNumber value="${cart.sale_price}" pattern="#,###" />원
                                            </strong>
                                        </c:when>

                                        <c:otherwise>
                                            <strong>
                                                <fmt:formatNumber value="${cart.price}" pattern="#,###" />원
                                            </strong>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    ${cart.quantity}개
                                </td>

                                <td>
                                    <fmt:formatNumber value="${cart.item_total}" pattern="#,###" />원
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${cart.delivery_fee == 0}">
                                            무료배송
                                        </c:when>

                                        <c:otherwise>
                                            <fmt:formatNumber value="${cart.delivery_fee}" pattern="#,###" />원
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <hr>

                <p>
                    총 상품 금액:
                    <strong>
                        <fmt:formatNumber value="${totalPrice}" pattern="#,###" />원
                    </strong>
                </p>

                <p>
                    총 배송비:
                    <strong>
                        <fmt:formatNumber value="${totalDeliveryFee}" pattern="#,###" />원
                    </strong>
                </p>

                <p>
                    결제 예정 금액:
                    <strong>
                        <fmt:formatNumber value="${paymentPrice}" pattern="#,###" />원
                    </strong>
                </p>

            </c:if>
        </div>
    </body>

</html>
