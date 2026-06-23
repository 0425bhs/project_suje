<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 카테고리 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="categories" />
        <jsp:param name="sidebarTitle" value="카테고리 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">CATEGORY MANAGEMENT</span>
                <h1>카테고리 관리</h1>
                <p>현재 카테고리 구조를 확인합니다. 등록/수정은 DAO 추가 후 확장하면 됩니다.</p>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-card-head">
                <h3>카테고리 목록</h3>
                <span class="admin-status active">조회 가능</span>
            </div>
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>대분류 번호</th>
                        <th>대분류</th>
                        <th>소분류 번호</th>
                        <th>소분류</th>
                        <th>상태</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="category" items="${categoryList}">
                    <tr>
                        <td>${category.parent_id}</td>
                        <td><strong>${category.parent_name}</strong></td>
                        <td>${category.child_id}</td>
                        <td>${category.child_name}</td>
                        <td><span class="admin-status active">사용중</span></td>
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
