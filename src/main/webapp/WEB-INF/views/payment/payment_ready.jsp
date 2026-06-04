<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>결제 대기</title>
        <link rel="stylesheet" href="/css/order-payment.css">

        <script src="https://js.tosspayments.com/v2/standard"></script>
    </head>

    <body>

    <header class="site-header">
        <div class="header-inner">
            <div class="brand">HAND<span>MADE</span></div>

            <nav class="main-nav">
                <a href="/product/main.do">상품보기</a>
                <a href="#">선물추천</a>
                <a href="#">베스트</a>
                <a href="#">취향발견</a>
                <a href="#">최신작품</a>
                <a href="#">작가</a>
            </nav>

            <div class="header-actions">
                <a href="/order/my">주문내역</a>
                <a href="#">관심</a>
                <a href="#">장바구니</a>
            </div>
        </div>
    </header>

    <section class="page-block soft">
        <div class="block-inner">
            <div class="page-title-row">
                <div>
                    <span>PAYMENT</span>
                    <h2>결제 대기</h2>
                </div>
                <p>주문 정보를 확인한 뒤 결제창에서 결제를 진행합니다.</p>
            </div>

            <div class="order-layout">
                <div class="panel">
                    <h3 class="panel-title">주문 상품</h3>

                    <c:forEach var="item" items="${orderItemList}">
                        <div class="order-item">
                            <img src="${item.imageS}" alt="상품 이미지">

                            <div class="item-info">
                                <div class="creator-line">작가 상품</div>
                                <strong>${item.productName}</strong>
                                <p>가격 ${item.price}원</p>
                                <p>수량 ${item.quantity}개</p>
                            </div>

                            <div class="item-price">
                                ${item.subtotalAmount}원
                            </div>
                        </div>
                    </c:forEach>

                    <div class="artist-note">
                        <strong>작가 안내</strong>
                        <p>핸드메이드 상품 특성상 결제 완료 후 제작 및 포장 준비가 시작됩니다.</p>
                    </div>
                </div>

                <aside class="panel side-panel">
                    <h3 class="panel-title">결제 요약</h3>

                    <div class="summary-line">
                        <span>주문번호</span>
                        <strong>${order.order_id}</strong>
                    </div>

                    <div class="summary-line">
                        <span>결제상태</span>
                        <span class="badge ${payment.status}">
                            <c:choose>
                                <c:when test="${payment.status eq 'READY'}">결제 대기</c:when>
                                <c:when test="${payment.status eq 'SUCCESS'}">결제 완료</c:when>
                                <c:when test="${payment.status eq 'FAIL'}">결제 실패</c:when>
                                <c:otherwise>${payment.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="summary-total">
                        <span>총 결제금액</span>
                        <strong>${payment.amount}원</strong>
                    </div>

                    <input type="hidden" id="tossClientKey" value="${tossClientKey}">
                    <input type="hidden" id="customerKey" value="${customerKey}">
                    <input type="hidden" id="payAmount" value="${payment.amount}">
                    <input type="hidden" id="tossOrderId" value="${tossOrderId}">
                    <input type="hidden" id="orderName" value="${orderName}">

                    <div class="btn-row">
                        <button type="button" class="btn primary full" id="payment-button">
                            결제 진행하기
                        </button>
                    </div>

                    <div class="btn-row">
                        <a class="btn light full" href="/order/my">
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
            <p>주문 정보를 확인한 뒤 결제창으로 이동합니다.</p>
        </div>
    </footer>

    <script>
        const clientKey = document.getElementById("tossClientKey").value;
        const customerKey = document.getElementById("customerKey").value;
        const payAmount = Number(document.getElementById("payAmount").value);
        const tossOrderId = document.getElementById("tossOrderId").value;
        const orderName = document.getElementById("orderName").value;

        const tossPayments = TossPayments(clientKey);

        const tossPayment = tossPayments.payment({
            customerKey: customerKey
        });

        document.getElementById("payment-button").addEventListener("click", async function () {
            try {
                await tossPayment.requestPayment({
                    method: "CARD",
                    amount: {
                        currency: "KRW",
                        value: payAmount
                    },
                    orderId: tossOrderId,
                    orderName: orderName,
                    successUrl: window.location.origin + "/payment/toss/success",
                    failUrl: window.location.origin + "/payment/toss/fail",
                    customerName: "테스트회원"
                });
            } catch (error) {
                alert("결제창을 여는 중 오류가 발생했습니다.");
                console.log(error);
            }
        });
    </script>

    </body>
</html>