<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>마이쇼핑</title>

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/order-payment.css?v=3">

        <script src="/js/product_main.js" defer></script>
        <script src="/js/order-payment.js" defer></script>
    </head>

    <body>

        <jsp:include page="/WEB-INF/views/product/product_header.jsp">
            <jsp:param name="activeMenu" value="order" />
        </jsp:include>

        <!-- 중요: 주문 상태별 개수 계산 -->
        <c:set var="totalCount" value="0" />
        <c:set var="pendingCount" value="0" />
        <c:set var="paidCount" value="0" />
        <c:set var="preparingCount" value="0" />
        <c:set var="shippingCount" value="0" />
        <c:set var="deliveredCount" value="0" />
        <c:set var="cancelCount" value="0" />

        <c:forEach var="order" items="${allOrderList}">
            <c:set var="totalCount" value="${totalCount + 1}" />

            <c:if test="${order.status eq 'PENDING'}">
                <c:set var="pendingCount" value="${pendingCount + 1}" />
            </c:if>

            <c:if test="${order.status eq 'PAID'}">
                <c:set var="paidCount" value="${paidCount + 1}" />
            </c:if>

            <c:if test="${order.status eq 'PREPARING'}">
                <c:set var="preparingCount" value="${preparingCount + 1}" />
            </c:if>

            <c:if test="${order.status eq 'SHIPPING'}">
                <c:set var="shippingCount" value="${shippingCount + 1}" />
            </c:if>

            <c:if test="${order.status eq 'DELIVERED'}">
                <c:set var="deliveredCount" value="${deliveredCount + 1}" />
            </c:if>

            <c:if test="${order.status eq 'CANCELLED'}">
                <c:set var="cancelCount" value="${cancelCount + 1}" />
            </c:if>
        </c:forEach>

        <section class="myshop-page">

            <div class="myshop-layout">

                <!-- 왼쪽 사이드바 -->
                <jsp:include page="/WEB-INF/views/order/common/myshop_sidebar.jsp" />

                <!-- 오른쪽 본문 -->
                <main class="myshop-content">

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
                                onclick="location.href='/order/my'">
                            <span>전체</span>
                            <strong>${totalCount}</strong>
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'PENDING' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=PENDING'">
                            <span>결제대기</span>
                            <strong>${pendingCount}</strong>
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'PAID' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=PAID'">
                            <span>결제완료</span>
                            <strong>${paidCount}</strong>
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'PREPARING' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=PREPARING'">
                            <span>제작 준비중</span>
                            <strong>${preparingCount}</strong>
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'SHIPPING' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=SHIPPING'">
                            <span>배송중</span>
                            <strong>${shippingCount}</strong>
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'DELIVERED' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=DELIVERED'">
                            <span>배송완료</span>
                            <strong>${deliveredCount}</strong>
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'CANCELLED' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=CANCELLED'">
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

                            <a href="/order/my">전체보기</a>
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

    <!-- 추가: 주문 1건 안에 들어있는 상품 개수 계산 -->
    <!-- 이유: 상품이 1개면 기존처럼 보이고, 여러 개면 펼쳐보기 버튼을 보여주기 위해서 -->
    <c:set var="itemCount" value="${fn:length(items)}" />

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

            <!-- 추가: 여러 상품 주문이면 대표 이미지에 개수 표시 -->
            <!-- 이유: 대표 이미지 하나만 보여도 여러 상품 주문이라는 걸 알 수 있게 하기 위해서 -->
            <c:if test="${itemCount gt 1}">
                <span class="myshop-thumb-count">${itemCount}</span>
            </c:if>
        </div>

        <div class="myshop-product-info">
            <c:choose>
                <c:when test="${not empty mainItem}">

                    <!-- 변경: 상품명을 클릭하면 상품 상세페이지로 이동 -->
                    <!-- 이유: 구매자가 주문 목록에서 바로 상품 상세를 볼 수 있게 하기 위해서 -->
                    <a class="myshop-product-name-link"
                       href="/product_detail.do?product_id=${mainItem.product_id}">
                        ${mainItem.productName}

                        <!-- 변경: 여러 상품 주문이면 전체 주문 상품 수 표시 -->
                        <!-- 이유: 사진처럼 이 주문에 총 몇 개 상품이 있는지 보여주기 위해서 -->
                        <c:if test="${itemCount gt 1}">
                            포함 총 ${itemCount}건
                        </c:if>
                    </a>

                    <p>
                        대표상품 수량 ${mainItem.quantity}개 ·
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

            <!-- 유지: 결제대기 상태에서는 구매자가 결제 진행 가능 -->
            <!-- 이유: 아직 결제 전이라 판매자 제작 단계에 들어가지 않았기 때문 -->
            <c:if test="${order.status eq 'PENDING'}">
                <a href="/payment/ready?order_id=${order.order_id}" class="primary">
                    결제하기
                </a>

                <!-- 유지: 결제 전 주문은 구매자가 주문취소 가능 -->
                <!-- 이유: 결제 완료 전이므로 제작/배송 상태 변경과는 다른 구매자 기능이기 때문 -->
                <form action="/order/cancel" method="post" class="inline-form">
                    <input type="hidden" name="order_id" value="${order.order_id}">

                    <button type="submit"
                            onclick="return confirm('주문을 취소하시겠습니까?');">
                        주문취소
                    </button>
                </form>
            </c:if>

            <!-- 변경: 결제취소는 PAID 상태에서만 표시 -->
            <!-- 이유: 결제완료 후 제작 준비중으로 넘어가기 전까지만 구매자가 취소할 수 있게 하기 위해서 -->
            <c:if test="${order.status eq 'PAID'}">
                <button type="button"
                        onclick="openCancelModal('${order.order_id}', '${order.total_amount}')">
                    결제취소
                </button>
            </c:if>

            <!-- 변경: 배송조회는 제작 준비중 이후부터 표시 -->
            <!-- 이유: PAID 상태는 아직 배송 조회할 단계가 아니고, PREPARING부터 배송 흐름에 들어가기 때문 -->
            <c:if test="${order.status eq 'PREPARING' || order.status eq 'SHIPPING' || order.status eq 'DELIVERED'}">
                <a href="/order/delivery?order_id=${order.order_id}">
                    배송조회
                </a>
            </c:if>

            <!-- 유지: 배송완료 상태에서만 리뷰쓰기 표시 -->
            <!-- 이유: 상품을 받은 후에 리뷰를 작성하는 흐름이 자연스럽기 때문 -->
            <c:if test="${order.status eq 'DELIVERED'}">
                <button type="button"
                        class="review"
                        onclick="alert('리뷰 작성 기능은 준비중입니다.');">
                    리뷰쓰기
                </button>
            </c:if>

            <!-- 유지: 문의하기는 상태 변경 기능이 아니라 구매자 문의 기능 -->
            <button type="button"
                    class="qna"
                    onclick="alert('문의 기능은 준비중입니다.');">
                문의하기
            </button>

        </div>

    </div>

    <!-- 추가: 여러 상품 주문일 때만 펼쳐보기 버튼 표시 -->
    <!-- 이유: 상품이 1개일 때는 기존 디자인 그대로 두고, 여러 개일 때만 주문 목록을 펼치기 위해서 -->
    <c:if test="${itemCount gt 1}">

        <button type="button"
                class="myshop-order-toggle"
                data-count="${itemCount}"
                onclick="toggleOrderItems(this)">
            <span class="toggle-text">총 ${itemCount}건 주문 펼쳐보기</span>
            <span class="toggle-arrow"></span>
        </button>

        <!-- 추가: 펼쳐보기 버튼 클릭 시 보일 주문 상품 목록 -->
        <!-- 이유: 한 주문 안에 들어있는 모든 상품을 확인할 수 있게 하기 위해서 -->
        <div class="myshop-order-items-panel">

            <c:forEach var="item" items="${items}">

                <div class="myshop-order-item-row">

                    <!-- 추가: 펼친 목록의 상품 이미지 클릭 시 상품 상세 이동 -->
                    <a class="myshop-order-item-thumb"
                       href="/product_detail.do?product_id=${item.product_id}">
                        <c:choose>
                            <c:when test="${not empty item.imageS and item.imageS ne 'no_file'}">
                                <img src="${item.imageS}" alt="${item.productName}">
                            </c:when>

                            <c:otherwise>
                                <img src="/images/no_image.png" alt="이미지 없음">
                            </c:otherwise>
                        </c:choose>
                    </a>

                    <div class="myshop-order-item-info">

                        <!-- 추가: 펼친 목록의 각 상품명 클릭 시 상품 상세 이동 -->
                        <!-- 이유: 여러 상품 중 원하는 상품 상세페이지로 바로 넘어가기 위해서 -->
                        <a href="/product_detail.do?product_id=${item.product_id}">
                            ${item.productName}
                        </a>

                        <p>
                            수량 ${item.quantity}개 ·
                            <fmt:formatNumber value="${item.price}" pattern="#,###"/>원
                        </p>

                    </div>

                    <div class="myshop-order-item-actions">

                        <!-- 추가: 펼친 상품별 상세보기 버튼 -->
                        <a href="/product_detail.do?product_id=${item.product_id}">
                            상세보기
                        </a>

                        <!-- 추가: 펼친 상품별 문의 버튼 -->
                        <!-- 이유: 구매자 페이지에서는 상태 변경이 아니라 문의 정도만 가능하게 하기 위해서 -->
                        <button type="button"
                                onclick="alert('문의 기능은 준비중입니다.');">
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

                </main>

            </div>

        </section>

        <!-- 중요: 결제취소 모달 -->
        <div class="cancel-modal-wrap" id="cancelModal">

            <div class="cancel-modal-bg" onclick="closeCancelModal()"></div>

            <div class="cancel-modal-box">

                <div class="cancel-modal-head">
                    <div>
                        <span>PAYMENT CANCEL</span>
                        <h3>결제취소 요청</h3>
                        <p>취소 사유와 안내사항을 확인해주세요.</p>
                    </div>

                    <button type="button"
                            class="cancel-modal-close"
                            onclick="closeCancelModal()">
                        ×
                    </button>
                </div>

                <div class="cancel-modal-body">

                    <div class="cancel-info-row">
                        <span>주문번호</span>
                        <strong id="cancelOrderIdText">#</strong>
                    </div>

                    <div class="cancel-info-row">
                        <span>결제금액</span>
                        <strong id="cancelAmountText">0원</strong>
                    </div>

                    <div class="cancel-form-row">
                        <label for="cancelReason">취소 사유</label>

                        <select id="cancelReason">
                            <option value="">취소 사유를 선택해주세요</option>
                            <option value="단순 변심">단순 변심</option>
                            <option value="상품을 잘못 주문함">상품을 잘못 주문함</option>
                            <option value="배송 일정 변경">배송 일정 변경</option>
                            <option value="다른 상품으로 재주문 예정">다른 상품으로 재주문 예정</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>

                    <div class="cancel-form-row">
                        <label for="cancelDetail">상세 사유</label>

                        <textarea id="cancelDetail"
                                placeholder="상세 사유를 입력해주세요. 선택 입력입니다."></textarea>
                    </div>

                    <div class="cancel-guide-box">
                        <strong>결제취소 안내</strong>

                        <ul>
                            <li>결제취소가 완료되면 주문 상태가 <b>주문 취소</b>로 변경됩니다.</li>
                            <li>환불은 결제 수단과 카드사 정책에 따라 처리 시간이 다를 수 있습니다.</li>
                            <li>이미 제작 또는 배송이 시작된 주문은 취소가 제한될 수 있습니다.</li>
                            <li>취소 요청 후에는 동일 주문으로 다시 결제할 수 없습니다.</li>
                        </ul>
                    </div>

                    <label class="cancel-agree">
                        <input type="checkbox" id="cancelAgree">
                        결제취소 안내사항을 확인했습니다.
                    </label>

                </div>

                <div class="cancel-modal-actions">

                    <button type="button"
                            class="cancel-close-btn"
                            onclick="closeCancelModal()">
                        닫기
                    </button>

                    <form action="/payment/toss/cancel" method="post" id="cancelForm">
                        <input type="hidden" name="order_id" id="cancelOrderId">
                        <input type="hidden" name="cancel_reason" id="cancelReasonInput">

                        <button type="button"
                                class="cancel-submit-btn"
                                onclick="submitCancelForm()">
                            결제취소 요청
                        </button>
                    </form>

                </div>

            </div>

        </div>

        <footer class="site-footer">
            <div class="footer-inner">
                <strong>HANDMADE</strong>
                <p>주문한 상품의 결제 상태와 배송 상태를 확인할 수 있습니다.</p>
            </div>
        </footer>

    </body>

</html>