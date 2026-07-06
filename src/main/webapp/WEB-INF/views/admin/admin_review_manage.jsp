<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 후기 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
    <script src="/js/admin_detail_common.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const master = document.getElementById("adminMasterDetail");
            const rows = document.querySelectorAll(".admin-clickable-row");
            const orderStatusLabels = {
                PENDING: "결제대기",
                PAID: "결제완료",
                PREPARING: "배송준비",
                SHIPPING: "배송중",
                DELIVERED: "배송완료",
                CANCELLED: "취소"
            };
            const statusLabels = {
                ACTIVE: "활성",
                HIDDEN: "숨김"
            };
            const managePanel = initAdminDetailManage({
                targetType: "REVIEW",
                statusUrl: "/admin/reviews/status",
                idParam: "review_id",
                statusBadgeId: "reviewDetailStatusBadge",
                statusLabels
            });

            rows.forEach((row) => {
                row.addEventListener("click", () => {
                    if (!master.classList.contains("is-collapsed") && row.classList.contains("selected")) {
                        closeDetailPanel(master, row);
                        return;
                    }

                    openDetailPanel(master, rows, row);

                    const reviewId = row.dataset.reviewId;

                    fetch("/admin/reviews/detail?review_id=" + encodeURIComponent(reviewId))
                    .then(res => res.json())
                    .then(data => {
                        const review = data.review;
                        const orderStatusKey = String(review.order_status || "").toUpperCase();
                        const statusKey = String(review.status || "ACTIVE").toUpperCase();
                        const statusLabel = statusLabels[statusKey] || "알 수 없음";
                        const orderStatusLabel = review.order_status
                            ? (orderStatusLabels[orderStatusKey] || "알 수 없음")
                            : "";

                        setDetailTitleBlock(
                            "reviewDetailTitle",
                            "reviewDetailMeta",
                            review.product_name || "후기 상세",
                            (review.user_name || "-") + " · 평점 " + (review.rating || "-") + "점"
                        );
                        setDetailStatusBadge("reviewDetailStatusBadge", statusKey, statusLabel);
                        setText("productName", review.product_name);
                        setText("userName", review.user_name);
                        setText("status", statusLabel);
                        setText("rating", review.rating);
                        setText("content", review.content);
                        setText("createdAt", review.created_at);
                        setText("reportCount", review.report_count);
                        setText("orderStatus", orderStatusLabel);
                        setText("orderCreatedAt", review.order_created_at);
                        setText("replyContent", review.reply_content);
                        setText("replyCreatedAt", review.reply_created_at);
                        managePanel.setTarget(review.review_id, statusKey, row);

                        document.getElementById("reviewMemberLink").href =
                            "/admin/members?user_id=" + encodeURIComponent(review.user_id);
                        document.getElementById("reviewProductLink").href =
                            "/admin/products?product_id=" + encodeURIComponent(review.product_id);
                        document.getElementById("reviewProductPublicLink").href =
                            "/product_detail.do?product_id=" + encodeURIComponent(review.product_id);

                        highlightAdminKeyword(document.getElementById("adminDetailPanel"));
                    })
                })
            })
        })
    </script>
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="reviews" />
        <jsp:param name="sidebarTitle" value="후기 관리" />
    </jsp:include>

    <main class="admin-main admin-main-fixed">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">REVIEW MANAGEMENT</span>
                <h1>후기 관리</h1>
            </div>
        </header>
        
        <div class="admin-fixed-list-layout">
            <div class="admin-filter-box admin-filter-modern">
            <form class="admin-filter-form" action="/admin/reviews" method="get">
                <input type="hidden" name="user_id" value="${user_id}">
                <input type="hidden" name="product_id" value="${product_id}">
                <input type="hidden" name="review_id" value="${review_id}">
                <input type="hidden" name="status" value="${status}">
                <div class="admin-filter-main-row">
                    <div class="admin-filter-tabs">
                        <a href="/admin/reviews?status=all&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${status eq 'all' ? 'active' : ''}">전체</a>
                        <a href="/admin/reviews?status=active&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${status eq 'active' ? 'active' : ''}">활성</a>
                        <a href="/admin/reviews?status=hidden&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                           class="${status eq 'hidden' ? 'active' : ''}">숨김</a>
                    </div>
                    <div class="admin-search-wrap">
                        <input type="text" id="keyword" class="admin-search" name="keyword"
                            placeholder="상품명, 작성자, 내용 검색" value="${keyword}">
                        <span class="admin-search-icon" aria-hidden="true"></span>
                    </div>
                    <button type="submit" class="admin-btn admin-search-submit">검색</button>
                    <button type="button" class="admin-btn light admin-filter-toggle">상세 검색</button>
                    <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                        <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                        <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                        <option value="rating" ${sort eq 'rating' ? 'selected' : ''}>평점순</option>
                        <option value="reports" ${sort eq 'reports' ? 'selected' : ''}>신고 많은 순</option>
                    </select>
                    <select id="pageSize" class="admin-filter-control admin-page-size-control" name="size">
                        <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                        <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                        <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                    </select>
                </div>

                <div class="admin-filter-detail-row">
                    <label class="admin-filter-field">
                        <span>평점</span>
                        <select class="admin-filter-control" name="rating">
                            <option value="">전체</option>
                            <option value="5" ${rating == 5 ? 'selected' : ''}>5점</option>
                            <option value="4" ${rating == 4 ? 'selected' : ''}>4점</option>
                            <option value="3" ${rating == 3 ? 'selected' : ''}>3점</option>
                            <option value="2" ${rating == 2 ? 'selected' : ''}>2점</option>
                            <option value="1" ${rating == 1 ? 'selected' : ''}>1점</option>
                        </select>
                    </label>
                    <label class="admin-filter-field admin-filter-date-range">
                        <span>작성일 범위</span>
                        <input type="date" class="admin-filter-control" name="startDate" value="${startDate}">
                        <em>~</em>
                        <input type="date" class="admin-filter-control" name="endDate" value="${endDate}">
                    </label>
                    <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                </div>

                <c:if test="${status ne 'all' || not empty keyword || not empty user_id || not empty product_id || not empty review_id || not empty rating || not empty startDate || not empty endDate}">
                    <div class="admin-filter-applied">
                        <span class="admin-filter-applied-label">적용된 조건:</span>
                        <c:if test="${status ne 'all'}">
                            <a class="admin-filter-chip" href="/admin/reviews?status=all&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                상태: ${status eq 'active' ? '활성' : '숨김'}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty keyword}">
                            <a class="admin-filter-chip" href="/admin/reviews?status=${status}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                검색어: ${keyword}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty user_id}">
                            <a class="admin-filter-chip" href="/admin/reviews?status=${status}&keyword=${keyword}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
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
                        <c:if test="${not empty product_id}">
                            <a class="admin-filter-chip" href="/admin/reviews?status=${status}&keyword=${keyword}&user_id=${user_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                상품:
                                <c:choose>
                                    <c:when test="${not empty filterProduct}">
                                        ${filterProduct.name}
                                    </c:when>
                                    <c:otherwise>${product_id}</c:otherwise>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty review_id}">
                            <a class="admin-filter-chip" href="/admin/reviews?status=${status}&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                후기:
                                <c:choose>
                                    <c:when test="${not empty filterReview}">
                                        #${filterReview.review_id} · ${filterReview.product_name}
                                    </c:when>
                                    <c:otherwise>${review_id}</c:otherwise>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty rating}">
                            <a class="admin-filter-chip" href="/admin/reviews?status=${status}&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                평점: ${rating}점
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty startDate || not empty endDate}">
                            <a class="admin-filter-chip" href="/admin/reviews?status=${status}&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&sort=${sort}&size=${pagination.size}&page=1">
                                작성일: ${startDate} ~ ${endDate}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <a class="admin-filter-clear" href="/admin/reviews">전체 해제</a>
                    </div>
                </c:if>

                <input type="hidden" name="page" value="1">
            </form>
        </div>

        <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-table-wrap">
                    <table class="admin-table admin-review-table">
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>상품</th>
                            <th>작성자</th>
                            <th>상태</th>
                            <th>평점</th>
                            <th>신고</th>
                            <th>내용</th>
                            <th>작성일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty reviewList}">
                            <tr>
                                <td colspan="8">리뷰 목록이 없습니다.</td>
                            </tr>
                        </c:if>
                        <c:forEach var="review" items="${reviewList}" varStatus="loop">
                        <tr class="admin-clickable-row" data-review-id="${review.review_id}">
                            <td>${pagination.offset + loop.index + 1}</td>
                            <td class="left admin-highlight-target"><strong>${review.product_name}</strong></td>
                            <td class="admin-highlight-target">${review.user_name}</td>
                            <td>
                                <span class="admin-status ${review.status eq 'HIDDEN' ? 'hidden' : 'active'}">
                                    ${review.status eq 'HIDDEN' ? '숨김' : '활성'}
                                </span>
                            </td>
                            <td>${review.rating}</td>
                            <td>${review.report_count}</td>
                            <td class="left admin-highlight-target review-content-cell">${review.content}</td>
                            <td>${review.created_at}</td>
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
                                                    <h2 id="reviewDetailTitle">후기 상세</h2>
                                                    <span class="admin-detail-status-badge" id="reviewDetailStatusBadge">-</span>
                                                </div>
                                                <p id="reviewDetailMeta">목록에서 후기를 선택하세요.</p>
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
                                                        <a href="#" id="reviewMemberLink">
                                                            <span>회원 관리</span>
                                                        </a>
                                                        <a href="#" id="reviewProductLink">
                                                            <span>상품 관리</span>
                                                        </a>
                                                        <a href="#" id="reviewProductPublicLink">
                                                            <span>상품 페이지</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <dl class="admin-detail-grid">
                            <div>
                                <dt>상품</dt>
                                <dd id="productName" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>작성자</dt>
                                <dd id="userName" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>상태</dt>
                                <dd id="status">-</dd>
                            </div>
                            <div>
                                <dt>평점</dt>
                                <dd id="rating">-</dd>
                            </div>
                            <div>
                                <dt>후기내용</dt>
                                <dd id="content" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>작성일</dt>
                                <dd id="createdAt">-</dd>
                            </div>
                            <div>
                                <dt>신고 수</dt>
                                <dd id="reportCount">-</dd>
                            </div>
                            <div>
                                <dt>주문 상태</dt>
                                <dd id="orderStatus">-</dd>
                            </div>
                            <div>
                                <dt>주문일</dt>
                                <dd id="orderCreatedAt">-</dd>
                            </div>
                            <div>
                                <dt>판매자 답글</dt>
                                <dd id="replyContent" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>답글 작성일</dt>
                                <dd id="replyCreatedAt">-</dd>
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
                                                            <span>후기 상태</span>
                                                            <select class="admin-filter-control admin-detail-status-control">
                                                                <option value="ACTIVE">활성</option>
                                                                <option value="HIDDEN">숨김</option>
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
                        <a href="/admin/reviews?status=${status}&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                            이전
                        </a>
                    </c:if>
                    <c:if test="${!pagination.hasPrev}">
                        <span class="disabled">이전</span>
                    </c:if>

                    <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                        <a href="/admin/reviews?status=${status}&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                            class="${pagination.page == i ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${pagination.hasNext}">
                        <a href="/admin/reviews?status=${status}&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&review_id=${review_id}&rating=${rating}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
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
