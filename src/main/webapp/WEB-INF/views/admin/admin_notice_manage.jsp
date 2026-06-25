<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 공지사항 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="notices" />
        <jsp:param name="sidebarTitle" value="공지사항 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">NOTICE MANAGEMENT</span>
                <h1>공지사항 관리</h1>
                <p>쇼핑몰 공지사항을 확인하고 관리합니다.</p>
            </div>
            <div class="admin-header-actions">
                <a href="/notice_form.do" class="admin-btn">공지 등록</a>
                <a href="/notice_list.do" class="admin-btn light">사용자 공지 보기</a>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-card-head">
                <h3>공지사항 목록</h3>
            </div>
            <div class="admin-filter-box">
                <form class="admin-filter-form" action="/admin/notices" method="get">
                    <div class="admin-filter-tabs">
                        <button type="button" class="active">전체</button>
                        <button type="button">공지</button>
                    </div>
                    <input type="text" class="admin-search" name="keyword" placeholder="제목 검색">
                </form>
            </div>
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>번호</th>
                        <th>유형</th>
                        <th>제목</th>
                        <th>상태</th>
                        <th>등록일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="notice" items="${noticeList}">
                    <tr>
                        <td>${notice.notice_id}</td>
                        <td>공지(미구현)</td>
                        <td class="left"><strong>${notice.title}</strong></td>
                        <td><span class="admin-status active">노출(미구현)</span></td>
                        <td>${notice.created_at}</td>
                        <td class="admin-table-actions">
                            <a href="/notice_update_form.do?notice_id=32" class="admin-btn light">수정</a>
                            <a href="/notice_detail.do?notice_id=32" class="admin-btn light">상세</a>
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
