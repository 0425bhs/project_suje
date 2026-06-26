<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

            <section class="admin-master-detail is-collapsed" id="adminMasterDetail">
                <div class="admin-card admin-list-panel">
                    <div class="admin-filter-box">
                        <form class="admin-filter-form" action="/admin/sellers" method="get">
                            <div class="admin-filter-tabs">
                                <a href="/admin/sellers?status=all&keyword=${keyword}"
                                    class="${status eq 'all' ? 'active' : ''}">전체</a>
                                <a href="/admin/sellers?status=pending&keyword=${keyword}"
                                    class="${status eq 'pending' ? 'active' : ''}">승인대기</a>
                                <a href="/admin/sellers?status=approved&keyword=${keyword}"
                                    class="${status eq 'approved' ? 'active' : ''}">승인완료</a>
                                <a href="/admin/sellers?status=rejected&keyword=${keyword}"
                                    class="${status eq 'rejected' ? 'active' : ''}">반려</a>
                            </div>
                            <span class="admin-filter-count">전체 ${totalCount}건</span>
                            <input type="hidden" name="status" value="${status}">
                            <input type="text" class="admin-search" name="keyword" placeholder="상점명, 대표자 검색"
                                value="${keyword}">
                        </form>
                    </div>

                    <div class="admin-table-wrap">
                        <table class="admin-table admin-seller-table">
                            <thead>
                                <tr>
                                    <th>신청번호</th>
                                    <th>상점명</th>
                                    <th>대표자</th>
                                    <th>사업자번호</th>
                                    <th>상태</th>
                                    <th>신청일</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="seller" items="${sellerList}">
                                    <tr class="admin-clickable-row" data-user-id="${seller.user_id}"
                                        data-seller-id="${seller.seller_id}"
                                        data-company-name="${seller.company_name}"
                                        data-representative-name="${seller.representative_name}"
                                        data-business-number="${seller.business_number}"
                                        data-opening-date="${seller.opening_date}"
                                        data-business-address="${seller.business_address}"
                                        data-status="${seller.status}"
                                        data-status-label="${seller.status eq 'PENDING' ? '승인대기' : seller.status eq 'APPROVED' ? '승인완료' : '반려'}"
                                        data-created-at="${seller.created_at}">
                                        <td>${seller.user_id}</td>
                                        <td class="left"><strong>${seller.company_name}</strong></td>
                                        <td>${seller.representative_name}</td>
                                        <td>${seller.business_number}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${seller.status eq 'PENDING'}">
                                                    <span class="admin-status pending">승인대기</span>
                                                </c:when>

                                                <c:when test="${seller.status eq 'APPROVED'}">
                                                    <span class="admin-status approved">승인완료</span>
                                                </c:when>

                                                <c:when test="${seller.status eq 'REJECTED'}">
                                                    <span class="admin-status rejected">반려</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>${seller.created_at}</td>
                                        <td class="admin-table-actions">
                                            <button type="button"
                                                class="admin-btn light admin-detail-btn">상세</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <aside class="admin-card admin-detail-panel" id="adminDetailPanel"
                    aria-labelledby="sellerDetailTitle">
                    <div class="admin-detail-panel-inner">
                        <div class="admin-detail-content" hidden>
                            <div class="admin-detail-head">
                                <div>
                                    <span class="admin-page-label">SELLER DETAIL</span>
                                    <h2 id="sellerDetailTitle">판매자 상세</h2>
                                </div>
                                <button type="button" class="admin-detail-close"
                                    aria-label="닫기">&times;</button>
                            </div>
                            <dl class="admin-detail-grid">
                                <div>
                                    <dt>신청번호</dt>
                                    <dd id="sellerPanelUserId">-</dd>
                                </div>
                                <div>
                                    <dt>판매자번호</dt>
                                    <dd id="sellerPanelSellerId">-</dd>
                                </div>
                                <div>
                                    <dt>상점명</dt>
                                    <dd id="sellerPanelCompanyName">-</dd>
                                </div>
                                <div>
                                    <dt>대표자</dt>
                                    <dd id="sellerPanelRepresentativeName">-</dd>
                                </div>
                                <div>
                                    <dt>사업자번호</dt>
                                    <dd id="sellerPanelBusinessNumber">-</dd>
                                </div>
                                <div>
                                    <dt>개업일자</dt>
                                    <dd id="sellerPanelOpeningDate">-</dd>
                                </div>
                                <div>
                                    <dt>사업자 주소</dt>
                                    <dd id="sellerPanelBusinessAddress">-</dd>
                                </div>
                                <div>
                                    <dt>상태</dt>
                                    <dd id="sellerPanelStatus">-</dd>
                                </div>
                                <div>
                                    <dt>신청일</dt>
                                    <dd id="sellerPanelCreatedAt">-</dd>
                                </div>
                            </dl>
                        </div>
                    </div>
                </aside>
            </section>
        </main>
    </div>
</body>

</html>
