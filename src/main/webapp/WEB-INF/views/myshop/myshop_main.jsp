<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>마이쇼핑 - HANDMADE</title>

    <link rel="stylesheet" href="/css/product/product_main.css">

    <!-- 마이쇼핑 / 주문 관련 공통 CSS -->
    <link rel="stylesheet" href="/css/order-payment.css?v=5">

    <!-- 대시보드 전용 CSS -->
    <link rel="stylesheet" href="/css/myshop-dashboard.css?v=1">

    <script src="/js/product_main.js" defer></script>
    <script src="/js/order-payment.js" defer></script>
</head>

<body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="order" />
    </jsp:include>

    <section class="myshop-page">
        <div class="myshop-layout">

            <jsp:include page="/WEB-INF/views/order/common/myshop_sidebar.jsp" />

            <main class="myshop-content">
                <jsp:include page="/WEB-INF/views${contentPage}.jsp" />
            </main>

        </div>
    </section>

</body>

</html>