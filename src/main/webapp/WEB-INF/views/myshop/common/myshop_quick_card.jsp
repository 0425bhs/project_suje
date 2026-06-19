<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<section class="myshop-quick-card">

    <!-- 중요: 배송중 필터 -->
    <button type="button" onclick="location.href='/myshop/orders'">
        <span>📦</span>
        <strong>주문/배송조회</strong>
    </button>

    <!-- 준비중: 내 리뷰 -->
    <button type="button"
            onclick="location.href='/myshop/reviews'">
        <span>⭐</span>
        <strong>리뷰관리</strong>
    </button>

    <!-- 준비중: 내 문의 -->
    <button type="button"
            onclick="location.href='/myshop/qnas'">
        <span>💬</span>
        <strong>문의내역</strong>
    </button>

    <!-- 준비중: 찜한 상품 -->
    <button type="button"
            onclick="location.href='/myshop/my_favorite_list.do'">
        <span>♡</span>
        <strong>찜한상품</strong>
    </button>

</section>
