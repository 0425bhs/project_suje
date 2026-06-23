<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 문의 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="qnas" />
        <jsp:param name="sidebarTitle" value="문의 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">QNA MANAGEMENT</span>
                <h1>문의 관리</h1>
                <p>상품 문의와 답변 상태를 확인합니다.</p>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <form class="admin-filter-form" action="/admin/qnas" method="get">
                    <div class="admin-filter-tabs">
                        <button type="button" class="active">전체</button>
                        <button type="button">미답변</button>
                        <button type="button">답변완료</button>
                        <button type="button">상품문의</button>
                    </div>
                    <input type="text" class="admin-search" name="keyword" placeholder="문의 제목, 작성자 검색">
                </form>
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>문의번호</th>
                        <th>구분</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>대상</th>
                        <th>상태</th>
                        <th>작성일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>#Q-422</td>
                        <td>상품문의</td>
                        <td class="left"><strong>배송 일정 문의드립니다.</strong></td>
                        <td>김하늘</td>
                        <td>자수 파우치</td>
                        <td><span class="admin-status pending">미답변</span></td>
                        <td>2026-06-16</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                        </td>
                    </tr>
                    <tr>
                        <td>#Q-418</td>
                        <td>상품문의</td>
                        <td class="left"><strong>재입고 일정 문의</strong></td>
                        <td>오브제상점</td>
                        <td>천연비누 세트</td>
                        <td><span class="admin-status done">완료</span></td>
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
