<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 신고 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="reports" />
        <jsp:param name="sidebarTitle" value="신고 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">REPORT MANAGEMENT</span>
                <h1>신고 관리</h1>
                <p>접수된 신고 내용을 확인하고 처리 상태를 관리하기 위한 기본 화면입니다.</p>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <div class="admin-filter-tabs">
                    <button type="button" class="active">미처리</button>
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
                        <th>신고번호</th>
                        <th>대상</th>
                        <th>사유</th>
                        <th>신고자</th>
                        <th>상태</th>
                        <th>접수일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>#RP-91</td>
                        <td class="left"><strong>후기 #R-875</strong></td>
                        <td>욕설/비방</td>
                        <td>blue***</td>
                        <td><span class="admin-status pending">미확인</span></td>
                        <td>2026-06-16</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                        </td>
                    </tr>
                    <tr>
                        <td>#RP-88</td>
                        <td class="left"><strong>상품 #P-312</strong></td>
                        <td>저작권 의심</td>
                        <td>craft***</td>
                        <td><span class="admin-status pending">미확인</span></td>
                        <td>2026-06-15</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
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
