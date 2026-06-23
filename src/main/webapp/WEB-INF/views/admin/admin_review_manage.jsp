<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 후기 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="reviews" />
        <jsp:param name="sidebarTitle" value="후기 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">REVIEW MANAGEMENT</span>
                <h1>후기 관리</h1>
                <p>상품 후기를 조회하고 상세 내용을 확인합니다.</p>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <form class="admin-filter-form" action="/admin/reviews" method="get">
                    <div class="admin-filter-tabs">
                        <button type="button" class="active">전체</button>
                        <button type="button">신규</button>
                        <button type="button">사진 후기</button>
                    </div>
                    <input type="text" class="admin-search" name="keyword" placeholder="상품명, 작성자, 내용 검색">
                </form>
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>후기번호</th>
                        <th>상품</th>
                        <th>작성자</th>
                        <th>평점</th>
                        <th>내용</th>
                        <th>상태</th>
                        <th>작성일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>#R-882</td>
                        <td class="left"><strong>자수 파우치</strong></td>
                        <td>김하늘</td>
                        <td>★★★★★</td>
                        <td class="left">마감이 깔끔하고 선물용으로 좋아요.</td>
                        <td><span class="admin-status active">노출</span></td>
                        <td>2026-06-16</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                        </td>
                    </tr>
                    <tr>
                        <td>#R-875</td>
                        <td class="left"><strong>천연비누 세트</strong></td>
                        <td>문라이트</td>
                        <td>★★☆☆☆</td>
                        <td class="left">배송 관련 불만 내용 포함</td>
                        <td><span class="admin-status active">노출</span></td>
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
