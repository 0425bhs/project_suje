<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <title>결제 진행</title>

                    <link rel="stylesheet" href="/css/product/product_main.css">
                    <link rel="stylesheet" href="/css/order-payment.css?v=3">

                    <script src="/js/product_main.js" defer></script>

                    <!-- Toss Payments SDK -->
                    <script src="https://js.tosspayments.com/v1/payment"></script>

                </head>

                <body>

                    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
                        <jsp:param name="activeMenu" value="order" />
                    </jsp:include>

                    <section class="page-block soft">

                        <div class="block-inner">

                            <div class="page-title-row">
                                <div>
                                    <span>PAYMENT</span>
                                    <h2>결제를 준비하고 있습니다</h2>
                                </div>

                                <p>잠시 후 결제창이 자동으로 열립니다.</p>
                            </div>

                            <div class="order-layout">

                                <!-- 왼쪽 주문 상품 -->
                                <section class="panel">

                                    <h3 class="panel-title">주문 상품</h3>

                                    <c:forEach var="item" items="${orderItemList}">
                                        <div class="order-item">

                                            <c:choose>
                                                <c:when test="${not empty item.imageL and item.imageL ne 'no_file'}">
                                                    <img src="/upload/${item.imageL}" alt="${item.productName}">
                                                </c:when>

                                                <c:otherwise>
                                                    <img src="/images/no_image.png" alt="이미지 없음">
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="item-info">
                                                <div class="creator-line">작가 상품</div>

                                                <strong>${item.productName}</strong>

                                                <c:if test="${not empty item.option_name}">
                                                    <p class="order-option-text">
                                                        옵션 : ${item.option_name}

                                                        <c:if test="${item.option_price gt 0}">
                                                            (+<fmt:formatNumber value="${item.option_price}" pattern="#,###" />원)
                                                        </c:if>
                                                    </p>
                                                </c:if>

                                                <p>
                                                    가격
                                                    <fmt:formatNumber value="${item.price}" pattern="#,###" />원
                                                </p>

                                                <p>수량 ${item.quantity}개</p>
                                            </div>

                                            <div class="item-price">
                                                <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###" />원
                                            </div>

                                        </div>
                                    </c:forEach>

                                    <div class="artist-note">
                                        <strong>결제 안내</strong>
                                        <p>결제창이 자동으로 열리지 않으면 오른쪽의 결제 진행 버튼을 눌러주세요.</p>
                                    </div>

                                </section>

                                <!-- 오른쪽 결제 요약 -->
                                <aside class="panel side-panel">

                                    <h3 class="panel-title">결제 요약</h3>

                                    <div class="summary-line">
                                        <span>주문번호</span>
                                        <strong>${order.order_id}</strong>
                                    </div>

                                    <div class="summary-line">
                                        <span>결제상태</span>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${payment.status eq 'READY'}">
                                                    <span class="badge READY">결제 대기</span>
                                                </c:when>

                                                <c:when test="${payment.status eq 'SUCCESS'}">
                                                    <span class="badge SUCCESS">결제 완료</span>
                                                </c:when>

                                                <c:when test="${payment.status eq 'FAIL'}">
                                                    <span class="badge FAIL">결제 실패</span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="badge">${payment.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>

                                    <div class="summary-total">
                                        <span>총 결제금액</span>

                                        <strong>
                                            <fmt:formatNumber value="${payment.amount}" pattern="#,###" />원
                                        </strong>
                                    </div>

                                    <div class="btn-row">
                                        <button type="button"
                                                class="btn primary full"
                                                id="paymentButton"
                                                data-client-key="${tossClientKey}"
                                                data-amount="${payment.amount}"
                                                data-order-id="${tossOrderId}"
                                                data-order-name="${fn:escapeXml(orderName)}"
                                                data-payment-status="${payment.status}">
                                            결제 진행하기
                                        </button>
                                    </div>

                                    <div class="btn-row">
                                        <a href="/myshop/orders" class="btn light full">
                                            주문내역으로
                                        </a>
                                    </div>

                                </aside>

                            </div>

                        </div>

                    </section>

                    <footer class="site-footer">
                        <div class="footer-inner">
                            <strong>HANDMADE</strong>
                            <p>결제창이 자동으로 열리지 않으면 결제 진행하기 버튼을 눌러주세요.</p>
                        </div>
                    </footer>

                    <script>
                        let paymentRequested = false;

                        window.addEventListener("load", function () {
                            const paymentButton = document.getElementById("paymentButton");

                            if (paymentButton == null) {
                                return;
                            }

                            paymentButton.addEventListener("click", requestTossPayment);

                            const paymentStatus = paymentButton.dataset.paymentStatus;

                            if (paymentStatus === "READY") {
                                setTimeout(function () {
                                    requestTossPayment();
                                }, 600);
                            }
                        });

                        function requestTossPayment() {
                            if (paymentRequested) {
                                return;
                            }

                            const paymentButton = document.getElementById("paymentButton");

                            if (paymentButton == null) {
                                return;
                            }

                            paymentRequested = true;

                            paymentButton.innerText = "결제창을 여는 중...";
                            paymentButton.disabled = true;

                            const clientKey = paymentButton.dataset.clientKey;
                            const amount = Number(paymentButton.dataset.amount);
                            const orderId = paymentButton.dataset.orderId;
                            const orderName = paymentButton.dataset.orderName;

                            const tossPayments = TossPayments(clientKey);

                            tossPayments.requestPayment("카드", {
                                amount: amount,
                                orderId: orderId,
                                orderName: orderName,
                                customerName: "회원",
                                successUrl: window.location.origin + "/payment/toss/success",
                                failUrl: window.location.origin + "/payment/toss/fail"
                            }).catch(function (error) {
                                paymentRequested = false;

                                paymentButton.innerText = "결제 진행하기";
                                paymentButton.disabled = false;

                                alert("결제창을 열지 못했습니다. 다시 시도해주세요.\n" + error.message);
                            });
                        }
                    </script>

                </body>

      
</html>
