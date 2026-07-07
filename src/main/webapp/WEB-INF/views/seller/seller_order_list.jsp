<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">

    <link rel="stylesheet" href="/css/seller/seller_form_common.css">
    <link rel="stylesheet" href="/css/seller/seller_order_list.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <script src="/js/seller_order.js" defer></script>
</head>

<body>

<div class="seller-board">

    <jsp:include page="seller_sidebar.jsp">
        <jsp:param name="activeMenu" value="orderList" />
        <jsp:param name="sidebarTitle" value="판매자 주문관리" />
    </jsp:include>

    <main class="seller-main">

        <div class="seller-main-header">
            <div>
                <span class="page-label">ORDER MANAGEMENT</span>
                <h1>주문 관리</h1>
                <p>판매자의 상품이 포함된 주문을 확인하고 주문 상태를 관리할 수 있습니다.</p>
            </div>
        </div>

        <c:set var="isClaimMode" value="${selectedStatus eq 'RETURN_EXCHANGE'}" />
        <c:set var="currentClaimTab" value="${empty claimTab ? 'ALL' : claimTab}" />

        <div class="seller-order-white-box">

            <div class="seller-order-top-line">

                <div class="seller-order-tab-wrap">
                    <div class="seller-order-main-tabs">

                        <a href="/seller_order_list.do"
                           class="${not isClaimMode ? 'active' : ''}">
                            상품관리
                        </a>

                        <a href="/seller_order_list.do?status=RETURN_EXCHANGE"
                           class="${isClaimMode ? 'active' : ''}">
                            반품/교환
                        </a>

                    </div>
                </div>

                <div class="seller-order-outside-tools">

                    <div class="view-switch-buttons">

                        <button type="button" class="view-icon-btn" data-view="simple" title="심플 형태">
                            <span class="view-icon simple"></span>
                        </button>

                        <button type="button" class="view-icon-btn" data-view="card" title="카드 형태">
                            <span class="view-icon card"></span>
                        </button>

                    </div>

                </div>

            </div>

            <c:choose>
                <c:when test="${isClaimMode}">

                    <div class="seller-claim-filter-buttons">

                        <a href="/seller_order_list.do?status=RETURN_EXCHANGE&amp;claimTab=ALL"
                           class="${currentClaimTab eq 'ALL' ? 'active' : ''}">
                            전체
                        </a>

                        <a href="/seller_order_list.do?status=RETURN_EXCHANGE&amp;claimTab=RETURN_REQUEST"
                           class="${currentClaimTab eq 'RETURN_REQUEST' ? 'active' : ''}">
                            반품요청
                        </a>

                        <a href="/seller_order_list.do?status=RETURN_EXCHANGE&amp;claimTab=EXCHANGE_REQUEST"
                           class="${currentClaimTab eq 'EXCHANGE_REQUEST' ? 'active' : ''}">
                            교환요청
                        </a>

                        <a href="/seller_order_list.do?status=RETURN_EXCHANGE&amp;claimTab=RETURN_DONE"
                           class="${currentClaimTab eq 'RETURN_DONE' ? 'active' : ''}">
                            반품처리
                        </a>

                        <a href="/seller_order_list.do?status=RETURN_EXCHANGE&amp;claimTab=EXCHANGE_DONE"
                           class="${currentClaimTab eq 'EXCHANGE_DONE' ? 'active' : ''}">
                            교환처리
                        </a>

                    </div>

                </c:when>

                <c:otherwise>

                    <div class="seller-order-filter-buttons">

                        <a href="/seller_order_list.do"
                           class="${empty selectedStatus ? 'active' : ''}">
                            전체
                        </a>

                        <a href="/seller_order_list.do?status=PAID"
                           class="${selectedStatus eq 'PAID' ? 'active' : ''}">
                            신규주문
                        </a>

                        <a href="/seller_order_list.do?status=PREPARING"
                           class="${selectedStatus eq 'PREPARING' ? 'active' : ''}">
                            제작준비
                        </a>

                        <a href="/seller_order_list.do?status=SHIPPING"
                           class="${selectedStatus eq 'SHIPPING' ? 'active' : ''}">
                            배송중
                        </a>

                        <a href="/seller_order_list.do?status=DELIVERED"
                           class="${selectedStatus eq 'DELIVERED' ? 'active' : ''}">
                            배송완료
                        </a>

                        <a href="/seller_order_list.do?status=CANCELLED"
                           class="${selectedStatus eq 'CANCELLED' ? 'active' : ''}">
                            취소
                        </a>

                    </div>

                </c:otherwise>
            </c:choose>

            <c:choose>

                <c:when test="${empty orderList}">

                    <div class="seller-order-empty-box">
                        조회된 주문이 없습니다.
                    </div>

                </c:when>

                <c:otherwise>

                    <div class="seller-order-view-wrap">

                        <section class="seller-order-simple-view" data-view-panel="simple">

                            <div class="simple-order-table-wrap">

                                <table class="simple-order-table">

                                    <thead>
                                        <c:choose>
                                            <c:when test="${isClaimMode}">
                                                <tr>
                                                    <th>주문번호</th>
                                                    <th>상품이미지</th>
                                                    <th>상품명 / 옵션</th>
                                                    <th>수량</th>
                                                    <th>결제액</th>
                                                    <th>수취인 / 연락처</th>
                                                    <th>배송지</th>
                                                    <th>주문일</th>
                                                    <th>접수일</th>
                                                    <th>배송상태</th>
                                                    <th>접수</th>
                                                </tr>
                                            </c:when>

                                            <c:otherwise>
                                                <tr>
                                                    <th>주문번호</th>
                                                    <th>상품이미지</th>
                                                    <th>상품명 / 옵션</th>
                                                    <th>수량</th>
                                                    <th>결제액</th>
                                                    <th>수취인 / 연락처</th>
                                                    <th>배송지</th>
                                                    <th>주문일</th>
                                                    <th>배송상태</th>
                                                    <th>접수</th>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </thead>

                                    <tbody>

                                    <c:forEach var="order" items="${orderList}">

                                        <c:set var="itemList" value="${orderItemMap[order.order_id]}" />
                                        <c:set var="mainItem" value="${itemList[0]}" />
                                        <c:set var="itemCount" value="${fn:length(itemList)}" />

                                        <tr class="seller-order-click-row"
                                            data-modal-target="order-modal-${order.order_id}">

                                            <td class="simple-order-no">
                                                #${order.order_id}
                                            </td>

                                            <td>
                                                <button type="button"
                                                        class="simple-product-img-btn"
                                                        data-modal-target="order-modal-${order.order_id}">

                                                    <c:choose>
                                                        <c:when test="${empty mainItem or empty mainItem.imageL or fn:trim(mainItem.imageL) eq 'no_file'}">
                                                            <img src="/images/no_image.png" alt="이미지 없음">
                                                        </c:when>

                                                        <c:when test="${fn:startsWith(fn:trim(mainItem.imageL), '/upload/')}">
                                                            <img src="${fn:trim(mainItem.imageL)}" alt="${mainItem.productName}">
                                                        </c:when>

                                                        <c:otherwise>
                                                            <img src="/upload/${fn:trim(mainItem.imageL)}" alt="${mainItem.productName}">
                                                        </c:otherwise>
                                                    </c:choose>

                                                </button>
                                            </td>

                                            <td class="simple-product-cell">

                                                <button type="button"
                                                        class="simple-product-name-btn"
                                                        data-modal-target="order-modal-${order.order_id}">
                                                    ${mainItem.productName}
                                                </button>

                                                <div class="simple-product-option">
                                                    <c:choose>
                                                        <c:when test="${not empty mainItem.option_name}">
                                                            옵션: ${mainItem.option_name}
                                                        </c:when>

                                                        <c:otherwise>
                                                            옵션 없음
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <c:if test="${itemCount gt 1}">
                                                    <div class="simple-more-count">
                                                        외 ${itemCount - 1}건
                                                    </div>
                                                </c:if>

                                            </td>

                                            <td>
                                                ${mainItem.quantity}개
                                            </td>

                                            <td class="simple-price order-total-price">
                                                <fmt:formatNumber value="${order.total_amount}" pattern="#,###" />원
                                            </td>

                                            <td class="simple-receiver">
                                                <strong>${order.receiver_name}</strong>
                                                <span>${order.receiver_phone}</span>
                                            </td>

                                            <td class="simple-address">
                                                ${order.delivery_address}
                                            </td>

                                            <c:choose>
                                                <c:when test="${isClaimMode}">

                                                    <td class="simple-date">
                                                        ${order.created_at}
                                                    </td>

                                                    <td class="simple-date">
                                                        ${order.claim_requested_at}
                                                    </td>

                                                    <td>
                                                        <span class="seller-claim-status-badge ${order.claim_status}">
                                                            <c:choose>
                                                                <c:when test="${order.claim_status eq 'RETURN_REQUEST'}">반품요청</c:when>
                                                                <c:when test="${order.claim_status eq 'EXCHANGE_REQUEST'}">교환요청</c:when>
                                                                <c:when test="${order.claim_status eq 'RETURN_DONE'}">반품완료</c:when>
                                                                <c:when test="${order.claim_status eq 'EXCHANGE_DONE'}">교환완료</c:when>
                                                                <c:otherwise>${order.claim_status}</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>

                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.claim_status eq 'RETURN_REQUEST'}">
                                                                <button type="button"
                                                                        class="simple-receipt-btn return buyer-claim-open-btn"
                                                                        data-claim-type="RETURN"
                                                                        data-claim-id="${order.claim_id}"
                                                                        data-order-item-id="${mainItem.order_item_id}"
                                                                        data-price="${mainItem.subtotalAmount}"
                                                                        data-request-reason="${fn:escapeXml(order.claim_reason)}"
                                                                        data-request-detail="${fn:escapeXml(order.claim_detail_reason)}"
                                                                        data-requested-at="${fn:escapeXml(order.claim_requested_at)}"
                                                                        onclick="openBuyerRequestClaimModal(event, this)">
                                                                    반품처리
                                                                </button>
                                                            </c:when>

                                                            <c:when test="${order.claim_status eq 'EXCHANGE_REQUEST'}">
                                                                <button type="button"
                                                                        class="simple-receipt-btn refund buyer-claim-open-btn"
                                                                        data-claim-type="EXCHANGE"
                                                                        data-claim-id="${order.claim_id}"
                                                                        data-order-item-id="${mainItem.order_item_id}"
                                                                        data-price="${mainItem.subtotalAmount}"
                                                                        data-request-reason="${fn:escapeXml(order.claim_reason)}"
                                                                        data-request-detail="${fn:escapeXml(order.claim_detail_reason)}"
                                                                        data-requested-at="${fn:escapeXml(order.claim_requested_at)}"
                                                                        onclick="openBuyerRequestClaimModal(event, this)">
                                                                    교환처리
                                                                </button>
                                                            </c:when>

                                                            <c:otherwise>
                                                                <span class="seller-claim-done-text">
                                                                    처리완료
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>

                                                </c:when>

                                                <c:otherwise>

                                                    <td class="simple-date">
                                                        ${order.created_at}
                                                    </td>

                                                    <td>
                                                        <form action="/seller_order_status_update.do"
                                                              method="post"
                                                              class="order-status-form">

                                                            <input type="hidden" name="order_id" value="${order.order_id}">
                                                            <input type="hidden" name="selectedStatus" value="${selectedStatus}">

                                                            <select name="status"
                                                                    class="seller-status-select simple-status-select status-${order.status}"
                                                                    data-current="${order.status}">

                                                                <option value="PAID" ${order.status eq 'PAID' ? 'selected' : ''}>
                                                                    신규주문
                                                                </option>

                                                                <option value="PREPARING" ${order.status eq 'PREPARING' ? 'selected' : ''}>
                                                                    제작준비
                                                                </option>

                                                                <option value="SHIPPING" ${order.status eq 'SHIPPING' ? 'selected' : ''}>
                                                                    배송중
                                                                </option>

                                                                <option value="DELIVERED" ${order.status eq 'DELIVERED' ? 'selected' : ''}>
                                                                    배송완료
                                                                </option>

                                                                <option value="CANCELLED" ${order.status eq 'CANCELLED' ? 'selected' : ''}>
                                                                    취소
                                                                </option>

                                                            </select>

                                                        </form>
                                                    </td>

                                                    <td>
                                                        <c:if test="${order.status eq 'DELIVERED'}">
                                                            <div class="simple-action-buttons">

                                                                <button type="button"
                                                                        class="simple-receipt-btn refund seller-direct-claim-open-btn"
                                                                        data-claim-type="EXCHANGE"
                                                                        data-order-id="${order.order_id}"
                                                                        data-item-template-id="direct-claim-items-${order.order_id}"
                                                                        onclick="openSellerDirectClaimModal(event, this)">
                                                                    교환처리
                                                                </button>

                                                                <button type="button"
                                                                        class="simple-receipt-btn return seller-direct-claim-open-btn"
                                                                        data-claim-type="RETURN"
                                                                        data-order-id="${order.order_id}"
                                                                        data-item-template-id="direct-claim-items-${order.order_id}"
                                                                        onclick="openSellerDirectClaimModal(event, this)">
                                                                    반품처리
                                                                </button>

                                                            </div>
                                                        </c:if>
                                                    </td>

                                                </c:otherwise>
                                            </c:choose>

                                        </tr>

                                    </c:forEach>

                                    </tbody>

                                </table>

                            </div>

                        </section>

                        <section class="seller-order-card-view" data-view-panel="card">

                            <div class="seller-order-list">

                                <c:forEach var="order" items="${orderList}">

                                    <c:set var="itemList" value="${orderItemMap[order.order_id]}" />
                                    <c:set var="mainItem" value="${itemList[0]}" />
                                    <c:set var="itemCount" value="${fn:length(itemList)}" />

                                    <article class="seller-order-card seller-order-click-card"
                                             data-modal-target="order-modal-${order.order_id}">

                                        <div class="seller-order-card-top">

                                            <div class="seller-order-info-group">

                                                <div class="seller-order-info-item">
                                                    <span>주문번호</span>
                                                    <strong>#${order.order_id}</strong>
                                                </div>

                                                <div class="seller-order-info-item">
                                                    <span>주문일</span>
                                                    <strong>${order.created_at}</strong>
                                                </div>

                                                <c:if test="${isClaimMode}">
                                                    <div class="seller-order-info-item">
                                                        <span>접수일</span>
                                                        <strong>${order.claim_requested_at}</strong>
                                                    </div>
                                                </c:if>

                                                <div class="seller-order-info-item seller-order-delivery-mini">

                                                    <div class="delivery-mini-row">
                                                        <span>수취인</span>
                                                        <strong>${order.receiver_name}</strong>
                                                    </div>

                                                    <div class="delivery-mini-row">
                                                        <span>연락처</span>
                                                        <strong>${order.receiver_phone}</strong>
                                                    </div>

                                                    <div class="delivery-mini-row">
                                                        <span>배송지</span>
                                                        <strong>${order.delivery_address}</strong>
                                                    </div>

                                                </div>

                                                <div class="seller-order-info-item">
                                                    <span>총 결제액</span>
                                                    <strong class="order-total-price">
                                                        <fmt:formatNumber value="${order.total_amount}" pattern="#,###" />원
                                                    </strong>
                                                </div>

                                            </div>

                                            <div class="seller-order-status-box">

                                                <c:choose>
                                                    <c:when test="${isClaimMode}">

                                                        <span class="status-title">배송상태</span>

                                                        <span class="seller-claim-status-badge ${order.claim_status}">
                                                            <c:choose>
                                                                <c:when test="${order.claim_status eq 'RETURN_REQUEST'}">반품요청</c:when>
                                                                <c:when test="${order.claim_status eq 'EXCHANGE_REQUEST'}">교환요청</c:when>
                                                                <c:when test="${order.claim_status eq 'RETURN_DONE'}">반품완료</c:when>
                                                                <c:when test="${order.claim_status eq 'EXCHANGE_DONE'}">교환완료</c:when>
                                                                <c:otherwise>${order.claim_status}</c:otherwise>
                                                            </c:choose>
                                                        </span>

                                                    </c:when>

                                                    <c:otherwise>

                                                        <span class="status-title">배송상태</span>

                                                        <form action="/seller_order_status_update.do"
                                                              method="post"
                                                              class="order-status-form">

                                                            <input type="hidden" name="order_id" value="${order.order_id}">
                                                            <input type="hidden" name="selectedStatus" value="${selectedStatus}">

                                                            <select name="status"
                                                                    class="seller-status-select status-${order.status}"
                                                                    data-current="${order.status}">

                                                                <option value="PAID" ${order.status eq 'PAID' ? 'selected' : ''}>
                                                                    신규주문
                                                                </option>

                                                                <option value="PREPARING" ${order.status eq 'PREPARING' ? 'selected' : ''}>
                                                                    제작준비
                                                                </option>

                                                                <option value="SHIPPING" ${order.status eq 'SHIPPING' ? 'selected' : ''}>
                                                                    배송중
                                                                </option>

                                                                <option value="DELIVERED" ${order.status eq 'DELIVERED' ? 'selected' : ''}>
                                                                    배송완료
                                                                </option>

                                                                <option value="CANCELLED" ${order.status eq 'CANCELLED' ? 'selected' : ''}>
                                                                    취소
                                                                </option>

                                                            </select>

                                                        </form>

                                                    </c:otherwise>
                                                </c:choose>

                                            </div>

                                        </div>

                                        <div class="seller-order-body">

                                            <div class="seller-order-main-item">

                                                <button type="button"
                                                        class="seller-order-thumb"
                                                        data-modal-target="order-modal-${order.order_id}">

                                                    <c:choose>
                                                        <c:when test="${empty mainItem or empty mainItem.imageL or fn:trim(mainItem.imageL) eq 'no_file'}">
                                                            <img src="/images/no_image.png" alt="이미지 없음">
                                                        </c:when>

                                                        <c:when test="${fn:startsWith(fn:trim(mainItem.imageL), '/upload/')}">
                                                            <img src="${fn:trim(mainItem.imageL)}" alt="${mainItem.productName}">
                                                        </c:when>

                                                        <c:otherwise>
                                                            <img src="/upload/${fn:trim(mainItem.imageL)}" alt="${mainItem.productName}">
                                                        </c:otherwise>
                                                    </c:choose>

                                                </button>

                                                <div class="seller-order-product-info">

                                                    <button type="button"
                                                            class="seller-order-product-name modal-product-open"
                                                            data-modal-target="order-modal-${order.order_id}">
                                                        ${mainItem.productName}
                                                    </button>

                                                    <div class="simple-product-option">
                                                        <c:choose>
                                                            <c:when test="${not empty mainItem.option_name}">
                                                                옵션: ${mainItem.option_name}
                                                            </c:when>

                                                            <c:otherwise>
                                                                옵션 없음
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <p class="seller-order-product-sub">
                                                        수량 ${mainItem.quantity}개
                                                        <span>·</span>
                                                        상품금액
                                                        <fmt:formatNumber value="${mainItem.subtotalAmount}" pattern="#,###" />원
                                                    </p>

                                                    <c:if test="${itemCount gt 1}">
                                                        <p class="seller-order-count-text">
                                                            이 주문에는 총 <strong>${itemCount}</strong>개의 상품이 포함되어 있습니다.

                                                            <button type="button"
                                                                    class="seller-order-modal-link"
                                                                    data-modal-target="order-modal-${order.order_id}">
                                                                전체 상품 보기
                                                            </button>
                                                        </p>
                                                    </c:if>

                                                </div>

                                            </div>

                                            <c:choose>
                                                <c:when test="${isClaimMode}">
                                                    <div class="seller-order-card-actions">

                                                        <c:choose>
                                                            <c:when test="${order.claim_status eq 'RETURN_REQUEST'}">
                                                                <button type="button"
                                                                        class="card-receipt-btn return buyer-claim-open-btn"
                                                                        data-claim-type="RETURN"
                                                                        data-claim-id="${order.claim_id}"
                                                                        data-order-item-id="${mainItem.order_item_id}"
                                                                        data-price="${mainItem.subtotalAmount}"
                                                                        data-request-reason="${fn:escapeXml(order.claim_reason)}"
                                                                        data-request-detail="${fn:escapeXml(order.claim_detail_reason)}"
                                                                        data-requested-at="${fn:escapeXml(order.claim_requested_at)}"
                                                                        onclick="openBuyerRequestClaimModal(event, this)">
                                                                    반품처리
                                                                </button>
                                                            </c:when>

                                                            <c:when test="${order.claim_status eq 'EXCHANGE_REQUEST'}">
                                                                <button type="button"
                                                                        class="card-receipt-btn refund buyer-claim-open-btn"
                                                                        data-claim-type="EXCHANGE"
                                                                        data-claim-id="${order.claim_id}"
                                                                        data-order-item-id="${mainItem.order_item_id}"
                                                                        data-price="${mainItem.subtotalAmount}"
                                                                        data-request-reason="${fn:escapeXml(order.claim_reason)}"
                                                                        data-request-detail="${fn:escapeXml(order.claim_detail_reason)}"
                                                                        data-requested-at="${fn:escapeXml(order.claim_requested_at)}"
                                                                        onclick="openBuyerRequestClaimModal(event, this)">
                                                                    교환처리
                                                                </button>
                                                            </c:when>

                                                            <c:otherwise>
                                                                <span class="seller-claim-done-text">
                                                                    처리완료
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>

                                                    </div>
                                                </c:when>

                                                <c:otherwise>
                                                    <c:if test="${order.status eq 'DELIVERED'}">
                                                        <div class="seller-order-card-actions">

                                                            <button type="button"
                                                                    class="card-receipt-btn refund seller-direct-claim-open-btn"
                                                                    data-claim-type="EXCHANGE"
                                                                    data-order-id="${order.order_id}"
                                                                    data-item-template-id="direct-claim-items-${order.order_id}"
                                                                    onclick="openSellerDirectClaimModal(event, this)">
                                                                교환처리
                                                            </button>

                                                            <button type="button"
                                                                    class="card-receipt-btn return seller-direct-claim-open-btn"
                                                                    data-claim-type="RETURN"
                                                                    data-order-id="${order.order_id}"
                                                                    data-item-template-id="direct-claim-items-${order.order_id}"
                                                                    onclick="openSellerDirectClaimModal(event, this)">
                                                                반품처리
                                                            </button>

                                                        </div>
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>

                                        </div>

                                    </article>

                                </c:forEach>

                            </div>

                        </section>

                        <c:if test="${pagination.totalPage > 1}">

                            <div class="seller-page-menu">

                                <c:choose>
                                    <c:when test="${pagination.hasPrev}">
                                        <a href="/seller_order_list.do?page=${pagination.prevPage}&amp;size=${pagination.size}&amp;status=${selectedStatus}&amp;claimTab=${currentClaimTab}">
                                            ◀
                                        </a>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="page-disabled">◀</span>
                                    </c:otherwise>
                                </c:choose>

                                <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">

                                    <c:choose>
                                        <c:when test="${pagination.page == i}">
                                            <span class="page-current">${i}</span>
                                        </c:when>

                                        <c:otherwise>
                                            <a href="/seller_order_list.do?page=${i}&amp;size=${pagination.size}&amp;status=${selectedStatus}&amp;claimTab=${currentClaimTab}">
                                                ${i}
                                            </a>
                                        </c:otherwise>
                                    </c:choose>

                                </c:forEach>

                                <c:choose>
                                    <c:when test="${pagination.hasNext}">
                                        <a href="/seller_order_list.do?page=${pagination.nextPage}&amp;size=${pagination.size}&amp;status=${selectedStatus}&amp;claimTab=${currentClaimTab}">
                                            ▶
                                        </a>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="page-disabled">▶</span>
                                    </c:otherwise>
                                </c:choose>

                            </div>

                        </c:if>

                        <!-- 주문 상품 모달 템플릿 -->
                        <div class="seller-order-modal-templates">

                            <c:forEach var="order" items="${orderList}">

                                <c:set var="itemList" value="${orderItemMap[order.order_id]}" />

                                <div id="order-modal-${order.order_id}" class="order-modal-template">

                                    <div class="order-modal-title-area">

                                        <h3>주문번호 #${order.order_id}</h3>

                                        <p>
                                            수취인 ${order.receiver_name}
                                            <span>·</span>
                                            ${order.receiver_phone}
                                        </p>

                                        <p class="modal-address">
                                            ${order.delivery_address}
                                        </p>

                                        <c:if test="${isClaimMode}">
                                            <p>
                                                접수일
                                                <span>·</span>
                                                ${order.claim_requested_at}
                                            </p>
                                        </c:if>

                                    </div>

                                    <div class="order-modal-product-list">

                                        <c:forEach var="item" items="${itemList}">

                                            <div class="order-modal-product-row">

                                                <div class="order-modal-thumb">

                                                    <c:choose>
                                                        <c:when test="${empty item.imageL or fn:trim(item.imageL) eq 'no_file'}">
                                                            <img src="/images/no_image.png" alt="이미지 없음">
                                                        </c:when>

                                                        <c:when test="${fn:startsWith(fn:trim(item.imageL), '/upload/')}">
                                                            <img src="${fn:trim(item.imageL)}" alt="${item.productName}">
                                                        </c:when>

                                                        <c:otherwise>
                                                            <img src="/upload/${fn:trim(item.imageL)}" alt="${item.productName}">
                                                        </c:otherwise>
                                                    </c:choose>

                                                </div>

                                                <div class="order-modal-product-info">

                                                    <strong>${item.productName}</strong>

                                                    <p>
                                                        <c:choose>
                                                            <c:when test="${not empty item.option_name}">
                                                                옵션: ${item.option_name}
                                                            </c:when>

                                                            <c:otherwise>
                                                                옵션 없음
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>

                                                    <p>
                                                        수량 ${item.quantity}개
                                                        <span>·</span>
                                                        상품금액
                                                        <fmt:formatNumber value="${item.subtotalAmount}" pattern="#,###" />원
                                                    </p>

                                                </div>

                                            </div>

                                        </c:forEach>

                                    </div>

                                </div>

                            </c:forEach>

                        </div>

                        <!-- 상품관리 탭 직접 처리 상품 선택 템플릿 -->
                        <div class="seller-direct-claim-item-templates" style="display:none;">

                            <c:forEach var="order" items="${orderList}">

                                <c:set var="itemList" value="${orderItemMap[order.order_id]}" />

                                <select id="direct-claim-items-${order.order_id}">
                                    <c:forEach var="item" items="${itemList}">
                                        <option value="${item.order_item_id}"
                                                data-price="${item.subtotalAmount}">
                                            <c:out value="${item.productName}" />
                                            /
                                            <c:choose>
                                                <c:when test="${not empty item.option_name}">
                                                    옵션: <c:out value="${item.option_name}" />
                                                </c:when>
                                                <c:otherwise>
                                                    옵션 없음
                                                </c:otherwise>
                                            </c:choose>
                                            /
                                            수량 ${item.quantity}개
                                            /
                                            <fmt:formatNumber value="${item.subtotalAmount}" pattern="#,###" />원
                                        </option>
                                    </c:forEach>
                                </select>

                            </c:forEach>

                        </div>

                        <!-- 실제 주문 상품 모달 -->
                        <div class="seller-order-modal" id="sellerOrderModal">

                            <div class="seller-order-modal-dim" data-modal-close></div>

                            <div class="seller-order-modal-box">

                                <button type="button" class="seller-order-modal-close" data-modal-close>
                                    ×
                                </button>

                                <div class="seller-order-modal-content" id="sellerOrderModalContent"></div>

                            </div>

                        </div>

                    </div>

                </c:otherwise>

            </c:choose>

        </div>

    </main>

</div>

<!-- 상품관리 탭: 판매자 직접 반품/교환 처리 모달 -->
<div class="cs-modal-wrap seller-claim-modal" id="sellerDirectClaimModal">

    <div class="cs-modal-bg" onclick="closeSellerDirectClaimModal()"></div>

    <div class="cs-modal-box">

        <div class="cs-modal-head">
            <div>
                <span>SELLER DIRECT PROCESS</span>
                <h3 id="sellerDirectClaimModalTitle">반품/교환 직접 처리</h3>
                <p>판매자가 상품과 사유를 선택해서 바로 반품 또는 교환 완료 처리합니다.</p>
            </div>

            <button type="button" class="cs-modal-close" onclick="closeSellerDirectClaimModal()">
                ×
            </button>
        </div>

        <div class="cs-modal-body">

            <h3>처리 유형</h3>

            <div class="cs-type-select">
                <input type="radio"
                       name="sellerDirectClaimType"
                       id="sellerDirectClaimReturn"
                       value="RETURN"
                       onchange="changeSellerDirectClaimType('RETURN')">

                <label for="sellerDirectClaimReturn">반품</label>

                <input type="radio"
                       name="sellerDirectClaimType"
                       id="sellerDirectClaimExchange"
                       value="EXCHANGE"
                       onchange="changeSellerDirectClaimType('EXCHANGE')">

                <label for="sellerDirectClaimExchange">교환</label>
            </div>

            <form id="sellerDirectClaimForm"
                  action="/seller_direct_claim_done.do"
                  method="post"
                  onsubmit="return submitSellerDirectClaimForm()">

                <input type="hidden" id="sellerDirectClaimStatus" name="status">
                <input type="hidden" id="sellerDirectOrderId" name="order_id">
                <input type="hidden" name="selectedStatus" value="${selectedStatus}">

                <div class="cs-form-row">
                    <label for="sellerDirectOrderItemSelect">처리 상품</label>
                    <select id="sellerDirectOrderItemSelect"
                            name="order_item_id"
                            onchange="changeSellerDirectItemPrice(this)">
                        <option value="">처리할 상품을 선택해주세요</option>
                    </select>
                </div>

                <div class="cs-info-row">
                    <span>결제금액</span>
                    <input id="sellerDirectPrice" readonly="readonly">
                </div>

                <div class="cs-form-row">
                    <label for="sellerDirectReason" id="sellerDirectReasonLabel">처리 사유</label>

                    <select id="sellerDirectReason" name="reason">
                        <option value="">처리 사유를 선택해주세요</option>
                    </select>
                </div>

                <div class="cs-form-row">
                    <label for="sellerDirectDetailReason">판매자 상세 사유</label>

                    <textarea id="sellerDirectDetailReason"
                            name="detail_reason"
                            placeholder="판매자가 직접 처리하는 상세 사유를 입력해주세요."></textarea>
                </div>

                <div class="cs-form-row">
                    <label for="sellerDirectSellerAnswer">판매자 처리 안내</label>

                    <textarea id="sellerDirectSellerAnswer"
                            name="seller_answer"
                            placeholder="구매자에게 보여줄 처리 안내를 입력해주세요."></textarea>
                </div>

                <div class="seller-claim-guide-box">
                    <strong id="sellerDirectGuideTitle">처리 안내</strong>

                    <ul id="sellerDirectGuideList">
                        <li>저장하면 바로 완료 상태로 변경됩니다.</li>
                        <li>판매자가 직접 처리한 건으로 저장됩니다.</li>
                    </ul>
                </div>

                <label class="seller-claim-agree">
                    <input type="checkbox" id="sellerDirectAgree">
                    처리 안내사항을 확인했습니다.
                </label>

                <div class="cs-modal-actions">
                    <button type="button" class="cs-close-btn" onclick="closeSellerDirectClaimModal()">
                        닫기
                    </button>

                    <button type="submit" class="cs-submit-btn" id="sellerDirectSubmitBtn">
                        처리하기
                    </button>
                </div>

            </form>

        </div>

    </div>
</div>

<!-- 반품/교환 탭: 구매자 요청 처리 모달 -->
<div class="cs-modal-wrap seller-claim-modal" id="buyerRequestClaimModal">

    <div class="cs-modal-bg" onclick="closeBuyerRequestClaimModal()"></div>

    <div class="cs-modal-box">

        <div class="cs-modal-head">
            <div>
                <span>BUYER CLAIM REQUEST</span>
                <h3 id="buyerRequestClaimTitle">구매자 요청 처리</h3>
                <p>구매자가 신청한 반품/교환 요청을 확인하고 처리 안내를 입력합니다.</p>
            </div>

            <button type="button" class="cs-modal-close" onclick="closeBuyerRequestClaimModal()">
                ×
            </button>
        </div>

        <div class="cs-modal-body">

            <form id="buyerRequestClaimForm"
                  action="/seller_buyer_claim_done.do"
                  method="post"
                  onsubmit="return submitBuyerRequestClaimForm()">

                <input type="hidden" id="buyerRequestClaimId" name="claim_id">
                <input type="hidden" id="buyerRequestClaimStatus" name="status">
                <input type="hidden" name="selectedStatus" value="${selectedStatus}">
                <input type="hidden" name="claimTab" value="${currentClaimTab}">

                <div class="cs-info-row">
                    <span>주문상품번호</span>
                    <input id="buyerRequestOrderItemIdText" readonly="readonly">
                </div>

                <div class="cs-info-row">
                    <span>결제금액</span>
                    <input id="buyerRequestPrice" readonly="readonly">
                </div>

                <div class="cs-info-row">
                    <span>요청일</span>
                    <input id="buyerRequestRequestedAt" readonly="readonly">
                </div>

                <div class="cs-info-row">
                    <span id="buyerRequestReasonLabel">구매자 요청 사유</span>
                    <input id="buyerRequestReason" readonly="readonly">
                </div>

                <div class="cs-form-row">
                    <label for="buyerRequestDetail">구매자 상세 사유</label>
                    <textarea id="buyerRequestDetail" readonly="readonly"></textarea>
                </div>

                <div class="cs-form-row">
                    <label for="buyerRequestSellerAnswer">판매자 처리 안내</label>
                    <textarea id="buyerRequestSellerAnswer"
                              name="seller_answer"
                              placeholder="구매자에게 보여줄 처리 안내를 입력해주세요."></textarea>
                </div>

                <div class="seller-claim-guide-box">
                    <strong id="buyerRequestGuideTitle">처리 안내</strong>
                    <ul id="buyerRequestGuideList">
                        <li>처리하면 요청 상태가 완료 상태로 변경됩니다.</li>
                        <li>구매자가 작성한 요청 사유는 수정하지 않습니다.</li>
                    </ul>
                </div>

                <label class="seller-claim-agree">
                    <input type="checkbox" id="buyerRequestAgree">
                    처리 내용을 확인했습니다.
                </label>

                <div class="cs-modal-actions">
                    <button type="button" class="cs-close-btn" onclick="closeBuyerRequestClaimModal()">
                        닫기
                    </button>

                    <button type="submit" class="cs-submit-btn" id="buyerRequestSubmitBtn">
                        처리하기
                    </button>
                </div>

            </form>

        </div>

    </div>
</div>

</body>
</html>