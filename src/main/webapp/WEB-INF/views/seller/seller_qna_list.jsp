<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="/css/seller/seller_product_list.css">
        <link rel="stylesheet" href="/css/seller/seller_qna.css">

        <script src="/js/seller_qna.js" defer></script>
    </head>

    <body>
        <div class="seller-board">

            <jsp:include page="seller_sidebar.jsp">
                <jsp:param name="activeMenu" value="qnaList" />
                <jsp:param name="sidebarTitle" value="상품 문의 답변 관리" />
            </jsp:include>

            <div class="seller-main">

                <div class="seller-main-header">
                    <div>
                        <span class="page-label">ORDER MANAGEMENT</span>
                        <h1>문의 관리</h1>
                        <p>판매자의 각 상품마다의 문의를 확인할 수 있습니다.</p>
                    </div>
                </div>
            </div>

        </div>
    </body>

</html>
