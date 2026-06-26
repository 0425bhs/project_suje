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
        
        <section class="admin-master-detail is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-filter-box">
                    <form class="admin-filter-form" action="/admin/reviews" method="get">
                        <div class="admin-filter-tabs">
                            <a href="/admin/reviews?status=all&keyword=${keyword}" class="${status eq 'all' ? 'active' : ''}">전체</a>
                            <a href="/admin/reviews?status=public&keyword=${keyword}" class="${status eq 'public' ? 'active' : ''}">공개</a>
                            <a href="/admin/reviews?status=private&keyword=${keyword}" class="${status eq 'private' ? 'active' : ''}">비공개</a>
                        </div>
                        <input type="hidden" name="status" value="${status}"/>
                        <input type="text" class="admin-search" name="keyword" 
                            placeholder="상품명, 작성자, 내용 검색" value="${keyword}">
                    </form>
                </div>

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
                            <td class="left"><strong>${review.product_name}</strong></td>
                            <td>${review.user_name}</td>
                            <td>${review.rating}</td>
                            <td class="left">${review.content}</td>

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
                                <dd id="content">-</dd>
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
        
    </main>
</div>
</body>
</html>
