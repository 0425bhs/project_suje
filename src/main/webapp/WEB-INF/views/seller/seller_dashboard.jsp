<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="/css/seller/seller_dashobard.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    </head>

    <body>
        <div class="seller-board">

            <jsp:include page="seller_sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard" />
                <jsp:param name="sidebarTitle" value="판매자 대시보드" />
            </jsp:include>

            <div class="seller-main">
                <div class="seller-main-header">
                    <div>
                        <span class="page-label">SELLER CENTER</span>
                        <h1>판매자 대시보드</h1>
                        <p>오늘의 할 일과 상점 현황을 한눈에 확인하세요.</p>
                    </div>
                </div>

                <div class="dashboard-grid">

                    <div class="dash-card span-3">
                        <div class="card-header">
                            <h3><span class="icon green">📦</span> 판매 관리</h3>
                        </div>

                        <div class="sales-funnel">
                            <div class="funnel-step clickable" onclick="location.href='/seller_order_list.do?status=PAID'">
                                <span class="label">신규주문</span>
                                <span class="count">${newOrderCount}<small>건</small></span>
                            </div>

                            <div class="funnel-arrow">〉</div>

                            <div class="funnel-step clickable" onclick="location.href='/seller_order_list.do?status=PREPARING'">
                                <span class="label">제작중</span>
                                <span class="count">${preparingCount}<small>건</small></span>
                            </div>

                            <div class="funnel-arrow">〉</div>

                            <div class="funnel-step clickable" onclick="location.href='/seller_order_list.do?status=SHIPPING'">
                                <span class="label">배송중</span>
                                <span class="count">${shippingCount}<small>건</small></span>
                            </div>

                            <div class="funnel-arrow">〉</div>

                            <div class="funnel-step clickable" onclick="location.href='/seller_order_list.do?status=DELIVERED'">
                                <span class="label">배송완료</span>
                                <span class="count">${deliveredCount}<small>건</small></span>
                            </div>

                        </div>
                    </div>

                    <div class="dash-card">
                        <div class="card-header">
                            <h3><span class="icon red">⚠️</span> 취소·반품·교환</h3>
                        </div>

                        <div class="list-group">
                            <div class="list-item">
                                <span class="label">취소요청(미구현)</span>
                                <span class="value zero">0</span>
                            </div>

                            <div class="list-item">
                                <span class="label">반품요청(미구현)</span>
                                <span class="value zero">0</span>
                            </div>

                            <div class="list-item">
                                <span class="label">교환요청(미구현)</span>
                                <span class="value zero">0</span>
                            </div>
                        </div>
                    </div>

                    <div class="dash-card">
                        <div class="card-header">
                            <h3><span class="icon teal">🛍️</span> 상품 관리</h3>
                        </div>

                        <div class="list-group">
                            <div class="list-item clickable" onclick="location.href='/seller_product_list.do'">
                                <span class="label">판매중 상품</span>
                                <span class="value highlight">${onSaleCount}</span>
                            </div>

                            <div class="list-item clickable" onclick="location.href='/seller_product_list.do?stockStatus=out'">
                                <span class="label">품절 상품</span>
                                <span class="value zero">${outOfStockCount}</span>
                            </div>

                            <div class="list-item">
                                <span class="label">수정요청 상품(미구현)</span>
                                <span class="value zero">0</span>
                            </div>
                        </div>
                    </div>

                    <div class="dash-card">
                        <div class="card-header">
                            <h3><span class="icon orange">💬</span> 문의·리뷰 현황</h3>
                        </div>

                        <div class="list-group">
                            <div class="list-item clickable" onclick="location.href='/seller_qna_list.do'">
                                <span class="label">미답변 상품 Q&A</span>
                                <span class="value zero">${unansweredQnaCount}</span>
                            </div>

                            <div class="list-item">
                                <span class="label">새로 작성된 리뷰</span>
                                <span class="value zero">${newReviewCount}</span>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </body>

</html>