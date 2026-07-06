<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>HANDMADE - 실시간 후기</title>

    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/product/product_card.css">
    <link rel="stylesheet" href="/css/review/live_review_list.css">

    <script src="/js/product_main.js" defer></script>
</head>

<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="live" />
</jsp:include>

<main class="live-review-page">
    <section class="live-review-section">
        <div class="live-review-section-title">
            <h2>실시간 후기</h2>
            <p>방금 도착한 고객들의 생생한 작품 후기를 만나보세요.</p>
        </div>

        <c:choose>
            <c:when test="${empty list}">
                <div class="live-review-empty">
                    아직 작성된 후기가 없습니다.
                </div>
            </c:when>

            <c:otherwise>
                <div class="common-product-wrap live-review-wrap">
                    <c:forEach var="vo" items="${list}">
                        <article class="common-product-card live-review-card">
                            <a href="/product_detail.do?product_id=${vo.product_id}"
                               class="common-image-link live-review-image-link">
                                <c:choose>
                                    <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                        <img src="/upload/${vo.image_l}" alt="${vo.product_name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/images/no_image.png" alt="no image">
                                    </c:otherwise>
                                </c:choose>

                                <span class="live-review-badge">NEW</span>
                            </a>

                            <div class="common-product-info live-review-info">
                                <div class="live-review-meta">
                                    <span class="live-review-user">
                                        <c:choose>
                                            <c:when test="${not empty vo.nick_name}">
                                                <c:out value="${vo.nick_name}" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${vo.user_name}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="live-review-date">
                                        <c:out value="${vo.created_at}" />
                                    </span>
                                </div>

                                <div class="live-review-rating" aria-label="별점 ${vo.rating}점">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span class="${i <= vo.rating ? 'filled' : ''}">
                                            <c:choose>
                                                <c:when test="${i <= vo.rating}">★</c:when>
                                                <c:otherwise>☆</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </c:forEach>
                                </div>

                                <div class="common-product-name live-review-product-name">
                                    <a href="/product_detail.do?product_id=${vo.product_id}">
                                        <c:out value="${vo.product_name}" />
                                    </a>
                                </div>

                                <p class="live-review-content">
                                    <c:out value="${vo.content}" />
                                </p>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty pageMenu}">
            <div class="live-review-page-menu">
                ${pageMenu}
            </div>
        </c:if>
    </section>
</main>

</body>
</html>
