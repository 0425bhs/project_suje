<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>판매자 대시보드</title>

    <link rel="stylesheet" href="/css/seller/seller_form_common.css">
    <link rel="stylesheet" href="/css/seller/seller_dashobard.css?v=4">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body>
<div class="seller-board">

    <jsp:include page="seller_sidebar.jsp">
        <jsp:param name="activeMenu" value="dashboard" />
        <jsp:param name="sidebarTitle" value="판매자 대시보드" />
    </jsp:include>

    <div class="seller-main">

        <div class="seller-main-header dashboard-header">
            <div>
                <span class="page-label">SELLER CENTER</span>
                <h1>판매자 대시보드</h1>
                <p>오늘의 할 일과 상점 현황을 한눈에 확인하세요.</p>
            </div>
        </div>

        <div class="dashboard-summary-row">
            <div class="summary-card clickable" onclick="location.href='/seller_order_list.do?status=PAID'">
                <span>신규주문</span>
                <strong>${empty newOrderCount ? 0 : newOrderCount}<small>건</small></strong>
            </div>

            <div class="summary-card clickable" onclick="location.href='/seller_product_list.do'">
                <span>판매중 상품</span>
                <strong>${empty onSaleCount ? 0 : onSaleCount}<small>개</small></strong>
            </div>

            <div class="summary-card clickable" onclick="location.href='/seller_qna_list.do'">
                <span>미답변 Q&A</span>
                <strong>${empty unansweredQnaCount ? 0 : unansweredQnaCount}<small>건</small></strong>
            </div>

            <div class="summary-card clickable" onclick="location.href='/seller_review_list.do'">
                <span>새 리뷰</span>
                <strong>${empty newReviewCount ? 0 : newReviewCount}<small>건</small></strong>
            </div>
        </div>

        <div class="dashboard-grid">

            <div class="dash-card span-3 sales-card">
                <div class="card-header">
                    <h3><span class="icon orange">📦</span> 판매 관리</h3>
                    <a href="/seller_order_list.do" class="card-more">주문 전체보기</a>
                </div>

                <div class="sales-funnel">
                    <div class="funnel-step clickable" onclick="location.href='/seller_order_list.do?status=PAID'">
                        <span class="label">신규주문</span>
                        <span class="count">${empty newOrderCount ? 0 : newOrderCount}<small>건</small></span>
                    </div>

                    <div class="funnel-arrow">〉</div>

                    <div class="funnel-step clickable" onclick="location.href='/seller_order_list.do?status=PREPARING'">
                        <span class="label">제작중</span>
                        <span class="count">${empty preparingCount ? 0 : preparingCount}<small>건</small></span>
                    </div>

                    <div class="funnel-arrow">〉</div>

                    <div class="funnel-step clickable" onclick="location.href='/seller_order_list.do?status=SHIPPING'">
                        <span class="label">배송중</span>
                        <span class="count">${empty shippingCount ? 0 : shippingCount}<small>건</small></span>
                    </div>

                    <div class="funnel-arrow">〉</div>

                    <div class="funnel-step clickable" onclick="location.href='/seller_order_list.do?status=DELIVERED'">
                        <span class="label">배송완료</span>
                        <span class="count">${empty deliveredCount ? 0 : deliveredCount}<small>건</small></span>
                    </div>
                </div>
            </div>

            <div class="dash-card">
                <div class="card-header">
                    <h3><span class="icon orange">⚠️</span> 취소·반품·교환</h3>
                    <span class="card-state">미구현 항목</span>
                </div>

                <div class="list-group">
                    <div class="list-item disabled">
                        <span class="label">취소요청(미구현)</span>
                        <span class="value zero">${empty cancelledCount ? 0 : cancelledCount}</span>
                    </div>

                    <div class="list-item disabled">
                        <span class="label">반품요청(미구현)</span>
                        <span class="value zero">${empty returnExchangeCount ? 0 : returnExchangeCount}</span>
                    </div>

                    <div class="list-item disabled">
                        <span class="label">교환요청(미구현)</span>
                        <span class="value zero">${empty returnExchangeCount ? 0 : returnExchangeCount}</span>
                    </div>
                </div>
            </div>

            <div class="dash-card">
                <div class="card-header">
                    <h3><span class="icon orange">🛍️</span> 상품 관리</h3>
                    <a href="/seller_product_list.do" class="card-more">상품 전체보기</a>
                </div>

                <div class="list-group">
                    <div class="list-item clickable" onclick="location.href='/seller_product_list.do'">
                        <span class="label">판매중 상품</span>
                        <span class="value highlight">${empty onSaleCount ? 0 : onSaleCount}</span>
                    </div>

                    <div class="list-item clickable" onclick="location.href='/seller_product_list.do'">
                        <span class="label">품절 상품</span>
                        <span class="value zero">${empty outOfStockCount ? 0 : outOfStockCount}</span>
                    </div>

                    <div class="list-item disabled">
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
                        <span class="value zero">${empty unansweredQnaCount ? 0 : unansweredQnaCount}</span>
                    </div>

                    <div class="list-item clickable" onclick="location.href='/seller_review_list.do'">
                        <span class="label">새로 작성된 리뷰</span>
                        <span class="value zero">${empty newReviewCount ? 0 : newReviewCount}</span>
                    </div>
                </div>
            </div>

            <div class="dash-card notice-card">
                <div class="card-header">
                    <h3><span class="icon orange">📢</span> 관리자 공지사항</h3>
                </div>

                <c:choose>
                    <c:when test="${empty noticeList}">
                        <div class="notice-empty">
                            등록된 공지사항이 없습니다.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="notice-list">
                            <c:forEach var="notice" items="${noticeList}">
                                <a href="/notice_detail.do?notice_id=${notice.notice_id}" class="notice-item">
                                    <div class="notice-title-wrap">
                                        <span class="notice-badge">공지</span>
                                        <strong>${notice.title}</strong>
                                    </div>
                                    <small>${notice.created_at}</small>
                                </a>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="dash-card sales-placeholder-card">
                <div class="card-header">
                    <h3><span class="icon orange">📊</span> 최근 7일 매출</h3>
                    <a href="/seller_statistics.do" class="card-more">자세히 보기</a>
                </div>

                <c:choose>
                    <c:when test="${empty dailySalesList}">
                        <div class="placeholder-box">
                            <strong>최근 매출 데이터가 없습니다.</strong>
                            <p>결제 완료된 주문이 생기면 최근 7일 매출이 표시됩니다.</p>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="dashboard-sales-list">
                            <c:forEach var="daily" items="${dailySalesList}">
                                <div class="dashboard-sales-item">
                                    <span>${daily.salesDate}</span>
                                    <strong>
                                        ${daily.salesAmount}원
                                    </strong>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</div>
</body>

</html>