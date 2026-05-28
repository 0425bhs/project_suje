<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>주문서 작성</title>
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
                    <span>ORDER FORM</span>
                    <h2>주문서 작성</h2>
                </div>
                <p>주문 상품과 배송지, 결제 수단을 확인합니다.</p>
            </div>

            <form action="/order/create" method="post">
                <input type="hidden" name="product_id" value="${product_id}">
                <input type="hidden" name="price" value="${price}">
                <input type="hidden" name="quantity" value="${quantity}">

                <div class="order-layout">
                    <div class="panel">
                        <h3 class="panel-title">주문 상품</h3>

                        <div class="order-item">
                            <img src="/images/${imageS}" alt="상품 이미지">

                            <div class="item-info">
                                <div class="creator-line">작가 상품</div>
                                <strong>${productName}</strong>
                                <p>가격 ${price}원</p>
                                <p>수량 ${quantity}개</p>
                            </div>

                            <div class="item-price">
                                ${total_amount}원
                            </div>
                        </div>

                        <div class="delivery-info-card">
                            <h4>배송 정보</h4>
                            <p><strong>받는 사람</strong> 테스트회원</p>
                            <p><strong>연락처</strong> 010-1111-2222</p>
                            <p><strong>주소</strong> 서울시 강남구 101동 101호</p>
                        </div>

                        <div class="artist-note">
                            <strong>작가 안내</strong>
                            <p>핸드메이드 상품은 결제 완료 후 제작 및 포장 준비가 시작됩니다.</p>
                        </div>
                    </div>

                    <aside class="panel side-panel">
                        <h3 class="panel-title">결제 요약</h3>

                        <div class="summary-line">
                            <span>상품 금액</span>
                            <strong>${total_amount}원</strong>
                        </div>

                        <div class="summary-line">
                            <span>배송비</span>
                            <strong>0원</strong>
                        </div>

                        <div class="summary-line">
                            <span>결제수단</span>
                            <strong>
                                <select name="payment_method">
                                    <option value="CARD">카드</option>
                                    <option value="TOSS">토스페이</option>
                                    <option value="KAKAO">카카오페이</option>
                                </select>
                            </strong>
                        </div>

                        <div class="summary-total">
                            <span>총 결제금액</span>
                            <strong>${total_amount}원</strong>
                        </div>

                        <div class="btn-row">
                            <button type="submit" class="btn primary full">
                                결제 화면으로 이동
                            </button>
                        </div>

                        <div class="btn-row">
                            <a class="btn light full" href="/order/my">주문내역으로</a>
                        </div>
                    </aside>
                </div>
            </form>
        </div>
    </section>

    <footer class="site-footer">
        <div class="footer-inner">
            <strong>HANDMADE</strong>
            <p>주문 상품과 결제 정보를 확인한 뒤 결제를 진행합니다.</p>
        </div>
    </footer>

    </body>
</html>