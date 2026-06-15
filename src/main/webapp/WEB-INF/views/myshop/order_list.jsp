<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 회원 요약 카드 -->
<jsp:include page="/WEB-INF/views/order/common/myshop_user_card.jsp">
    <jsp:param name="label" value="MY ORDER" />
    <jsp:param name="count" value="${totalCount}" />
</jsp:include>

<!-- 빠른 메뉴 -->
<jsp:include page="/WEB-INF/views/order/common/myshop_quick_card.jsp" />

<!-- 주문 상태 요약 -->
<section class="myshop-status-card">

    <button type="button"
            class="${empty selectedStatus ? 'active' : ''}"
            onclick="location.href='/myshop/orders'">
        <span>전체</span>
        <strong>${totalCount}</strong>
    </button>

    <button type="button"
            class="${selectedStatus eq 'PENDING' ? 'active' : ''}"
            onclick="location.href='/myshop/orders?status=PENDING'">
        <span>결제대기</span>
        <strong>${pendingCount}</strong>
    </button>

    <button type="button"
            class="${selectedStatus eq 'PAID' ? 'active' : ''}"
            onclick="location.href='/myshop/orders?status=PAID'">
        <span>결제완료</span>
        <strong>${paidCount}</strong>
    </button>

    <button type="button"
            class="${selectedStatus eq 'SHIPPING' ? 'active' : ''}"
            onclick="location.href='/myshop/orders?status=SHIPPING'">
        <span>배송중</span>
        <strong>${shippingCount}</strong>
    </button>

    <button type="button"
            class="${selectedStatus eq 'DELIVERED' ? 'active' : ''}"
            onclick="location.href='/myshop/orders?status=DELIVERED'">
        <span>배송완료</span>
        <strong>${deliveredCount}</strong>
    </button>

    <button type="button"
            class="${selectedStatus eq 'CANCELLED' ? 'active' : ''}"
            onclick="location.href='/myshop/orders?status=CANCELLED'">
        <span>취소</span>
        <strong>${cancelCount}</strong>
    </button>

</section>

<!-- 주문/배송내역 -->
<section class="myshop-order-section">

    <div class="myshop-section-head">
        <div>
            <h2>주문/배송내역</h2>
            <p>주문한 작품의 상태를 확인하고 필요한 작업을 진행할 수 있습니다.</p>
        </div>

        <a href="/myshop/orders">전체보기</a>
    </div>

    <c:choose>
        <c:when test="${empty orderList}">
            <div class="myshop-empty-order">
                아직 주문 내역이 없습니다.
            </div>
        </c:when>

        <c:otherwise>
            <div class="myshop-order-list">

                <c:forEach var="order" items="${orderList}">

                    <!-- 중요: 주문별 상품 목록 -->
                    <c:set var="items" value="${orderItemMap[order.order_id]}" />
                    <c:set var="mainItem" value="${items[0]}" />

                    <article class="myshop-order-card">

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

                                <span>${order.created_at} · 주문번호 #${order.order_id}</span>
                            </div>

                            <a href="/order/detail?order_id=${order.order_id}">
                                주문상세 &gt;
                            </a>

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

                            <div class="myshop-product-info">
                                <c:choose>
                                    <c:when test="${not empty mainItem}">
                                        <a href="/product_detail.do?product_id=${mainItem.product_id}">
                                            ${mainItem.productName}

                                            <c:if test="${fn:length(items) > 1}">
                                                외 ${fn:length(items) - 1}건
                                            </c:if>
                                        </a>

                                        <p>
                                            수량 ${mainItem.quantity}개 ·
                                            <fmt:formatNumber value="${mainItem.price}" pattern="#,###"/>원
                                        </p>
                                    </c:when>

                                    <c:otherwise>
                                        <strong>주문 상품 정보 없음</strong>
                                        <p>상품 정보를 불러오지 못했습니다.</p>
                                    </c:otherwise>
                                </c:choose>

                                <strong>
                                    총 결제금액
                                    <fmt:formatNumber value="${order.total_amount}" pattern="#,###"/>원
                                </strong>
                            </div>

                            <div class="myshop-order-actions">

                                <a href="/order/detail?order_id=${order.order_id}">
                                    상세보기
                                </a>

                                <!-- 중요: 결제대기 상태 -->
                                <c:if test="${order.status eq 'PENDING'}">
                                    <a href="/payment/ready?order_id=${order.order_id}" class="primary">
                                        결제하기
                                    </a>

                                    <form action="/order/cancel" method="post" class="inline-form">
                                        <input type="hidden" name="order_id" value="${order.order_id}">

                                        <button type="submit"
                                                onclick="return confirm('주문을 취소하시겠습니까?');">
                                            주문취소
                                        </button>
                                    </form>
                                </c:if>

                                <!-- 중요: 배송조회 가능 상태 -->
                                <c:if test="${order.status eq 'PAID' || order.status eq 'PREPARING' || order.status eq 'SHIPPING' || order.status eq 'DELIVERED'}">
                                    <a href="/order/delivery?order_id=${order.order_id}">
                                        배송조회
                                    </a>
                                </c:if>

                                <!-- 중요: 결제취소 가능 상태 -->
                                <c:if test="${order.status eq 'PAID'}">
                                    <button type="button"
                                            onclick="openCancelModal('${order.order_id}', '${order.total_amount}')">
                                        결제취소
                                    </button>
                                </c:if>

                                <!-- 준비중: 리뷰쓰기 -->
                                <c:if test="${order.status eq 'DELIVERED'}">
                                    <button type="button"
                                            class="review"
                                            onclick="location.href='/review_form.do?order_item_id=${mainItem.order_item_id}'">
                                        리뷰쓰기
                                    </button>
                                </c:if>

                                <!-- 준비중: 문의하기 -->
                                <button type="button"
                                        class="qna"
                                        onclick="alert('문의 기능은 준비중입니다.');">
                                    문의하기
                                </button>

                            </div>

                        </div>

                    </article>

                </c:forEach>

            </div>
        </c:otherwise>
    </c:choose>

</section>