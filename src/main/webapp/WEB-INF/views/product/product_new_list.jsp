<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <title>
            <c:choose>
                <c:when test="${isSearch}">
                    HANDMADE - ${keyword} 검색 결과
                </c:when>
                <c:otherwise>
                    HANDMADE - 신제품
                </c:otherwise>
            </c:choose>
        </title>
        <!-- 메인 상단바 공통 CSS -->
        <link rel="stylesheet" href="/css/product/product_main.css">

        <!-- 신제품 전용 CSS -->
        <link rel="stylesheet" href="/css/product/product_new_list.css">

        <!-- 전체 카테고리 열고 닫는 JS -->
        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <!-- 공통 헤더 include: 상단 메뉴 및 카테고리 영역 렌더링 -->
   <jsp:include page="/WEB-INF/views/product/product_header.jsp">
      <jsp:param name="activeMenu" value="${isSearch ? 'search' : 'new'}" />
   </jsp:include>

    <main class="new-page">

        <div class="new-page-title">
            <c:choose>
                <c:when test="${isSearch}">
                    <h2>'${keyword}'에 대한 검색결과</h2>
                </c:when>

                <c:otherwise>
                    <h2>신제품</h2>
                    <p>새롭게 등록된 상품을 최신순으로 확인할 수 있습니다.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${isSearch}">
            <div class="search-control-wrap simple-search">

                <div class="search-filters">
                    <button type="button" class="filter">쿠폰/할인 ⌄</button>
                    <button type="button" class="filter">예상출발일 ⌄</button>
                    <button type="button" class="filter">가격대 ⌄</button>
                    <button type="button" class="filter">작품 특징 ⌄</button>
                    <button type="button" class="filter">카테고리 ⌄</button>
                </div>

                <div class="search-sorts">
                    <div class="sort-pills">
                        <button class="pill active">인기순 <span class="info">ⓘ</span></button>
                        <span class="sep">|</span>
                        <button class="pill">최신순(NEW)</button>
                        <span class="sep">|</span>
                        <button class="pill">찜 많은순</button>
                        <span class="sep">|</span>
                        <button class="pill">판매수 많은순</button>
                        <span class="sep">|</span>
                        <button class="pill">할인율 높은순</button>
                        <span class="sep">|</span>
                        <button class="pill">낮은 가격순</button>
                        <span class="sep">|</span>
                        <button class="pill">높은 가격순</button>
                    </div>

                    <label class="search-view-toggle">
                        <input type="checkbox" /> 이미지만 볼래요
                    </label>
                </div>

                <div class="search-stats">총 ${rowTotal}개</div>

            </div>
        </c:if>

        <!-- 상품 목록 존재 여부에 따라 내용 분기 -->
        <c:choose>

            <c:when test="${empty list}">
                <div class="new-empty">
                    <c:choose>
                        <c:when test="${isSearch}">
                            '${keyword}'에 대한 검색 결과가 없습니다.
                        </c:when>
                        <c:otherwise>
                            등록된 신제품이 없습니다.
                        </c:otherwise>
                    </c:choose>
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

        <div class="new-page-menu">
            ${pageMenu}
        </div>

    </main>

    </body>
</html>