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
    <style>
        .admin-report-reason-text {
            display: block;
            max-width: 100%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const master = document.getElementById("adminMasterDetail");
            const rows = document.querySelectorAll(".admin-clickable-row");
            const statusLabels = {
                PENDING: "처리대기",
                PROCESSED: "처리완료",
                REJECTED: "반려"
            };
            const managePanel = initAdminDetailManage({
                targetType: "REPORT",
                statusUrl: "/admin/reports/status",
                idParam: "report_id",
                statusBadgeId: "reportDetailStatusBadge",
                statusLabels
            });

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
                        const targetLabels = {
                            PRODUCT: "상품",
                            REVIEW: "후기",
                            QNA: "문의"
                        };
                        const statusKey = String(report.status || "").toUpperCase();
                        const targetKey = String(report.target_type || "").toUpperCase();
                        const statusLabel = statusLabels[statusKey] || "알 수 없음";
                        const targetLabel = targetLabels[targetKey] || "알 수 없음";

                        setDetailTitleBlock(
                            "reportDetailTitle",
                            "reportDetailMeta",
                            report.target_title || "신고 상세",
                            (targetLabel || "-") + " · " + (report.reporter_name || "-")
                        );
                        setDetailStatusBadge("reportDetailStatusBadge", report.status, statusLabel);
                        setText("targetType", targetLabel);
                        setText("targetTitle", report.target_title);
                        setText("reason", report.reason);
                        setText("reporterName", report.reporter_name);
                        setText("status", statusLabel);
                        setText("createdAt", report.created_at);
                        managePanel.setTarget(report.report_id, statusKey, row);

                        document.getElementById("reportMemberLink").href =
                            "/admin/members?user_id=" + encodeURIComponent(report.reporter_id);
                        document.getElementById("reportMemberReportsLink").href =
                            "/admin/reports?user_id=" + encodeURIComponent(report.reporter_id);

                        const targetLink = document.getElementById("reportTargetLink");

                        if (targetLink) {
                            if (targetKey === "PRODUCT") {
                                targetLink.href = "/admin/products?product_id=" + encodeURIComponent(report.target_id);
                                targetLink.querySelector("span").textContent = "대상 상품";
                                targetLink.hidden = false;
                            } else if (targetKey === "REVIEW") {
                                targetLink.href = "/admin/reviews?review_id=" + encodeURIComponent(report.target_id);
                                targetLink.querySelector("span").textContent = "대상 후기";
                                targetLink.hidden = false;
                            } else {
                                targetLink.hidden = true;
                            }
                        }

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

    <main class="admin-main admin-main-fixed">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">REPORT MANAGEMENT</span>
                <h1>신고 관리</h1>
            </div>
        </header>

        <div class="admin-fixed-list-layout">
            <div class="admin-filter-box admin-filter-modern">
            <form class="admin-filter-form" action="/admin/reports" method="get">
                <div class="admin-filter-main-row">
                    <div class="admin-filter-tabs">
                        <a href="/admin/reports?status=all&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1" class="${status eq 'all' ? 'active' : ''}">전체</a>
                        <a href="/admin/reports?status=pending&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1" class="${status eq 'pending' ? 'active' : ''}">처리대기</a>
                        <a href="/admin/reports?status=processed&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1" class="${status eq 'processed' ? 'active' : ''}">처리완료</a>
                        <a href="/admin/reports?status=rejected&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1" class="${status eq 'rejected' ? 'active' : ''}">반려</a>
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
                    <label class="admin-filter-field">
                        <span>대상 유형</span>
                        <select class="admin-filter-control" name="targetType">
                            <option value="all" ${targetType eq 'all' ? 'selected' : ''}>전체</option>
                            <option value="PRODUCT" ${targetType eq 'PRODUCT' ? 'selected' : ''}>상품</option>
                            <option value="REVIEW" ${targetType eq 'REVIEW' ? 'selected' : ''}>후기</option>
                            <option value="QNA" ${targetType eq 'QNA' ? 'selected' : ''}>문의</option>
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

                <c:if test="${status ne 'all' || not empty keyword || not empty user_id || targetType ne 'all' || not empty target_id || not empty startDate || not empty endDate}">
                    <div class="admin-filter-applied">
                        <span class="admin-filter-applied-label">적용된 조건:</span>
                        <c:if test="${status ne 'all'}">
                            <a class="admin-filter-chip"
                                href="/admin/reports?status=all&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                상태:
                                ${status eq 'pending' ? '처리대기' : status eq 'processed' ? '처리완료' : '반려'}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty keyword}">
                            <a class="admin-filter-chip" href="/admin/reports?status=${status}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                검색어: ${keyword}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty user_id}">
                            <a class="admin-filter-chip" href="/admin/reports?status=${status}&keyword=${keyword}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                회원:
                                <c:choose>
                                    <c:when test="${not empty filterUser}">
                                        ${filterUser.name} · ${filterUser.login_id}
                                    </c:when>
                                    <c:otherwise>${user_id}</c:otherwise>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${targetType ne 'all'}">
                            <a class="admin-filter-chip" href="/admin/reports?status=${status}&keyword=${keyword}&user_id=${user_id}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                대상 유형:
                                <c:choose>
                                    <c:when test="${targetType eq 'PRODUCT'}">상품</c:when>
                                    <c:when test="${targetType eq 'REVIEW'}">후기</c:when>
                                    <c:otherwise>문의</c:otherwise>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty target_id}">
                            <a class="admin-filter-chip" href="/admin/reports?status=${status}&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                대상 번호: ${target_id}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty startDate || not empty endDate}">
                            <a class="admin-filter-chip" href="/admin/reports?status=${status}&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&sort=${sort}&size=${pagination.size}&page=1">
                                접수일: ${startDate} ~ ${endDate}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <a class="admin-filter-clear" href="/admin/reports">전체 해제</a>
                    </div>
                </c:if>

                <input type="hidden" name="target_id" value="${target_id}">

                <input type="hidden" name="user_id" value="${user_id}">
                <input type="hidden" name="page" value="1">
            </form>
        </div>

        <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>대상 유형</th>
                            <th>대상 요약</th>
                            <th>사유</th>
                            <th>신고자</th>
                            <th>상태</th>
                            <th>접수일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty reportList}">
                            <tr>
                                <td colspan="7">신고 목록이 없습니다.</td>
                            </tr>
                        </c:if>
                        <c:forEach var="report" items="${reportList}" varStatus="loop">
                        <tr class="admin-clickable-row" data-report-id="${report.report_id}">
                            <td>${pagination.offset + loop.index + 1}</td>
                            <td>
                                <strong>
                                    <c:choose>    
                                        <c:when test="${report.target_type eq 'PRODUCT'}">상품</c:when>
                                        <c:when test="${report.target_type eq 'REVIEW'}">후기</c:when>
                                        <c:when test="${report.target_type eq 'QNA'}">문의</c:when>
                                    </c:choose>
                                    </strong>
                            </td>
                            <td class="admin-highlight-target">${report.target_title}</td>
                            <td class="admin-highlight-target">
                                <span class="admin-report-reason-text" title="${report.reason}">${report.reason}</span>
                            </td>
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
                                        <div class="admin-detail-head-main">
                                            <div class="admin-detail-title-block">
                                                <div class="admin-detail-title-line">
                                                    <h2 id="reportDetailTitle">신고 상세</h2>
                                                    <span class="admin-detail-status-badge" id="reportDetailStatusBadge">-</span>
                                                </div>
                                                <p id="reportDetailMeta">목록에서 신고를 선택하세요.</p>
                                            </div>
                                            <div class="admin-detail-toolbar">
                                                <button type="button" class="admin-detail-close"
                                                    aria-label="닫기">&times;</button>
                                            </div>
                                        </div>
                                        <div class="admin-detail-tabs">
                                            <button type="button" class="admin-detail-tab active" data-detail-tab="info">
                                                정보
                                            </button>
                                            <button type="button" class="admin-detail-tab" data-detail-tab="manage">
                                                관리
                                            </button>
                                        </div>
                                    </div>
                        <div class="admin-detail-tab-body">
                                        <div class="admin-detail-tab-panel active" data-detail-panel="info">
                                            <div class="admin-detail-info-scroll">
                                                <div class="admin-detail-manage-section admin-detail-quick-link-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>바로가기</h3>
                                                    </div>
                                                    <div class="admin-detail-link-list">
                                                        <a href="#" id="reportMemberLink">
                                                            <span>회원 관리</span>
                                                        </a>
                                                        <a href="#" id="reportMemberReportsLink">
                                                            <span>회원 신고</span>
                                                        </a>
                                                        <a href="#" id="reportTargetLink" hidden>
                                                            <span>신고 대상</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <dl class="admin-detail-grid">
                            <div>
                                <dt>대상 유형</dt>
                                <dd id="targetType">-</dd>
                            </div>
                            <div>
                                <dt>대상 요약</dt>
                                <dd id="targetTitle" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>사유</dt>
                                <dd id="reason" class="admin-highlight-target">-</dd>
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
                                        <div class="admin-detail-tab-panel" data-detail-panel="manage">
                                            <div class="admin-detail-manage">
                                                <div class="admin-detail-manage-section admin-detail-status-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>상태 관리</h3>
                                                    </div>
                                                    <div class="admin-detail-setting-row">
                                                        <label class="admin-detail-control">
                                                            <span>신고 상태</span>
                                                            <select class="admin-filter-control admin-detail-status-control">
                                                            <option value="PENDING">처리대기</option>
                                                            <option value="PROCESSED">처리완료</option>
                                                            <option value="REJECTED">반려</option>
                                                            </select>
                                                        </label>
                                                    </div>
                                                    <textarea class="admin-detail-memo admin-detail-status-reason"
                                                        rows="3" placeholder="상태 변경 사유를 입력하세요."></textarea>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light">변경 취소</button>
                                                        <button type="button" class="admin-btn admin-detail-status-change">상태 변경</button>
                                                    </div>
                                                </div>

                                                <div class="admin-detail-manage-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>관리 메모</h3>
                                                    </div>
                                                    <textarea class="admin-detail-memo" rows="5"
                                                        placeholder="관리 중 필요한 메모를 입력하세요."></textarea>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light">메모 저장</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                    </div>
                </div>
            </aside>
        </section>

        <div class="admin-pagination">
            <div class="admin-pagination-pages">
                <c:if test="${pagination.totalPage > 0}">
                    <c:if test="${pagination.hasPrev}">
                        <a href="/admin/reports?status=${status}&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                            이전
                        </a>
                    </c:if>
                    <c:if test="${!pagination.hasPrev}">
                        <span class="disabled">이전</span>
                    </c:if>

                    <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                        <a href="/admin/reports?status=${status}&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                            class="${pagination.page == i ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${pagination.hasNext}">
                        <a href="/admin/reports?status=${status}&keyword=${keyword}&user_id=${user_id}&targetType=${targetType}&target_id=${target_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
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
            </div>
    </main>
</div>
</body>
</html>
