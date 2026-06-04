<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <link rel="stylesheet" href="/css/seller/seller_product_list.css">
    </head>

    <body>
        <div class="seller-board">

            <jsp:include page="seller_sidebar.jsp">
                <jsp:param name="activeMenu" value="qnaList" />
                <jsp:param name="sidebarTitle" value="상품 문의 답변 관리" />
            </jsp:include>
        </div>
    </body>

</html>
