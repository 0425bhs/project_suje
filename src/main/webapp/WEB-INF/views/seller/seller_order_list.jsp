<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="/css/seller/seller_product_list.css">
    </head>

    <body>
        <div class="seller-board">

            <jsp:include page="seller_sidebar.jsp">
                <jsp:param name="activeMenu" value="orderList" />
                <jsp:param name="sidebarTitle" value="판매자 주문관리" />
            </jsp:include>

            <div class="seller-main">

                <div class="seller-main-header">
                    <div>
                        <span class="page-label">ORDER MANAGEMENT</span>
                        <h1>주문 관리</h1>
                        <p>판매자의 상품이 포함된 주문을 상태별로 확인할 수 있습니다.</p>
                    </div>
                </div>

                <div class="filter-box">
                    <div class="filter-buttons">
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
                            배송준비
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
                </div>

                <c:choose>

                    <!-- 주문이 없을 때 -->
                    <c:when test="${empty orderList}">
                        <div class="empty-box">
                            조회된 주문이 없습니다.
                        </div>
                    </c:when>

                    <!-- 주문이 있을 때 -->
                    <c:otherwise>

                        <div class="seller-order-list">

                            <c:forEach var="order" items="${orderList}">

                                <c:set var="itemList" value="${orderItemMap[order.order_id]}" />
                                <c:set var="mainItem" value="${itemList[0]}" />
                                <c:set var="itemCount" value="${fn:length(itemList)}" />

                                <article class="seller-order-card">

                                    <div class="seller-order-card-top">

                                        <div class="seller-order-no-box">
                                            <span>주문번호</span>
                                            <strong>#${order.order_id}</strong>
                                        </div>

                                        <div class="seller-order-date-box">
                                            <span>주문일</span>
                                            <strong>${order.created_at}</strong>
                                        </div>

                                        <div class="seller-order-total-box">
                                            <span>주문금액</span>
                                            <strong>
                                                <fmt:formatNumber value="${order.total_amount}" pattern="#,###" />원
                                            </strong>
                                        </div>

                                        <div class="seller-order-status-box">

                                            <form action="/seller_order_status_update.do"
                                                  method="post"
                                                  class="order-status-form">

                                                <input type="hidden" name="order_id" value="${order.order_id}">
                                                <input type="hidden" name="selectedStatus" value="${selectedStatus}">

                                                <select name="status"
                                                        class="seller-status-select ${order.status}"
                                                        data-current="${order.status}"
                                                        onchange="sellerOrderStatusChange(this)">

                                                    <option value="PAID"
                                                            ${order.status eq 'PAID' ? 'selected' : ''}>
                                                        신규주문
                                                    </option>

                                                    <option value="PREPARING"
                                                            ${order.status eq 'PREPARING' ? 'selected' : ''}>
                                                        배송준비
                                                    </option>

                                                    <option value="SHIPPING"
                                                            ${order.status eq 'SHIPPING' ? 'selected' : ''}>
                                                        배송중
                                                    </option>

                                                    <option value="DELIVERED"
                                                            ${order.status eq 'DELIVERED' ? 'selected' : ''}>
                                                        배송완료
                                                    </option>

                                                    <option value="CANCELLED"
                                                            ${order.status eq 'CANCELLED' ? 'selected' : ''}>
                                                        취소
                                                    </option>

                                                </select>

                                            </form>

                                        </div>

                                    </div>

                                    <!-- 대표 상품 영역 -->
                                    <div class="seller-order-main-item">

                                        <div class="seller-order-thumb">

                                            <c:choose>

                                                <!-- 대표 상품 이미지가 없으면 기본 이미지 -->
                                                <c:when test="${empty mainItem or empty mainItem.imageL or fn:trim(mainItem.imageL) eq 'no_file'}">
                                                    <img src="/images/no_image.png" alt="이미지 없음">
                                                </c:when>

                                                <!-- 대표 상품 이미지가 이미 /upload/파일명 형태면 그대로 사용 -->
                                                <c:when test="${fn:startsWith(fn:trim(mainItem.imageL), '/upload/')}">
                                                    <img src="${fn:trim(mainItem.imageL)}"
                                                         alt="${mainItem.productName}"
                                                         onerror="this.onerror=null; this.src='/images/no_image.png';">
                                                </c:when>

                                                <!-- 대표 상품 이미지가 파일명만 있으면 /upload/ 붙여서 사용 -->
                                                <c:otherwise>
                                                    <img src="/upload/${fn:trim(mainItem.imageL)}"
                                                         alt="${mainItem.productName}"
                                                         onerror="this.onerror=null; this.src='/images/no_image.png';">
                                                </c:otherwise>

                                            </c:choose>

                                        </div>

                                        <div class="seller-order-product-info">

                                            <span class="seller-order-label">대표 상품</span>

                                            <strong class="seller-order-product-name">
                                                ${mainItem.productName}
                                            </strong>

                                            <p>
                                                수량 ${mainItem.quantity}개 ·
                                                상품금액
                                                <fmt:formatNumber value="${mainItem.subtotalAmount}" pattern="#,###" />원
                                            </p>

                                            <c:if test="${itemCount gt 1}">
                                                <p class="seller-order-count-text">
                                                    이 주문에는 총 ${itemCount}개의 상품이 포함되어 있습니다.
                                                </p>
                                            </c:if>

                                        </div>
                                    </div>

                                    <c:if test="${itemCount gt 1}">

                                        <button type="button" class="seller-order-toggle" data-count="${itemCount - 1}" onclick="toggleSellerOrderItems(this)">
                                            <span class="toggle-text">나머지 ${itemCount - 1}건 주문 펼쳐보기</span>
                                            <span class="toggle-arrow">⌄</span>
                                        </button>

                                        <div class="seller-order-items-panel">

                                            <c:forEach var="item" items="${itemList}" varStatus="st">

                                                <c:if test="${st.index gt 0}">

                                                    <div class="seller-order-item-row">

                                                        <div class="seller-order-item-thumb">

                                                            <c:choose>

                                                                <c:when test="${empty item.imageL or fn:trim(item.imageL) eq 'no_file'}">
                                                                    <img src="/images/no_image.png" alt="이미지 없음">
                                                                </c:when>

                                                                <c:when test="${fn:startsWith(fn:trim(item.imageL), '/upload/')}">
                                                                    <img src="${fn:trim(item.imageL)}" alt="${item.productName}" onerror="this.onerror=null; this.src='/images/no_image.png';">
                                                                </c:when>

                                                                <c:otherwise>
                                                                    <img src="/upload/${fn:trim(item.imageL)}" alt="${item.productName}" onerror="this.onerror=null; this.src='/images/no_image.png';">
                                                                </c:otherwise>

                                                            </c:choose>

                                                        </div>

                                                        <div class="seller-order-item-info">
                                                            <strong>${item.productName}</strong>

                                                            <p>
                                                                수량 ${item.quantity}개 ·
                                                                상품금액
                                                                <fmt:formatNumber value="${item.subtotalAmount}" pattern="#,###" />원
                                                            </p>
                                                        </div>

                                                    </div>

                                                </c:if>

                                            </c:forEach>

                                        </div>

                                    </c:if>

                                </article>

                            </c:forEach>

                        </div>

                    </c:otherwise>

                </c:choose>

            </div>
        </div>
    </body>

</html>