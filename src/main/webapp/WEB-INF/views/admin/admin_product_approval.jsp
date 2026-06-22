<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 상품 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="products" />
        <jsp:param name="sidebarTitle" value="상품 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">PRODUCT MANAGEMENT</span>
                <h1>상품 관리</h1>
                <p>등록된 상품 정보를 확인하고 판매 상태를 빠르게 파악합니다.</p>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <div class="admin-filter-tabs">
                    <button type="button" class="active">전체</button>
                    <button type="button">판매중</button>
                    <button type="button">품절</button>
                    <button type="button">승인대기</button>
                </div>
                <input type="text" class="admin-search" placeholder="상품명, 판매자 검색">
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>이미지</th>
                        <th>상품명</th>
                        <th>판매자</th>
                        <th>카테고리</th>
                        <th>가격</th>
                        <th>상태</th>
                        <th>등록일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td><span class="admin-thumb">IMG</span></td>
                        <td class="left"><strong>핸드메이드 라탄 바구니</strong></td>
                        <td>라탄하우스</td>
                        <td>생활소품</td>
                        <td>42,000원</td>
                        <td><span class="admin-status active">판매중</span></td>
                        <td>2026-06-16</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="admin-thumb">IMG</span></td>
                        <td class="left"><strong>천연염색 스카프</strong></td>
                        <td>물빛공방</td>
                        <td>패션잡화</td>
                        <td>58,000원</td>
                        <td><span class="admin-status active">판매중</span></td>
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
