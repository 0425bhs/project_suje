<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head></head>

    <body>

        <div>
            <img src="${vo.image_l}" alt="${vo.name}"/>

                <h3>${vo.name}</h3>

                <c:if test="${vo.sale_price==0}">
                    <p><fmt:formatNumber value="${vo.price}" pattern="#,###"/>원</p>
                </c:if>
                <c:if test="${vo.sale_price>0}">
                    <p>
                        <span style="text-decoration: line-through; color: gray;">
                            <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                        </span>
                    </p>
                    <p>
                        <strong>${vo.sale_rate}% 할인</strong>
                        <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                    </p>
                </c:if>
                <p>재고: ${vo.stock}개</p>
                
                <c:if test="${vo.free_shipping>0}">
                    <p>
                        <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 무료배송
                    </p>
                </c:if>
                <c:if test="${vo.free_shipping==0}">
                    <p>무료배송</p>
                </c:if>

                <p>${vo.description}</p>

                <div>
                    <h3>상세정보</h3>

                    ${vo.description}
                </div>

                <input type="button" value="장바구니 담기" onclick="location.href='/cart_insert.do?product_id=${vo.product_id}'"/>
        </div>
        
    </body>

</html>
