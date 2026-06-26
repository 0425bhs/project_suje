<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="/css/seller/seller_product_list.css">
        <link rel="stylesheet" href="/css/seller/seller_review.css">

        <script src="/js/seller_review.js"></script>
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
                        <span class="page-label">ORDER MANAGEMENT</span>
                        <h1>리뷰 관리</h1>
                        <p>판매자의 각 상품마다의 리뷰를 확인할 수 있습니다.</p>
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
                                    ${product.name}
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

                                <div class="review-product-area">

                                    <div class="review-product-img-box">
                                        <c:choose>
                                            <c:when test="${not empty review.image_l}">
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(review.image_l, '/upload/')}">
                                                        <img src="${review.image_l}"
                                                            onerror="this.src='/images/no_image.png'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="/upload/${review.image_l}"
                                                            onerror="this.src='/images/no_image.png'">
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>

                                            <c:otherwise>
                                                <img src="/images/no_image.png">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="review-product-info">
                                        <div class="review-product-name">
                                            ${review.product_name}
                                        </div>

                                        <div class="review-date">
                                            ${review.created_at_text}
                                        </div>
                                    </div>

                                </div>

                                <div class="review-content-area">

                                    <div class="review-meta">
                                        <span class="review-user">
                                            작성자 : ${review.user_name}
                                        </span>

                                        <span class="review-rating">
                                            평점 ${review.rating}점
                                        </span>
                                    </div>

                                    <div class="review-content">
                                        ${review.content}
                                    </div>

                                </div>

                                <div class="review-btn-area">
                                    <button type="button" class="review-report-btn" data-review-id="${review.review_id}">
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
