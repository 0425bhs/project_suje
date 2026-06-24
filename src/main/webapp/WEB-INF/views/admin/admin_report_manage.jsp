<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
                <form class="admin-filter-form" action="/admin/reports" method="get">
                    <div class="admin-filter-tabs">
                        <button type="button" class="active">미처리</button>
                        <button type="button">상품</button>
                        <button type="button">후기</button>
                        <button type="button">회원</button>
                    </div>
                    <input type="text" class="admin-search" name="keyword" placeholder="신고 대상, 신고자 검색">
                </form>
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
                    <c:forEach var="report" items="${reportList}">
                    <tr>
                        <td>${report.report_id}</td>
                        <td class="left"><strong>${report.target_type}${report.target_id}</strong></td>
                        <td>${report.reason}</td>
                        <td>${report.reporter_name}</td>
                        <td><span class="admin-status pending">${report.status}</span></td>
                        <td>${report.created_at}</td>
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
