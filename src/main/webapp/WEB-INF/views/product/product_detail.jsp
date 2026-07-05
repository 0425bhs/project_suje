<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

                <section class="store-detail-left">

                    <div class="store-main-image-box">

                        <button type="button"
                                class="store-wish-icon-btn"
                                id="productWishBtn"
                                data-product-id="${vo.product_id}">
                            ♡
                        </button>

                        <button type="button" class="store-image-nav store-image-prev" id="detailImgPrev">
                            ‹
                        </button>

                        <c:choose>
                            <c:when test="${not empty imageLPath}">
                                <img id="detailMainImage" src="${imageLPath}" alt="${vo.name}">
                            </c:when>

                            <c:when test="${not empty vo.imageList}">
                                <img id="detailMainImage" src="/upload/${vo.imageList[0].image_url}" alt="${vo.name}">
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
                                <img src="${imageLPath}" alt="${vo.name}">
                            </button>
                        </c:if>

                        <c:if test="${not empty vo.imageList}">
                            <c:forEach var="img" items="${vo.imageList}">
                                <button type="button" class="store-thumb-btn" data-img="/upload/${img.image_url}">
                                    <img src="/upload/${img.image_url}" alt="${vo.name}">
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

                                    <c:if test="${status.index < 2}">

                                        <div class="review-preview-card">

                                            <c:set var="reviewPreviewImage" value="${fn:trim(review.review_image)}" />

                                            <c:choose>
                                                <c:when test="${not empty reviewPreviewImage and reviewPreviewImage ne 'no_file'}">
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(reviewPreviewImage, '/upload/')}">
                                                            <img class="review-preview-img" src="${reviewPreviewImage}">
                                                        </c:when>

                                                        <c:otherwise>
                                                            <img class="review-preview-img" src="/upload/${reviewPreviewImage}">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:when>

                                                <c:otherwise>
                                                    <img class="review-preview-img" src="/images/no_image.png">
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="review-preview-content">

                                                <div class="review-preview-top">
                                                    <span class="review-star">★</span>
                                                    <span class="review-rating">${review.rating}</span>
                                                    <span class="review-badge">베스트글</span>
                                                    
                                                </div>

                                                <p class="review-preview-text">
                                                    ${review.content}
                                                </p>

                                            </div>

                                            <c:if test="${vo.review_count > 2 and status.index == 1}">
                                                <a class="review-more-btn" href="#reviewBox">
                                                    더보기
                                                </a>
                                            </c:if>

                                        </div>

                                    </c:if>

                                </c:forEach>

                            </div>
                        </div>
                    </c:if>

                </section>

                <section class="store-detail-right">

                    <div class="store-seller-line">
                        <a href="/seller_shop_homepage.do?seller_id=${vo.seller_id}">
                            ${vo.company_name} 샵 보기 >
                        </a>

                        <button type="button"
                                class="wish-shop-btn ${favorite ? 'active' : ''}"
                                id="sellerWishBtn"
                                data-seller-id="${vo.seller_id}">
                            <span class="wish-shop-heart">
                                ${favorite ? '♥' : '♡'}
                            </span>

                            <span class="wish-shop-text">
                                ${favorite ? '찜 취소' : '작가샵 찜하기'}
                            </span>
                        </button>
                    </div>

                    <h1 class="store-product-title">${vo.name}</h1>

                    <div class="store-price-box">
                        <c:choose>
                            <c:when test="${isSaleActive}">
                                <div class="store-origin-price">
                                    <fmt:formatNumber value="${vo.price}" pattern="#,###" />원
                                </div>

                                <div class="store-sale-price">
                                    <span>
                                        <fmt:formatNumber value="${((vo.price - vo.sale_price) / vo.price) * 100}" pattern="0" />%
                                    </span>

                                    <strong>
                                        <fmt:formatNumber value="${vo.sale_price}" pattern="#,###" />원
                                    </strong>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="store-sale-price">
                                    <strong>
                                        <fmt:formatNumber value="${vo.price}" pattern="#,###" />원
                                    </strong>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="store-info-table">

                        <div class="store-info-row">
                            <span>재고</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty vo.optionList}">
                                        옵션 선택 후 확인
                                    </c:when>

                                    <c:otherwise>
                                        ${vo.stock}개
                                    </c:otherwise>
                                </c:choose>
                            </strong>
                        </div>

                        <div class="store-info-row">
                            <span>배송비</span>
                            <strong>
                                <c:if test="${vo.delivery_fee == 0}">
                                    무료배송
                                </c:if>

                                <c:if test="${vo.delivery_fee > 0}">
                                    <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###" />원
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
                                        <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###" />원 이상 구매 시 무료배송
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

                    <form action="/order/form" method="get" class="store-order-box">

                        <input type="hidden" id="product_id" name="product_id" value="${vo.product_id}">

                        <c:set var="hasOption" value="${not empty vo.optionList}" />
                        <c:set var="sellableStock" value="${hasOption ? vo.optionTotalStock : vo.stock}" />
                        <c:set var="isSoldOut" value="${sellableStock le 0}" />

                        <c:choose>

                            <c:when test="${hasOption}">

                                <div class="product-option-box">
                                    <label for="option_id" class="option-select-label">
                                        옵션 선택 (필수)<span>*</span>
                                    </label>

                                    <select id="option_id" class="product-option-select" data-unit-price="${unitPrice}" ${vo.status ne 'APPROVED' or isSoldOut ? 'disabled' : ''}>

                                        <option value="">컬러</option>

                                        <c:forEach var="option" items="${vo.optionList}">
                                            <option value="${option.option_id}" data-option-name="${option.option_name}" data-price="${option.option_price}"
                                                    data-stock="${option.option_stock}" ${option.option_stock le 0 ? 'disabled' : ''}>

                                                ${option.option_name}

                                                <c:if test="${option.option_price gt 0}">
                                                    (+<fmt:formatNumber value="${option.option_price}" pattern="#,###" />원)
                                                </c:if>

                                                <c:if test="${option.option_stock le 0}">
                                                    - 품절
                                                </c:if>
                                            </option>
                                        </c:forEach>

                                    </select>
                                </div>

                                <input type="hidden" id="optionBasePrice" value="${unitPrice}">

                                <div id="selectedOptionBox" class="selected-option-list" style="display:none;"></div>

                            </c:when>

                            <c:otherwise>

                                <div class="store-option-box">

                                    <p class="store-option-name">${vo.name}</p>

                                    <div class="store-option-bottom">

                                        <div class="store-quantity-box">

                                            <button type="button"
                                                    id="qtyMinus"
                                                    ${vo.stock le 0 or vo.status ne 'APPROVED' ? 'disabled' : ''}>
                                                −
                                            </button>

                                            <input type="number" id="detailQuantity" name="quantity" value="1" min="1" max="${vo.stock}"
                                                data-unit-price="${unitPrice}" ${vo.stock le 0 or vo.status ne 'APPROVED' ? 'disabled' : ''} />

                                            <button type="button" id="qtyPlus" ${vo.stock le 0 or vo.status ne 'APPROVED' ? 'disabled' : ''}>
                                                +
                                            </button>

                                        </div>

                                        <div class="store-option-price">
                                            <fmt:formatNumber value="${unitPrice}" pattern="#,###" />원
                                        </div>

                                    </div>

                                </div>

                            </c:otherwise>

                        </c:choose>

                        <div class="store-total-row">
                            <span>총 상품금액</span>

                            <strong>
                                총 <em id="detailTotalCount">${hasOption ? 0 : 1}</em>개

                                <b id="detailTotalPrice">
                                    <c:choose>
                                        <c:when test="${hasOption}">
                                            0원
                                        </c:when>

                                        <c:otherwise>
                                            <fmt:formatNumber value="${unitPrice}" pattern="#,###" />원
                                        </c:otherwise>
                                    </c:choose>
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

                                <c:when test="${isSoldOut}">
                                    <button type="button" class="store-cart-btn disabled" disabled>
                                        품절
                                    </button>
                                </c:when>

                                <c:otherwise>
                                    <button type="button" class="store-cart-btn" id="cartBtn" onclick="cartInsert()" ${hasOption ? 'disabled' : ''}>
                                        장바구니
                                    </button>

                                    <button type="submit" class="store-order-btn" id="orderBtn" ${hasOption ? 'disabled' : ''}>
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

                    <c:set var="reviewTotalCount" value="${fn:length(review_list)}" />
                    <c:set var="ratingSum" value="0" />

                    <c:set var="rating5Count" value="0" />
                    <c:set var="rating4Count" value="0" />
                    <c:set var="rating3Count" value="0" />
                    <c:set var="rating2Count" value="0" />
                    <c:set var="rating1Count" value="0" />
                    <c:set var="photoReviewCount" value="0" />

                    <c:forEach var="review" items="${review_list}">
                        <c:set var="reviewRating" value="${empty review.rating ? 0 : review.rating}" />
                        <c:set var="ratingSum" value="${ratingSum + reviewRating}" />

                        <c:if test="${reviewRating == 5}">
                            <c:set var="rating5Count" value="${rating5Count + 1}" />
                        </c:if>

                        <c:if test="${reviewRating == 4}">
                            <c:set var="rating4Count" value="${rating4Count + 1}" />
                        </c:if>

                        <c:if test="${reviewRating == 3}">
                            <c:set var="rating3Count" value="${rating3Count + 1}" />
                        </c:if>

                        <c:if test="${reviewRating == 2}">
                            <c:set var="rating2Count" value="${rating2Count + 1}" />
                        </c:if>

                        <c:if test="${reviewRating == 1}">
                            <c:set var="rating1Count" value="${rating1Count + 1}" />
                        </c:if>

                        <c:if test="${not empty review.imageList}">
                            <c:set var="photoReviewCount" value="${photoReviewCount + 1}" />
                        </c:if>
                    </c:forEach>

                    <c:set var="reviewAvg" value="${reviewTotalCount > 0 ? ratingSum / reviewTotalCount : 0}" />

                    <c:set var="rating5Percent" value="${reviewTotalCount > 0 ? rating5Count * 100.0 / reviewTotalCount : 0}" />
                    <c:set var="rating4Percent" value="${reviewTotalCount > 0 ? rating4Count * 100.0 / reviewTotalCount : 0}" />
                    <c:set var="rating3Percent" value="${reviewTotalCount > 0 ? rating3Count * 100.0 / reviewTotalCount : 0}" />
                    <c:set var="rating2Percent" value="${reviewTotalCount > 0 ? rating2Count * 100.0 / reviewTotalCount : 0}" />
                    <c:set var="rating1Percent" value="${reviewTotalCount > 0 ? rating1Count * 100.0 / reviewTotalCount : 0}" />

                    <div class="detail-review-area">

                        <aside class="review-summary-card">

                            <div class="review-summary-score">
                                <fmt:formatNumber value="${reviewAvg}" pattern="0.0" />
                            </div>

                            <div class="review-summary-stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= reviewAvg}">
                                            <span class="summary-star on">★</span>
                                        </c:when>

                                        <c:when test="${i - reviewAvg <= 0.5}">
                                            <span class="summary-star half">★</span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="summary-star">★</span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>

                            <p class="review-summary-count">
                                총 <strong>${reviewTotalCount}</strong>개 리뷰
                            </p>

                            <div class="review-score-bars">

                                <div class="review-score-row">
                                    <span>5점</span>
                                    <div class="review-score-track">
                                        <div class="review-score-fill" data-percent="${rating5Percent}"></div>
                                    </div>
                                    <em><fmt:formatNumber value="${rating5Percent}" pattern="0" />%</em>
                                </div>

                                <div class="review-score-row">
                                    <span>4점</span>
                                    <div class="review-score-track">
                                        <div class="review-score-fill" data-percent="${rating4Percent}"></div>
                                    </div>
                                    <em><fmt:formatNumber value="${rating4Percent}" pattern="0" />%</em>
                                </div>

                                <div class="review-score-row">
                                    <span>3점</span>
                                    <div class="review-score-track">
                                        <div class="review-score-fill" data-percent="${rating3Percent}"></div>
                                    </div>
                                    <em><fmt:formatNumber value="${rating3Percent}" pattern="0" />%</em>
                                </div>

                                <div class="review-score-row">
                                    <span>2점</span>
                                    <div class="review-score-track">
                                        <div class="review-score-fill" data-percent="${rating2Percent}"></div>
                                    </div>
                                    <em><fmt:formatNumber value="${rating2Percent}" pattern="0" />%</em>
                                </div>

                                <div class="review-score-row">
                                    <span>1점</span>
                                    <div class="review-score-track">
                                        <div class="review-score-fill" data-percent="${rating1Percent}"></div>
                                    </div>
                                    <em><fmt:formatNumber value="${rating1Percent}" pattern="0" />%</em>
                                </div>

                            </div>

                        </aside>

                        <div class="detail-review-right">

                            <div class="review-filter-tabs">

                                <button type="button" class="review-filter-tab active" data-review-tab="all">
                                    전체리뷰 <span id="reviewAllCount">(${reviewTotalCount})</span>
                                </button>

                                <button type="button" class="review-filter-tab" data-review-tab="best">
                                    베스트순
                                </button>

                                <button type="button" class="review-filter-tab" data-review-tab="photo">
                                    포토리뷰 <span id="reviewPhotoCount">(${photoReviewCount})</span>
                                </button>

                                <button type="button" id="reviewResetBtn" class="review-reset-btn">
                                    <span class="review-reset-icon">↻</span>
                                    <span>초기화</span>
                                </button>

                            </div>

                            <div class="review-search-filter-row">

                                <div class="review-search-box">
                                    <span class="review-search-icon">⌕</span>
                                    <input type="text" id="reviewSearchInput" placeholder="검색어를 입력하세요">
                                </div>

                                <div class="review-rating-select-box">

                                    <button type="button" id="reviewRatingBtn" class="review-rating-btn">
                                        <span id="reviewRatingText">모든 별점</span>
                                        <span class="review-rating-arrow">⌄</span>
                                    </button>

                                    <div id="reviewRatingMenu" class="review-rating-menu">

                                        <button type="button" class="review-rating-option active" data-rating-filter="all" data-rating-label="모든 별점">
                                            <span class="rating-option-left">모든 별점</span>
                                            <em id="ratingAllCount">${reviewTotalCount}</em>
                                        </button>

                                        <button type="button" class="review-rating-option" data-rating-filter="5" data-rating-label="★★★★★">
                                            <span class="rating-option-left">
                                                최고
                                                <span class="rating-menu-stars">
                                                    <span class="on">★</span><span class="on">★</span><span class="on">★</span><span class="on">★</span><span class="on">★</span>
                                                </span>
                                            </span>
                                            <em id="rating5Count">${rating5Count}</em>
                                        </button>

                                        <button type="button" class="review-rating-option" data-rating-filter="4" data-rating-label="★★★★☆">
                                            <span class="rating-option-left">
                                                좋음
                                                <span class="rating-menu-stars">
                                                    <span class="on">★</span><span class="on">★</span><span class="on">★</span><span class="on">★</span><span>★</span>
                                                </span>
                                            </span>
                                            <em id="rating4Count">${rating4Count}</em>
                                        </button>

                                        <button type="button" class="review-rating-option" data-rating-filter="3" data-rating-label="★★★☆☆">
                                            <span class="rating-option-left">
                                                보통
                                                <span class="rating-menu-stars">
                                                    <span class="on">★</span><span class="on">★</span><span class="on">★</span><span>★</span><span>★</span>
                                                </span>
                                            </span>
                                            <em id="rating3Count">${rating3Count}</em>
                                        </button>

                                        <button type="button" class="review-rating-option" data-rating-filter="2" data-rating-label="★★☆☆☆">
                                            <span class="rating-option-left">
                                                별로
                                                <span class="rating-menu-stars">
                                                    <span class="on">★</span><span class="on">★</span><span>★</span><span>★</span><span>★</span>
                                                </span>
                                            </span>
                                            <em id="rating2Count">${rating2Count}</em>
                                        </button>

                                        <button type="button" class="review-rating-option" data-rating-filter="1" data-rating-label="★☆☆☆☆">
                                            <span class="rating-option-left">
                                                나쁨
                                                <span class="rating-menu-stars">
                                                    <span class="on">★</span><span>★</span><span>★</span><span>★</span><span>★</span>
                                                </span>
                                            </span>
                                            <em id="rating1Count">${rating1Count}</em>
                                        </button>

                                    </div>

                                </div>

                            </div>

                            <div class="detail-review-list" id="detailReviewList">

                                <c:forEach var="review" items="${review_list}" varStatus="status">

                                    <c:set var="reviewImageCount" value="${not empty review.imageList ? fn:length(review.imageList) : 0}" />
                                    <c:set var="reviewContentText" value="${empty review.content ? '' : fn:trim(review.content)}" />
                                    <c:set var="reviewContentLength" value="${fn:length(reviewContentText)}" />

                                    <div class="detail-review-card review-card-item"
                                        data-review-index="${status.index}"
                                        data-rating="${empty review.rating ? 0 : review.rating}"
                                        data-photo="${reviewImageCount > 0 ? 'Y' : 'N'}"
                                        data-image-count="${reviewImageCount}"
                                        data-content-length="${reviewContentLength}">

                                        <div class="detail-review-top">

                                            <div class="detail-review-user-area">

                                                <div class="detail-review-profile-box">

                                                    <c:choose>
                                                        <c:when test="${not empty review.photo_name and review.photo_name ne 'no_file'}">
                                                            <img src="/upload/${review.photo_name}" alt="프로필">
                                                        </c:when>

                                                        <c:otherwise>
                                                            <img src="/images/no_profile.png" alt="기본 프로필">
                                                        </c:otherwise>
                                                    </c:choose>

                                                </div>

                                                <div class="detail-review-user-info">

                                                    <div class="detail-review-user-line">
                                                        <span class="detail-review-user-name">
                                                            <c:choose>
                                                                <c:when test="${not empty review.nick_name}">
                                                                    ${review.nick_name}
                                                                </c:when>

                                                                <c:when test="${not empty review.user_name and fn:length(review.user_name) >= 2}">
                                                                    ${fn:substring(review.user_name, 0, 1)}*${fn:substring(review.user_name, 2, fn:length(review.user_name))}
                                                                </c:when>

                                                                <c:otherwise>
                                                                    ${review.user_name}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>

                                                        <span class="detail-review-date">
                                                            <c:choose>
                                                                <c:when test="${not empty review.created_at_text}">
                                                                    ${review.created_at_text}
                                                                </c:when>

                                                                <c:otherwise>
                                                                    ${review.created_at}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>

                                                    <div class="detail-review-star-line">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <c:choose>
                                                                <c:when test="${i <= review.rating}">
                                                                    <span class="detail-star on">★</span>
                                                                </c:when>

                                                                <c:otherwise>
                                                                    <span class="detail-star">★</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </div>

                                                </div>

                                            </div>

                                            <button type="button" class="detail-report-btn" data-report-target-type="REVIEW" data-report-target-id="${review.review_id}">
                                                신고
                                            </button>

                                        </div>

                                        <div class="detail-review-product-info">

                                            <p class="detail-review-product-name">
                                                <c:choose>
                                                    <c:when test="${not empty review.product_name}">
                                                        <c:out value="${review.product_name}" />
                                                    </c:when>

                                                    <c:otherwise>
                                                        <c:out value="${vo.name}" />
                                                    </c:otherwise>
                                                </c:choose>

                                                <c:if test="${not empty review.option_name}">
                                                    , <c:out value="${review.option_name}" />
                                                </c:if>
                                            </p>

                                        </div>

                                        <c:if test="${not empty review.imageList}">
                                            <div class="detail-review-photo-list">

                                                <c:forEach var="image" items="${review.imageList}" varStatus="st">

                                                    <c:set var="reviewImgUrl" value="${empty image.image_url ? '' : fn:trim(image.image_url)}" />

                                                    <c:if test="${st.index < 6 and not empty reviewImgUrl and reviewImgUrl ne 'no_file'}">
                                                        <div class="detail-review-photo-item">
                                                            <c:choose>
                                                                <c:when test="${fn:startsWith(reviewImgUrl, '/upload/')}">
                                                                    <img src="${reviewImgUrl}" alt="리뷰 사진">
                                                                </c:when>

                                                                <c:otherwise>
                                                                    <img src="/upload/${reviewImgUrl}" alt="리뷰 사진">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:if>

                                                </c:forEach>

                                            </div>
                                        </c:if>

                                        <div class="detail-review-content">
                                            <c:out value="${review.content}" />
                                        </div>

                                        <c:if test="${not empty review.reply_content}">
                                            <div class="detail-seller-reply-box">

                                                <div class="detail-seller-reply-head">
                                                    <strong>판매자 답변</strong>

                                                    <c:if test="${not empty review.reply_created_at_text}">
                                                        <span>${review.reply_created_at_text}</span>
                                                    </c:if>
                                                </div>

                                                <div class="detail-seller-reply-content">
                                                    <c:out value="${review.reply_content}" />
                                                </div>

                                            </div>
                                        </c:if>

                                    </div>

                                </c:forEach>

                            </div>

                            <p id="reviewFilterEmpty" class="review-filter-empty" style="display:none;">
                                조건에 맞는 리뷰가 없습니다.
                            </p>

                        </div>

                    </div>

                </c:if>

            </section>

            <section class="product-qna-box store-tab-panel" id="qnaBox">

                <div class="product-qna-header">
                    <h2>상품문의</h2>

                    <a href="/qna_form.do?product_id=${vo.product_id}" class="qna-write-btn">
                        문의하기
                    </a>
                </div>

                <c:choose>
                    <c:when test="${empty qna_list}">
                        <p class="qna-empty">아직 등록된 문의가 없습니다.</p>
                    </c:when>

                    <c:otherwise>

                        <div class="product-qna-list">

                            <c:forEach var="qna" items="${qna_list}">

                                <c:set var="isPrivateQna" value="${qna.is_private == 1}" />
                                <c:set var="isQnaOwner" value="${not empty sessionScope.user and sessionScope.user.user_id == qna.user_id}" />
                                <c:set var="hidePrivateQna" value="${isPrivateQna and not isQnaOwner}" />

                                <div class="qna-item ${isPrivateQna ? 'private-qna-item' : ''}">

                                    <div class="qna-card-top">

                                        <div class="qna-user-area">

                                            <div class="qna-profile-box">

                                                <c:choose>
                                                    <c:when test="${not empty qna.photo_name and qna.photo_name ne 'no_file'}">
                                                        <img src="/upload/${qna.photo_name}" alt="프로필">
                                                    </c:when>

                                                    <c:otherwise>
                                                        <img src="/images/no_profile.png" alt="기본 프로필">
                                                    </c:otherwise>
                                                </c:choose>

                                            </div>

                                            <div class="qna-user-info">

                                                <div class="qna-user-name">
                                                    <c:choose>
                                                        <c:when test="${not empty qna.nick_name}">
                                                            ${qna.nick_name}
                                                        </c:when>

                                                        <c:when test="${not empty qna.user_name and fn:length(qna.user_name) >= 2}">
                                                            ${fn:substring(qna.user_name, 0, 1)}*${fn:substring(qna.user_name, 2, fn:length(qna.user_name))}
                                                        </c:when>

                                                        <c:otherwise>
                                                            ${qna.user_name}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="qna-created-at">
                                                    ${qna.created_at}
                                                </div>

                                            </div>

                                        </div>

                                        <div class="qna-card-actions">

                                            <c:if test="${isPrivateQna}">
                                                <span class="product-qna-open-badge private">🔒 비공개</span>
                                            </c:if>

                                            <button type="button" class="detail-report-btn qna-report-btn" data-report-target-type="QNA" data-report-target-id="${qna.qna_id}">
                                                신고
                                            </button>

                                        </div>

                                    </div>

                                    <div class="qna-question-row">

                                        <div class="qna-question-content">

                                            <c:choose>
                                                <c:when test="${hidePrivateQna}">
                                                    <strong class="private-title">
                                                        비공개 문의입니다.
                                                    </strong>

                                                    <p class="product-qna-private-text">
                                                        🔒 작성자만 확인할 수 있습니다.
                                                    </p>
                                                </c:when>

                                                <c:otherwise>
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${not empty qna.title}">
                                                                <c:out value="${qna.title}" />
                                                            </c:when>

                                                            <c:otherwise>
                                                                문의 내용
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>

                                                    <p class="product-qna-content"><c:out value="${qna.content}" /></p>
                                                </c:otherwise>
                                            </c:choose>

                                        </div>

                                    </div>

                                    <c:choose>
                                        <c:when test="${not empty qna.answer}">

                                            <div class="qna-answer ${isPrivateQna ? 'private-answer' : ''}">

                                                <div class="qna-answer-head">

                                                    <strong>작가의 답변</strong>

                                                    <c:if test="${isPrivateQna}">
                                                        <span class="product-qna-open-badge private answer-private-badge">
                                                            🔒 비공개
                                                        </span>
                                                    </c:if>

                                                </div>

                                                <c:choose>
                                                    <c:when test="${hidePrivateQna}">
                                                        <p class="private-answer-text">
                                                            🔒 비공개 답변입니다. 작성자만 확인할 수 있습니다.
                                                        </p>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <p><c:out value="${qna.answer}" /></p>
                                                    </c:otherwise>
                                                </c:choose>

                                            </div>

                                        </c:when>

                                        <c:otherwise>
                                            <div class="qna-answer waiting-answer">
                                                아직 답변이 등록되지 않았습니다.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                </div>

                            </c:forEach>

                        </div>

                    </c:otherwise>
                </c:choose>

            </section>

        </div>

        <div id="detailReportModalBg" class="qna-report-modal-bg">

            <div class="qna-report-modal">

                <div class="qna-report-modal-head">
                    <h3>신고하기</h3>

                    <button type="button" class="qna-report-close-btn">
                        ×
                    </button>
                </div>

                <input type="hidden" id="reportTargetType">
                <input type="hidden" id="reportTargetId">

                <div class="qna-report-field">
                    <label for="reportType">신고 유형</label>

                    <select id="reportType">
                        <option value="">신고 유형을 선택하세요</option>
                        <option value="SPAM">스팸/홍보성 글</option>
                        <option value="ABUSE">욕설/비방</option>
                        <option value="INAPPROPRIATE">부적절한 내용</option>
                        <option value="FAKE">허위 내용</option>
                        <option value="ETC">기타</option>
                    </select>
                </div>

                <div class="qna-report-field">
                    <label for="reportReason">신고 사유</label>

                    <textarea id="reportReason"
                            placeholder="신고 사유를 입력해주세요."></textarea>
                </div>

                <div class="qna-report-actions">
                    <button type="button" class="qna-report-cancel-btn">
                        취소
                    </button>

                    <button type="button" class="qna-report-submit-btn">
                        신고하기
                    </button>
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