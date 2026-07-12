<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 종합 현황 카드 영역 -->
<section class="myshop-quick-card dashboard-status-cards">
    
    <%-- 주문 현황 카드 --%>
    <button type="button" class="dashboard-status-card" onclick="location.href='/myshop/orders'">
        <span>📦</span>
        <strong>주문/배송조회</strong>
        <small class="dashboard-order-status-summary">
            <em>결제대기 ${watingQnaCount}</em>
            <em>배송중 ${shippingCount}</em>
            <em>배송완료 ${deliveredCount}</em>
        </small>
    </button>

    <%-- 리뷰 관리 카드 --%>
    <button type="button" class="dashboard-status-card" onclick="location.href='/myshop/reviews'">
        <span>⭐</span>
        <strong>리뷰관리</strong>
        <small class="dashboard-order-status-summary">
            <em>작성완료 ${writtenReviewCount}</em>
            <em>작성가능 ${writableReviewCount}</em>
        </small>
    </button>

    <%-- 문의 현황 카드 --%>
    <button type="button" class="dashboard-status-card" onclick="location.href='/myshop/qnas'">
        <span>💬</span>
        <strong>문의내역</strong>
        <small class="dashboard-order-status-summary">
            <em>답변대기 ${watingQnaCount}</em>
            <em>답변완료 ${answeredQnaCount}</em>
        </small>
    </button>

    <%-- 관심 상품 카드 --%>
    <button type="button" class="dashboard-status-card" onclick="location.href='/myshop/my_favorite_list.do'">
        <span>♡</span>
        <strong>찜한상품</strong>
        <small class="dashboard-order-status-summary">
            <em>상품 ${productFavoriteCount}</em>
            <em>작가 ${sellerFavoriteCount}</em>
        </small>
    </button>

</section>

<div class="dashboard-lower-layout">

    <!-- ================= 왼쪽: 최근 주문 내역 시작 ================= -->
    <section class="dashboard-section dashboard-recent-orders">
        
            <div class="dashboard-section-head">
                <h3>최근 주문 내역 <span>최근 5건</span></h3>
                <a href="/myshop/orders" class="view-all-btn">전체보기 &gt;</a>
            </div>

            <c:choose>
                <c:when test="${empty orderList}">
                    <div class="dashboard-empty-state dashboard-order-empty">
                        <span class="dashboard-empty-icon" aria-hidden="true">⌑</span>
                        <strong>최근 주문 내역이 없어요</strong>
                        <p>마음에 드는 상품을 주문하면 이곳에서 배송 현황을 확인할 수 있어요.</p>
                        <a href="/all_list.do?sort=new" class="dashboard-empty-action">
                            상품 둘러보기
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="myshop-order dashboard-list-compact">
                        <%-- 최근 5건만 출력 --%>
                        <c:forEach var="order" items="${orderList}" varStatus="status">
                            <c:if test="${status.index < 5}"> 

                                <c:set var="items" value="${orderItemMap[order.order_id]}" />
                                <c:set var="mainItem" value="${items[0]}" />
                                <c:set var="itemCount" value="${fn:length(items)}" />

                                <article class="myshop-order-card dashboard-order-card">
                                    <div class="myshop-order-top">
                                        <div>
                                            <strong class="myshop-status-badge ${order.status}">
                                                <c:choose>
                                                    <c:when test="${order.status eq 'PENDING'}">주문 접수</c:when>
                                                    <c:when test="${order.status eq 'PAID'}">결제 완료</c:when>
                                                    <c:when test="${order.status eq 'PREPARING'}">제작 준비중</c:when>
                                                    <c:when test="${order.status eq 'SHIPPING'}">배송중</c:when>
                                                    <c:when test="${order.status eq 'DELIVERED'}">배송 완료</c:when>
                                                    <c:when test="${order.status eq 'CANCELLED'}">주문 취소</c:when>
                                                    <c:otherwise>${order.status}</c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </div>
                                        <a href="/order/detail?order_id=${order.order_id}">주문상세 &gt;</a>
                                    </div>

                                    <div class="myshop-order-body">
                                        <div class="myshop-product-thumb">
                                            <c:choose>
                                                <c:when test="${not empty mainItem and not empty mainItem.imageL and mainItem.imageL ne 'no_file'}">
                                                    <img src="/upload/${mainItem.imageL}" alt="${mainItem.productName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="/images/no_image.png" alt="이미지 없음">
                                                </c:otherwise>
                                            </c:choose>

                                        </div>

                                        <div class="myshop-product-info dashboard-order-info">
                                            <c:choose>
                                                <c:when test="${not empty order.created_at and fn:length(order.created_at) ge 16}">
                                                    <span class="myshop-order-date-text">
                                                        ${fn:substring(order.created_at, 0, 16)} 주문
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="myshop-order-date-text">
                                                        ${order.created_at} 주문
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>

                                            <c:choose>
                                                <c:when test="${not empty mainItem}">
                                                    <strong class="myshop-product-name-text">
                                                        ${mainItem.productName}

                                                        <c:if test="${itemCount gt 1}">
                                                            <span class="myshop-product-count-text">
                                                                포함 총 ${itemCount}건
                                                            </span>
                                                        </c:if>
                                                    </strong>

                                                    <strong class="dashboard-order-total">
                                                        총 결제금액
                                                        <fmt:formatNumber value="${order.total_amount}" pattern="#,###"/>원
                                                    </strong>
                                                </c:when>
                                                <c:otherwise>
                                                    <strong class="myshop-product-name-text">주문 상품 정보 없음</strong>
                                                    <p class="dashboard-order-empty-text">상품 정보를 불러오지 못했습니다.</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="myshop-order-actions">
                                            <c:if test="${order.status eq 'PENDING' and order.total_amount > 0}"> 
                                                <a href="/payment/ready?order_id=${order.order_id}" class="primary">
                                                    결제하기
                                                </a>
                                            </c:if>

                                            <c:if test="${order.status eq 'PREPARING' || order.status eq 'SHIPPING' || order.status eq 'DELIVERED'}">
                                                <a href="/order/delivery?order_id=${order.order_id}">
                                                    배송조회
                                                </a>
                                            </c:if>

                                            <c:if test="${itemCount eq 1 and not empty mainItem}">
                                                <button type="button"
                                                        class="qna"
                                                        onclick="location.href='/qna_form.do?product_id=${mainItem.product_id}'">
                                                    문의하기
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </article>

                            </c:if>
                        </c:forEach>
                    </div>
                
                    <div class="more-btn-wrap">
                        <button type="button" class="more-btn" onclick="location.href='/myshop/orders'">더보기</button>
                    </div>
                </c:otherwise>
            </c:choose>

    </section>
    <!-- ================= 왼쪽: 최근 주문 내역 끝 ================= -->

    <!-- ================= 오른쪽: 최근 활동 알림 시작 ================= -->
    <aside class="dashboard-activity-sidebar">

        <%-- 나의 혜택 요약 --%>
        <section class="dashboard-section dashboard-benefit-card">
            <div class="dashboard-section-head">
                <h3>나의 쇼핑 혜택</h3>
            </div>
            <div class="dashboard-benefit-row">
                <div class="dashboard-benefit-item point"
                    onclick="location.href='/myshop/points'"
                    style="cursor:pointer;">
                    <span>적립금</span>
                    <strong>
                        <fmt:formatNumber value="${empty pointBalance ? 0 : pointBalance}" pattern="#,###"/>
                        <small>P</small>
                    </strong>
                </div>  
                <div class="dashboard-benefit-item coupon"
                    onclick="location.href='/myshop/coupons'"
                    style="cursor:pointer;">
                    <span>쿠폰</span>
                    <strong>
                        ${empty couponCount ? 0 : couponCount}
                        <small>장</small>
                    </strong>
                </div>
            </div>
        </section>

        <%-- 최근 본 상품 --%>
        <section class="dashboard-section recently-viewed recent-viewed-compact">
            <div class="dashboard-section-head">
                <h3>최근 본 상품</h3>
                <a href="/myshop/recent" class="view-all-btn">더보기 &gt;</a>
            </div>
            <c:choose>
                <c:when test="${empty productRecentList}">
                    <div class="dashboard-empty-state dashboard-recent-empty">
                        <span class="dashboard-empty-icon" aria-hidden="true">♡</span>
                        <strong>최근 본 상품이 없어요</strong>
                        <p>관심 있는 상품을 둘러보면 여기에 표시됩니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="recent-prod-grid">
                        <c:forEach var="product" items="${productRecentList}" varStatus="status">
                            <c:if test="${status.index lt 5}">
                                <a href="/product_detail.do?product_id=${product.product_id}">
                                    <div class="prod-item">
                                        <c:choose>
                                            <c:when test="${not empty product.image_l and product.image_l ne 'no_file'}">
                                                <img src="/upload/${product.image_l}" alt="${product.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="/images/no_image.png" alt="이미지 없음">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </a>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <%-- 2. 작성 가능한 리뷰 (워딩 변경) --%>
        <section class="dashboard-section dashboard-writable-reviews">
            <div class="dashboard-section-head">
                <h3>작성 가능한 리뷰 <span>${writableReviewCount}</span></h3>
                <a href="/myshop/reviews?tab=writable" class="view-all-btn">전체보기 &gt;</a>
            </div>
            <c:choose>
                <c:when test="${empty writableReviews}">
                    <div class="dashboard-empty-state dashboard-review-empty">
                        <span class="dashboard-empty-icon" aria-hidden="true">✓</span>
                        <strong>작성할 리뷰가 없어요</strong>
                        <p>배송이 완료되면 이곳에서 리뷰를 작성할 수 있어요.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <ul class="compact-prod-list dashboard-review-list">
                        <c:forEach var="review" items="${writableReviews}" varStatus="status">
                            <c:if test="${status.index lt 3}">
                                <li class="dashboard-review-item">
                                    <a href="/product_detail.do?product_id=${review.product_id}"
                                       class="dashboard-review-product">
                                        <span class="dashboard-review-thumb">
                                            <c:choose>
                                                <c:when test="${not empty review.image_l and review.image_l ne 'no_file'}">
                                                    <img src="/upload/${review.image_l}" alt="${review.product_name}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="/images/no_image.png" alt="이미지 없음">
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="dashboard-review-info">
                                            <strong>${review.product_name}</strong>
                                            <c:if test="${not empty review.option_name}">
                                                <small>${review.option_name}</small>
                                            </c:if>
                                            <em>배송 완료 · 리뷰 작성 가능</em>
                                        </span>
                                    </a>
                                    <button type="button"
                                            class="dashboard-review-btn"
                                            onclick="location.href='/review_form.do?order_item_id=${review.order_item_id}'">
                                        리뷰쓰기
                                    </button>
                                </li>
                            </c:if>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>
        </section>

        <%-- 3. 최근 내 문의 --%>
        <section class="dashboard-section">
            <div class="dashboard-section-head">
                <h3>최근 내 문의</h3>
                <a href="/myshop/qnas" class="view-all-btn">전체보기 &gt;</a>
            </div>
            <c:choose>
                <c:when test="${empty qnaList}">
                    <div class="dashboard-empty-state dashboard-qna-empty">
                        <span class="dashboard-empty-icon" aria-hidden="true">?</span>
                        <strong>최근 문의 내역이 없어요</strong>
                        <p>상품에 궁금한 점이 생기면 문의를 남겨보세요.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="compact-inquiry">
                        <c:forEach var="qna" items="${qnaList}">
                            <p>
                                <a href="/qna_detail.do?qna_id=${qna.qna_id}">
                                    ${qna.title}
                                </a>
                                <span class="status">${qna.status}</span>
                                <span class="type">${qna.created_at}</span>
                            </p>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

    </aside>

</div>
