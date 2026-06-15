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
    
    <%-- 대시보드 전용 스타일시트 --%>
    <style>
        /* 대시보드 메인 레이아웃 */
        .myshop-dashboard-content {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        /* 1. 상단 회원 환영 바 */
        .dashboard-welcome-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(to right, #ffffff, #fdfbfb);
            padding: 24px 32px;
            border-radius: 16px;
            border: 1px solid #eaeaea;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }
        .user-info-basic { display: flex; align-items: center; gap: 16px; }
        .user-avatar { width: 56px; height: 56px; background-color: #f5f5f5; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 26px; }
        .user-name-email strong { font-size: 18px; color: #222; font-weight: 700; letter-spacing: -0.3px; }
        .user-name-email span { font-size: 14px; color: #888; display: block; margin-top: 4px; }
        .welcome-msg { font-size: 18px; font-weight: 600; color: #333; letter-spacing: -0.3px; }

        /* 2. 종합 현황 카드 영역 */
        .dashboard-status-cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }
        .status-card {
            background-color: #fff;
            padding: 24px 20px;
            border-radius: 16px;
            border: 1px solid #eaeaea;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.01);
        }
        .status-card:hover { 
            border-color: #ff6b6b; 
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(255, 107, 107, 0.08);
        }
        .status-card .icon { font-size: 32px; margin-bottom: 12px; display: inline-block; }
        .status-card h4 { font-size: 14px; color: #666; margin-bottom: 8px; font-weight: 500; }
        .status-card strong { font-size: 26px; color: #222; font-weight: 700; display: block; letter-spacing: -0.5px; }
        .status-card .sub-info { font-size: 12px; color: #a0a0a0; margin-top: 8px; display: block; }

        /* 3. 하단 2단 레이아웃 */
        .dashboard-lower-layout {
            display: grid;
            grid-template-columns: 1.2fr 1fr; /* 폼이 더 예쁘게 떨어지도록 비율 미세조정 */
            grid-template-areas:
                "recent benefit"
                "orders activity";
            gap: 24px;
            align-items: stretch;
        }

        .dashboard-activity-sidebar {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .recent-viewed-compact { grid-area: recent; }
        .dashboard-benefit-card { grid-area: benefit; }
        .dashboard-recent-orders { grid-area: orders; }
        .dashboard-activity-sidebar { grid-area: activity; }

        .dashboard-benefit-card {
            margin-bottom: 0 !important;
        }

        .dashboard-activity-sidebar > .dashboard-section {
            margin-bottom: 0 !important;
        }

        /* 하단 공통 섹션 스타일 */
        .dashboard-section {
            background-color: #fff;
            padding: 28px;
            border-radius: 16px;
            border: 1px solid #eaeaea;
            box-shadow: 0 2px 8px rgba(0,0,0,0.01);
            box-sizing: border-box;
        }
        .dashboard-section-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .dashboard-section-head h3 { font-size: 18px; color: #222; font-weight: 700; display: flex; align-items: center; letter-spacing: -0.5px; }
        .dashboard-section-head h3 span { color: #ff6b6b; font-weight: 600; font-size: 15px; margin-left: 6px;}
        .view-all-btn { font-size: 13px; color: #888; text-decoration: none; display: inline-flex; align-items: center; transition: color 0.2s;}
        .view-all-btn:hover { color: #ff6b6b; }

        .more-btn-wrap { text-align: center; margin-top: 24px; }
        .more-btn { background: #fff; border: 1px solid #ddd; padding: 10px 24px; border-radius: 30px; color: #555; font-size: 13px; font-weight: 500; cursor: pointer; transition: all 0.2s; }
        .more-btn:hover { background-color: #f9f9f9; border-color: #ccc; color: #222; }

        /* 주문 내역 리스트 (인라인 스타일 분리 및 개선) */
        .dashboard-order-card {
            border: 1px solid #eaeaea;
            margin-bottom: 16px;
            border-radius: 12px;
            overflow: hidden;
            transition: border-color 0.2s;
        }
        .dashboard-order-card:hover { border-color: #ddd; }
        .dashboard-order-card:last-child { margin-bottom: 0; }

        .myshop-order-top {
            background-color: #fcfcfc;
            padding: 14px 20px;
            border-bottom: 1px solid #eaeaea;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
        }
        .myshop-status-badge { font-weight: 700; color: #ff6b6b; margin-right: 10px; }
        .myshop-order-top span { color: #777; }
        .myshop-order-top a { color: #666; text-decoration: none; font-weight: 500; transition: color 0.2s; }
        .myshop-order-top a:hover { color: #222; }

        .myshop-order-body {
            padding: 20px;
            display: flex;
            gap: 16px;
            align-items: center;
            background-color: #fff;
        }
        .myshop-product-thumb { width: 72px; height: 72px; border: 1px solid #f0f0f0; border-radius: 8px; overflow: hidden; flex-shrink: 0; background-color: #fafafa; }
        .myshop-product-thumb img { width: 100%; height: 100%; object-fit: cover; }

        .myshop-product-info { flex: 1; }
        .myshop-product-info a { text-decoration: none; color: #222; font-weight: 600; font-size: 15px; display: block; margin-bottom: 4px; line-height: 1.3; transition: color 0.2s; }
        .myshop-product-info a:hover { color: #ff6b6b; }
        .myshop-product-info p { color: #888; font-size: 13px; margin: 0 0 8px 0; }
        .myshop-product-info strong { display: block; font-size: 15px; color: #222; font-weight: 700; }

        .myshop-order-actions { display: flex; flex-direction: column; gap: 6px; width: 85px; }
        .myshop-order-actions a { border: 1px solid #ddd; padding: 8px 0; border-radius: 6px; color: #555; text-decoration: none; font-size: 12px; font-weight: 500; text-align: center; background: #fff; transition: all 0.2s; }
        .myshop-order-actions a:hover { background: #f9f9f9; border-color: #ccc; }
        .myshop-order-actions a.primary { background-color: #ff6b6b; color: #fff; border-color: #ff6b6b; }
        .myshop-order-actions a.primary:hover { background-color: #e55a5a; border-color: #e55a5a; }

        /* 오른쪽 활동 알림 사이드바 */
        .activity-sub-section { margin-bottom: 24px; }
        .activity-sub-section:last-child { margin-bottom: 0; }
        .activity-sub-section h4 { font-size: 15px; color: #222; margin-bottom: 12px; font-weight: 600; }

        .compact-prod-list { list-style: none; padding: 0; margin: 0; }
        .compact-prod-list li { display: flex; align-items: center; gap: 12px; padding: 12px 0; border-bottom: 1px solid #f5f5f5; }
        .compact-prod-list li:last-child { border-bottom: none; padding-bottom: 0; }
        .compact-prod-list img { width: 48px; height: 48px; border-radius: 8px; border: 1px solid #f0f0f0; object-fit: cover; background-color: #fafafa; }
        .compact-prod-list .info { flex: 1; }
        .compact-prod-list .info span { font-size: 14px; color: #333; display: block; margin-bottom: 4px; font-weight: 500; }
        .compact-prod-list .info .action { font-size: 12px; color: #ff6b6b; font-weight: 600; cursor: pointer; }
        .compact-prod-list .info .stars { font-size: 12px; color: #ffc107; }

        .compact-inquiry { background-color: #fbfbfb; padding: 16px; border-radius: 12px; border: 1px solid #eaeaea; }
        .compact-inquiry p { margin: 0 0 6px 0; color: #222; font-size: 14px; font-weight: 600; }
        .compact-inquiry .status { color: #ff6b6b; font-size: 13px; font-weight: 600; }
        .compact-inquiry .type { color: #a0a0a0; font-size: 12px; margin-left: 8px; }

        .recent-prod-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
        .recent-prod-grid .prod-item { border: 1px solid #eaeaea; border-radius: 8px; aspect-ratio: 1; background-color: #fafafa; display: flex; align-items: center; justify-content: center; color: #ccc; font-size: 12px; overflow: hidden; transition: border-color 0.2s; }
        .recent-prod-grid .prod-item:hover { border-color: #ccc; }

        .recent-viewed-compact {
            padding: 18px 20px;
        }
        .dashboard-benefit-card {
            padding: 18px 20px !important;
        }
        .recent-viewed-compact .dashboard-section-head {
            margin-bottom: 12px;
        }
        .dashboard-benefit-card .dashboard-section-head {
            margin-bottom: 12px !important;
        }
        .recent-viewed-compact .dashboard-section-head h3 {
            font-size: 16px;
        }
        .dashboard-benefit-card .dashboard-section-head h3 {
            font-size: 16px !important;
        }
        .dashboard-benefit-card .dashboard-section-head + div {
            gap: 10px;
        }
        .dashboard-benefit-card .dashboard-section-head + div > div {
            padding: 11px 12px !important;
        }
        .recent-viewed-compact .recent-prod-grid {
            grid-template-columns: repeat(4, 64px);
            justify-content: start;
            gap: 10px;
        }
        .recent-viewed-compact .prod-item {
            width: 64px;
            border-radius: 6px;
        }
    </style>

    <script src="/js/product_main.js" defer></script>
    <script src="/js/order-payment.js" defer></script>
</head>

<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="order" />
</jsp:include>

<section class="myshop-page">
    <div class="myshop-layout">

        <!-- 왼쪽 사이드바 -->
        <jsp:include page="/WEB-INF/views/order/common/myshop_sidebar.jsp" />

        <!-- 오른쪽 본문 -->
        <main class="myshop-content myshop-dashboard-content">
            <jsp:include page="/WEB-INF/views/${contentPage}.jsp" />
        </main>
    </div>
</section>

</body>
</html>
