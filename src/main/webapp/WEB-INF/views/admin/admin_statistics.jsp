<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 기본 통계</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="statistics" />
        <jsp:param name="sidebarTitle" value="기본 통계" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">BASIC STATISTICS</span>
                <h1>기본 통계</h1>
                <p>현재 구현하기 쉬운 단순 집계 위주로 구성합니다.</p>
            </div>
        </header>

        <section class="admin-grid">
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">전체 회원</span>
                <strong class="admin-stat-value">128<small>명</small></strong>
                <span class="admin-stat-note">users 기준</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">등록 상품</span>
                <strong class="admin-stat-value">42<small>개</small></strong>
                <span class="admin-stat-note">products 기준</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">주문</span>
                <strong class="admin-stat-value">18<small>건</small></strong>
                <span class="admin-stat-note">orders 기준</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">후기</span>
                <strong class="admin-stat-value">31<small>건</small></strong>
                <span class="admin-stat-note">reviews 기준</span>
            </article>
        </section>

        <section class="admin-grid three" style="margin-top:18px;">
            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>주문 상태</h3>
                </div>
                <div class="admin-list">
                    <div class="admin-list-item"><span>결제 완료</span><strong>6건</strong></div>
                    <div class="admin-list-item"><span>배송중</span><strong>4건</strong></div>
                    <div class="admin-list-item"><span>배송 완료</span><strong>8건</strong></div>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>고객 활동</h3>
                </div>
                <div class="admin-list">
                    <div class="admin-list-item"><span>작성된 후기</span><strong>31건</strong></div>
                    <div class="admin-list-item"><span>답변 대기 문의</span><strong>9건</strong></div>
                    <div class="admin-list-item"><span>찜한 상품</span><strong>54건</strong></div>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>상품 상태</h3>
                </div>
                <div class="admin-list">
                    <div class="admin-list-item"><span>판매중</span><strong>36개</strong></div>
                    <div class="admin-list-item"><span>품절</span><strong>4개</strong></div>
                    <div class="admin-list-item"><span>승인 대기</span><strong>2개</strong></div>
                </div>
            </article>
        </section>
    </main>
</div>
</body>
</html>
