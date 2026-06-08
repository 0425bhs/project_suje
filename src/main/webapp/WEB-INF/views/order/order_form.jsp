<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>주문서 작성</title>
        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/order-payment.css">
        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

        <jsp:include page="/WEB-INF/views/product/product_header.jsp">
            <jsp:param name="activeMenu" value="detail" />
        </jsp:include>

        <section class="page-block soft">
            <div class="block-inner">
                <div class="page-title-row">
                    <div>
                        <span>ORDER FORM</span>
                        <h2>주문서 작성</h2>
                    </div>
                    <p>주문 상품과 결제 금액을 확인합니다.</p>
                </div>

                <form action="/order/create" method="post">
                    <input type="hidden" name="product_id" value="${product.product_id}">
                    <input type="hidden" name="quantity" value="${quantity}">

                    <div class="order-layout">
                        <div class="panel">
                            <h3 class="panel-title">주문 상품</h3>

                            <div class="order-item">
                                <img src="${product.image_s}" alt="상품 이미지">

                                <div class="item-info">
                                    <div class="creator-line">작가 상품</div>
                                    <strong>${product.name}</strong>
                                    <p>가격 <fmt:formatNumber value="${price}" pattern="#,###" />원</p>
                                    <p>수량 ${quantity}개</p>
                                </div>

                                <div class="item-price">
                                    <fmt:formatNumber value="${item_amount}" pattern="#,###" />원
                                </div>
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
                                <strong><fmt:formatNumber value="${item_amount}" pattern="#,###" />원</strong>
                            </div>

                            <div class="summary-line">
                                <span>배송비</span>
                                <strong><fmt:formatNumber value="${delivery_fee}" pattern="#,###" />원</strong>
                            </div>

                            <div class="summary-total">
                                <span>총 결제금액</span>
                                <strong><fmt:formatNumber value="${total_amount}" pattern="#,###" />원</strong>
                            </div>

                            <div class="btn-row">
                                <button type="submit" class="btn primary full">
                                    주문하고 결제하기
                                </button>
                            </div>

                            <div class="btn-row">
                                <a class="btn light full" href="/product/list.do">
                                    상품 목록으로
                                </a>
                            </div>
                        </aside>
                    </div>
                </form>
            </div>
        </section>

        <footer class="site-footer">
            <div class="footer-inner">
                <strong>HANDMADE</strong>
                <p>주문 상품과 결제 금액을 확인한 뒤 결제를 진행합니다.</p>
            </div>
        </footer>

    </body>
</html>