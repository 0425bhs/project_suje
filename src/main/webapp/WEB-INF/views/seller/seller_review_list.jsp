<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">

    <link rel="stylesheet" href="/css/seller/seller_form_common.css">
    <link rel="stylesheet" href="/css/seller/seller_product_list.css">
    <link rel="stylesheet" href="/css/seller/seller_review.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <script src="/js/seller_review.js" defer></script>
</head>

<body>
<div class="seller-board">

    <jsp:include page="seller_sidebar.jsp">
        <jsp:param name="activeMenu" value="reviewList" />
        <jsp:param name="sidebarTitle" value="상품 리뷰 관리" />
    </jsp:include>

    <div class="seller-main">

        <div class="seller-main-header">
            <div>
                <span class="page-label">REVIEW MANAGEMENT</span>
                <h1>리뷰 관리</h1>
                <p>판매자가 등록한 상품의 작성된 리뷰를 확인하고 관리할 수 있습니다.</p>
            </div>
        </div>

        <div class="review-summary-box">

            <div class="review-summary-item total">
                <div>
                    <strong>전체 리뷰</strong>
                    <span id="totalReviewCount">${fn:length(reviewList)}개</span>
                </div>
            </div>

            <div class="review-summary-item waiting">
                <i class="bi bi-chat-square-text"></i>
                <div>
                    <strong>답글 대기</strong>
                    <span id="waitingReviewCount">0</span>
                </div>
            </div>

            <div class="review-summary-item completed">
                <i class="bi bi-check-lg"></i>
                <div>
                    <strong>답글 완료</strong>
                    <span id="completedReviewCount">0</span>
                </div>
            </div>

            <div class="review-summary-item photo">
                <i class="bi bi-image"></i>
                <div>
                    <strong>사진 리뷰</strong>
                    <span id="photoReviewCount">0</span>
                </div>
            </div>

            <div class="review-filter-wrap">
                <label for="productFilter">상품 필터</label>

                <select id="productFilter" class="review-filter-select">
                    <option value="all">전체 상품 리뷰</option>

                    <c:forEach var="product" items="${productList}">
                        <option value="${product.product_id}">
                            ${product.product_name}
                        </option>
                    </c:forEach>
                </select>
            </div>

        </div>

        <c:if test="${empty reviewList}">
            <div class="empty-review-box">
                아직 등록된 리뷰가 없습니다.
            </div>
        </c:if>

        <c:if test="${not empty reviewList}">
            <div class="seller-review-wrap">

                <div class="review-tab-box">
                    <button type="button" class="review-tab active" data-tab="all">
                        전체 리뷰
                    </button>

                    <button type="button" class="review-tab" data-tab="waiting">
                        답글 대기 <span id="waitingTabCount">(0)</span>
                    </button>

                    <button type="button" class="review-tab" data-tab="completed">
                        답글 완료 <span id="completedTabCount">(0)</span>
                    </button>

                    <button type="button" class="review-tab" data-tab="photo">
                        사진 리뷰 <span id="photoTabCount">(0)</span>
                    </button>
                </div>

                <div class="seller-review-list">

                    <c:forEach var="review" items="${reviewList}">

                        <div class="seller-review-card" data-product-id="${review.product_id}" data-replied="false" data-has-photo="${not empty review.imageList ? 'true' : 'false'}">

                            <div class="review-card-top">

                                <div class="review-user-area">

                                    <div class="review-user-photo-box">
                                        <c:choose>

                                            <c:when test="${not empty review.photo_name}">
                                                <c:choose>

                                                    <c:when test="${fn:startsWith(review.photo_name, '/upload/')}">
                                                        <img src="${review.photo_name}">
                                                    </c:when>

                                                    <c:otherwise>
                                                        <img src="/upload/${review.photo_name}">
                                                    </c:otherwise>

                                                </c:choose>
                                            </c:when>

                                            <c:otherwise>
                                                <img src="/images/no_profile.png">
                                            </c:otherwise>

                                        </c:choose>
                                    </div>

                                    <div class="review-user-info">

                                        <div class="review-user-line">
                                            <span class="review-user-name">
                                                <c:choose>
                                                    <c:when test="${not empty review.nick_name}">
                                                        ${review.nick_name}
                                                    </c:when>

                                                    <c:when test="${not empty review.user_name and fn:length(review.user_name) >= 2}">
                                                        ${fn:substring(review.user_name, 0, 1)}*${fn:substring(review.user_name, 2, fn:length(review.user_name))}
                                                    </c:when>

                                                    <c:otherwise>
                                                        ${review.user_name}
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>

                                            <span class="review-write-date">${review.created_at_text}</span>
                                        </div>

                                        <div class="review-star-line">
                                            <span class="review-stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= review.rating}">
                                                            <span class="star on">★</span>
                                                        </c:when>

                                                        <c:otherwise>
                                                            <span class="star">★</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </span>
                                        </div>

                                        <div class="review-product-line">
                                            <span class="review-product-title">${review.product_name}</span>

                                            <c:if test="${not empty review.option_name}">
                                                <span class="review-option-title">, ${review.option_name}</span>
                                            </c:if>
                                        </div>

                                    </div>

                                </div>

                                <div class="review-photo-list">
                                    <c:if test="${not empty review.imageList}">
                                        <c:forEach var="img" items="${review.imageList}" varStatus="st">
                                            <c:if test="${st.index < 5}">
                                                <div class="review-photo-item">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(img.image_url, '/upload/')}">
                                                            <img src="${img.image_url}" onerror="this.src='/images/no_image.png'">
                                                        </c:when>

                                                        <c:otherwise>
                                                            <img src="/upload/${img.image_url}" onerror="this.src='/images/no_image.png'">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </div>

                                <div class="review-status-area">
                                    <span class="reply-status waiting-status">
                                        <i class="bi bi-chat-square-text"></i>
                                        답글 대기
                                    </span>

                                    <span class="reply-status complete-status">
                                        <i class="bi bi-check-lg"></i>
                                        답글 완료
                                    </span>

                                    <button type="button" class="review-more-btn">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </button>
                                </div>

                            </div>

                            <div class="review-bottom-grid">

                                <div class="review-content-box">
                                    <div class="review-content-title">후기 내용</div>

                                    <div class="review-content">
                                        ${review.content}
                                    </div>

                                    <div class="review-btn-area">
                                        <button type="button"
                                                class="review-report-btn"
                                                data-review-id="${review.review_id}">
                                            <i class="bi bi-exclamation-triangle"></i>
                                            신고
                                        </button>
                                    </div>
                                </div>

                                <div class="seller-reply-box">

                                    <div class="reply-waiting-box">
                                        <strong>고객의 리뷰에 답변해보세요</strong>

                                        <p>
                                            답변을 작성하면 고객과의 신뢰가 쌓여요.<br>
                                            빠른 답변이 좋은 인상을 남깁니다.
                                        </p>

                                        <button type="button" class="reply-write-btn" data-review-id="${review.review_id}">
                                            답글 작성
                                        </button>
                                    </div>

                                    <div class="reply-complete-box">
                                        <div class="reply-complete-head">
                                            <strong>판매자 답변</strong>
                                            <span>답변 완료</span>
                                        </div>

                                        <div class="reply-complete-content">
                                            등록된 판매자 답변입니다.
                                        </div>

                                        <button type="button" class="reply-edit-btn" data-review-id="${review.review_id}">
                                            답글 수정
                                        </button>
                                    </div>

                                </div>

                            </div>

                        </div>

                    </c:forEach>

                </div>

            </div>
        </c:if>

    </div>

</div>
</body>
</html>