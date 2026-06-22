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
                <p>회원, 상품, 후기, 문의처럼 현재 프로젝트에서 조회 화면으로 만들기 쉬운 항목을 모았습니다.</p>
            </div>
            <div class="admin-header-actions">
                <a href="/product/main.do" class="admin-btn light">쇼핑몰로 이동</a>
            </div>
        </header>

        <section class="admin-grid">
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">회원</span>
                <strong class="admin-stat-value">128<small>명</small></strong>
                <span class="admin-stat-note">목록 조회, 검색</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">상품</span>
                <strong class="admin-stat-value">42<small>개</small></strong>
                <span class="admin-stat-note">상품 정보 확인</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">후기</span>
                <strong class="admin-stat-value">31<small>건</small></strong>
                <span class="admin-stat-note">후기 내용 확인</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">문의</span>
                <strong class="admin-stat-value">9<small>건</small></strong>
                <span class="admin-stat-note">답변 상태 확인</span>
            </article>
        </section>

        <section class="admin-grid three" style="margin-top:18px;">
            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>기본 관리</h3>
                </div>
                <div class="admin-list">
                    <a href="/admin/members" class="admin-list-item"><span>회원 관리</span><strong>목록</strong></a>
                    <a href="/admin/products" class="admin-list-item"><span>상품 관리</span><strong>목록</strong></a>
                    <a href="/admin/categories" class="admin-list-item"><span>카테고리 관리</span><strong>조회</strong></a>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>고객 활동</h3>
                </div>
                <div class="admin-list">
                    <a href="/admin/reviews" class="admin-list-item"><span>후기 관리</span><strong>확인</strong></a>
                    <a href="/admin/qnas" class="admin-list-item"><span>문의 관리</span><strong>확인</strong></a>
                    <a href="/admin/reports" class="admin-list-item"><span>신고 관리</span><strong>확인</strong></a>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>운영 관리</h3>
                </div>
                <div class="admin-list">
                    <a href="/admin/notices" class="admin-list-item"><span>공지사항 관리</span><strong>가능</strong></a>
                    <a href="/admin/statistics" class="admin-list-item"><span>기본 통계</span><strong>간단</strong></a>
                    <a href="/admin/sellers" class="admin-list-item"><span>판매자 관리</span><strong>조회</strong></a>
                </div>
            </article>

            <article class="admin-card span-3">
                <div class="admin-card-head">
                    <h3>최근 확인 항목</h3>
                    <span class="admin-status pending">UI 예시</span>
                </div>
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>구분</th>
                            <th>내용</th>
                            <th>상태</th>
                            <th>등록일</th>
                            <th>이동</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>상품</td>
                            <td class="left"><strong>핸드메이드 자수 파우치</strong></td>
                            <td><span class="admin-status active">판매중</span></td>
                            <td>2026-06-16</td>
                            <td><a href="/admin/products" class="admin-btn light">보기</a></td>
                        </tr>
                        <tr>
                            <td>문의</td>
                            <td class="left"><strong>배송 일정 문의드립니다.</strong></td>
                            <td><span class="admin-status pending">답변대기</span></td>
                            <td>2026-06-16</td>
                            <td><a href="/admin/qnas" class="admin-btn light">보기</a></td>
                        </tr>
                        <tr>
                            <td>후기</td>
                            <td class="left"><strong>사진 후기 등록</strong></td>
                            <td><span class="admin-status done">노출</span></td>
                            <td>2026-06-15</td>
                            <td><a href="/admin/reviews" class="admin-btn light">보기</a></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </article>
        </section>
    </main>
</div>
</body>
</html>
