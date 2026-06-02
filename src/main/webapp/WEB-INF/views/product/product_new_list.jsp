<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head></head>

<body>

<h2>신제품</h2>

<c:forEach var="list" items="${list}">
    <div>
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

</body>
</html>