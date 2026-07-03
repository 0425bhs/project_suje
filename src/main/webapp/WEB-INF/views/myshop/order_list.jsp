<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 회원 요약 카드 -->
<jsp:include page="/WEB-INF/views/myshop/common/myshop_user_card.jsp">
    <jsp:param name="label" value="MY ORDER" />
    <jsp:param name="count" value="${totalCount}" />
</jsp:include>

<!-- 빠른 메뉴 -->
<jsp:include page="/WEB-INF/views/myshop/common/myshop_quick_card.jsp" />

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

    <!-- <button type="button"
            class="${selectedStatus eq 'PREPARING' ? 'active' : ''}"
            onclick="location.href='/myshop/orders?status=PREPARING'">
        <span>제작준비</span>
        <strong>${preparingCount}</strong>
    </button> -->

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
        <span>주문취소</span>
        <strong>${cancelCount}</strong>
    </button>

</section>

<!-- 주문/배송내역 -->
<section class="myshop-order-section">

    <div class="myshop-section-head">
        <div>
            <h2>주문/배송내역</h2>
            <p>주문한 작품의 결제 상태와 배송 상태를 확인할 수 있습니다.</p>
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
            <div class="myshop-order">

                <c:forEach var="order" items="${orderList}">

                    <c:set var="items" value="${orderItemMap[order.order_id]}" />
                    <c:set var="mainItem" value="${items[0]}" />
                    <c:set var="itemCount" value="${fn:length(items)}" />

                    <article class="myshop-order-card">

                        <div class="myshop-order-top">

                            <div>
                                <strong class="myshop-status-badge ${order.status}">
                                    <c:choose>
                                        <c:when test="${order.status eq 'PENDING'}">결제 대기</c:when>
                                        <c:when test="${order.status eq 'PAID'}">결제 완료</c:when>
                                        <c:when test="${order.status eq 'PREPARING'}">제작 준비중</c:when>
                                        <c:when test="${order.status eq 'SHIPPING'}">배송중</c:when>
                                        <c:when test="${order.status eq 'DELIVERED'}">배송 완료</c:when>
                                        <c:when test="${order.status eq 'CANCELLED'}">주문 취소</c:when>
                                        <c:otherwise>${order.status}</c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>

                            <a href="/order/detail?order_id=${order.order_id}">
                                주문상세 &gt;
                            </a>

                        </div>

                        <div class="myshop-order-body">

                            <div class="myshop-product-thumb">
                                <c:choose>
                                    <c:when test="${not empty mainItem and not empty mainItem.imageL and mainItem.imageL ne 'no_file'}">
                                        <img src="/upload/${mainItem.imageL}"
                                             alt="${mainItem.productName}">
                                    </c:when>

                                    <c:otherwise>
                                        <img src="/images/no_image.png" alt="이미지 없음">
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="myshop-product-info">

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
                                    <c:when test="${itemCount eq 1}">
                                        <strong class="myshop-product-name-text">
                                            ${mainItem.productName}
                                        </strong>

                                        <c:if test="${not empty mainItem.option_name}">
                                            <span class="myshop-order-option-text">
                                                옵션 : ${mainItem.option_name}

                                                <c:if test="${mainItem.option_price gt 0}">
                                                    (+
                                                    <fmt:formatNumber value="${mainItem.option_price}" pattern="#,###" />원)
                                                </c:if>
                                            </span>
                                        </c:if>
                                    </c:when>

                                    <c:otherwise>
                                        <button type="button"
                                                class="myshop-product-name-text myshop-product-open-btn"
                                                onclick="toggleOrderItems(this.closest('.myshop-order-card').querySelector('.myshop-order-toggle'))">
                                            ${mainItem.productName}

                                            <span class="myshop-product-count-text">
                                                포함 총 ${itemCount}건
                                            </span>
                                        </button>
                                    </c:otherwise>
                                </c:choose>

                                <strong>
                                    총 결제금액
                                    <fmt:formatNumber value="${order.total_amount}" pattern="#,###" />원
                                </strong>
                            </div>

                            <div class="myshop-order-actions">

                                <c:if test="${order.status eq 'PENDING' and order.total_amount > 0}">
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

                                <c:if test="${order.status eq 'PAID'}">
                                    <button type="button"
                                            onclick="openCancelModal('${order.order_id}', '${order.total_amount}')">
                                        결제취소
                                    </button>
                                </c:if>

                                <c:if test="${order.status eq 'PAID' or order.status eq 'PREPARING' or order.status eq 'SHIPPING' or order.status eq 'DELIVERED'}">
                                    <a href="/order/delivery?order_id=${order.order_id}">
                                        배송조회
                                    </a>
                                </c:if>

                                <c:if test="${itemCount eq 1 and order.status eq 'DELIVERED' and empty mainItem.confirmed_at}">

                                    <button type="button"
                                            class="refund"
                                            onclick="openCsModal('${mainItem.order_item_id}', '${mainItem.subtotalAmount}')">
                                    반품/교환
                                    </button>

                                    <form action="/order_confirm.do" method="post" class="inline-form">
                                        <input type="hidden" name="order_item_id" value="${mainItem.order_item_id}">

                                        <button type="submit"
                                                class="primary"
                                                onclick="return confirm('구매확정 처리하시겠습니까?');">
                                            구매확정
                                        </button>
                                    </form>

                                </c:if>

                                <c:if test="${itemCount eq 1 and not empty mainItem.confirmed_at}">
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

                            </div>

                        </div>

                        <c:if test="${itemCount ne 1}">

                            <button type="button"
                                    class="myshop-order-toggle"
                                    data-count="${itemCount}"
                                    onclick="toggleOrderItems(this)">
                                <span class="toggle-text">총 ${itemCount}건 주문 펼쳐보기</span>
                                <span class="toggle-arrow"></span>
                            </button>

                            <div class="myshop-order-items-panel">

                                <c:forEach var="item" items="${items}">

                                    <div class="myshop-order-item-row">

                                        <a class="myshop-order-item-thumb"
                                           href="/product_detail.do?product_id=${item.product_id}">
                                            <c:choose>
                                                <c:when test="${not empty item.imageL and item.imageL ne 'no_file'}">
                                                    <img src="/upload/${item.imageL}"
                                                         alt="${item.productName}">
                                                </c:when>

                                                <c:otherwise>
                                                    <img src="/images/no_image.png" alt="이미지 없음">
                                                </c:otherwise>
                                            </c:choose>
                                        </a>

                                        <div class="myshop-order-item-info">

                                            <a href="/product_detail.do?product_id=${item.product_id}">
                                                ${item.productName}
                                            </a>

                                            <c:if test="${not empty item.option_name}">
                                                <p class="myshop-order-option-text">
                                                    옵션 : ${item.option_name}

                                                    <c:if test="${item.option_price gt 0}">
                                                        (+
                                                        <fmt:formatNumber value="${item.option_price}" pattern="#,###" />원)
                                                    </c:if>
                                                </p>
                                            </c:if>

                                            <p>
                                                수량 ${item.quantity}개 ·
                                                <fmt:formatNumber value="${item.subtotalAmount}" pattern="#,###" />원
                                            </p>
                                        </div>

                                        <div class="myshop-order-item-actions">

                                            <c:if test="${order.status eq 'DELIVERED' and empty item.confirmed_at}">

                                                <button type="button"
                                                        class="myshop-order-action-btn cart"
                                                        onclick="cartInsert('${item.product_id}', 1, '${item.option_id}')">
                                                    장바구니 담기
                                                </button>

                                                <c:choose>
                                                    <c:when test="${not empty item.option_id}">
                                                        <button type="button"
                                                                class="myshop-order-action-btn buy"
                                                                onclick="location.href='/order/form?product_id=${item.product_id}&quantity=1&option_id=${item.option_id}'">
                                                            바로 구매하기
                                                        </button>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <button type="button"
                                                                class="myshop-order-action-btn buy"
                                                                onclick="location.href='/order/form?product_id=${item.product_id}&quantity=1'">
                                                            바로 구매하기
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>

                                                <button type="button"
                                                        class="myshop-order-action-btn refund"
                                                        onclick="openCsModal('${item.order_item_id}', '${item.subtotalAmount}')">
                                                반품/교환
                                                </button>

                                                <form action="/order_confirm.do" method="post" class="inline-form">
                                                    <input type="hidden" name="order_item_id" value="${item.order_item_id}">

                                                    <button type="submit"
                                                            class="myshop-order-action-btn confirm"
                                                            onclick="return confirm('구매확정 처리하시겠습니까?');">
                                                        구매확정
                                                    </button>
                                                </form>

                                            </c:if>

                                            <c:if test="${not empty item.confirmed_at}">
                                                <button type="button"
                                                        class="myshop-order-action-btn review"
                                                        onclick="location.href='/review_form.do?order_item_id=${item.order_item_id}'">
                                                    리뷰쓰기
                                                </button>
                                            </c:if>

                                            <button type="button"
                                                    class="myshop-order-action-btn qna"
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

<!-- 결제취소 모달 -->
<div class="cancel-modal-wrap" id="cancelModal">

    <div class="cancel-modal-bg" onclick="closeCancelModal()"></div>

    <div class="cancel-modal-box">

        <div class="cancel-modal-head">
            <div>
                <span>PAYMENT CANCEL</span>
                <h3>결제취소 요청</h3>
                <p>취소 사유와 안내사항을 확인해주세요.</p>
            </div>

            <button type="button" class="cancel-modal-close" onclick="closeCancelModal()">
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

                <textarea id="cancelDetail" placeholder="상세 사유를 입력해주세요. 선택 입력입니다."></textarea>
            </div>

            <div class="cancel-guide-box">
                <strong>결제취소 안내</strong>

                <ul>
                    <li>결제취소가 완료되면 주문 상태가 <b>주문 취소</b>로 변경됩니다.</li>
                    <li>반품은 결제 수단과 카드사 정책에 따라 처리 시간이 다를 수 있습니다.</li>
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

            <button type="button" class="cancel-close-btn" onclick="closeCancelModal()">
                닫기
            </button>

            <form action="/payment/toss/cancel" method="post" id="cancelForm">
                <input type="hidden" name="order_id" id="cancelOrderId">
                <input type="hidden" name="cancel_reason" id="cancelReasonInput">

                <button type="button" class="cancel-submit-btn" onclick="submitCancelForm()">
                    결제취소 요청
                </button>
            </form>

        </div>

    </div>

</div>

<!-- 교환/반품 모달 -->
<div class="cs-modal-wrap" id="csModal">

    <div class="cs-modal-bg" onclick="closeCsModal()"></div>

    <div class="cs-modal-box">

        <div class="cs-modal-head">
            <div>
                <span>EXCHANGE/REFUND</span>
                <h3>반품/교환 신청</h3>
                <p>사유와 안내사항을 확인해주세요.</p>
            </div>

            <button type="button" class="cs-modal-close" onclick="closeCsModal()">
                ×
            </button>
        </div>

        <div class="cs-modal-body">

            <h3>반품/교환</h3>

            <div class="cs-type-select">
                <input type="radio" name="sel" id="RETURN" onchange="toggleForm()">
                <label for="RETURN">반품</label>

                <input type="radio" name="sel" id="EXCHANGE" onchange="toggleForm()" checked>
                <label for="EXCHANGE">교환</label>
            </div>

            <form id="exchangeForm">
                <div id="exchangeDiv">

                    <input type="hidden" value="EXCHANGE_REQUEST" name="status"/>

                    <div class="cs-info-row">
                        <span>주문상품번호</span>
                        <input id="exchangeOrderIdText"
                               name="order_item_id"
                               readonly="readonly"/>
                    </div>

                    <div class="exchange-info-row">
                        <span>결제금액</span>
                        <input id="exchangePrice" readonly="readonly"/>
                    </div>

                    <div class="exchange-form-row">
                        <label for="exchangeReason">교환 사유</label>

                        <select id="exchangeReason" name="reason">
                            <option value="">교환 사유를 선택해주세요</option>
                            <option value="단순 변심">단순 변심</option>
                            <option value="잘못된 상품 배송">잘못된 상품 배송</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>

                    <div class="exchange-form-row">
                        <label for="exchangeDetail">상세 사유</label>

                        <textarea id="exchangeDetail"
                                  name="detail_reason"
                                  placeholder="상세 사유를 입력해주세요. 선택 입력입니다."></textarea>
                    </div>

                    <div class="exchange-guide-box">
                        <strong>교환 안내</strong>

                        <ul>
                            <li>교환 신청 후 판매자 확인이 진행됩니다.</li>
                            <li>이미 제작 또는 배송이 시작된 주문은 교환이 제한될 수 있습니다.</li>
                        </ul>
                    </div>

                    <label class="exchange-agree">
                        <input type="checkbox" id="exchangeAgree">
                        교환신청 안내사항을 확인했습니다.
                    </label>

                    <div class="cs-modal-actions">

                        <button type="button" class="cs-close-btn" onclick="closeCsModal()">
                            닫기
                        </button>

                        <button type="button" class="exchange-submit-btn" onclick="submitExchangeForm(this.form)">
                            교환신청
                        </button>

                    </div>

                </div>
            </form>

            <form id="returnForm">
                <div id="returnDiv">

                    <input type="hidden" value="RETURN_REQUEST" name="status"/>

                    <div class="cs-info-row">
                        <span>주문상품번호</span>
                        <input id="returnOrderIdText"
                               name="order_item_id"
                               readonly="readonly"/>
                    </div>

                    <div class="return-info-row">
                        <span>결제금액</span>
                        <input id="returnPrice" readonly="readonly"/>
                    </div>

                    <div class="return-form-row">
                        <label for="returnReason">반품 사유</label>

                        <select id="returnReason" name="reason">
                            <option value="">반품 사유를 선택해주세요</option>
                            <option value="단순 변심">단순 변심</option>
                            <option value="배송 지연">배송 지연</option>
                            <option value="상품 불량">상품 불량</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>

                    <div class="cs-form-row">
                        <label for="returnDetail">상세 사유</label>

                        <textarea id="returnDetail"
                                  name="detail_reason"
                                  placeholder="상세 사유를 입력해주세요. 선택 입력입니다."></textarea>
                    </div>

                    <div class="return-guide-box">
                        <strong>반품 안내</strong>

                        <ul>
                            <li>이미 제작 또는 배송이 시작된 주문은 반품이 제한될 수 있습니다.</li>
                            <li>반품된 상품 검수 후 <b>반품</b>이 진행됩니다.</li>
                            <li>반품은 결제 수단과 카드사 정책에 따라 처리 시간이 다를 수 있습니다.</li>
                        </ul>
                    </div>

                    <label class="return-agree">
                        <input type="checkbox" id="returnAgree">
                    반품신청 안내사항을 확인했습니다.
                    </label>

                    <div class="return-modal-actions">

                        <button type="button" class="cs-close-btn" onclick="closeCsModal()">
                            닫기
                        </button>

                        <button type="button" class="cs-submit-btn" onclick="submitReturnForm(this.form)">
                            반품신청
                        </button>

                    </div>

                </div>
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