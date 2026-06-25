<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 통계</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="statistics" />
        <jsp:param name="sidebarTitle" value="통계" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">ADMIN STATISTICS</span>
                <h1>매출/상품/판매자 통계</h1>
                <p>기간별 매출, 인기 상품, 판매자 성과를 확인합니다.</p>
            </div>
            <div class="admin-header-actions">
                <button type="button" class="admin-btn light">7일</button>
                <button type="button" class="admin-btn light">30일</button>
                <button type="button" class="admin-btn dark">엑셀 다운로드</button>
            </div>
        </header>

        <section class="admin-grid">
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">총 매출</span>
                <strong class="admin-stat-value">82,400,000<small>원</small></strong>
                <span class="admin-stat-note">전월 대비 +8.4%</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">주문 수</span>
                <strong class="admin-stat-value">1,284<small>건</small></strong>
                <span class="admin-stat-note">취소 제외</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">활성 상품</span>
                <strong class="admin-stat-value">3,412<small>개</small></strong>
                <span class="admin-stat-note">판매중 상품 기준</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">활성 판매자</span>
                <strong class="admin-stat-value">248<small>명</small></strong>
                <span class="admin-stat-note">최근 30일 판매 발생</span>
            </article>
        </section>

        <section class="admin-grid three" style="margin-top:18px;">
            <article class="admin-card span-2">
                <div class="admin-card-head">
                    <h3>매출 추이</h3>
                    <span class="admin-status active">월간</span>
                </div>
                <div class="admin-chart-placeholder">매출 차트 영역</div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>판매자 TOP 5</h3>
                </div>
                <div class="admin-list">
                    <div class="admin-list-item"><span>오브제상점</span><strong>8,420,000원</strong></div>
                    <div class="admin-list-item"><span>라온공방</span><strong>6,110,000원</strong></div>
                    <div class="admin-list-item"><span>물빛공방</span><strong>5,870,000원</strong></div>
                    <div class="admin-list-item"><span>소일 세라믹</span><strong>4,920,000원</strong></div>
                    <div class="admin-list-item"><span>라탄하우스</span><strong>4,510,000원</strong></div>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>인기 상품</h3>
                </div>
                <div class="admin-list">
                    <div class="admin-list-item"><span>자수 파우치</span><strong>128개</strong></div>
                    <div class="admin-list-item"><span>라탄 바구니</span><strong>96개</strong></div>
                    <div class="admin-list-item"><span>천연비누 세트</span><strong>88개</strong></div>
                </div>
            </article>

            <article class="admin-card span-2">
                <div class="admin-card-head">
                    <h3>카테고리별 매출</h3>
                </div>
                <div class="admin-chart-placeholder">카테고리 통계 차트 영역</div>
            </article>
        </section>
    </main>
</div>
</body>
</html>
