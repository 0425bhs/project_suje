<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

    <head></head>

    <body>
        <div>
            <c:forEach var="product" items="${list}">

            <div class="product-card">

                <img src="${product.image_l}" alt="${product.name}">

                <h3><a href="product_content.do?id=${product.id}">${product.name}</a></h3>

                <p class="price">${product.price}원</p>

                <p class="desc">${product.description}</p>

                <p>재고: ${product.stock}개</p>

                <p class="delivery">배송비: ${product.delivery_fee}원</p>

            </div>

            </c:forEach>
        </div>
    </body>

</html>
