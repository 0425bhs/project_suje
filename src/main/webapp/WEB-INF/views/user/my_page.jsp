<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>마이페이지</title>
    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/order-payment.css?v=3">

    <script src="/js/product_main.js" defer></script>
    <script src="/js/order-payment.js" defer></script>
</head>
<body>
    <jsp:include page="/WEB-INF/views/product/product_header.jsp" />

    <section class="myshop-page">
        <div class="myshop-layout">
            <jsp:include page="/WEB-INF/views/order/common/myshop_sidebar.jsp" />

            <main class="myshop-content">
                <jsp:include page="/WEB-INF/views/order/common/myshop_user_card.jsp" />
                <jsp:include page="/WEB-INF/views/order/common/myshop_quick_card.jsp" />
            </main>
        </div>
    </section>
</body>
</html>