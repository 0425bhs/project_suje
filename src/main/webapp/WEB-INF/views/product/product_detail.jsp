<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>상품 상세</title>
    <link rel="stylesheet" href="/css/product.css">
</head>

<body>

<header class="product-header">

    <div class="product-util">
        <div class="product-util-inner">
            <span>작가의 손길이 담긴 핸드메이드 마켓</span>

            <div class="product-util-menu">
                <a href="#" class="disabled">로그인</a>
                <a href="#" class="disabled">회원가입</a>
                <a href="#" class="disabled">고객센터</a>
            </div>
        </div>
    </div>

    <div class="product-header-inner">
        <a class="product-brand" href="/product/main.do">
            HAND<span>MADE</span>
        </a>

        <div class="product-search-box disabled">
            찾으시는 작가, 작품이 있나요?
        </div>

        <div class="product-header-actions">
            <a href="/order/my">주문내역</a>
            <a href="#" class="disabled">♡ 관심</a>
            <a href="#" class="disabled">🛒 장바구니</a>
        </div>
    </div>

    <nav class="product-nav-bar">
        <div class="product-nav-inner">
            <a href="#" class="disabled">☰ 전체 카테고리</a>
            <a href="#" class="disabled">🎁 선물추천</a>
            <a href="#" class="disabled">🏷️ 할인</a>
            <a href="#" class="disabled">🏆 베스트</a>
            <a href="#" class="disabled">💛 취향발견</a>
            <a href="#" class="disabled">🆕 최신작품</a>
            <a href="#" class="disabled">💬 커뮤니티</a>
        </div>
    </nav>

</header>

<div class="product-detail-page">

    <div class="product-detail-layout">

        <div class="product-detail-panel">
            <h2 class="product-detail-title">상품 상세</h2>

            <div class="product-detail-main">
                <img class="product-detail-img" src="${vo.image_l}" alt="${vo.name}">

                <div class="product-detail-info">
                    <div class="product-label">작가 상품</div>

                    <h3>${vo.name}</h3>

                    <div class="product-detail-price-box">
                        <c:choose>
                            <c:when test="${vo.sale_price > 0}">
                                <p class="origin-price">
                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                </p>

                                <p class="sale-price">
                                    <strong>${vo.sale_rate}% 할인</strong>
                                    <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                </p>
                            </c:when>

                            <c:otherwise>
                                <p class="sale-price">
                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <p>재고: ${vo.stock}개</p>

                    <p>
                        배송비:
                        <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                    </p>

                    <p>
                        무료배송 조건:
                        <c:choose>
                            <c:when test="${vo.free_shipping > 0}">
                                <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 구매 시 무료배송
                            </c:when>

                            <c:otherwise>
                                무료배송 조건 없음
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <p>${vo.description}</p>
                </div>
            </div>

            <div class="product-detail-desc">
                <strong>상세정보</strong>
                <p>${vo.description}</p>
            </div>
        </div>

        <div class="product-order-box">
            <h3>주문 선택</h3>

            <form action="/order/form" method="get">
                <input type="hidden" name="product_id" value="${vo.product_id}">

                <div class="product-summary-line">
                    <span>수량</span>
                    <strong>
                        <input class="product-quantity" type="number" name="quantity" value="1" min="1">
                    </strong>
                </div>

                <div class="product-summary-line">
                    <span>배송비</span>
                    <strong>
                        <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                    </strong>
                </div>

                <div class="product-summary-line">
                    <span>무료배송</span>
                    <strong>
                        <c:choose>
                            <c:when test="${vo.free_shipping > 0}">
                                <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상
                            </c:when>

                            <c:otherwise>
                                조건 없음
                            </c:otherwise>
                        </c:choose>
                    </strong>
                </div>

                <div class="product-summary-total">
                    <span>판매가</span>
                    <strong>
                        <c:choose>
                            <c:when test="${vo.sale_price > 0}">
                                <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                            </c:when>

                            <c:otherwise>
                                <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                            </c:otherwise>
                        </c:choose>
                    </strong>
                </div>

                <div class="product-btn-row">
                    <button type="submit" class="product-btn primary full">
                        주문하기
                    </button>list.domain.do
                </div>
            </form>

            <div class="product-btn-row">
                <button type="button" class="product-btn light full disabled">
                    장바구니 담기
                </button>
            </div>

            <div class="product-btn-row">
                <a class="product-btn light full" href="/product/main.do">
                    상품 목록으로
                </a>
            </div>
        </div>

    </div>

</div>

<footer class="product-footer">
    <div class="product-footer-inner">
        <strong>HANDMADE</strong>
        <p>작가 상품을 둘러보고 마음에 드는 작품을 주문할 수 있습니다.</p>
    </div>
</footer>

</body>

</html>