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

        <section class="admin-master-detail is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-filter-box">
                    <form class="admin-filter-form" action="/admin/reports" method="get">
                        <div class="admin-filter-tabs">
                            <a href="/admin/reports?status=all&keyword=${keyword}&size=${pagination.size}&page=1" class="${status eq 'all' ? 'active' : ''}">전체</a>
                            <a href="/admin/reports?status=pending&keyword=${keyword}&size=${pagination.size}&page=1" class="${status eq 'pending' ? 'active' : ''}">처리대기</a>
                            <a href="/admin/reports?status=processed&keyword=${keyword}&size=${pagination.size}&page=1" class="${status eq 'processed' ? 'active' : ''}">처리완료</a>
                            <a href="/admin/reports?status=rejected&keyword=${keyword}&size=${pagination.size}&page=1" class="${status eq 'rejected' ? 'active' : ''}">반려</a>
                        </div>
                        <input type="hidden" name="status" value="${status}"/>
                        <input type="hidden" name="size" value="${pagination.size}"/>
                        <input type="hidden" name="page" value="1"/>
                        <input type="text" class="admin-search" name="keyword" 
                               placeholder="신고 대상, 신고자 검색" value="${keyword}">
                    </form>
                </div>

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
                            <td>${report.reason}</td>
                            <td>${report.reporter_name}</td>
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
                                <dd id="reason">-</dd>
                            </div>
                            <div>
                                <dt>신고자 번호</dt>
                                <dd id="reporterId">-</dd>
                            </div>
                            <div>
                                <dt>신고자</dt>
                                <dd id="reporterName">-</dd>
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
            <c:if test="${pagination.totalPage > 0}">
                <c:if test="${pagination.hasPrev}">
                    <a href="/admin/reports?status=${status}&keyword=${keyword}&size=${pagination.size}&page=${pagination.prevPage}">
                        이전
                    </a>
                </c:if>
                <c:if test="${!pagination.hasPrev}">
                    <span class="disabled">이전</span>
                </c:if>

                <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                    <a href="/admin/reports?status=${status}&keyword=${keyword}&size=${pagination.size}&page=${i}"
                        class="${pagination.page == i ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>

                <c:if test="${pagination.hasNext}">
                    <a href="/admin/reports?status=${status}&keyword=${keyword}&size=${pagination.size}&page=${pagination.nextPage}">
                        다음
                    </a>
                </c:if>
                <c:if test="${!pagination.hasNext}">
                    <span class="disabled">다음</span>
                </c:if>
            </c:if>
        </div>
    </main>
</div>
</body>
</html>
