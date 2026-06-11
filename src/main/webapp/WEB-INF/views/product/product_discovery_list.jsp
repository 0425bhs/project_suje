<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>HANDMADE - 취향발견</title>

        <!-- 메인 상단바 공통 CSS -->
        <link rel="stylesheet" href="/css/product/product_main.css">
        
        <link rel="stylesheet" href="/css/product/product_card.css">

        <!-- 취향발견 전용 CSS -->
        <link rel="stylesheet" href="/css/product/product_discovery_list.css">

        <!-- 전체 카테고리 열고 닫는 JS -->
        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="discovery" />
    </jsp:include>


    <main class="discovery-page">

        <!-- 카테고리 바로가기 -->
        <section class="discovery-category-section">

            <div class="discovery-section-title">
                <h3>카테고리로 더 둘러보기</h3>
            </div>

        </section>


        <!-- 추천 상품 목록 -->
        <section class="discovery-list-section">

            <div class="discovery-section-title">
                <h3>추천 작품</h3>

                <c:choose>
                    <c:when test="${isFallback}">
                        <p>취향 기록이 쌓이기 전까지는 최신 작품을 보여드립니다.</p>
                    </c:when>

                    <c:otherwise>
                        <p>최근 본 카테고리와 비슷한 작품을 모았습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>


            <c:choose>

                <c:when test="${empty list}">
                    <div class="discovery-empty">
                        추천할 상품이 없습니다.
                    </div>
                </c:when>

                <c:otherwise>

                    <div class="common-product-wrap">

                        <c:forEach var="vo" items="${list}">

                            <%@ include file="/WEB-INF/views/product/product_card.jspf" %>

                        </c:forEach>

                    </div>

                </c:otherwise>

            </c:choose>

        </section>

    </main>

    </body>
</html>