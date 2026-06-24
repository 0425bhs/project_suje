<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 고객센터 문의 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="inquiries" />
        <jsp:param name="sidebarTitle" value="고객센터 문의 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">INQUIRY MANAGEMENT</span>
                <h1>고객센터 문의 관리</h1>
                <p>회원, 주문, 결제, 판매자 관련 문의를 확인하고 답변합니다.</p>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <form class="admin-filter-form" action="/admin/inquiries" method="get">
                    <div class="admin-filter-tabs">
                        <a href="/admin/inquiries?status=all&keyword=${keyword}"
                           class="${status eq 'all' ? 'active' : ''}">전체</a>
                        <a href="/admin/inquiries?status=waiting&keyword=${keyword}"
                           class="${status eq 'waiting' ? 'active' : ''}">미답변</a>
                        <a href="/admin/inquiries?status=answered&keyword=${keyword}"
                           class="${status   eq 'answered' ? 'active' : ''}">답변완료</a>
                    </div>
                    <input type="hidden" name="status" value="${status}"/>
                    <input type="text" class="admin-search" name="keyword" 
                           placeholder="문의 제목, 작성자 검색" value="${keyword}"/>
                </form>
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>문의번호</th>
                        <th>문의 유형</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>상태</th>
                        <th>작성일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="inquiry" items="${inquiryList}">
                    <tr>
                        <td>${inquiry.inquiry_id}</td>
                        <td>
                            <c:choose>
                                <c:when test="${inquiry.inquiry_type eq 'SERVICE'}">서비스 이용</c:when>
                                <c:when test="${inquiry.inquiry_type eq 'ACCOUNT'}">회원/계정</c:when>
                                <c:when test="${inquiry.inquiry_type eq 'PAYMENT'}">결제 오류</c:when>
                                <c:when test="${inquiry.inquiry_type eq 'SELLER'}">판매자 센터</c:when>
                                <c:when test="${inquiry.inquiry_type eq 'POLICY'}">운영 정책</c:when>
                                <c:when test="${inquiry.inquiry_type eq 'ETC'}">기타</c:when>
                            </c:choose>
                        </td>
                        <td class="left"><strong>${inquiry.title}</strong></td>
                        <td>${inquiry.user_name}</td>
                        <td>
                        <c:choose>
                            <c:when test="${inquiry.status eq 'WAITING'}">
                            <span class="admin-status waiting">미답변</span>
                            </c:when>

                            <c:when test="${inquiry.status eq 'ANSWERED'}">
                            <span class="admin-status answered">답변</span>
                            </c:when>
                        </c:choose>
                        </td>
                        <td>${inquiry.created_at}</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn">답변</button>
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
