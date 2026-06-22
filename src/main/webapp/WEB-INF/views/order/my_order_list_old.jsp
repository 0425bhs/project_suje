<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
            class="${selectedStatus eq 'PREPARING' ? 'active' : ''}"
            onclick="location.href='/myshop/orders?status=PREPARING'">
        <span>제작중</span>
        <strong>${preparingCount}</strong>
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
            class="${selectedStatus eq 'CONFIRMED' ? 'active' : ''}"
            onclick="location.href='/myshop/orders?status=CONFIRMED'">
        <span>구매확정</span>
        <strong>${confirmedCount}</strong>
    </button>

    <button type="button"
            class="${selectedStatus eq 'CANCELLED' ? 'active' : ''}"
            onclick="location.href='/myshop/orders?status=CANCELLED'">
        <span>취소</span>
        <strong>${cancelCount}</strong>
    </button>

</section>

<section class="myshop-list-section">

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
            <div class="myshop-list">

                <c:forEach var="order" items="${orderList}">

                    <c:set var="items" value="${orderItemMap[order.order_id]}" />
                    <c:set var="mainItem" value="${items[0]}" />
                    <c:set var="itemCount" value="${fn:length(items)}" />

                    <c:set var="hasPaidItem" value="false" />
                    <c:set var="hasPreparingItem" value="false" />
                    <c:set var="hasShippingItem" value="false" />
                    <c:set var="hasDeliveredItem" value="false" />
                    <c:set var="hasConfirmedItem" value="false" />

                    <c:forEach var="item" items="${items}">
                        <c:if test="${item.status eq 'PAID'}">
                            <c:set var="hasPaidItem" value="true" />
                        </c:if>

                        <c:if test="${item.status eq 'PREPARING'}">
                            <c:set var="hasPreparingItem" value="true" />
                        </c:if>

                        <c:if test="${item.status eq 'SHIPPING'}">
                            <c:set var="hasShippingItem" value="true" />
                        </c:if>

                        <c:if test="${item.status eq 'DELIVERED'}">
                            <c:set var="hasDeliveredItem" value="true" />
                        </c:if>

                        <c:if test="${item.status eq 'CONFIRMED'}">
                            <c:set var="hasConfirmedItem" value="true" />
                        </c:if>
                    </c:forEach>

                    <article class="myshop-list-card">

                        <div class="myshop-list-top">

                            <div>
                                <strong class="myshop-status-badge ${mainItem.status}">
                                    <c:choose>
                                        <c:when test="${mainItem.status eq 'PENDING'}">주문 접수</c:when>
                                        <c:when test="${mainItem.status eq 'PAID'}">결제 완료</c:when>
                                        <c:when test="${mainItem.status eq 'PREPARING'}">제작 준비중</c:when>
                                        <c:when test="${mainItem.status eq 'SHIPPING'}">배송중</c:when>
                                        <c:when test="${mainItem.status eq 'DELIVERED'}">배송 완료</c:when>
                                        <c:when test="${mainItem.status eq 'CONFIRMED'}">구매 확정</c:when>
                                        <c:when test="${mainItem.status eq 'CANCELLED'}">주문 취소</c:when>
                                        <c:otherwise>${mainItem.status}</c:otherwise>
                                    </c:choose>
                                </strong>

                                <span>${order.created_at} · 주문번호 #${order.order_id}</span>
                            </div>

                            <a href="/order/detail?order_id=${order.order_id}">
                                주문상세 &gt;
                            </a>

                        </div>

                        <div class="myshop-list-body">

                            <div class="myshop-product-thumb">
                                <c:choose>
                                    <c:when test="${not empty mainItem and not empty mainItem.imageL and mainItem.imageL ne 'no_file'}">
                                        <img src="${mainItem.imageL}" alt="${mainItem.productName}">
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

                                            <c:if test="${itemCount > 1}">
                                                외 ${itemCount - 1}건
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

                            <div class="myshop-list-actions">

                                <a href="/order/detail?order_id=${order.order_id}">
                                    상세보기
                                </a>

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

                                <c:if test="${hasPaidItem and not hasPreparingItem and not hasShippingItem and not hasDeliveredItem and not hasConfirmedItem}">
                                    <button type="button"
                                            onclick="openCancelModal('${order.order_id}', '${order.total_amount}')">
                                        결제취소
                                    </button>
                                </c:if>

                                <c:if test="${hasPaidItem or hasPreparingItem or hasShippingItem or hasDeliveredItem}">
                                    <a href="/order/delivery?order_id=${order.order_id}">
                                        배송조회
                                    </a>
                                </c:if>

                                <c:if test="${itemCount eq 1 and mainItem.status eq 'DELIVERED'}">
                                    <form action="/order_confirm.do" method="post" class="inline-form">
                                        <input type="hidden" name="order_item_id" value="${mainItem.order_item_id}">

                                        <button type="submit"
                                                class="primary"
                                                onclick="return confirm('구매확정 처리하시겠습니까?');">
                                            구매확정
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${itemCount eq 1 and mainItem.status eq 'CONFIRMED'}">
                                    <button type="button"
                                            class="review"
                                            onclick="location.href='/review_form.do?order_item_id=${mainItem.order_item_id}'">
                                        리뷰쓰기
                                    </button>
                                </c:if>

                                <c:if test="${itemCount eq 1}">
                                    <button type="button"
                                            class="qna"
                                            onclick="location.href='/qna_form.do?product_id=${mainItem.product_id}'">
                                        문의하기
                                    </button>
                                </c:if>

                                <c:if test="${itemCount > 1}">
                                    <button type="button"
                                            class="qna"
                                            data-count="${itemCount}"
                                            onclick="toggleOrderItems(this)">
                                        <span class="toggle-text">총 ${itemCount}건 주문 펼쳐보기</span>
                                    </button>
                                </c:if>

                            </div>

                        </div>

                        <c:if test="${itemCount > 1}">
                            <div class="myshop-order-items-panel">

                                <c:forEach var="item" items="${items}">
                                    <div class="myshop-order-item-row">

                                        <div class="myshop-order-item-info">
                                            <strong>${item.productName}</strong>

                                            <p>
                                                수량 ${item.quantity}개 ·
                                                <fmt:formatNumber value="${item.price}" pattern="#,###"/>원
                                            </p>

                                            <span class="myshop-status-badge ${item.status}">
                                                <c:choose>
                                                    <c:when test="${item.status eq 'PENDING'}">주문 접수</c:when>
                                                    <c:when test="${item.status eq 'PAID'}">결제 완료</c:when>
                                                    <c:when test="${item.status eq 'PREPARING'}">제작 준비중</c:when>
                                                    <c:when test="${item.status eq 'SHIPPING'}">배송중</c:when>
                                                    <c:when test="${item.status eq 'DELIVERED'}">배송 완료</c:when>
                                                    <c:when test="${item.status eq 'CONFIRMED'}">구매 확정</c:when>
                                                    <c:when test="${item.status eq 'CANCELLED'}">주문 취소</c:when>
                                                    <c:otherwise>${item.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="myshop-order-item-actions">

                                            <c:if test="${item.status eq 'DELIVERED'}">
                                                <form action="/order_confirm.do" method="post" class="inline-form">
                                                    <input type="hidden" name="order_item_id" value="${item.order_item_id}">

                                                    <button type="submit"
                                                            class="primary"
                                                            onclick="return confirm('구매확정 처리하시겠습니까?');">
                                                        구매확정
                                                    </button>
                                                </form>
                                            </c:if>

                                            <c:if test="${item.status eq 'CONFIRMED'}">
                                                <button type="button"
                                                        class="review"
                                                        onclick="location.href='/review_form.do?order_item_id=${item.order_item_id}'">
                                                    리뷰쓰기
                                                </button>
                                            </c:if>

                                            <button type="button"
                                                    onclick="location.href='/qna_form.do?product_id=${item.product_id}'">
                                                문의하기
                                            </button>

                                        </div>

                                    </div>
                                </c:forEach>

                            </div>
                        </c:if>

                    </article>

                </c:forEach>

            </div>
        </c:otherwise>
    </c:choose>

</section>