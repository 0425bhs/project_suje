<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<aside class="seller-sidebar">

    <div class="sidebar-logo">
        <a href="/product/main.do">HAND<span>MADE</span></a>
    </div>

    <div class="sidebar-title">
        ${empty param.sidebarTitle ? '판매자 센터' : param.sidebarTitle}
    </div>

    <nav class="sidebar-menu">

        <a href="/seller_dashboard.do" class="${param.activeMenu eq 'dashboard' ? 'menu-active':''}">
            판매자 대시보드
        </a>

        <a href="/seller_product_list.do" class="${param.activeMenu eq 'productList' ? 'menu-active':''}">
            내 상품 관리
        </a>

        <a href="/seller_product_insert.do" class="${param.activeMenu eq 'productInsert' ? 'menu-active':''}">
            상품 등록
        </a>

        <a href="/seller_order_list.do" class="${param.activeMenu eq 'orderList' ? 'menu-active':''}">
            판매자 주문 관리
        </a>

        <a href="/seller_review_list.do" class="${param.activeMenu eq 'reviewList' ? 'menu-active':''}">
            상품 리뷰 관리
        </a>

        <a href="/seller_qna_list.do" class="${param.activeMenu eq 'qnaList' ? 'menu-active':''}">
            상품 문의 답변 관리
        </a>

        <a href="/seller_statistics.do" class="${param.activeMenu eq 'statisty' ? 'menu-active':''}">
            판매자 매출 통계
        </a>

    </nav>

    <div class="sidebar-bottom">
        <a href="/product/main.do">쇼핑몰로 이동</a>
    </div>

</aside>