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
            <h2>내 후기 목록</h2>
            <p>내가 작성한 상품 후기와 첨부 이미지를 확인할 수 있습니다.</p>
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
                                <span>${review.created_at}</span>
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

                                <p>별점 ${review.rating}점 · 작성일 ${review.created_at}</p>
                                <strong>${review.content}</strong>

                                <c:if test="${not empty review.imageList}">
                                    <div class="myshop-review-photo-list">
                                        <c:forEach var="image" items="${review.imageList}">
                                            <img src="/upload/${image.image_url}" alt="리뷰 사진">
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>

                            <div class="myshop-list-actions">
                                <a href="/review_update_form.do?review_id=${review.review_id}">
                                    수정
                                </a>

                                <button type="button"
                                        onclick="if (confirm('삭제하시겠습니까?')) location.href='/review_delete.do?review_id=${review.review_id}';">
                                    삭제
                                </button>
                            </div>
                        </div>

                    </article>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</section>
