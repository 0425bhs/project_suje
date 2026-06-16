<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 판매자 승인/반려</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="sellers" />
        <jsp:param name="sidebarTitle" value="판매자 승인 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">SELLER APPROVAL</span>
                <h1>판매자 승인/반려</h1>
                <p>입점 신청 서류와 상점 정보를 검토하고 승인 또는 반려합니다.</p>
            </div>
            <div class="admin-header-actions">
                <button type="button" class="admin-btn">선택 승인</button>
                <button type="button" class="admin-btn danger">선택 반려</button>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <div class="admin-filter-tabs">
                    <button type="button" class="active">승인대기</button>
                    <button type="button">승인완료</button>
                    <button type="button">반려</button>
                    <button type="button">보류</button>
                </div>
                <input type="text" class="admin-search" placeholder="상점명, 대표자 검색">
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th><input type="checkbox"></th>
                        <th>신청번호</th>
                        <th>상점명</th>
                        <th>대표자</th>
                        <th>사업자번호</th>
                        <th>주요 카테고리</th>
                        <th>상태</th>
                        <th>신청일</th>
                        <th>처리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>#S-204</td>
                        <td class="left"><strong>라온공방</strong></td>
                        <td>박라온</td>
                        <td>123-45-67890</td>
                        <td>가죽공예</td>
                        <td><span class="admin-status pending">대기</span></td>
                        <td>2026-06-16</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn">승인</button>
                            <button type="button" class="admin-btn danger">반려</button>
                            <button type="button" class="admin-btn light">서류</button>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>#S-203</td>
                        <td class="left"><strong>소일 세라믹</strong></td>
                        <td>이소일</td>
                        <td>222-11-77777</td>
                        <td>도자기</td>
                        <td><span class="admin-status pending">대기</span></td>
                        <td>2026-06-15</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn">승인</button>
                            <button type="button" class="admin-btn danger">반려</button>
                            <button type="button" class="admin-btn light">서류</button>
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
