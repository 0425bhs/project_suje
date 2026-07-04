<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="maxProductSales" value="0" />
<c:forEach var="product" items="${productSalesTopList}">
    <c:if test="${product.totalSales > maxProductSales}">
        <c:set var="maxProductSales" value="${product.totalSales}" />
    </c:if>
</c:forEach>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>판매자 매출 통계</title>

    <link rel="stylesheet" href="/css/seller/seller_form_common.css">
    <link rel="stylesheet" href="/css/seller/seller_statistics.css?v=4">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>
<div class="seller-board">

    <jsp:include page="seller_sidebar.jsp">
        <jsp:param name="activeMenu" value="statistics"/>
        <jsp:param name="sidebarTitle" value="판매자 통계" />
    </jsp:include>

    <main class="seller-main">

        <header class="seller-main-header statistics-header">
            <div>
                <span class="page-label">판매자 통계</span>
                <h1>판매자 매출 통계</h1>
                <p>주문 완료 기준으로 집계된 매출 현황입니다.</p>
            </div>
        </header>

        <section class="sales-summary-grid">
            <div class="sales-summary-card">
                <div>
                    <span>오늘 매출</span>
                    <strong>
                        <fmt:formatNumber value="${empty todaySales ? 0 : todaySales}" pattern="#,###"/>원
                    </strong>
                    <p>오늘 발생한 결제 완료 매출</p>
                </div>
                <div class="summary-icon">
                    <i class="bi bi-calendar-check"></i>
                </div>
            </div>

            <div class="sales-summary-card">
                <div>
                    <span>이번 달 매출</span>
                    <strong>
                        <fmt:formatNumber value="${empty monthSales ? 0 : monthSales}" pattern="#,###"/>원
                    </strong>
                    <p>이번 달 누적 매출</p>
                </div>
                <div class="summary-icon">
                    <i class="bi bi-bar-chart-line"></i>
                </div>
            </div>

            <div class="sales-summary-card">
                <div>
                    <span>총 매출</span>
                    <strong>
                        <fmt:formatNumber value="${empty totalSales ? 0 : totalSales}" pattern="#,###"/>원
                    </strong>
                    <p>전체 누적 매출</p>
                </div>
                <div class="summary-icon">
                    <i class="bi bi-cash-coin"></i>
                </div>
            </div>
        </section>

        <section class="statistics-grid">

            <div class="statistics-card chart-card">
                <div class="card-header">
                    <h3>최근 7일 매출 추이</h3>
                    <span>일별</span>
                </div>

                <c:choose>
                    <c:when test="${empty dailySalesList}">
                        <div class="empty-box">최근 7일 매출 데이터가 없습니다.</div>
                    </c:when>

                    <c:otherwise>
                        <div class="chart-box">
                            <canvas id="dailySalesChart"></canvas>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="statistics-card product-rank-card">
                <div class="card-header">
                    <h3>상품별 매출 순위</h3>
                    <span>매출순</span>
                </div>

                <c:choose>
                    <c:when test="${empty productSalesTopList}">
                        <div class="empty-box">상품별 매출 데이터가 없습니다.</div>
                    </c:when>

                    <c:otherwise>
                        <div class="product-rank-list">
                            <c:forEach var="product" items="${productSalesTopList}" varStatus="status">
                                <div class="product-rank-item">
                                    <div class="rank-num">${status.index + 1}</div>

                                    <div class="rank-info">
                                        <div class="rank-top">
                                            <strong>${product.name}</strong>
                                            <span>
                                                <fmt:formatNumber value="${product.totalQuantity}" pattern="#,###"/>개
                                            </span>
                                        </div>

                                        <div class="rank-bottom">
                                            <div class="rank-bar-bg">
                                                <c:set var="barWidth" value="0" />

                                                <c:if test="${maxProductSales ne 0}">
                                                    <c:set var="barWidth" value="${product.totalSales * 100 / maxProductSales}" />
                                                </c:if>

                                                <div class="rank-bar" data-width="${barWidth}"></div>
                                            </div>

                                            <em>
                                                <fmt:formatNumber value="${product.totalSales}" pattern="#,###"/>원
                                            </em>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="statistics-card category-card">
                <div class="card-header">
                    <h3>카테고리별 매출 비중</h3>
                    <span>카테고리</span>
                </div>

                <c:choose>
                    <c:when test="${empty categorySalesList}">
                        <div class="empty-box">카테고리별 매출 데이터가 없습니다.</div>
                    </c:when>

                    <c:otherwise>
                        <div class="category-chart-layout">
                            <div class="category-chart-box">
                                <canvas id="categorySalesChart"></canvas>
                            </div>

                            <div class="category-sales-list">
                                <c:forEach var="category" items="${categorySalesList}">
                                    <div class="category-sales-item">
                                        <span>${category.categoryName}</span>
                                        <strong>
                                            <fmt:formatNumber value="${category.salesAmount}" pattern="#,###"/>원
                                        </strong>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </section>

        <section class="sales-guide-box">
            <i class="bi bi-info-circle"></i>
            <span>통계 데이터는 주문상품 상태가 결제완료 이후인 주문을 기준으로 집계됩니다.</span>
        </section>

    </main>

</div>

<script>
    window.dailySalesLabels = [
        <c:forEach var="daily" items="${dailySalesList}" varStatus="status">
            '${daily.salesDate}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    window.dailySalesData = [
        <c:forEach var="daily" items="${dailySalesList}" varStatus="status">
            ${daily.salesAmount}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    window.categorySalesLabels = [
        <c:forEach var="category" items="${categorySalesList}" varStatus="status">
            '${category.categoryName}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    window.categorySalesData = [
        <c:forEach var="category" items="${categorySalesList}" varStatus="status">
            ${category.salesAmount}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
</script>

<script src="/js/seller_statistics.js"></script>

</body>
</html>