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

                            <div class="seller-review-card"
                                data-product-id="${review.product_id}"
                                data-replied="${not empty review.reply_content ? 'true' : 'false'}"
                                data-has-photo="${not empty review.imageList ? 'true' : 'false'}">

                                <div class="review-card-top">

                                    <div class="review-user-area">

                                        <div class="review-user-photo-box">
                                            <c:set var="profileName" value="${fn:trim(review.photo_name)}" />

                                            <c:choose>
                                                <c:when test="${not empty profileName and profileName ne 'no_file'}">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(profileName, '/upload/')}">
                                                            <img src="${profileName}" alt="프로필 이미지">
                                                        </c:when>

                                                        <c:otherwise>
                                                            <img src="/upload/${profileName}" alt="프로필 이미지">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>

                                                <c:otherwise>
                                                    <img src="/images/no_profile.png" alt="기본 프로필 이미지">
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

                                    <c:if test="${not empty review.imageList}">
                                        <div class="review-photo-list" data-review-id="${review.review_id}">

                                            <c:set var="photoTotal" value="${fn:length(review.imageList)}" />

                                            <c:forEach var="img" items="${review.imageList}" varStatus="st">

                                                <c:set var="reviewImgUrl" value="${fn:trim(img.image_url)}" />

                                                <c:if test="${not empty reviewImgUrl and reviewImgUrl ne 'no_file'}">

                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(reviewImgUrl, '/upload/')}">
                                                            <c:set var="finalReviewImgUrl" value="${reviewImgUrl}" />
                                                        </c:when>

                                                        <c:otherwise>
                                                            <c:set var="finalReviewImgUrl" value="/upload/${reviewImgUrl}" />
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <span class="review-modal-data"
                                                        data-review-id="${review.review_id}"
                                                        data-img-url="${finalReviewImgUrl}"
                                                        data-img-index="${st.index}">
                                                    </span>

                                                    <c:if test="${st.index < 3}">
                                                        <button type="button"
                                                                class="review-photo-item"
                                                                data-review-id="${review.review_id}"
                                                                data-img-index="${st.index}">
                                                            <img src="${finalReviewImgUrl}" alt="리뷰 이미지">

                                                            <c:if test="${st.index == 2 and photoTotal > 3}">
                                                                <span class="review-photo-more">
                                                                    +${photoTotal - 3}
                                                                </span>
                                                            </c:if>
                                                        </button>
                                                    </c:if>

                                                </c:if>

                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <div class="review-status-area">
                                        <c:choose>
                                            <c:when test="${empty review.reply_content}">
                                                <span class="reply-status waiting-status">
                                                    <i class="bi bi-chat-square-text"></i>
                                                    답글 대기
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="reply-status complete-status">
                                                    <i class="bi bi-check-lg"></i>
                                                    답글 완료
                                                </span>
                                            </c:otherwise>
                                        </c:choose>

                                        <button type="button" class="review-more-btn">
                                            <i class="bi bi-three-dots-vertical"></i>
                                        </button>
                                    </div>

                                </div>

                                <div class="review-bottom-grid">

                                    <div class="review-content-box">

                                        <div class="review-content js-review-content">
                                            <c:out value="${review.content}" />
                                        </div>

                                        <button type="button" class="review-toggle-btn" style="display:none;">
                                            펼쳐보기
                                            <i class="bi bi-chevron-down"></i>
                                        </button>

                                        <div class="review-btn-area">
                                            <button type="button" class="review-report-btn" data-target-id="${review.review_id}">
                                                <i class="bi bi-exclamation-triangle"></i>
                                                신고
                                            </button>
                                        </div>

                                    </div>

                                    <div class="seller-reply-box">

                                        <c:choose>
                                            <c:when test="${empty review.reply_content}">
                                                <div class="reply-waiting-box" id="replyView-${review.review_id}">
                                                    <strong>고객의 리뷰에 답변해보세요</strong>

                                                    <p>
                                                        리뷰에 대한 답변을 작성하여 고객과의 유대를 쌓아보세요.<br>
                                                        답변은 작가님의 팬에게 좋은 인상을 남깁니다.
                                                    </p>

                                                    <button type="button" class="reply-write-btn" data-review-id="${review.review_id}">
                                                        답글 작성
                                                    </button>
                                                </div>
                                            </c:when>

                                            <c:otherwise>
                                                <div class="reply-complete-box" id="replyView-${review.review_id}">
                                                    <div class="reply-complete-head">
                                                        <strong>판매자 답변</strong>
                                                        <span>${review.reply_created_at_text}</span>
                                                    </div>

                                                    <div class="reply-complete-content">
                                                        <c:out value="${review.reply_content}" />
                                                    </div>

                                                    <button type="button" class="reply-write-btn" data-review-id="${review.review_id}">
                                                        답글 수정
                                                    </button>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="reply-write-form" id="replyForm-${review.review_id}" style="display:none;">
                                            <textarea class="reply-textarea" id="replyContent-${review.review_id}"><c:out value="${review.reply_content}" /></textarea>

                                            <div class="reply-form-btn-area">
                                                <button type="button" class="reply-submit-btn" data-review-id="${review.review_id}">
                                                    등록
                                                </button>

                                                <button type="button" class="reply-cancel-btn" data-review-id="${review.review_id}">
                                                    취소
                                                </button>
                                            </div>
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

    <div class="review-image-modal" id="reviewImageModal">
        <div class="review-image-modal-dim"></div>

        <div class="review-image-modal-box">

            <div class="review-image-modal-head">
                <span id="reviewImageCounter">1 / 1</span>

                <button type="button" class="review-image-modal-close" id="reviewImageModalClose">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

            <div class="review-image-modal-body">
                <button type="button" class="review-image-nav-btn prev" id="reviewImagePrev">
                    <i class="bi bi-chevron-left"></i>
                </button>

                <img src="" alt="리뷰 이미지" id="reviewImageModalImg">

                <button type="button" class="review-image-nav-btn next" id="reviewImageNext">
                    <i class="bi bi-chevron-right"></i>
                </button>
            </div>

            <div class="review-image-modal-foot">
                리뷰 이미지는 실제 구매자가 등록한 이미지입니다.
            </div>

        </div>
    </div>

    <div id="reviewReportModal" class="review-report-modal-bg">
        <div class="review-report-modal">
            <input type="hidden" id="reportReviewId">

            <div class="review-report-modal-head">
                <div>
                    <strong>리뷰 신고</strong>
                    <p>부적절한 리뷰라고 판단되는 경우 신고할 수 있습니다.</p>
                </div>

                <button type="button" class="review-report-close-btn">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>

            <div class="review-report-field">
                <label for="reviewReportType">신고 사유</label>
                <select id="reviewReportType">
                    <option value="">신고 사유를 선택해주세요.</option>
                    <option value="ABUSE">욕설/비방</option>
                    <option value="SPAM">도배/스팸</option>
                    <option value="AD">광고/홍보성 내용</option>
                    <option value="PERSONAL_INFO">개인정보 노출</option>
                    <option value="IRRELEVANT">상품과 관련 없는 내용</option>
                    <option value="ETC">기타</option>
                </select> 
            </div>

            <div class="review-report-field">
                <label for="reviewReportReason">신고 내용</label>
                <textarea id="reviewReportReason" placeholder="리뷰 신고 내용을 입력해주세요."></textarea>
            </div>

            <div class="review-report-modal-actions">
                <button type="button" class="review-report-cancel-btn">취소</button>
                <button type="button" class="review-report-submit-btn">신고하기</button>
            </div>
        </div>
    </div>

</body>
</html>