<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <title>HANDMADE - 실시간 후기</title>

    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/review/live_review_list.css">

    <script src="/js/product_main.js" defer></script>
</head>

<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="live" />
</jsp:include>

<main class="live-review-page">

    <div class="live-review-page-title">
        <h2>실시간 후기</h2>
        <p>고객들이 남긴 따끈한 수제 상품 후기를 최신순으로 만나보세요.</p>
    </div>

    <div class="live-review-top">
        <span>⏱ 최근 후기 순으로 보여드려요.</span>
        <button type="button" onclick="location.reload()">새로고침</button>
    </div>

    <c:choose>

        <c:when test="${empty list}">
            <div class="live-review-empty">
                아직 작성된 후기가 없습니다.
            </div>
        </c:when>

        <c:otherwise>

            <div class="live-review-wrap">

                <c:forEach var="vo" items="${list}">

                    <div class="live-review-card">

                        <div class="live-review-time">
                            <span>NEW</span>
                            <em>${vo.created_at}</em>
                        </div>

                        <a href="/product_detail.do?product_id=${vo.product_id}"
                           class="live-review-image-link">

                            <c:choose>
                                <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                    <img src="${vo.image_l}" alt="${vo.product_name}">
                                </c:when>

                                <c:when test="${not empty vo.image_s and vo.image_s ne 'no_file'}">
                                    <img src="${vo.image_s}" alt="${vo.product_name}">
                                </c:when>

                                <c:otherwise>
                                    <img src="/images/no_image.png" alt="이미지 없음">
                                </c:otherwise>
                            </c:choose>

                        </a>

                        <div class="live-review-info">

                            <div class="live-review-user">
                                <span class="live-review-profile">👤</span>
                                <span class="live-review-name">${vo.user_name}</span>
                                <span class="live-review-like">♡</span>
                            </div>

                            <div class="live-review-rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= vo.rating}">
                                            ★
                                        </c:when>
                                        <c:otherwise>
                                            ☆
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>

                            <div class="live-review-product-name">
                                <a href="/product_detail.do?product_id=${vo.product_id}">
                                    ${vo.product_name}
                                </a>
                            </div>

                            <p class="live-review-content">
                                ${vo.content}
                            </p>

                        </div>

                    </div>

                </c:forEach>

            </div>

        </c:otherwise>

    </c:choose>

    <div class="live-review-page-menu">
        ${pageMenu}
    </div>

</main>

</body>
</html>