<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%--
    제품 상세 페이지: 판매가가 있는 경우 세일가를 기준으로 주문 수량 총액을 계산합니다.
    unitPrice 변수는 장바구니/주문 선택 영역에서 사용됩니다.
--%>
<c:choose>
    <c:when test="${vo.sale_price > 0 and vo.sale_price < vo.price}">
        <c:set var="unitPrice" value="${vo.sale_price}" />
    </c:when>
    <c:otherwise>
        <c:set var="unitPrice" value="${vo.price}" />
    </c:otherwise>
</c:choose>

    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>${vo.name}</title>

        <!-- 공통 상품 페이지 스크립트 및 상세 페이지 전용 스크립트 로드 -->
        <script src="/js/product_main.js" defer></script>
        <script src="/js/product_detail.js" defer></script>
        <link rel="stylesheet" href="/css/product/product_main.css">
        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="detail" />
    </jsp:include>

    <div class="store-detail-page">

        <div class="store-detail-layout">

            <!-- 왼쪽 이미지 영역 -->
            <section class="store-detail-left">

                <div class="store-main-image-box">

                <!-- 메인 상품 이미지: 왼쪽/오른쪽 버튼으로 이미지 전환 가능 -->
                <button type="button" class="store-image-nav store-image-prev" id="detailImgPrev">
                    ‹
                </button>

                <c:choose>
                    <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                        <img id="detailMainImage" src="${vo.image_l}" alt="${vo.name}">
                    </c:when>

                    <c:when test="${not empty vo.image_s and vo.image_s ne 'no_file'}">
                        <img id="detailMainImage" src="${vo.image_s}" alt="${vo.name}">
                    </c:when>

                    <c:otherwise>
                        <img id="detailMainImage" src="/images/no_image.png" alt="이미지 없음">
                    </c:otherwise>
                </c:choose>

                <button type="button" class="store-image-nav store-image-next" id="detailImgNext">
                    ›
                </button>

            </div>

<div class="store-thumb-row">
    <!-- 상품 이미지 썸네일: 클릭 시 메인 이미지가 변경됩니다 -->
    <c:if test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
        <button type="button" class="store-thumb-btn active" data-img="${vo.image_l}">
            <img src="${vo.image_l}" alt="${vo.name}">
        </button>
    </c:if>

    <c:if test="${not empty vo.image_s and vo.image_s ne 'no_file'}">
        <button type="button" class="store-thumb-btn" data-img="${vo.image_s}">
            <img src="${vo.image_s}" alt="${vo.name}">
        </button>
    </c:if>
</div>

            </section>

            <!-- 오른쪽 상품 정보 / 주문 영역 -->
            <section class="store-detail-right">

                <!-- 판매자 정보 및 샵 이동 링크 -->
                <div class="store-seller-line">
                    <a href="/seller_shop_homepage.do?seller_id=${vo.seller_id}">
                        판매자 샵 보기
                    </a>
                    <span>판매자 번호 ${vo.seller_id}</span>
                </div>

                <h1 class="store-product-title">${vo.name}</h1>

                <p class="store-product-desc">
                    ${vo.description}
                </p>

                <!-- 가격 정보: 할인 중이면 원가와 세일가를 모두 보여줍니다 -->
                <div class="store-price-box">
                    <c:choose>
                        <c:when test="${vo.sale_price > 0 and vo.sale_price < vo.price}">
                            <div class="store-origin-price">
                                <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                            </div>

                            <div class="store-sale-price">
                                <span>${vo.sale_rate}%</span>
                                <strong>
                                    <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                </strong>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="store-sale-price">
                                <strong>
                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                </strong>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 상품 기본 정보: 재고, 배송비, 무료배송 조건, 상태 등 -->
                <div class="store-info-table">

                    <div class="store-info-row">
                        <span>재고</span>
                        <strong>${vo.stock}개</strong>
                    </div>

                    <div class="store-info-row">
                        <span>배송비</span>
                        <strong>
                            <c:choose>
                                <c:when test="${vo.delivery_fee == 0}">
                                    무료배송
                                </c:when>

                                <c:otherwise>
                                    <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                                </c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                    <div class="store-info-row">
                        <span>무료배송 조건</span>
                        <strong>
                            <c:choose>
                                <c:when test="${vo.free_shipping > 0}">
                                    <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 구매 시 무료배송
                                </c:when>

                                <c:otherwise>
                                    조건 없음
                                </c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                    <div class="store-info-row">
                        <span>상품 상태</span>
                        <strong>
                            <c:choose>
                                <c:when test="${vo.status eq 'APPROVED'}">판매중</c:when>
                                <c:when test="${vo.status eq 'HIDDEN'}">판매중지</c:when>
                                <c:when test="${vo.status eq 'PENDING'}">승인대기</c:when>
                                <c:when test="${vo.status eq 'REJECTED'}">승인거절</c:when>
                                <c:otherwise>${vo.status}</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>

                </div>

                <!-- 주문 수량 및 가격 선택 영역 -->
                <form action="/order/form" method="get" class="store-order-box">
                    <input type="hidden" name="product_id" value="${vo.product_id}">

                    <div class="store-option-box">
                        <p class="store-option-name">${vo.name}</p>

                        <div class="store-option-bottom">
                            <div class="store-quantity-box">
                                <button type="button" id="qtyMinus">−</button>

                                <input type="number"
                                    id="detailQuantity"
                                    name="quantity"
                                    value="1"
                                    min="1"
                                    max="${vo.stock}"
                                    data-unit-price="${unitPrice}"
                                    ${vo.stock <= 0 ? 'disabled' : ''}>

                                <button type="button" id="qtyPlus">+</button>
                            </div>

                            <div class="store-option-price">
                                <fmt:formatNumber value="${unitPrice}" pattern="#,###"/>원
                            </div>
                        </div>
                    </div>

                    <div class="store-total-row">
                        <span>총 상품금액</span>

                        <strong>
                            총 <em id="detailTotalCount">1</em>개
                            <b id="detailTotalPrice">
                                <fmt:formatNumber value="${unitPrice}" pattern="#,###"/>원
                            </b>
                        </strong>
                    </div>

                    <div class="store-main-buttons">
                        <button type="button" class="store-cart-btn" disabled>
                            장바구니 준비중
                        </button>

                        <c:choose>
                            <c:when test="${vo.stock > 0 and vo.status eq 'APPROVED'}">
                                <button type="submit" class="store-order-btn">
                                    주문하기
                                </button>
                            </c:when>

                            <c:otherwise>
                                <button type="button" class="store-order-btn disabled" disabled>
                                    주문 불가
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="store-sub-buttons">
                        <button type="button" disabled>♡ 찜하기 준비중</button>
                        <a href="/qna_form.do?product_id=${vo.product_id}">문의하기</a>
                    </div>

                </form>

            </section>

        </div>

        <!-- 상세 정보 -->
        <section class="store-detail-info-section">
            <h2>상세정보</h2>
            <p>${vo.description}</p>
        </section>

    </div>

    <footer class="product-footer">
        <div class="product-footer-inner">
            <strong>HANDMADE</strong>
            <p>작가 상품을 둘러보고 마음에 드는 작품을 주문할 수 있습니다.</p>
        </div>
    </footer>

    </body>
</html>