<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 신고 처리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="reports" />
        <jsp:param name="sidebarTitle" value="신고 처리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">REPORT MANAGEMENT</span>
                <h1>신고 처리</h1>
                <p>상품, 후기, 문의, 회원 신고를 검토하고 제재 또는 반려 처리합니다.</p>
            </div>
            <div class="admin-header-actions">
                <button type="button" class="admin-btn danger">선택 제재</button>
                <button type="button" class="admin-btn light">선택 반려</button>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <div class="admin-filter-tabs">
                    <button type="button" class="active">미처리</button>
                    <button type="button">처리완료</button>
                    <button type="button">상품</button>
                    <button type="button">후기</button>
                    <button type="button">회원</button>
                </div>
                <input type="text" class="admin-search" placeholder="신고 대상, 신고자 검색">
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th><input type="checkbox"></th>
                        <th>신고번호</th>
                        <th>대상</th>
                        <th>사유</th>
                        <th>신고자</th>
                        <th>누적</th>
                        <th>긴급도</th>
                        <th>접수일</th>
                        <th>처리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>#RP-91</td>
                        <td class="left"><strong>후기 #R-875</strong></td>
                        <td>욕설/비방</td>
                        <td>blue***</td>
                        <td>3회</td>
                        <td><span class="admin-status danger">높음</span></td>
                        <td>2026-06-16</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn danger">숨김</button>
                            <button type="button" class="admin-btn light">반려</button>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>#RP-88</td>
                        <td class="left"><strong>상품 #P-312</strong></td>
                        <td>저작권 의심</td>
                        <td>craft***</td>
                        <td>1회</td>
                        <td><span class="admin-status warning">보통</span></td>
                        <td>2026-06-15</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn muted">상품숨김</button>
                            <button type="button" class="admin-btn light">보류</button>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
