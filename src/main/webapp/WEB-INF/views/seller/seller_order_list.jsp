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
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty orderList}">
                            <div class="empty-box">
                                조회된 주문이 없습니다.
                            </div>
                        </c:when>

                        <c:otherwise>

                            <div class="seller-order-list">

                                <div class="seller-order-head">
                                    <div>주문번호</div>
                                    <div>상품정보</div>
                                    <div>상품상태</div>
                                    <div>수량</div>
                                    <div>상품금액</div>
                                    <div>주문금액</div>
                                    <div>주문일</div>
                                </div>

                                <c:forEach var="order" items="${orderList}">
                                    <c:set var="itemList" value="${orderItemMap[order.order_id]}" />

                                    <div class="seller-order-card">

                                        <div class="order-no-box">
                                            <strong>#${order.order_id}</strong>
                                        </div>

                                        <div class="order-card-items">
                                            <c:forEach var="item" items="${itemList}">
                                                <div class="order-item-line">

                                                    <div class="order-product-info">
                                                        <c:choose>
                                                            <c:when test="${not empty item.imageL and fn:trim(item.imageL) ne 'no_file'}">
                                                                <c:set var="orderImagePath" value="${fn:trim(item.imageL)}" />

                                                                <c:choose>
                                                                    <c:when test="${fn:startsWith(orderImagePath, '/upload/')}">
                                                                        <img src="${orderImagePath}"
                                                                            class="product-thumb"
                                                                            alt="${item.productName}"
                                                                            onerror="this.outerHTML='<div class=&quot;no-image&quot;>이미지 없음</div>';">
                                                                    </c:when>

                                                                    <c:otherwise>
                                                                        <img src="/upload/${orderImagePath}"
                                                                            class="product-thumb"
                                                                            alt="${item.productName}"
                                                                            onerror="this.outerHTML='<div class=&quot;no-image&quot;>이미지 없음</div>';">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>

                                                            <c:otherwise>
                                                                <div class="no-image">이미지 없음</div>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <div class="order-product-name">
                                                            ${item.productName}
                                                        </div>
                                                    </div>

                                                    <div class="order-item-status">
                                                        <c:choose>
                                                            <c:when test="${item.status eq 'PAID'}">
                                                                <span class="status-badge status-pending">신규주문</span>

                                                                <form action="/seller_order_status_update.do" method="post" class="order-status-form">
                                                                    <input type="hidden" name="order_item_id" value="${item.order_item_id}">
                                                                    <input type="hidden" name="selectedStatus" value="${selectedStatus}">
                                                                    <button type="submit" name="status" value="PREPARING" class="status-change-btn">
                                                                        배송준비 처리
                                                                    </button>
                                                                </form>
                                                            </c:when>

                                                            <c:when test="${item.status eq 'PREPARING'}">
                                                                <span class="status-badge status-approved">배송준비</span>

                                                                <form action="/seller_order_status_update.do" method="post" class="order-status-form">
                                                                    <input type="hidden" name="order_item_id" value="${item.order_item_id}">
                                                                    <input type="hidden" name="selectedStatus" value="${selectedStatus}">
                                                                    <button type="submit" name="status" value="SHIPPING" class="status-change-btn">
                                                                        배송중 처리
                                                                    </button>
                                                                </form>
                                                            </c:when>

                                                            <c:when test="${item.status eq 'SHIPPING'}">
                                                                <span class="status-badge status-hidden">배송중</span>

                                                                <form action="/seller_order_status_update.do" method="post" class="order-status-form">
                                                                    <input type="hidden" name="order_item_id" value="${item.order_item_id}">
                                                                    <input type="hidden" name="selectedStatus" value="${selectedStatus}">
                                                                    <button type="submit" name="status" value="DELIVERED" class="status-change-btn">
                                                                        배송완료 처리
                                                                    </button>
                                                                </form>
                                                            </c:when>

                                                            <c:when test="${item.status eq 'DELIVERED'}">
                                                                <span class="status-badge status-approved">배송완료</span>
                                                            </c:when>

                                                            <c:when test="${item.status eq 'CONFIRMED'}">
                                                                <span class="status-badge status-approved">구매확정</span>
                                                            </c:when>

                                                            <c:when test="${item.status eq 'CANCELLED'}">
                                                                <span class="status-badge status-rejected">취소</span>
                                                            </c:when>

                                                            <c:otherwise>
                                                                <span class="status-badge status-rejected">${item.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div class="order-item-qty">
                                                        ${item.quantity}개
                                                    </div>

                                                    <div class="order-item-price">
                                                        <fmt:formatNumber value="${item.subtotalAmount}" pattern="#,###" />원
                                                    </div>

                                                </div>
                                            </c:forEach>
                                        </div>

                                        <div class="order-total-box">
                                            <strong>
                                                <fmt:formatNumber value="${order.total_amount}" pattern="#,###" />원
                                            </strong>
                                        </div>

                                        <div class="order-date-box">
                                            ${order.created_at}
                                        </div>

                                    </div>
                                </c:forEach>

                            </div>

                        </c:otherwise>
                    </c:choose>

                </div>
            </div>
        </body>

    </html>