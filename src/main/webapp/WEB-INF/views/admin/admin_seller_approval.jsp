<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 판매자 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
    <script src="/js/admin_detail_common.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const master = document.getElementById("adminMasterDetail");
            const rows = document.querySelectorAll(".admin-clickable-row");

            rows.forEach((row) => {
                //모든 행에 클릭 이벤트 부여
                row.addEventListener("click", () => {
                    //상세 패널이 열려있고 이미 선택된 행을 눌렀을 때
                    if (!master.classList.contains("is-collapsed") && row.classList.contains("selected")) {
                        closeDetailPanel(master, row);
                        return;
                    }

                    openDetailPanel(master, rows, row);

                    //상세 패널 내용 변경
                    const sellerId = row.dataset.sellerId;

                    fetch("/admin/sellers/detail?seller_id=" + encodeURIComponent(sellerId))
                    .then(res => res.json())
                    .then(data => {
                        const seller = data.seller;
                        const statusLabels = {
                            PENDING: "승인대기",
                            APPROVED: "승인완료",
                            REJECTED: "반려"
                        };
                        const statusKey = String(seller.status || "").toUpperCase();
                        const statusLabel = statusLabels[statusKey] || seller.status;

                        setDetailTitleBlock(
                            "sellerDetailTitle",
                            "sellerDetailMeta",
                            seller.company_name || "판매자 상세",
                            (seller.representative_name || "-") + " · 신청번호 #" + (seller.seller_id || "-")
                        );
                        setDetailStatusBadge("sellerDetailStatusBadge", seller.status, statusLabel);
                        setText("sellerId", seller.seller_id);
                        setText("userId", seller.user_id);
                        setText("companyName", seller.company_name);
                        setText("representativeName", seller.representative_name);
                        setText("businessNumber", seller.business_number);
                        setText("openingDate", seller.opening_date);
                        setText("businessAddress", seller.business_address);
                        setText("status", statusLabel);
                        setText("createdAt", seller.created_at);
                        highlightAdminKeyword(document.getElementById("adminDetailPanel"));
                    })
                });
            });
        });
    </script>
</head>

<body>
    <div class="admin-board">
        <jsp:include page="admin_sidebar.jsp">
            <jsp:param name="activeMenu" value="sellers" />
            <jsp:param name="sidebarTitle" value="판매자 관리" />
        </jsp:include>

        <main class="admin-main admin-main-fixed">
            <header class="admin-main-header">
                <div>
                    <span class="admin-page-label">SELLER MANAGEMENT</span>
                    <h1>판매자 관리</h1>
                </div>
            </header>

            <div class="admin-fixed-list-layout">
            <div class="admin-filter-box admin-filter-modern">
                <form class="admin-filter-form" action="/admin/sellers" method="get">
                    <div class="admin-filter-main-row">
                        <div class="admin-filter-tabs">
                            <a href="/admin/sellers?status=all&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                class="${status eq 'all' ? 'active' : ''}">전체</a>
                            <a href="/admin/sellers?status=pending&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                class="${status eq 'pending' ? 'active' : ''}">승인대기</a>
                            <a href="/admin/sellers?status=approved&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                class="${status eq 'approved' ? 'active' : ''}">승인완료</a>
                            <a href="/admin/sellers?status=rejected&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                class="${status eq 'rejected' ? 'active' : ''}">반려</a>
                        </div>

                        <div class="admin-search-wrap">
                            <input type="text" id="keyword" class="admin-search" name="keyword"
                                placeholder="상점명, 대표자 검색" value="${keyword}">
                            <span class="admin-search-icon" aria-hidden="true"></span>
                        </div>
                        <button type="submit" class="admin-btn admin-search-submit">검색</button>
                        <button type="button" class="admin-btn light admin-filter-toggle">상세 검색</button>
                        <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                            <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                            <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                            <option value="name" ${sort eq 'name' ? 'selected' : ''}>이름순</option>
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
                                <option value="pending" ${status eq 'pending' ? 'selected' : ''}>승인대기</option>
                                <option value="approved" ${status eq 'approved' ? 'selected' : ''}>승인완료</option>
                                <option value="rejected" ${status eq 'rejected' ? 'selected' : ''}>반려</option>
                            </select>
                        </label>
                        <label class="admin-filter-field admin-filter-date-range">
                            <span>신청일 범위</span>
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
                                    href="/admin/sellers?status=all&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                    상태:
                                    ${status eq 'pending' ? '승인대기' : status eq 'approved' ? '승인완료' : '반려'}
                                    <span aria-hidden="true">&times;</span>
                                </a>
                            </c:if>
                            <c:if test="${not empty keyword}">
                                <a class="admin-filter-chip" href="/admin/sellers?status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                    검색어: ${keyword}
                                    <span aria-hidden="true">&times;</span>
                                </a>
                            </c:if>
                            <c:if test="${not empty startDate || not empty endDate}">
                                <a class="admin-filter-chip" href="/admin/sellers?status=${status}&keyword=${keyword}&sort=${sort}&size=${pagination.size}&page=1">
                                    신청일: ${startDate} ~ ${endDate}
                                    <span aria-hidden="true">&times;</span>
                                </a>
                            </c:if>
                            <a class="admin-filter-clear" href="/admin/sellers">전체 해제</a>
                        </div>
                    </c:if>

                    <input type="hidden" name="page" value="1">
                </form>
            </div>

            <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
                <div class="admin-card admin-list-panel">
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
                                        <td class="left admin-highlight-target"><strong>${seller.company_name}</strong></td>
                                        <td class="admin-highlight-target">${seller.representative_name}</td>
                                        <td class="admin-highlight-target">${seller.business_number}</td>
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
                        <div class="admin-detail-content">
                            <div class="admin-detail-head">
                                        <div class="admin-detail-head-main">
                                            <div class="admin-detail-title-block">
                                                <div class="admin-detail-title-line">
                                                    <h2 id="sellerDetailTitle">판매자 상세</h2>
                                                    <span class="admin-detail-status-badge" id="sellerDetailStatusBadge">-</span>
                                                </div>
                                                <p id="sellerDetailMeta">목록에서 판매자를 선택하세요.</p>
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
                                                <dl class="admin-detail-grid">
                                <div>
                                    <dt>신청번호</dt>
                                    <dd id="sellerId">-</dd>
                                </div>
                                <div>
                                    <dt>판매자번호</dt>
                                    <dd id="userId">-</dd>
                                </div>
                                <div>
                                    <dt>상점명</dt>
                                    <dd id="companyName" class="admin-highlight-target">-</dd>
                                </div>
                                <div>
                                    <dt>대표자</dt>
                                    <dd id="representativeName" class="admin-highlight-target">-</dd>
                                </div>
                                <div>
                                    <dt>사업자번호</dt>
                                    <dd id="businessNumber" class="admin-highlight-target">-</dd>
                                </div>
                                <div>
                                    <dt>개업일자</dt>
                                    <dd id="openingDate">-</dd>
                                </div>
                                <div>
                                    <dt>사업자 주소</dt>
                                    <dd id="businessAddress" class="admin-highlight-target">-</dd>
                                </div>
                                <div>
                                    <dt>상태</dt>
                                    <dd id="status">-</dd>
                                </div>
                                <div>
                                    <dt>신청일</dt>
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
                                                            <span>판매자 상태</span>
                                                            <select class="admin-filter-control admin-detail-status-control">
                                                            <option value="PENDING">승인대기</option>
                                                            <option value="APPROVED">승인완료</option>
                                                            <option value="REJECTED">반려</option>
                                                            </select>
                                                        </label>
                                                    </div>
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
                            <a href="/admin/sellers?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                                이전
                            </a>
                        </c:if>
                        <c:if test="${!pagination.hasPrev}">
                            <span class="disabled">이전</span>
                        </c:if>

                        <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                            <a href="/admin/sellers?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                                class="${pagination.page == i ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:forEach>

                        <c:if test="${pagination.hasNext}">
                            <a href="/admin/sellers?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
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
