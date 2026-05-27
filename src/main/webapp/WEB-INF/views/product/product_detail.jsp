<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

    <head></head>

    <body>

        <div>
            <img src="${list.image_l}" alt="${list.name}"/>

                <h3><a href="product_detail.do?id=${list.id}">${list.name}</a></h3>

                <p>${list.price}원</p>
                <p>${list.sale_price}원</p>
                <p>재고: ${list.stock}개</p>
                <p>${list.delivery_fee}원</p>
                <p>${list.description}</p>

                <div>
                    <h3>상세정보</h3>

                        
                    ${list.description}
                </div>

                <input type="button" value="장바구니 담기" onclick="location.href='cart_insert.do?product_id=${list.id}'"/>
        </div>
        
    </body>

</html>
