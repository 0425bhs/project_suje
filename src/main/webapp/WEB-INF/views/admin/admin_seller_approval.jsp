<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 판매자 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="sellers" />
        <jsp:param name="sidebarTitle" value="판매자 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">SELLER MANAGEMENT</span>
                <h1>판매자 관리</h1>
                <p>판매자 신청 정보와 현재 상태를 확인합니다.</p>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <div class="admin-filter-tabs">
                    <button type="button" class="active">승인대기</button>
                    <button type="button">승인완료</button>
                </div>
                <input type="text" class="admin-search" placeholder="상점명, 대표자 검색">
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>신청번호</th>
                        <th>상점명</th>
                        <th>대표자</th>
                        <th>사업자번호</th>
                        <th>주요 카테고리</th>
                        <th>상태</th>
                        <th>신청일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="seller" items="${sellerList}">
                    <tr>
                        <td>${seller.user_id}</td>
                        <td class="left"><strong>${seller.company_name}</strong></td>
                        <td>${seller.representative_name}</td>
                        <td>${seller.business_number}</td>
                        <td>(미구현)</td>
                        <td><span class="admin-status pending">${seller.status eq pending ? "승인대기" : "승인완료"}</span></td>
                        <td>${seller.created_at}</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                        </td>
                    </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
