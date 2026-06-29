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

                        setText("reviewId", review.review_id);
                        setText("userId", review.user_id);
                        setText("productId", review.product_id);
                        setText("orderItemId", review.order_item_id);
                        setText("rating", review.rating);
                        setText("content", review.content);
                        setText("createdAt", review.created_at);
                        setText("status", review.status);
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

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">REVIEW MANAGEMENT</span>
                <h1>후기 관리</h1>
                <p>상품 후기를 조회하고 상세 내용을 확인합니다.</p>
            </div>
        </header>
        
        <div class="admin-filter-box admin-filter-modern">
            <form class="admin-filter-form" action="/admin/reviews" method="get">
                <div class="admin-filter-main-row">
                    <div class="admin-filter-tabs">
                        <a href="/admin/reviews?status=all&keyword=${keyword}&size=${pagination.size}&page=1" class="${status eq 'all' ? 'active' : ''}">전체</a>
                        <a href="/admin/reviews?status=public&keyword=${keyword}&size=${pagination.size}&page=1" class="${status eq 'public' ? 'active' : ''}">공개</a>
                        <a href="/admin/reviews?status=private&keyword=${keyword}&size=${pagination.size}&page=1" class="${status eq 'private' ? 'active' : ''}">비공개</a>
                    </div>

                    <div class="admin-search-wrap">
                        <input type="text" id="keyword" class="admin-search" name="keyword"
                            placeholder="상품명, 작성자, 내용 검색" value="${keyword}">
                        <span class="admin-search-icon" aria-hidden="true"></span>
                    </div>
                    <button type="submit" class="admin-btn admin-search-submit">검색</button>
                    <button type="button" class="admin-btn light admin-filter-toggle">상세 검색</button>
                    <select class="admin-filter-control admin-sort-control" name="sort">
                        <option value="latest">최신순</option>
                        <option value="oldest">오래된순</option>
                        <option value="rating">평점순</option>
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
                        <select class="admin-filter-control" name="detailStatus">
                            <option value="all">전체</option>
                            <option value="public">공개</option>
                            <option value="private">비공개</option>
                        </select>
                    </label>
                    <label class="admin-filter-field admin-filter-date-range">
                        <span>작성일 범위</span>
                        <input type="date" class="admin-filter-control" name="startDate">
                        <em>~</em>
                        <input type="date" class="admin-filter-control" name="endDate">
                    </label>
                    <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                </div>

                <c:if test="${status ne 'all' || not empty keyword}">
                    <div class="admin-filter-applied">
                        <span class="admin-filter-applied-label">적용된 조건:</span>
                        <c:if test="${status ne 'all'}">
                            <a class="admin-filter-chip"
                                href="/admin/reviews?status=all&keyword=${keyword}&size=${pagination.size}&page=1">
                                상태: ${status eq 'public' ? '공개' : '비공개'}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty keyword}">
                            <a class="admin-filter-chip" href="/admin/reviews?status=${status}&size=${pagination.size}&page=1">
                                검색어: ${keyword}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <a class="admin-filter-clear" href="/admin/reviews">전체 해제</a>
                    </div>
                </c:if>

                <input type="hidden" name="status" value="${status}">
                <input type="hidden" name="page" value="1">
            </form>
        </div>

        <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>후기번호</th>
                            <th>상품</th>
                            <th>작성자</th>
                            <th>평점</th>
                            <th>내용</th>
                            <th>상태</th>
                            <th>작성일</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="review" items="${reviewList}">
                        <tr class="admin-clickable-row" data-review-id="${review.review_id}">
                            <td>${review.review_id}</td>
                            <td class="left admin-highlight-target"><strong>${review.product_name}</strong></td>
                            <td class="admin-highlight-target">${review.user_name}</td>
                            <td>${review.rating}</td>
                            <td class="left admin-highlight-target">${review.content}</td>

                            <c:choose>

                            <c:when test="${review.status eq 'public'}">
                            <td><span class="admin-status active">공개</span></td>
                            </c:when>

                            <c:when test="${review.status eq 'private'}">
                            <td><span class="admin-status active">비공개</span></td>
                            </c:when>

                            </c:choose>

                            <td>${review.created_at}</td>
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
                                <span class="admin-page-label">REVIEW DETAIL</span>
                                <h2 id="reviewDetailTitle">후기 상세</h2>
                            </div>
                            <button type="button" class="admin-detail-close" aria-label="닫기">&times;</button>
                        </div>
                        <dl class="admin-detail-grid">
                            <div>
                                <dt>후기번호</dt>
                                <dd id="reviewId">-</dd>
                            </div>
                            <div>
                                <dt>유저번호</dt>
                                <dd id="userId">-</dd>
                            </div>
                            <div>
                                <dt>상품번호</dt>
                                <dd id="productId">-</dd>
                            </div>
                            <div>
                                <dt>주문 상품 번호</dt>
                                <dd id="orderItemId">-</dd>
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
                                <dt>상태</dt>
                                <dd id="status">-</dd>
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
                        <a href="/admin/reviews?status=${status}&keyword=${keyword}&size=${pagination.size}&page=${pagination.prevPage}">
                            이전
                        </a>
                    </c:if>
                    <c:if test="${!pagination.hasPrev}">
                        <span class="disabled">이전</span>
                    </c:if>

                    <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                        <a href="/admin/reviews?status=${status}&keyword=${keyword}&size=${pagination.size}&page=${i}"
                            class="${pagination.page == i ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${pagination.hasNext}">
                        <a href="/admin/reviews?status=${status}&keyword=${keyword}&size=${pagination.size}&page=${pagination.nextPage}">
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
