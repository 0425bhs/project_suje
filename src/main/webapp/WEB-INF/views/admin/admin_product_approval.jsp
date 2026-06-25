<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 상품 승인/반려/숨김</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="products" />
        <jsp:param name="sidebarTitle" value="상품 승인 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">PRODUCT MODERATION</span>
                <h1>상품 승인/반려/숨김</h1>
                <p>신규 등록 상품과 신고 상품을 검토하고 노출 상태를 관리합니다.</p>
            </div>
            <div class="admin-header-actions">
                <button type="button" class="admin-btn">선택 승인</button>
                <button type="button" class="admin-btn danger">선택 숨김</button>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <div class="admin-filter-tabs">
                    <button type="button" class="active">승인대기</button>
                    <button type="button">판매중</button>
                    <button type="button">반려</button>
                    <button type="button">숨김</button>
                    <button type="button">신고누적</button>
                </div>
                <input type="text" class="admin-search" placeholder="상품명, 판매자 검색">
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th><input type="checkbox"></th>
                        <th>이미지</th>
                        <th>상품명</th>
                        <th>판매자</th>
                        <th>카테고리</th>
                        <th>가격</th>
                        <th>상태</th>
                        <th>신청일</th>
                        <th>처리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td><span class="admin-thumb">IMG</span></td>
                        <td class="left"><strong>핸드메이드 라탄 바구니</strong></td>
                        <td>라탄하우스</td>
                        <td>생활소품</td>
                        <td>42,000원</td>
                        <td><span class="admin-status pending">대기</span></td>
                        <td>2026-06-16</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn">승인</button>
                            <button type="button" class="admin-btn danger">반려</button>
                            <button type="button" class="admin-btn muted">숨김</button>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td><span class="admin-thumb">IMG</span></td>
                        <td class="left"><strong>천연염색 스카프</strong></td>
                        <td>물빛공방</td>
                        <td>패션잡화</td>
                        <td>58,000원</td>
                        <td><span class="admin-status warning">신고검토</span></td>
                        <td>2026-06-15</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                            <button type="button" class="admin-btn muted">숨김</button>
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
