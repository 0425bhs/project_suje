<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>결제 대기</title>
        <link rel="stylesheet" href="/css/order-payment.css">
    </head>
    
    <body>

    <header class="site-header">
        <div class="header-inner">
            <div class="brand">HAND<span>MADE</span></div>

            <nav class="main-nav">
                <a href="#">선물추천</a>
                <a href="#">베스트</a>
                <a href="#">취향발견</a>
                <a href="#">최신작품</a>
                <a href="#">작가</a>
                <a href="#">커뮤니티</a>
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
                <p>주문 정보를 확인한 뒤 결제를 진행합니다.</p>
            </div>

            <div class="order-layout">
                <div class="panel">
                    <h3 class="panel-title">주문 상품</h3>

                    <c:forEach var="item" items="${orderItemList}">
                        <div class="order-item">
                            <img src="/images/${item.imageS}" alt="상품 이미지">

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
                        <span>결제수단</span>
                        <strong>
                            <c:choose>
                                <c:when test="${payment.payment_method eq 'CARD'}">카드</c:when>
                                <c:when test="${payment.payment_method eq 'TOSS'}">토스페이</c:when>
                                <c:when test="${payment.payment_method eq 'KAKAO'}">카카오페이</c:when>
                                <c:otherwise>${payment.payment_method}</c:otherwise>
                            </c:choose>
                        </strong>
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

                    <div class="btn-row">
                        <a class="btn primary full" href="/payment/success?order_id=${order.order_id}">결제 진행하기</a>
                    </div>

                    <div class="btn-row">
                        <a class="btn light full" href="/payment/fail?order_id=${order.order_id}">주문 취소</a>
                    </div>
                </aside>
            </div>
        </div>
    </section>

    <footer class="site-footer">
        <div class="footer-inner">
            <strong>HANDMADE</strong>
            <p>실제 결제 API 연동 전 테스트용 결제 화면입니다.</p>
        </div>
    </footer>

    </body>
</html>