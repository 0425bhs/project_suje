<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <link rel="stylesheet" href="/css/seller/seller_form_common.css">
    <link rel="stylesheet" href="/css/seller/seller_product_list.css">
    <link rel="stylesheet" href="/css/seller/seller_review.css">
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
                <p>판매자 상품에 작성된 리뷰를 확인할 수 있습니다.</p>
            </div>
        </div>

        <div class="review-top-box">
            <div>
                <strong>전체 리뷰</strong>
                <span class="review-count">${fn:length(reviewList)}개</span>
            </div>

            <select id="productFilter" class="review-filter-select">
                <option value="all">전체 상품 리뷰</option>

                <c:forEach var="product" items="${productList}">
                    <option value="${product.product_id}">
                        ${product.product_name}
                    </option>
                </c:forEach>
            </select>
        </div>

        <c:if test="${empty reviewList}">
            <div class="empty-review-box">
                아직 등록된 리뷰가 없습니다.
            </div>
        </c:if>

        <div class="seller-review-list">

            <c:forEach var="review" items="${reviewList}">
                <div class="seller-review-card" data-product-id="${review.product_id}">

                    <!-- 상단 작성자 정보 -->
                    <div class="review-user-top">

                        <div class="review-user-photo-box">
                            <c:choose>
                                <c:when test="${not empty review.photo_name}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(review.photo_name, '/upload/')}">
                                            <img src="${review.photo_name}" onerror="this.style.display='none'; this.parentNode.classList.add('empty');">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="/upload/${review.photo_name}" onerror="this.style.display='none'; this.parentNode.classList.add('empty');">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="review-user-photo-empty"></div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="review-user-info">
                            <div class="review-user-name">
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
                            </div>

                            <div class="review-score-date">
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

                                <span class="review-write-date">${review.created_at_text}</span>
                            </div>
                        </div>

                    </div>

                    <!-- 상품명 + 옵션명 -->
                    <div class="review-product-line">
                        <span class="review-product-title">${review.product_name}</span>
                        <c:if test="${not empty review.option_name}">
                            <span class="review-option-title">, ${review.option_name}</span>
                        </c:if>
                    </div>

                    <!-- 고객 리뷰 사진 -->
                    <c:if test="${not empty review.imageList}">
                        <div class="review-photo-list">
                            <c:forEach var="img" items="${review.imageList}">
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
                            </c:forEach>
                        </div>
                    </c:if>

                    <!-- 리뷰 내용 -->
                    <div class="review-content">
                        ${review.content}
                    </div>

                    <!-- 신고 버튼 -->
                    <div class="review-btn-area">
                        <button type="button"
                                class="review-report-btn"
                                data-review-id="${review.review_id}">
                            신고
                        </button>
                    </div>

                </div>
            </c:forEach>

        </div>

    </div>

</div>
</body>
</html>