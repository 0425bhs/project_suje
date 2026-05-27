<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

    <head></head>

    <body>
        
        <div>

            <div>
                <input type="button" value="내상품관리"/>
                <input type="button" value="판매자 상품 등록" onclick="location.href='seller_product_insert.do'"/>
                <input type="button" value="판매자 상품 수정" onclick="location.href='seller_product_modify.do'"/>
            </div>

            <c:forEach var="list" items="${list}">
                <div>
                
                    <img src="${list.image_l}" alt="${list.name}"/>

                    <h3><a href="product_detail.do?product_id=${list.product_id}">${list.name}</a></h3>

                    <p>${list.price}원</p>
                    <p>${list.sale_price}원</p>
                    <p>재고: ${list.stock}개</p>
                    <p>${list.delivery_fee}원</p>
                    

                    <input type="button" value="장바구니 담기" onclick="location.href='cart_insert.do?product_id=${list.id}'"/>

                </div>
            </c:forEach>

        </div>

    </body>

</html>
