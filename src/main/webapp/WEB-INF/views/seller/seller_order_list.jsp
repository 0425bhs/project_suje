<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">

<head>
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

            <div class="view-switch-buttons">

                <button type="button" class="view-icon-btn" data-view="simple" title="심플 형태">
                    <span class="view-icon simple"></span>
                </button>

                <button type="button" class="view-icon-btn active" data-view="card" title="카드형태">
                    <span class="view-icon card"></span>
                </button>

            </div>

            <div class="seller-order-filter-box">
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

                    <a href="/seller_order_list.do?status=RETURN_EXCHANGE"
                       class="${selectedStatus eq 'RETURN_EXCHANGE' ? 'active' : ''}">
                        반품/교환
                    </a>

                    <a href="/seller_order_list.do?status=CANCELLED"
                       class="${selectedStatus eq 'CANCELLED' ? 'active' : ''}">
                        취소
                    </a>
                </div>
            </div>

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
                                        <tr>
                                            <th>주문번호</th>
                                            <th>상품이미지</th>
                                            <th>상품명 / 옵션</th>
                                            <th>수량</th>
                                            <th>상품가격</th>
                                            <th>수취인 / 연락처</th>
                                            <th>배송지</th>
                                            <th>배송상태</th>
                                            <th>주문일</th>
                                            <th>접수</th>
                                        </tr>
                                    </thead>

                                    <tbody>

                                        <c:forEach var="order" items="${orderList}">

                                            <c:set var="itemList" value="${orderItemMap[order.order_id]}" />
                                            <c:set var="mainItem" value="${itemList[0]}" />
                                            <c:set var="itemCount" value="${fn:length(itemList)}" />

                                            <tr>
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

                                                <td class="simple-price">
                                                    <fmt:formatNumber value="${mainItem.subtotalAmount}" pattern="#,###" />원
                                                </td>

                                                <td class="simple-receiver">
                                                    <strong>${order.receiver_name}</strong>
                                                    <span>${order.receiver_phone}</span>
                                                </td>

                                                <td class="simple-address">
                                                    ${order.delivery_address}
                                                </td>

                                                <td>
                                                    <form action="/seller_order_status_update.do"
                                                          method="post"
                                                          class="order-status-form">

                                                        <input type="hidden" name="order_item_id" value="${mainItem.order_item_id}">
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

                                                            <option value="RETURN_EXCHANGE" ${order.status eq 'RETURN_EXCHANGE' ? 'selected' : ''}>
                                                                반품/교환
                                                            </option>

                                                            <option value="CANCELLED" ${order.status eq 'CANCELLED' ? 'selected' : ''}>
                                                                취소
                                                            </option>

                                                        </select>

                                                    </form>
                                                </td>

                                                <td class="simple-date">
                                                    ${order.created_at}
                                                </td>

                                                <td>
                                                    <c:if test="${order.status eq 'DELIVERED'}">
                                                        <div class="simple-action-buttons">
                                                            <button type="button" class="simple-receipt-btn refund">
                                                                환불
                                                            </button>

                                                            <button type="button" class="simple-receipt-btn return">
                                                                반품
                                                            </button>
                                                        </div>
                                                    </c:if>
                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </tbody>
                                </table>

                            </div>

                        </section>

                        <section class="seller-order-card-view active" data-view-panel="card">

                            <div class="seller-order-list">

                                <c:forEach var="order" items="${orderList}">

                                    <c:set var="itemList" value="${orderItemMap[order.order_id]}" />
                                    <c:set var="mainItem" value="${itemList[0]}" />
                                    <c:set var="itemCount" value="${fn:length(itemList)}" />

                                    <article class="seller-order-card">

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

                                                <!-- 추가: 주문일과 주문금액 사이 -->
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
                                                    <span>주문금액</span>
                                                    <strong class="order-total-price">
                                                        <fmt:formatNumber value="${order.total_amount}" pattern="#,###" />원
                                                    </strong>
                                                </div>

                                            </div>

                                            <div class="seller-order-status-box">

                                                <span class="status-title">배송상태</span>

                                                <form action="/seller_order_status_update.do"
                                                      method="post"
                                                      class="order-status-form">

                                                    <input type="hidden" name="order_item_id" value="${mainItem.order_item_id}">
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

                                                        <option value="RETURN_EXCHANGE" ${order.status eq 'RETURN_EXCHANGE' ? 'selected' : ''}>
                                                            반품/교환
                                                        </option>

                                                        <option value="CANCELLED" ${order.status eq 'CANCELLED' ? 'selected' : ''}>
                                                            취소
                                                        </option>

                                                    </select>

                                                </form>

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

                                            <c:if test="${order.status eq 'DELIVERED'}">
                                                <div class="seller-order-card-actions">
                                                    <button type="button" class="card-receipt-btn refund">
                                                        환불 접수
                                                    </button>

                                                    <button type="button" class="card-receipt-btn return">
                                                        반품 접수
                                                    </button>
                                                </div>
                                            </c:if>

                                        </div>

                                    </article>

                                </c:forEach>

                            </div>

                        </section>

                        <c:if test="${pagination.totalPage > 1}">
                            <div class="seller-page-menu">

                                <c:choose>
                                    <c:when test="${pagination.hasPrev}">
                                        <a href="/seller_order_list.do?page=${pagination.prevPage}&size=${pagination.size}&status=${selectedStatus}">
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
                                            <a href="/seller_order_list.do?page=${i}&size=${pagination.size}&status=${selectedStatus}">
                                                ${i}
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <c:choose>
                                    <c:when test="${pagination.hasNext}">
                                        <a href="/seller_order_list.do?page=${pagination.nextPage}&size=${pagination.size}&status=${selectedStatus}">
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

                        <!-- 실제 모달 -->
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

        </main>

    </div>

</body>
</html>