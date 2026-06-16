<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 대시보드</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="dashboard" />
        <jsp:param name="sidebarTitle" value="관리자 센터" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">ADMIN CENTER</span>
                <h1>관리자 대시보드</h1>
                <p>승인 대기, 신고, 문의, 매출 흐름을 한눈에 확인합니다.</p>
            </div>
            <div class="admin-header-actions">
                <button type="button" class="admin-btn light">오늘</button>
                <button type="button" class="admin-btn dark">운영 리포트</button>
            </div>
        </header>

        <section class="admin-grid">
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">신규 가입 회원</span>
                <strong class="admin-stat-value">128<small>명</small></strong>
                <span class="admin-stat-note">전일 대비 +12%</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">판매자 승인 대기</span>
                <strong class="admin-stat-value">14<small>건</small></strong>
                <span class="admin-stat-note">서류 검토 필요</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">상품 승인 대기</span>
                <strong class="admin-stat-value">37<small>건</small></strong>
                <span class="admin-stat-note">숨김 요청 5건 포함</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">미처리 신고</span>
                <strong class="admin-stat-value">9<small>건</small></strong>
                <span class="admin-stat-note">긴급 2건</span>
            </article>
        </section>

        <section class="admin-grid three" style="margin-top:18px;">
            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>승인 업무</h3>
                    <a href="/admin/products" class="admin-btn light">전체보기</a>
                </div>
                <div class="admin-list">
                    <div class="admin-list-item"><span>판매자 승인 대기</span><strong>14건</strong></div>
                    <div class="admin-list-item"><span>상품 승인 대기</span><strong>37건</strong></div>
                    <div class="admin-list-item"><span>재심사 요청</span><strong>6건</strong></div>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>콘텐츠 관리</h3>
                    <a href="/admin/reviews" class="admin-btn light">전체보기</a>
                </div>
                <div class="admin-list">
                    <div class="admin-list-item"><span>신규 후기</span><strong>42건</strong></div>
                    <div class="admin-list-item"><span>미답변 문의</span><strong>18건</strong></div>
                    <div class="admin-list-item"><span>숨김 검토 후기</span><strong>5건</strong></div>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>오늘 매출</h3>
                    <a href="/admin/statistics" class="admin-btn light">통계보기</a>
                </div>
                <div class="admin-list">
                    <div class="admin-list-item"><span>결제금액</span><strong>8,420,000원</strong></div>
                    <div class="admin-list-item"><span>주문 수</span><strong>126건</strong></div>
                    <div class="admin-list-item"><span>판매자 정산 예정</span><strong>6,930,000원</strong></div>
                </div>
            </article>

            <article class="admin-card span-2">
                <div class="admin-card-head">
                    <h3>최근 처리 필요 항목</h3>
                    <span class="admin-status warning">확인 필요</span>
                </div>
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>구분</th>
                            <th>대상</th>
                            <th>상태</th>
                            <th>요청일</th>
                            <th>처리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>판매자 승인</td>
                            <td class="left"><strong>오브제 스튜디오</strong></td>
                            <td><span class="admin-status pending">대기</span></td>
                            <td>2026-06-16</td>
                            <td><button type="button" class="admin-btn">검토</button></td>
                        </tr>
                        <tr>
                            <td>상품 승인</td>
                            <td class="left"><strong>핸드메이드 자수 파우치</strong></td>
                            <td><span class="admin-status pending">대기</span></td>
                            <td>2026-06-16</td>
                            <td><button type="button" class="admin-btn">검토</button></td>
                        </tr>
                        <tr>
                            <td>신고</td>
                            <td class="left"><strong>부적절한 후기 신고</strong></td>
                            <td><span class="admin-status danger">긴급</span></td>
                            <td>2026-06-15</td>
                            <td><button type="button" class="admin-btn danger">처리</button></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>운영 메모</h3>
                </div>
                <div class="admin-form-row">
                    <label>오늘 확인할 내용</label>
                    <textarea placeholder="관리자 메모 영역입니다."></textarea>
                </div>
                <div style="margin-top:12px; text-align:right;">
                    <button type="button" class="admin-btn">저장</button>
                </div>
            </article>
        </section>
    </main>
</div>
</body>
</html>
