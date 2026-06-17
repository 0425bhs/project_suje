<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 회원 요약 카드 -->
<jsp:include page="/WEB-INF/views/myshop/common/myshop_user_card.jsp">
    <jsp:param name="label" value="MY SHOP" />
    <jsp:param name="count" value="${totalCount}" />
</jsp:include>

<!-- 종합 현황 카드 영역 -->
<section class="myshop-quick-card dashboard-status-cards">
    
    <%-- 주문 현황 카드 --%>
    <button type="button" class="dashboard-status-card" onclick="location.href='/myshop/orders'">
        <span>📦</span>
        <strong>주문/배송조회</strong>
        <small>전체 ${totalCount}건</small>
    </button>

    <%-- 리뷰 관리 카드 --%>
    <button type="button" class="dashboard-status-card" onclick="location.href='/myshop/reviews'">
        <span>⭐</span>
        <strong>리뷰관리</strong>
        <small>작성 12건</small>
    </button>

    <%-- 문의 현황 카드 --%>
    <button type="button" class="dashboard-status-card" onclick="location.href='/myshop/qnas'">
        <span>💬</span>
        <strong>문의내역</strong>
        <small>전체 4건</small>
    </button>

    <%-- 관심 상품 카드 --%>
    <button type="button" class="dashboard-status-card" onclick="alert('찜한 상품 기능은 준비중입니다.');">
        <span>♡</span>
        <strong>찜한상품</strong>
        <small>전체 18건</small>
    </button>

</section>

<div class="dashboard-lower-layout">

    <!-- ================= 왼쪽: 최근 주문 내역 시작 ================= -->
    <section class="dashboard-section dashboard-recent-orders">
        
            <div class="dashboard-section-head">
                <h3>최근 주문 내역 <span>최근 3건</span></h3>
                <a href="/myshop/orders" class="view-all-btn">전체보기 &gt;</a>
            </div>

            <c:choose>
                <c:when test="${empty orderList}">
                    <div class="myshop-empty-order">
                        최근 주문 내역이 없습니다.
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="myshop-order dashboard-list-compact">
                        <%-- 최근 3건만 출력 --%>
                        <c:forEach var="order" items="${orderList}" varStatus="status">
                            <c:if test="${status.index < 3}"> 

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
                                                <c:when test="${not empty mainItem and not empty mainItem.imageS and mainItem.imageS ne 'no_file'}">
                                                    <img src="${mainItem.imageS}" alt="${mainItem.productName}">
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
                                            <c:if test="${order.status eq 'PENDING'}">
                                                <a href="/payment/ready?order_id=${order.order_id}" class="primary">
                                                    결제하기
                                                </a>
                                            </c:if>

                                            <c:if test="${order.status eq 'PREPARING' || order.status eq 'SHIPPING' || order.status eq 'DELIVERED'}">
                                                <a href="/order/delivery?order_id=${order.order_id}">
                                                    배송조회
                                                </a>
                                            </c:if>

                                            <c:if test="${order.status eq 'DELIVERED' and not empty mainItem}">
                                                <button type="button"
                                                        class="review"
                                                        onclick="location.href='/review_form.do?order_item_id=${mainItem.order_item_id}'">
                                                    리뷰쓰기
                                                </button>
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
                <div class="dashboard-benefit-item point">
                    <span>적립금</span>
                    <strong>2,500<small>원</small></strong>
                </div>
                <div class="dashboard-benefit-item coupon">
                    <span>쿠폰</span>
                    <strong>2<small>장</small></strong>
                </div>
            </div>
        </section>

        <%-- 최근 본 상품 --%>
        <section class="dashboard-section recently-viewed recent-viewed-compact">
            <div class="dashboard-section-head">
                <h3>최근 본 상품 <span>(4)</span></h3>
                <a href="/myshop/recent" class="view-all-btn">더보기 &gt;</a>
            </div>
            <div class="recent-prod-grid">
                <div class="prod-item">img</div>
                <div class="prod-item">img</div>
                <div class="prod-item">img</div>
                <div class="prod-item">img</div>
            </div>
        </section>

        <%-- 2. 작성 가능한 리뷰 (워딩 변경) --%>
        <section class="dashboard-section">
            <div class="dashboard-section-head">
                <h3>작성 가능한 리뷰</h3>
                <a href="/mypage/review" class="view-all-btn">더보기 &gt;</a>
            </div>
            <ul class="compact-prod-list">
                <li>
                    <img src="/images/tmp_prod_1.jpg" alt="">
                    <div class="info">
                        <span>핸드메이드 코스튬 자켓</span>
                        <a href="/mypage/review/write" class="action">리뷰 쓰고 500원 받기</a>
                    </div>
                </li>
            </ul>
        </section>

        <%-- 3. 최근 내 문의 --%>
        <section class="dashboard-section">
            <div class="dashboard-section-head">
                <h3>최근 내 문의</h3>
                <a href="/mypage/qna" class="view-all-btn">더보기 &gt;</a>
            </div>
            <div class="compact-inquiry">
                <p>배송 지연 문의드립니다.</p>
                <span class="status">답변 완료</span>
                <span class="type">2023.10.25</span>
            </div>
        </section>

    </aside>

</div>
