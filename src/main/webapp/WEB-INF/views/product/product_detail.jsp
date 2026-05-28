<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

    <head></head>

    <body>

        <div>
            <img src="${vo.image_s}" alt="${list.name}"/>

                <h3>${vo.name}</h3>

                <p>${vo.price}원</p>
                <p>${vo.sale_price}원</p>
                <p>재고: ${vo.stock}개</p>
                <p>${vo.delivery_fee}원</p>
                <p>${vo.description}</p>

                <div>
                    <h3>상세정보</h3>

                        
                    ${vo.description}
                </div>

                <input type="button" value="장바구니 담기" onclick="location.href='cart_insert.do?product_id=${list.product_id}'"/>
        </div>
        
    </body>

</html>
