<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>결제 실패</title>
        <link rel="stylesheet" href="/css/order-payment.css">
    </head>

    <body>

    <header class="site-header">
        <div class="header-inner">
            <div class="brand">HAND<span>MADE</span></div>

            <nav class="main-nav">
                <a href="/product/list.do">상품보기</a>
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
            <div class="complete-box">
                <div class="complete-icon">!</div>

                <h2>결제에 실패했습니다</h2>

                <p>
                    결제가 정상적으로 처리되지 않았습니다.
                    다시 시도하거나 주문 내역을 확인해주세요.
                </p>

                <div class="complete-detail">
                    <div>
                        <span>주문번호</span>
                        <strong>${order_id}</strong>
                    </div>

                    <div>
                        <span>결제상태</span>
                        <strong><span class="badge FAIL">결제 실패</span></strong>
                    </div>
                </div>

                <div class="order-guide">
                    ${message}
                </div>

                <div class="btn-row">
                    <a class="btn light full" href="/order/my">
                        내 주문 내역으로 이동
                    </a>

                    <a class="btn primary full" href="/product/list.do">
                        상품 목록으로 이동
                    </a>
                </div>
            </div>
        </div>
    </section>

    <footer class="site-footer">
        <div class="footer-inner">
            <strong>HANDMADE</strong>
            <p>결제 실패 시 주문 내역에서 다시 확인할 수 있습니다.</p>
        </div>
    </footer>

    </body>
</html>