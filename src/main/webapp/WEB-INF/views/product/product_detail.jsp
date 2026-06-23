<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:formatDate var="today" value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd" />

<c:set var="saleStartDate" value="${empty vo.sale_start_at ? '' : fn:substring(vo.sale_start_at, 0, 10)}" />
<c:set var="saleEndDate" value="${empty vo.sale_end_at ? '' : fn:substring(vo.sale_end_at, 0, 10)}" />

<c:set var="isAlwaysSale"
       value="${vo.price > 0 and vo.sale_price > 0 and vo.sale_price < vo.price and empty saleStartDate and empty saleEndDate}" />

<c:set var="isPeriodSale"
       value="${vo.price > 0 and vo.sale_price > 0 and vo.sale_price < vo.price and not empty saleStartDate and not empty saleEndDate and today ge saleStartDate and today le saleEndDate}" />

<c:set var="isSaleActive" value="${isAlwaysSale or isPeriodSale}" />

<c:choose>
    <c:when test="${isSaleActive}">
        <c:set var="unitPrice" value="${vo.sale_price}" />
    </c:when>

    <c:otherwise>
        <c:set var="unitPrice" value="${vo.price}" />
    </c:otherwise>
</c:choose>

<c:set var="imageLPath" value="" />

<c:if test="${not empty vo.image_l and fn:trim(vo.image_l) ne 'no_file'}">
    <c:choose>
        <c:when test="${fn:startsWith(vo.image_l, '/upload/')}">
            <c:set var="imageLPath" value="${vo.image_l}" />
        </c:when>

        <c:otherwise>
            <c:set var="imageLPath" value="/upload/${vo.image_l}" />
        </c:otherwise>
    </c:choose>
</c:if>


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

                        <button type="button" class="store-wish-icon-btn" id="productWishBtn" data-product-id="${vo.product_id}">♡</button>

                        <button type="button" class="store-image-nav store-image-prev" id="detailImgPrev">
                            ‹
                        </button>

                        <c:choose>
                            <c:when test="${not empty imageLPath}">
                                <img id="detailMainImage"
                                    src="${imageLPath}"
                                    alt="${vo.name}"
                                    onerror="this.onerror=null; this.src='/images/no_image.png';">
                            </c:when>

                            <c:when test="${not empty vo.imageList}">
                                <img id="detailMainImage"
                                    src="/upload/${vo.imageList[0].image_url}"
                                    alt="${vo.name}"
                                    onerror="this.onerror=null; this.src='/images/no_image.png';">
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
                        <c:if test="${not empty imageLPath}">
                            <button type="button" class="store-thumb-btn active" data-img="${imageLPath}">
                                <img src="${imageLPath}"
                                     alt="${vo.name}"
                                     onerror="this.onerror=null; this.src='/images/no_image.png';">
                            </button>
                        </c:if>

                        <c:if test="${not empty vo.imageList}">
                            <c:forEach var="img" items="${vo.imageList}">
                                <button type="button" class="store-thumb-btn" data-img="/upload/${img.image_url}">
                                    <img src="/upload/${img.image_url}"
                                        alt="${vo.name}"
                                        onerror="this.onerror=null; this.src='/images/no_image.png';">
                                </button>
                            </c:forEach>
                        </c:if>
                    </div>

                    <c:if test="${not empty bestReview}">
                        <div class="detail-review-preview-wrap">

                            <div class="review-preview-title">
                                <span class="review-crown">👑</span>
                                <span>
                                    <strong>${vo.review_count}</strong>명의 고객님들이 구매했어요!
                                </span>
                            </div>

                            <div class="review-preview-list">

                                <c:forEach var="review" items="${bestReview}" varStatus="status">
                                    <div class="review-preview-card">

                                        <c:choose>
                                            <c:when test="${not empty review.review_image}">
                                                <img class="review-preview-img" src="/upload/${review.review_image}" onerror="this.src='/images/no_image.png'">
                                            </c:when>

                                            <c:otherwise>
                                                <img class="review-preview-img"
                                                    src="/images/no_image.png">
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="review-preview-content">

                                            <div class="review-preview-top">
                                                <span class="review-star">★</span>
                                                <span class="review-rating">${review.rating}</span>

                                                <c:if test="${status.index == 0}">
                                                    <span class="review-badge">베스트글</span>
                                                </c:if>
                                            </div>

                                            <p class="review-preview-text">
                                                ${review.content}
                                            </p>
                                        </div>

                                        <!-- 세 번째 리뷰 카드에만 더보기 버튼 출력 -->
                                        <c:if test="${status.index == 2}">
                                            <a class="review-more-btn" href="#reviewBox">
                                                더보기
                                            </a>
                                        </c:if>

                                    </div>
                                </c:forEach>

                            </div>
                        </div>
                    </c:if>

                </section>

                <!-- 오른쪽 상품 정보 / 주문 영역 -->
                <section class="store-detail-right">

                    <div class="store-seller-line">
                        <a href="/seller_shop_homepage.do?seller_id=${vo.seller_id}">
                             ${vo.company_name} 샵 보기 >
                        </a>
                        <br/>

                        <button type="button" class="wish-shop-btn ${favorite ? 'active' : ''}" id="sellerWishBtn" data-seller-id="${vo.seller_id}">
                        <span class="wish-shop-heart">
                            ${favorite ? '♥' : '♡'}
                        </span>

                        <span class="wish-shop-text">
                            ${favorite ? '찜 취소' : '작가샵 찜하기'}
                        </span>
                    </button>
                    </div>

                    <h1 class="store-product-title">${vo.name}</h1>

                    <!-- 가격 정보 -->
                    <div class="store-price-box">
                        <c:choose>
                            <c:when test="${isSaleActive}">
                                <div class="store-origin-price">
                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                </div>

                                <div class="store-sale-price">
                                    <span>
                                        <fmt:formatNumber value="${((vo.price - vo.sale_price) / vo.price) * 100}" pattern="0"/>%
                                    </span>

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
                                <c:choose>
                                    <c:when test="${vo.delivery_fee eq 0}">
                                        조건 없음
                                    </c:when>

                                    <c:when test="${vo.delivery_fee gt 0 and vo.free_shipping gt 0}">
                                        <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 구매 시 무료배송
                                    </c:when>

                                    <c:otherwise>
                                        유료배송
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
                        <input type="hidden" id="product_id" name="product_id" value="${vo.product_id}">

                        <div class="store-option-box">
                            <p class="store-option-name">${vo.name}</p>

                            <div class="store-option-bottom">
                                <div class="store-quantity-box">
                                    <button type="button" id="qtyMinus" ${vo.stock le 0 or vo.status ne 'APPROVED' ? 'disabled' : ''}>
                                        −
                                    </button>

                                    <input type="number"
                                           id="detailQuantity"
                                           name="quantity"
                                           value="1"
                                           min="1"
                                           max="${vo.stock}"
                                           data-unit-price="${unitPrice}"
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
                                <c:when test="${vo.status ne 'APPROVED'}">
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

            <section class="store-detail-info-section store-tab-panel" id="detailInfo">
                <h2>상세정보</h2>

                <div class="product-editor-content">
                    <c:out value="${vo.description}" escapeXml="false" />
                </div>
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

                            <c:if test="${not empty review.imageList}">
                                <div class="review-photo-list">
                                    <c:forEach var="image" items="${review.imageList}">
                                        <img class="review-photo-item" src="/upload/${image.image_url}" alt="리뷰 사진" width="100">
                                    </c:forEach>
                                </div>
                            </c:if>
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