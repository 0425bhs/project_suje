<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


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

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_detail.css">

        <script src="/js/product_main.js" defer></script>
        <script src="/js/product_detail.js" defer></script>
        <script src="/js/cart.js" defer></script>
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

                        <button type="button" class="store-wish-icon-btn">♡</button>

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

                    <div class="store-seller-line">
                        <a href="/seller_shop_homepage.do?seller_id=${vo.seller_id}">
                            판매자 샵 보기
                        </a>
                        <br/>
                        <span>판매자 번호 ${vo.seller_id}</span>
                    </div>

                    <h1 class="store-product-title">${vo.name}</h1>

                    <p class="store-product-desc">
                        ${vo.description}
                    </p>

                    <!-- 가격 정보 -->
                    <div class="store-price-box">
                        <c:choose>
                            <c:when test="${vo.sale_price>0 and vo.price>vo.sale_price}">
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

                    <!-- 상품 기본 정보 -->
                    <div class="store-info-table">

                        <div class="store-info-row">
                            <span>재고</span>
                            <strong>${vo.stock}개</strong>
                        </div>

                        <div class="store-info-row">
                            <span>배송비</span>
                            <strong>
                                <c:if test="${vo.delivery_fee == 0}">
                                        무료배송
                                </c:if>

                                <c:if test="${vo.delivery_fee > 0}">
                                    <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                                </c:if>
                            </strong>
                        </div>

                        <div class="store-info-row">
                            <span>무료배송 조건</span>
                            <strong>
                                <c:if test="${vo.free_shipping > 0}">
                                    <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 구매 시 무료배송
                                </c:if>

                                <c:if test="${vo.delivery_fee > 0 &&vo.free_shipping = 0}">
                                    유료배송
                                </c:if>

                                <c:if test="${vo.delivery_fee = 0}" >
                                    무료배송
                                </c:if>
                                
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
                        <input type="hidden" id="product_id" name="product_id" value="${vo.product_id}">

                        <div class="store-option-box">
                            <p class="store-option-name">${vo.name}</p>

                            <div class="store-option-bottom">
                                <div class="store-quantity-box">
                                    <button type="button" id="qtyMinus" ${vo.stock le 0 or vo.status ne 'APPROVED' ? 'disabled' : ''}>
                                        −
                                    </button>

                                    <input type="number" id="detailQuantity" name="quantity" value="1" min="1" max="${vo.stock}" data-unit-price="${unitPrice}"
                                        ${vo.stock le 0 or vo.status ne 'APPROVED' ? 'disabled' : ''} />

                                    <button type="button" id="qtyPlus" ${vo.stock le 0 or vo.status ne 'APPROVED' ? 'disabled' : ''}>
                                        +
                                    </button>
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

                            <c:choose>

                                <c:when test="${vo.status ne 'APPROVED' || (vo.status ne 'APPROVED' && vo.stock le 0)}">
                                    <button type="button" class="store-cart-btn disabled" disabled>
                                        판매중지
                                    </button>
                                </c:when>

                                <c:when test="${vo.stock le 0}">
                                    <button type="button" class="store-cart-btn disabled" disabled>
                                        품절
                                    </button>
                                </c:when>

                                <c:otherwise>
                                    <button type="button" class="store-cart-btn" onclick="cartInsert()">
                                        장바구니
                                    </button>

                                    <button type="submit" class="store-order-btn">
                                        주문하기
                                    </button>
                                </c:otherwise>

                            </c:choose>

                        </div>

                        
                    </form>

                </section>

            </div>


            <div class="store-detail-tab-wrap">

                <button type="button" class="store-detail-tab active" data-tab-target="detailInfo">
                    상세정보
                </button>

                <button type="button" class="store-detail-tab" data-tab-target="reviewBox">
                    상품평
                </button>

                <button type="button" class="store-detail-tab" data-tab-target="qnaBox">
                    상품문의
                </button>

            </div>

            <section class="store-detail-info-section store-tab-panel active" id="detailInfo">
                <h2>상세정보</h2>
                <p>${vo.description}</p>
            </section>

            <section class="product-review-box store-tab-panel" id="reviewBox">
                <h2>상품평</h2>

                <c:if test="${empty review_list}">
                    <p class="review-empty">아직 등록된 리뷰가 없습니다.</p>
                </c:if>

                <c:if test="${not empty review_list}">
                    <c:forEach var="review" items="${review_list}">
                        <div class="review-item">
                            <div>
                                <span class="review-star">★</span>
                                <strong>${review.rating}</strong>
                            </div>

                            <p>${review.content}</p>
                            <small>${review.created_at}</small>
                        </div>
                    </c:forEach>
                </c:if>

            </section>

            <section class="product-qna-box store-tab-panel" id="qnaBox">

                <div class="product-qna-header">
                    <h2>상품문의</h2>

                    <a href="/qna_form.do?product_id=${vo.product_id}" class="qna-write-btn">
                        문의하기
                    </a>
                </div>

                <c:if test="${empty qna_list}">
                    <p class="qna-empty">아직 등록된 문의가 없습니다.</p>
                </c:if>

                <c:if test="${not empty qna_list}">
                    <c:forEach var="qna" items="${qna_list}">
                        <div class="qna-item">

                            <div class="qna-title-row">
                                <strong>${qna.title}</strong>
                                <span>${qna.created_at}</span>
                            </div>

                            <p>${qna.content}</p>

                            <c:if test="${not empty qna.answer}">
                                <div class="qna-answer">
                                    <strong>답변</strong>
                                    <p>${qna.answer}</p>
                                </div>
                            </c:if>

                        </div>
                    </c:forEach>
                </c:if>

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