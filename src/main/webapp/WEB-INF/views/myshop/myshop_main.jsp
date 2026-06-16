<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>마이쇼핑 대시보드 - HANDMADE</title>

    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/order-payment.css?v=3">
    <link rel="stylesheet" href="/css/myshop/myshop.css?v=1">
    
    <script src="/js/product_main.js" defer></script>
    <script src="/js/order-payment.js" defer></script>
</head>

<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="" />
</jsp:include>

<section class="myshop-page">
    <div class="myshop-layout">

        <!-- 왼쪽 사이드바 -->
        <jsp:include page="/WEB-INF/views/myshop/common/myshop_sidebar.jsp" >
            <jsp:param name="activeMenu" value="${activeMenu}" />
        </jsp:include>

        <!-- 오른쪽 본문 -->
        <main class="myshop-content myshop-dashboard-content">
            <jsp:include page="/WEB-INF/views/${contentPage}.jsp" />
        </main>
    </div>
</section>

</body>
</html>
