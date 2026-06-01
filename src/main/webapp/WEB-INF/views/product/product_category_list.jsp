<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <script src="/js/product_category_list.js"></script>
</head>

<body>

    <header>
        <div class="product-nav-inner">
            <a href="#" class="disabled">☰ 전체 카테고리</a>
            
            <div class="category-group">
                <a href="/category_list.do?category_id=1">패션/주얼리</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=7">주얼리</a>
                    <a href="/category_list.do?category_id=8">모자/스카프</a>
                    <a href="/category_list.do?category_id=9">아이웨어</a>
                    <a href="/category_list.do?category_id=10">기타</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=2">홈리빙</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=11">조명</a>
                    <a href="/category_list.do?category_id=12">생활용품</a>
                    <a href="/category_list.do?category_id=13">인테리어 소품</a>
                    <a href="/category_list.do?category_id=14">가구</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=3">뷰티</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=15">틴트/립스틱</a>
                    <a href="/category_list.do?category_id=16">베이스 메이크업</a>
                    <a href="/category_list.do?category_id=17">아이 메이크업</a>
                    <a href="/category_list.do?category_id=18">기타</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=4">식품</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=19">식단관리</a>
                    <a href="/category_list.do?category_id=20">초콜릿/젤리/캔디</a>
                    <a href="/category_list.do?category_id=21">간편식</a>
                    <a href="/category_list.do?category_id=22">베이커리</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=5">공예</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=23">비누</a>
                    <a href="/category_list.do?category_id=24">향수</a>
                    <a href="/category_list.do?category_id=25">도자기</a>
                    <a href="/category_list.do?category_id=26">키링</a>
                </div>
            </div>

            <div class="category-group">
                <a href="/category_list.do?category_id=6">반려동물</a>
                <div class="sub-category">
                    <a href="/category_list.do?category_id=27">의류/악세사리</a>
                    <a href="/category_list.do?category_id=28">사료/간식</a>
                    <a href="/category_list.do?category_id=29">산책용품</a>
                    <a href="/category_list.do?category_id=30">장난감</a>
                </div>
            </div>
        </div>
    </header>

    <main>
        <h2>${category_name}</h2>

        <c:forEach var="list" items="${list}">
            <div>
                <img src="${list.image_l}" alt="${list.name}"/>

                <div>
                    <a href="/product_detail.do?product_id=${list.product_id}">
                        ${list.name}
                    </a>
                </div>

                <c:if test="${list.sale_price==0}">
                    <p>
                        <fmt:formatNumber value="${list.price}" pattern="#,###"/>원
                    </p>
                </c:if>

                <c:if test="${list.sale_price>0}">
                    <p>
                        <span style="text-decoration: line-through; color: gray;">
                            <fmt:formatNumber value="${list.price}" pattern="#,###"/>원
                        </span>
                    </p>

                    <p>
                        <strong>${list.sale_rate}% 할인</strong>
                        <fmt:formatNumber value="${list.sale_price}" pattern="#,###"/>원
                    </p>
                </c:if>

                <c:if test="${list.free_shipping>0}">
                    <p>
                        <fmt:formatNumber value="${list.free_shipping}" pattern="#,###"/>원 이상 무료배송
                    </p>
                </c:if>

                <c:if test="${list.free_shipping==0}">
                    <p>무료배송</p>
                </c:if>
            </div>
        </c:forEach>
</main>
</body>
</html>