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
    <link rel="stylesheet" href="/css/myshop/common.css?v=1">
    <link rel="stylesheet" href="/css/myshop/card.css?v=1">

    <c:if test="${contentPage eq '/myshop/dashboard'}">
        <link rel="stylesheet" href="/css/myshop/order.css?v=1">
        <link rel="stylesheet" href="/css/myshop/dashboard.css?v=1">
    </c:if>

    <c:if test="${contentPage eq '/myshop/order_list'}">
        <link rel="stylesheet" href="/css/myshop/cancleModal.css?v=1">
        <link rel="stylesheet" href="/css/myshop/order.css?v=2">
    </c:if>

    <c:if test="${contentPage eq '/myshop/review_list'}">
        <link rel="stylesheet" href="/css/myshop/review.css?v=1">
    </c:if>

    <c:if test="${contentPage eq '/myshop/favorite_list'}">
        <link rel="stylesheet" href="/css/myshop/favorite.css?v=2">
    </c:if>

    <c:if test="${contentPage eq '/myshop/qna_list'}">
        <link rel="stylesheet" href="/css/myshop/order.css?v=2">
        <link rel="stylesheet" href="/css/myshop/qna.css?v=1">
    </c:if>

    <c:if test="${contentPage eq '/myshop/recent'}">
        <link rel="stylesheet" href="/css/product/product_card.css?v=1">
        <link rel="stylesheet" href="/css/myshop/recent.css?v=1">
    </c:if>

    <c:if test="${contentPage eq '/myshop/point_history'}">
        <link rel="stylesheet" href="/css/myshop/point_history.css?v=1">
    </c:if>
    
    <script src="/js/product_main.js" defer></script>

    <c:if test="${contentPage eq '/myshop/order_list'}">
        <script src="/js/cart.js" defer></script>
        <script src="/js/order-payment.js" defer></script>
    </c:if>

    <c:if test="${contentPage eq '/myshop/coupon_history'}">
        <link rel="stylesheet" href="/css/myshop/coupon_history.css?v=1">
    </c:if>

    <c:if test="${contentPage eq '/myshop/exchange_return'}">
    <link rel="stylesheet" href="/css/myshop/order.css?v=1">
</c:if>

</head>

<body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="myshop" />
    </jsp:include>

    <section class="myshop-page">
        <div class="myshop-layout">

            <c:if test="${not empty flashMsg}">
                <script>alert("${flashMsg}");</script>
                <c:remove var="flashMsg" scope="session" />
            </c:if>

            <!-- 왼쪽 사이드바 -->
            <jsp:include page="/WEB-INF/views/myshop/common/myshop_sidebar.jsp" >
                <jsp:param name="activeMenu" value="${activeMenu}" />
            </jsp:include>

            <main class="myshop-content ${contentPage eq '/myshop/dashboard' ? 'myshop-dashboard-content' : ''}">
                <jsp:include page="/WEB-INF/views${contentPage}.jsp" />
            </main>

        </div>
    </section>

</body>

</html>