<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 주문 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
    <script src="/js/admin_detail_common.js"></script>
    <script>
        function formatAdminOrderAmount(value) {
            const amount = Number(value || 0);
            return amount.toLocaleString("ko-KR") + "원";
        }

        function renderOrderItems(items) {
            const target = document.getElementById("orderItems");

            if (!target) {
                return;
            }

            if (!items || !items.length) {
                target.textContent = "-";
                return;
            }

            const list = document.createElement("div");
            list.className = "admin-detail-grid";

            items.forEach((item) => {
                const row = document.createElement("div");
                const name = item.product_name || "-";
                const option = item.option_name ? " / " + item.option_name : "";
                const quantity = item.quantity || 0;
                const price = formatAdminOrderAmount(item.subtotal_amount || item.price);
                const status = item.status || "-";

                row.innerHTML =
                    "<dt>" + name + option + "</dt>" +
                    "<dd>" + quantity + "개 · " + price + " · " + status + "</dd>";
                list.appendChild(row);
            });

            target.replaceChildren(list);
        }

        document.addEventListener("DOMContentLoaded", () => {
            const master = document.getElementById("adminMasterDetail");
            const rows = document.querySelectorAll(".admin-clickable-row");
            const statusLabels = {
                PENDING: "결제대기",
                PAID: "결제완료",
                PREPARING: "배송준비",
                SHIPPING: "배송중",
                DELIVERED: "배송완료",
                CANCELLED: "취소"
            };
            const managePanel = initAdminDetailManage({
                targetType: "ORDER",
                statusUrl: "/admin/orders/status",
                idParam: "order_id",
                statusBadgeId: "orderDetailStatusBadge",
                statusLabels
            });

            rows.forEach((row) => {
                row.addEventListener("click", () => {
                    if (!master.classList.contains("is-collapsed") && row.classList.contains("selected")) {
                        closeDetailPanel(master, row);
                        return;
                    }

                    openDetailPanel(master, rows, row);

                    const orderId = row.dataset.orderId;

                    fetch("/admin/orders/detail?order_id=" + encodeURIComponent(orderId))
                    .then(res => res.json())
                    .then(data => {
                        const order = data.order;
                        const statusKey = String(order.status || "").toUpperCase();
                        const statusLabel = statusLabels[statusKey] || order.status;

                        setDetailTitleBlock(
                            "orderDetailTitle",
                            "orderDetailMeta",
                            "주문 #" + (order.order_id || "-"),
                            (order.user_name || "-") + " · " + (order.login_id || "-")
                        );
                        setDetailStatusBadge("orderDetailStatusBadge", order.status, statusLabel);
                        setText("orderId", order.order_id);
                        setText("userId", order.user_id);
                        setText("userName", order.user_name);
                        setText("loginId", order.login_id);
                        setText("email", order.email);
                        setText("userPhone", order.user_phone);
                        setText("status", statusLabel);
                        setText("totalAmount", formatAdminOrderAmount(order.total_amount));
                        setText("usedPoint", formatAdminOrderAmount(order.used_point));
                        setText("paymentMethod", order.payment_method);
                        setText("paymentStatus", order.payment_status);
                        setText("paymentAmount", formatAdminOrderAmount(order.payment_amount));
                        setText("transactionId", order.transaction_id);
                        setText("recipientName", order.recipient_name);
                        setText("receiverPhone", order.receiver_phone);
                        setText("deliveryAddress", order.delivery_address);
                        setText("cancelReason", order.cancel_reason);
                        setText("cancelledAt", order.cancelled_at);
                        setText("createdAt", order.created_at);
                        setText("updatedAt", order.updated_at);
                        renderOrderItems(data.orderItemList);
                        managePanel.setTarget(order.order_id, statusKey, row);

                        document.getElementById("orderMemberLink").href =
                            "/admin/members?user_id=" + encodeURIComponent(order.user_id);
                        document.getElementById("orderMemberOrdersLink").href =
                            "/admin/orders?user_id=" + encodeURIComponent(order.user_id);
                        document.getElementById("orderPublicDetailLink").href =
                            "/order/detail?order_id=" + encodeURIComponent(order.order_id);

                        highlightAdminKeyword(document.getElementById("adminDetailPanel"));
                    })
                });
            });
        });
    </script>
</head>

<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="orders" />
        <jsp:param name="sidebarTitle" value="주문 관리" />
    </jsp:include>

    <main class="admin-main admin-main-fixed">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">ORDER MANAGEMENT</span>
                <h1>주문 관리</h1>
            </div>
        </header>

        <div class="admin-fixed-list-layout">
            <div class="admin-filter-box admin-filter-modern">
            <form class="admin-filter-form" action="/admin/orders" method="get">
                <div class="admin-filter-main-row">
                    <div class="admin-filter-tabs">
                        <a href="/admin/orders?status=all&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                            class="${status eq 'all' ? 'active' : ''}">전체</a>
                        <a href="/admin/orders?status=pending&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                            class="${status eq 'pending' ? 'active' : ''}">결제대기</a>
                        <a href="/admin/orders?status=paid&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                            class="${status eq 'paid' ? 'active' : ''}">결제완료</a>
                        <a href="/admin/orders?status=preparing&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                            class="${status eq 'preparing' ? 'active' : ''}">배송준비</a>
                        <a href="/admin/orders?status=shipping&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                            class="${status eq 'shipping' ? 'active' : ''}">배송중</a>
                        <a href="/admin/orders?status=delivered&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                            class="${status eq 'delivered' ? 'active' : ''}">배송완료</a>
                        <a href="/admin/orders?status=cancelled&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                            class="${status eq 'cancelled' ? 'active' : ''}">취소</a>
                    </div>

                    <div class="admin-search-wrap">
                        <input type="text" id="keyword" class="admin-search" name="keyword"
                            placeholder="주문번호, 주문자, 상품명, 거래번호 검색" value="${keyword}">
                        <span class="admin-search-icon" aria-hidden="true"></span>
                    </div>
                    <button type="submit" class="admin-btn admin-search-submit">검색</button>
                    <button type="button" class="admin-btn light admin-filter-toggle">상세 검색</button>
                    <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                        <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                        <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                        <option value="amount" ${sort eq 'amount' ? 'selected' : ''}>금액순</option>
                    </select>
                    <select id="pageSize" class="admin-filter-control admin-page-size-control" name="size">
                        <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                        <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                        <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                    </select>
                </div>

                <div class="admin-filter-detail-row">
                    <label class="admin-filter-field">
                        <span>주문 상태</span>
                        <select class="admin-filter-control" name="status">
                            <option value="all" ${status eq 'all' ? 'selected' : ''}>전체</option>
                            <option value="pending" ${status eq 'pending' ? 'selected' : ''}>결제대기</option>
                            <option value="paid" ${status eq 'paid' ? 'selected' : ''}>결제완료</option>
                            <option value="preparing" ${status eq 'preparing' ? 'selected' : ''}>배송준비</option>
                            <option value="shipping" ${status eq 'shipping' ? 'selected' : ''}>배송중</option>
                            <option value="delivered" ${status eq 'delivered' ? 'selected' : ''}>배송완료</option>
                            <option value="cancelled" ${status eq 'cancelled' ? 'selected' : ''}>취소</option>
                        </select>
                    </label>
                    <label class="admin-filter-field admin-filter-date-range">
                        <span>주문일 범위</span>
                        <input type="date" class="admin-filter-control" name="startDate" value="${startDate}">
                        <em>~</em>
                        <input type="date" class="admin-filter-control" name="endDate" value="${endDate}">
                    </label>
                    <label class="admin-filter-field admin-filter-date-range">
                        <span>결제금액 범위</span>
                        <input type="number" class="admin-filter-control" name="minAmount" value="${minAmount}" min="0" placeholder="최소">
                        <em>~</em>
                        <input type="number" class="admin-filter-control" name="maxAmount" value="${maxAmount}" min="0" placeholder="최대">
                    </label>
                    <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                </div>

                <c:if test="${status ne 'all' || not empty keyword || not empty user_id || not empty seller_id || not empty product_id || not empty minAmount || not empty maxAmount || not empty startDate || not empty endDate}">
                    <div class="admin-filter-applied">
                        <span class="admin-filter-applied-label">적용된 조건:</span>
                        <c:if test="${status ne 'all'}">
                            <a class="admin-filter-chip"
                                href="/admin/orders?status=all&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                상태:
                                <c:choose>
                                    <c:when test="${status eq 'pending'}">결제대기</c:when>
                                    <c:when test="${status eq 'paid'}">결제완료</c:when>
                                    <c:when test="${status eq 'preparing'}">배송준비</c:when>
                                    <c:when test="${status eq 'shipping'}">배송중</c:when>
                                    <c:when test="${status eq 'delivered'}">배송완료</c:when>
                                    <c:when test="${status eq 'cancelled'}">취소</c:when>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty keyword}">
                            <a class="admin-filter-chip"
                                href="/admin/orders?status=${status}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                검색어: ${keyword}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty user_id}">
                            <a class="admin-filter-chip"
                                href="/admin/orders?status=${status}&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                회원:
                                <c:choose>
                                    <c:when test="${not empty filterUser}">
                                        ${filterUser.name} · ${filterUser.login_id}
                                    </c:when>
                                    <c:otherwise>${user_id}</c:otherwise>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty seller_id}">
                            <a class="admin-filter-chip"
                                href="/admin/orders?status=${status}&keyword=${keyword}&user_id=${user_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                판매자:
                                <c:choose>
                                    <c:when test="${not empty filterSeller}">
                                        ${filterSeller.company_name} · ${filterSeller.representative_name}
                                    </c:when>
                                    <c:otherwise>${seller_id}</c:otherwise>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty product_id}">
                            <a class="admin-filter-chip"
                                href="/admin/orders?status=${status}&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                상품:
                                <c:choose>
                                    <c:when test="${not empty filterProduct}">
                                        ${filterProduct.name}
                                    </c:when>
                                    <c:otherwise>${product_id}</c:otherwise>
                                </c:choose>
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty minAmount || not empty maxAmount}">
                            <a class="admin-filter-chip"
                                href="/admin/orders?status=${status}&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                결제금액: ${minAmount} ~ ${maxAmount}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty startDate || not empty endDate}">
                            <a class="admin-filter-chip"
                                href="/admin/orders?status=${status}&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&sort=${sort}&size=${pagination.size}&page=1">
                                주문일: ${startDate} ~ ${endDate}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <a class="admin-filter-clear" href="/admin/orders">전체 해제</a>
                    </div>
                </c:if>

                <input type="hidden" name="user_id" value="${user_id}">
                <input type="hidden" name="seller_id" value="${seller_id}">
                <input type="hidden" name="product_id" value="${product_id}">
                <input type="hidden" name="page" value="1">
            </form>
        </div>

        <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>주문번호</th>
                            <th>주문 상품</th>
                            <th>주문자</th>
                            <th>결제금액</th>
                            <th>주문상태</th>
                            <th>결제상태</th>
                            <th>주문일</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="order" items="${orderList}">
                            <tr class="admin-clickable-row" data-order-id="${order.order_id}">
                                <td>${order.order_id}</td>
                                <td class="left admin-highlight-target"><strong>${order.order_name}</strong></td>
                                <td class="admin-highlight-target">${order.user_name}</td>
                                <td><fmt:formatNumber value="${order.total_amount}" pattern="#,###" />원</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status eq 'PENDING'}">
                                            <span class="admin-status pending">결제대기</span>
                                        </c:when>
                                        <c:when test="${order.status eq 'PAID'}">
                                            <span class="admin-status paid">결제완료</span>
                                        </c:when>
                                        <c:when test="${order.status eq 'PREPARING'}">
                                            <span class="admin-status warning">배송준비</span>
                                        </c:when>
                                        <c:when test="${order.status eq 'SHIPPING'}">
                                            <span class="admin-status shipping">배송중</span>
                                        </c:when>
                                        <c:when test="${order.status eq 'DELIVERED'}">
                                            <span class="admin-status done">배송완료</span>
                                        </c:when>
                                        <c:when test="${order.status eq 'CANCELLED'}">
                                            <span class="admin-status cancelled">취소</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>${order.payment_status}</td>
                                <td>${order.created_at}</td>
                                <td class="admin-table-actions">
                                    <button type="button" class="admin-btn light">상세</button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <aside class="admin-card admin-detail-panel" id="adminDetailPanel">
                <div class="admin-detail-panel-inner">
                    <div class="admin-detail-content">
                        <div class="admin-detail-head">
                                        <div class="admin-detail-head-main">
                                            <div class="admin-detail-title-block">
                                                <div class="admin-detail-title-line">
                                                    <h2 id="orderDetailTitle">주문 상세</h2>
                                                    <span class="admin-detail-status-badge" id="orderDetailStatusBadge">-</span>
                                                </div>
                                                <p id="orderDetailMeta">목록에서 주문을 선택하세요.</p>
                                            </div>
                                            <div class="admin-detail-toolbar">
                                                <button type="button" class="admin-detail-close"
                                                    aria-label="닫기">&times;</button>
                                            </div>
                                        </div>
                                        <div class="admin-detail-tabs">
                                            <button type="button" class="admin-detail-tab active" data-detail-tab="info">
                                                정보
                                            </button>
                                            <button type="button" class="admin-detail-tab" data-detail-tab="manage">
                                                관리
                                            </button>
                                        </div>
                                    </div>
                        <div class="admin-detail-tab-body">
                                        <div class="admin-detail-tab-panel active" data-detail-panel="info">
                                            <div class="admin-detail-info-scroll">
                                                <dl class="admin-detail-grid">
                            <div>
                                <dt>주문번호</dt>
                                <dd id="orderId">-</dd>
                            </div>
                            <div>
                                <dt>회원번호</dt>
                                <dd id="userId">-</dd>
                            </div>
                            <div>
                                <dt>주문자</dt>
                                <dd id="userName" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>아이디</dt>
                                <dd id="loginId" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>이메일</dt>
                                <dd id="email" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>연락처</dt>
                                <dd id="userPhone">-</dd>
                            </div>
                            <div>
                                <dt>주문 상태</dt>
                                <dd id="status">-</dd>
                            </div>
                            <div>
                                <dt>총 결제 금액</dt>
                                <dd id="totalAmount">-</dd>
                            </div>
                            <div>
                                <dt>사용 포인트</dt>
                                <dd id="usedPoint">-</dd>
                            </div>
                            <div>
                                <dt>결제 수단</dt>
                                <dd id="paymentMethod">-</dd>
                            </div>
                            <div>
                                <dt>결제 상태</dt>
                                <dd id="paymentStatus">-</dd>
                            </div>
                            <div>
                                <dt>결제 금액</dt>
                                <dd id="paymentAmount">-</dd>
                            </div>
                            <div>
                                <dt>거래번호</dt>
                                <dd id="transactionId">-</dd>
                            </div>
                            <div>
                                <dt>수령인</dt>
                                <dd id="recipientName">-</dd>
                            </div>
                            <div>
                                <dt>수령인 연락처</dt>
                                <dd id="receiverPhone">-</dd>
                            </div>
                            <div>
                                <dt>배송지</dt>
                                <dd id="deliveryAddress">-</dd>
                            </div>
                            <div>
                                <dt>취소 사유</dt>
                                <dd id="cancelReason">-</dd>
                            </div>
                            <div>
                                <dt>취소일</dt>
                                <dd id="cancelledAt">-</dd>
                            </div>
                            <div>
                                <dt>주문일</dt>
                                <dd id="createdAt">-</dd>
                            </div>
                            <div>
                                <dt>수정일</dt>
                                <dd id="updatedAt">-</dd>
                            </div>
                            <div>
                                <dt>주문 상품</dt>
                                <dd id="orderItems">-</dd>
                            </div>
                        </dl>
                                            </div>
                                        </div>
                                        <div class="admin-detail-tab-panel" data-detail-panel="manage">
                                            <div class="admin-detail-manage">
                                                <div class="admin-detail-manage-section admin-detail-status-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>상태 관리</h3>
                                                    </div>
                                                    <div class="admin-detail-setting-row">
                                                        <label class="admin-detail-control">
                                                            <span>주문 상태</span>
                                                            <select class="admin-filter-control admin-detail-status-control">
                                                            <option value="PENDING">결제대기</option>
                                                            <option value="PAID">결제완료</option>
                                                            <option value="PREPARING">배송준비</option>
                                                            <option value="SHIPPING">배송중</option>
                                                            <option value="DELIVERED">배송완료</option>
                                                            <option value="CANCELLED">취소</option>
                                                            </select>
                                                        </label>
                                                    </div>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light">변경 취소</button>
                                                        <button type="button" class="admin-btn admin-detail-status-change">상태 변경</button>
                                                    </div>
                                                </div>

                                                <div class="admin-detail-manage-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>관리 메모</h3>
                                                    </div>
                                                    <textarea class="admin-detail-memo" rows="5"
                                                        placeholder="관리 중 필요한 메모를 입력하세요."></textarea>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light">메모 저장</button>
                                                    </div>
                                                </div>

                                                <div class="admin-detail-manage-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>바로가기</h3>
                                                    </div>
                                                    <div class="admin-detail-link-list">
                                                        <a href="#" id="orderMemberLink">
                                                            <span>회원 관리</span>
                                                        </a>
                                                        <a href="#" id="orderMemberOrdersLink">
                                                            <span>회원 주문</span>
                                                        </a>
                                                        <a href="#" id="orderPublicDetailLink">
                                                            <span>주문 상세</span>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                    </div>
                </div>
            </aside>
        </section>

        <div class="admin-pagination">
            <div class="admin-pagination-pages">
                <c:if test="${pagination.totalPage > 0}">
                    <c:if test="${pagination.hasPrev}">
                        <a href="/admin/orders?status=${status}&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                            이전
                        </a>
                    </c:if>
                    <c:if test="${!pagination.hasPrev}">
                        <span class="disabled">이전</span>
                    </c:if>

                    <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                        <a href="/admin/orders?status=${status}&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                            class="${pagination.page == i ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${pagination.hasNext}">
                        <a href="/admin/orders?status=${status}&keyword=${keyword}&user_id=${user_id}&seller_id=${seller_id}&product_id=${product_id}&minAmount=${minAmount}&maxAmount=${maxAmount}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
                            다음
                        </a>
                    </c:if>
                    <c:if test="${!pagination.hasNext}">
                        <span class="disabled">다음</span>
                    </c:if>
                </c:if>
            </div>
            <span class="admin-filter-count">전체 ${totalCount}건</span>
        </div>
            </div>
    </main>
</div>
</body>

</html>
