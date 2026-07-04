<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 대시보드</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <script src="/js/admin_detail_common.js"></script>
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="dashboard" />
        <jsp:param name="sidebarTitle" value="관리자 센터" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">ADMIN CENTER</span>
                <h1>관리자 대시보드</h1>
            </div>
            <div class="admin-header-actions">
                <a href="/product/main.do" class="admin-btn light">쇼핑몰로 이동</a>
            </div>
        </header>

        <section class="admin-grid three">
            <a href="/admin/sellers?page=1" class="admin-card admin-stat-card admin-stat-link">
                <span class="admin-stat-label">전체 판매자</span>
                <strong class="admin-stat-value">${totalSellerCount}<small>곳</small></strong>
                <span class="admin-stat-note">판매자 신청/승인 전체</span>
            </a>
            <a href="/admin/products?status=approved&page=1" class="admin-card admin-stat-card admin-stat-link">
                <span class="admin-stat-label">판매중 상품</span>
                <strong class="admin-stat-value">${approvedProductCount}<small>개</small></strong>
                <span class="admin-stat-note">현재 구매 가능한 상품</span>
            </a>
            <a href="/admin/members?page=1" class="admin-card admin-stat-card admin-stat-link">
                <span class="admin-stat-label">전체 회원</span>
                <strong class="admin-stat-value">${totalMemberCount}<small>명</small></strong>
                <span class="admin-stat-note">가입 계정 전체</span>
            </a>
        </section>
        
        <section class="admin-grid" style="margin-top:18px;">
            <a href="/admin/sellers?status=pending&page=1" class="admin-card admin-stat-card admin-stat-link">
                <span class="admin-stat-label">판매자 승인 대기</span>
                <strong class="admin-stat-value">${pendingSellerCount}<small>건</small></strong>
            </a>
            <a href="/admin/products?status=pending&page=1" class="admin-card admin-stat-card admin-stat-link">
                <span class="admin-stat-label">상품 승인 대기</span>
                <strong class="admin-stat-value">${pendingProductCount}<small>건</small></strong>
            </a>
            <a href="/admin/reports?status=pending&page=1" class="admin-card admin-stat-card admin-stat-link">
                <span class="admin-stat-label">신고 처리 대기</span>
                <strong class="admin-stat-value">${pendingReportCount}<small>건</small></strong>
            </a>
            <a href="/admin/inquiries?status=waiting&page=1" class="admin-card admin-stat-card admin-stat-link">
                <span class="admin-stat-label">관리자 문의 대기</span>
                <strong class="admin-stat-value">${waitingInquiryCount}<small>건</small></strong>
            </a>
        </section>

        <section class="admin-grid" style="margin-top:18px;">
            <article class="admin-card span-4">
                <div class="admin-card-head">
                    <h3>최근 처리 내역</h3>
                    <a href="/admin/action-logs" class="admin-btn light">전체 보기</a>
                </div>
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>관리자</th>
                            <th>대상</th>
                            <th>작업</th>
                            <th>변경</th>
                            <th>사유</th>
                            <th>일시</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty recentActionLogList}">
                                <tr>
                                    <td colspan="6">최근 상태 변경 내역이 없습니다.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="log" items="${recentActionLogList}">
                                    <c:choose>
                                        <c:when test="${log.target_type eq 'MEMBER'}">
                                            <c:set var="targetHref" value="/admin/members?user_id=${log.target_id}&page=1" />
                                        </c:when>
                                        <c:when test="${log.target_type eq 'SELLER'}">
                                            <c:set var="targetHref" value="/admin/sellers?seller_id=${log.target_id}&page=1" />
                                        </c:when>
                                        <c:when test="${log.target_type eq 'PRODUCT'}">
                                            <c:set var="targetHref" value="/admin/products?product_id=${log.target_id}&page=1" />
                                        </c:when>
                                        <c:when test="${log.target_type eq 'INQUIRY'}">
                                            <c:set var="targetHref" value="/admin/inquiries?status=all&page=1" />
                                        </c:when>
                                        <c:when test="${log.target_type eq 'REPORT'}">
                                            <c:set var="targetHref" value="/admin/reports?status=all&page=1" />
                                        </c:when>
                                        <c:when test="${log.target_type eq 'ORDER'}">
                                            <c:set var="targetHref" value="/admin/orders?keyword=${log.target_id}&page=1" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="targetHref" value="" />
                                        </c:otherwise>
                                    </c:choose>
                                    <tr class="${empty targetHref ? '' : 'admin-clickable-row'}" data-href="${targetHref}">
                                        <td>${empty log.admin_name ? '관리자' : log.admin_name}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${log.target_type eq 'MEMBER'}">회원 #${log.target_id}</c:when>
                                                <c:when test="${log.target_type eq 'SELLER'}">판매자 #${log.target_id}</c:when>
                                                <c:when test="${log.target_type eq 'PRODUCT'}">상품 #${log.target_id}</c:when>
                                                <c:when test="${log.target_type eq 'INQUIRY'}">문의 #${log.target_id}</c:when>
                                                <c:when test="${log.target_type eq 'REPORT'}">신고 #${log.target_id}</c:when>
                                                <c:when test="${log.target_type eq 'ORDER'}">주문 #${log.target_id}</c:when>
                                                <c:otherwise>기타 #${log.target_id}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${log.action_type eq 'ANSWER'}">답변 저장</c:when>
                                                <c:otherwise>상태 변경</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <strong>${log.beforeStatusLabel}</strong>
                                            →
                                            <strong>${log.afterStatusLabel}</strong>
                                        </td>
                                        <td class="left">${empty log.memo ? '없음' : log.memo}</td>
                                        <td>${log.created_at}</td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </article>
        </section>
    </main>
</div>
</body>
</html>
