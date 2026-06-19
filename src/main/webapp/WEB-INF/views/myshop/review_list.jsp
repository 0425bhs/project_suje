<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 회원 요약 카드 -->
<jsp:include page="/WEB-INF/views/myshop/common/myshop_user_card.jsp">
    <jsp:param name="label" value="MY REVIEW" />
    <jsp:param name="count" value="${totalCount}" />
</jsp:include>

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
<section class="myshop-list-section myshop-review-section">

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
            <div class="myshop-list">
                <c:forEach var="review" items="${list}">
                    <article class="myshop-list-card">

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

                        <div class="myshop-list-body myshop-review-body">
                            <div class="myshop-product-thumb">
                                <c:choose>
                                    <c:when test="${not empty review.image_s}">
                                        <img src="${review.image_s}" alt="${review.product_name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/images/no_image.png" alt="이미지 없음">
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="myshop-product-info">
                                <a href="/product_detail.do?product_id=${review.product_id}">
                                    ${review.product_name}
                                </a>

                                <c:choose>
                                    <c:when test="${tab eq 'writable'}">
                                        <div class="myshop-review-guide">
                                            <span>REVIEW READY</span>
                                            <strong>이 상품의 후기를 남길 수 있습니다.</strong>
                                            <p>작품의 사용감, 포장, 배송 경험을 함께 남겨보세요.</p>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <div class="myshop-review-meta">
                                            <span class="myshop-review-rating">별점 ${review.rating}점</span>
                                            <span>작성일 ${review.created_at}</span>
                                        </div>

                                        <div class="myshop-review-content">
                                            ${review.content}
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${not empty review.imageList}">
                                    <div class="myshop-review-photo-list">
                                        <c:forEach var="image" items="${review.imageList}">
                                            <img src="/upload/${image.image_url}" alt="리뷰 사진">
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>

                            <div class="myshop-list-actions">
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
