<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>판매자 홈페이지</title>

        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <script src="/js/seller_statistics.js"></script>
    </head>

    <body>

    <div class="seller-board">

        <jsp:include page="seller_sidebar.jsp">
            <jsp:param name="activeMenu" value="statistcs"/>
            <jsp:param name="sidebarTitle" value="판매자 통계" />
        </jsp:include>

        <main class="seller-main">

            <header class="seller-main-header">
                <div>
                    <span class="page-label">판매자 통계</span>
                    <h1>판매자 매출 통계</h1>
                </div>
            </header>

            

        </main>

    </div>

    </body>
</html>