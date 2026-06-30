<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 신고 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
    <script src="/js/admin_detail_common.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const master = document.getElementById("adminMasterDetail");
            const rows = document.querySelectorAll(".admin-clickable-row");

            rows.forEach((row) => {
                row.addEventListener("click", () => {
                    if (!master.classList.contains("is-collapsed") && row.classList.contains("selected")) {
                        closeDetailPanel(master, row);
                        return;
                    }

                    openDetailPanel(master, rows, row);

                    const reportId = row.dataset.reportId;

                    fetch("/admin/reports/detail?report_id=" + encodeURIComponent(reportId))
                    .then(res => res.json())
                    .then(data => {
                        const report = data.report;

                        setText("reportId", report.report_id);
                        setText("targetType", report.target_type);
                        setText("targetId", report.target_id);
                        setText("reason", report.reason);
                        setText("reporterId", report.reporter_id);
                        setText("reporterName", report.reporter_name);
                        setText("status", report.status);
                        setText("createdAt", report.created_at);
                        highlightAdminKeyword(document.getElementById("adminDetailPanel"));
                    });
                });
            });
        });
    </script>
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

        <div class="admin-filter-box admin-filter-modern">
            <form class="admin-filter-form" action="/admin/reports" method="get">
                <div class="admin-filter-main-row">
                    <div class="admin-filter-tabs">
                        <a href="/admin/reports?status=all&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1" class="${status eq 'all' ? 'active' : ''}">전체</a>
                        <a href="/admin/reports?status=pending&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1" class="${status eq 'pending' ? 'active' : ''}">처리대기</a>
                        <a href="/admin/reports?status=processed&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1" class="${status eq 'processed' ? 'active' : ''}">처리완료</a>
                        <a href="/admin/reports?status=rejected&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1" class="${status eq 'rejected' ? 'active' : ''}">반려</a>
                    </div>

                    <div class="admin-search-wrap">
                        <input type="text" id="keyword" class="admin-search" name="keyword"
                            placeholder="신고 대상, 신고자 검색" value="${keyword}">
                        <span class="admin-search-icon" aria-hidden="true"></span>
                    </div>
                    <button type="submit" class="admin-btn admin-search-submit">검색</button>
                    <button type="button" class="admin-btn light admin-filter-toggle">상세 검색</button>
                    <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                        <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                        <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                        <option value="target" ${sort eq 'target' ? 'selected' : ''}>대상순</option>
                    </select>
                    <select id="pageSize" class="admin-filter-control admin-page-size-control" name="size">
                        <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                        <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                        <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                    </select>
                </div>

                <div class="admin-filter-detail-row">
                    <label class="admin-filter-field">
                        <span>상태</span>
                        <select class="admin-filter-control" name="status">
                            <option value="all" ${status eq 'all' ? 'selected' : ''}>전체</option>
                            <option value="pending" ${status eq 'pending' ? 'selected' : ''}>처리대기</option>
                            <option value="processed" ${status eq 'processed' ? 'selected' : ''}>처리완료</option>
                            <option value="rejected" ${status eq 'rejected' ? 'selected' : ''}>반려</option>
                        </select>
                    </label>
                    <label class="admin-filter-field admin-filter-date-range">
                        <span>접수일 범위</span>
                        <input type="date" class="admin-filter-control" name="startDate" value="${startDate}">
                        <em>~</em>
                        <input type="date" class="admin-filter-control" name="endDate" value="${endDate}">
                    </label>
                    <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                </div>

                <c:if test="${status ne 'all' || not empty keyword || not empty startDate || not empty endDate}">
                    <div class="admin-filter-applied">
                        <span class="admin-filter-applied-label">적용된 조건:</span>
                        <c:if test="${status ne 'all'}">
                            <a class="admin-filter-chip"
                                href="/admin/reports?status=all&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                상태:
                                ${status eq 'pending' ? '처리대기' : status eq 'processed' ? '처리완료' : '반려'}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty keyword}">
                            <a class="admin-filter-chip" href="/admin/reports?status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                검색어: ${keyword}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty startDate || not empty endDate}">
                            <a class="admin-filter-chip" href="/admin/reports?status=${status}&keyword=${keyword}&sort=${sort}&size=${pagination.size}&page=1">
                                접수일: ${startDate} ~ ${endDate}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <a class="admin-filter-clear" href="/admin/reports">전체 해제</a>
                    </div>
                </c:if>

                <input type="hidden" name="page" value="1">
            </form>
        </div>

        <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>신고번호</th>
                            <th>대상 유형</th>
                            <th>대상 번호</th>
                            <th>사유</th>
                            <th>신고자</th>
                            <th>상태</th>
                            <th>접수일</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="report" items="${reportList}">
                        <tr class="admin-clickable-row" data-report-id="${report.report_id}">
                            <td>${report.report_id}</td>
                            <td>
                                <strong>
                                    <c:choose>    
                                        <c:when test="${report.target_type eq 'PRODUCT'}">상품</c:when>
                                        <c:when test="${report.target_type eq 'REVIEW'}">후기</c:when>
                                        <c:when test="${report.target_type eq 'QNA'}">문의</c:when>
                                    </c:choose>
                                    </strong>
                            </td>
                            <td><strong>${report.target_id}</strong></td>
                            <td class="admin-highlight-target">${report.reason}</td>
                            <td class="admin-highlight-target">${report.reporter_name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${report.status eq 'PENDING'}">
                                        <span class="admin-status pending">처리대기</span>
                                    </c:when>
                                    <c:when test="${report.status eq 'PROCESSED'}">
                                        <span class="admin-status processed">처리완료</span>
                                    </c:when>
                                    <c:when test="${report.status eq 'REJECTED'}">
                                        <span class="admin-status rejected">반려</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>${report.created_at}</td>
                            <td class="admin-table-actions">
                                <button type="button" class="admin-btn light">상세</button>
                            </td>
                        </tr>
                        </c:forEach>
                        
                        </tbody>
                    </table>
                </div>
            </div>

            <aside class="admin-card admin-detail-panel" id="adminDetailPanel">
                <div class="admin-detail-panel-inner">
                    <div class="admin-detail-content">
                        <div class="admin-detail-head">
                            <div>
                                <span class="admin-page-label">REPORT DETAIL</span>
                                <h2 id="reportDetailTitle">신고 상세</h2>
                            </div>
                            <button type="button" class="admin-detail-close" aria-label="닫기">&times;</button>
                        </div>
                        <dl class="admin-detail-grid">
                            <div>
                                <dt>신고번호</dt>
                                <dd id="reportId">-</dd>
                            </div>
                            <div>
                                <dt>대상 유형</dt>
                                <dd id="targetType">-</dd>
                            </div>
                            <div>
                                <dt>대상 번호</dt>
                                <dd id="targetId">-</dd>
                            </div>
                            <div>
                                <dt>사유</dt>
                                <dd id="reason" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>신고자 번호</dt>
                                <dd id="reporterId">-</dd>
                            </div>
                            <div>
                                <dt>신고자</dt>
                                <dd id="reporterName" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>상태</dt>
                                <dd id="status">-</dd>
                            </div>
                            <div>
                                <dt>접수일</dt>
                                <dd id="createdAt">-</dd>
                            </div>
                        </dl>
                    </div>
                </div>
            </aside>
        </section>

        <div class="admin-pagination">
            <div class="admin-pagination-pages">
                <c:if test="${pagination.totalPage > 0}">
                    <c:if test="${pagination.hasPrev}">
                        <a href="/admin/reports?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                            이전
                        </a>
                    </c:if>
                    <c:if test="${!pagination.hasPrev}">
                        <span class="disabled">이전</span>
                    </c:if>

                    <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                        <a href="/admin/reports?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                            class="${pagination.page == i ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${pagination.hasNext}">
                        <a href="/admin/reports?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
                            다음
                        </a>
                    </c:if>
                    <c:if test="${!pagination.hasNext}">
                        <span class="disabled">다음</span>
                    </c:if>
                </c:if>
            </div>
            <span class="admin-filter-count">전체 ${totalCount}건</span>
        </div>
    </main>
</div>
</body>
</html>
