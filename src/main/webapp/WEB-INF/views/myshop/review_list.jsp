<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 빠른 메뉴 -->
<jsp:include page="/WEB-INF/views/myshop/common/myshop_quick_card.jsp" />

<!-- 리뷰 상태 요약 -->
<section class="myshop-status-card myshop-status-card-review">

    <button type="button"
        class="${tab eq 'written' ? 'active' : ''}"
        onclick="location.href='/myshop/reviews'">
    <span>내가 작성한 리뷰</span>
    <strong>${empty writtenReviewCount ? 0 : writtenReviewCount}</strong>
    </button>

    <button type="button"
        class="${tab eq 'writable' ? 'active' : ''}"
            onclick="location.href='/myshop/reviews?tab=writable'">
        <span>작성 가능한 리뷰</span>
        <strong>${empty writableReviewCount ? 0 : writableReviewCount}</strong>
    </button>

</section>

<!-- 내 후기 목록 -->
<section class="myshop-list-section myshop-review-section ${tab eq 'writable' ? 'myshop-review-writable-section' : ''}">

    <div class="myshop-section-head">
        <div>
            <h2>${tab eq 'writable' ? '작성 가능한 리뷰' : '내 후기 목록'}</h2>
            <p>
                <c:choose>
                    <c:when test="${tab eq 'writable'}">배송 완료된 상품 중 아직 리뷰를 작성하지 않은 상품입니다.</c:when>
                    <c:otherwise>내가 작성한 상품 후기와 첨부 이미지를 확인할 수 있습니다.</c:otherwise>
                </c:choose>
            </p>
        </div>

        <a href="/live_review_list.do">실시간 리뷰 보기</a>
    </div>

    <c:choose>
        <c:when test="${empty list}">
            <div class="myshop-empty-order">
                아직 작성한 후기가 없습니다.
            </div>
        </c:when>

        <c:otherwise>
            <div class="myshop-list ${tab eq 'writable' ? 'myshop-review-writable-list' : ''}">
                <c:forEach var="review" items="${list}">
                    <article class="myshop-list-card ${tab eq 'writable' ? 'myshop-review-writable-card' : ''}">

                        <div class="myshop-list-top">
                            <div>
                                <strong class="myshop-review-state ${tab eq 'writable' ? 'writable' : 'written'}">
                                    ${tab eq 'writable' ? '작성 가능' : '작성 완료'}
                                </strong>

                                <span>
                                    <c:choose>
                                        <c:when test="${tab eq 'writable'}">배송 완료 상품</c:when>
                                        <c:otherwise>${review.created_at}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <a href="/product_detail.do?product_id=${review.product_id}">
                                상품보기 &gt;
                            </a>
                        </div>

                        <div class="myshop-list-body myshop-review-body myshop-review-card-body">
                            <a class="myshop-review-product-image"
                               href="/product_detail.do?product_id=${review.product_id}">
                                <c:choose>
                                    <c:when test="${not empty review.image_l}">
                                        <img src="/upload/${review.image_l}" alt="${review.product_name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/images/no_image.png" alt="이미지 없음">
                                    </c:otherwise>
                                </c:choose>
                            </a>

                            <div class="myshop-review-summary">
                                <a class="myshop-review-product-name" href="/product_detail.do?product_id=${review.product_id}">
                                    ${review.product_name}<c:if test="${not empty review.option_name}">, ${review.option_name}</c:if>
                                </a>

                                <c:choose>
                                    <c:when test="${tab eq 'writable'}">
                                        <div class="myshop-review-guide myshop-review-reward">
                                            <span>리뷰 작성하고</span>
                                            <strong>포인트 100P 받기</strong>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="myshop-review-score-row">
                                            <div class="myshop-review-stars">
                                                <c:forEach begin="1" end="5" var="star">
                                                    <span class="${star le review.rating ? 'filled' : ''}">★</span>
                                                </c:forEach>
                                            </div>
                                            <strong>${review.rating}/5</strong>
                                        </div>

                                        <div class="myshop-review-content">
                                            <span>${review.content}</span>
                                        </div>

                                        <c:if test="${not empty review.imageList}">
                                            <div class="myshop-review-photo-list">
                                                <c:forEach var="image" items="${review.imageList}" varStatus="photoStatus">
                                                    <c:if test="${photoStatus.index lt 5}">
                                                        <img src="/upload/${image.image_url}" alt="리뷰 사진">
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="myshop-list-actions myshop-review-actions">
                                <c:choose>
                                    <c:when test="${tab eq 'writable'}">
                                        <a class="primary" href="/review_form.do?order_item_id=${review.order_item_id}">
                                            리뷰쓰기
                                        </a>
                                    </c:when>

                                    <c:otherwise>
                                        <a href="/review_update_form.do?review_id=${review.review_id}">
                                            수정
                                        </a>

                                        <button type="button"
                                                onclick="if (confirm('삭제하시겠습니까?')) location.href='/review_delete.do?review_id=${review.review_id}';">
                                            삭제
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                    </article>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</section>
