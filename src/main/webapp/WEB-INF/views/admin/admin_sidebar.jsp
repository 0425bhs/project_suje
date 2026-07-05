<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="admin-sidebar">

    <div class="admin-sidebar-logo">
        <a href="/">HAND<span>MADE</span></a>
    </div>

    <div class="admin-sidebar-title">
        ${empty param.sidebarTitle ? '관리자 센터' : param.sidebarTitle}
    </div>

    <nav class="admin-sidebar-menu">
        <a href="/admin/dashboard" class="${param.activeMenu eq 'dashboard' ? 'menu-active' : ''}">
            <i class="bi bi-sliders"></i>
            <span>관리자 대시보드</span>
        </a>
        <a href="/admin/sellers" class="${param.activeMenu eq 'sellers' ? 'menu-active' : ''}">
            <i class="bi bi-shop"></i>
            <span>판매자 관리</span>
        </a>
        <a href="/admin/products" class="${param.activeMenu eq 'products' ? 'menu-active' : ''}">
            <i class="bi bi-box-seam"></i>
            <span>상품 관리</span>
        </a>
        <a href="/admin/reports" class="${param.activeMenu eq 'reports' ? 'menu-active' : ''}">
            <i class="bi bi-flag"></i>
            <span>신고 관리</span>
        </a>
        <a href="/admin/inquiries" class="${param.activeMenu eq 'inquiries' ? 'menu-active' : ''}">
            <i class="bi bi-chat-square-text"></i>
            <span>문의 관리</span>
        </a>
        <a href="/admin/action-logs" class="${param.activeMenu eq 'actionLogs' ? 'menu-active' : ''}">
            <i class="bi bi-clock-history"></i>
            <span>처리 내역</span>
        </a>
        <a href="/admin/members" class="${param.activeMenu eq 'members' ? 'menu-active' : ''}">
            <i class="bi bi-people"></i>
            <span>회원 관리</span>
        </a>
        <a href="/admin/reviews" class="${param.activeMenu eq 'reviews' ? 'menu-active' : ''}">
            <i class="bi bi-chat-dots-fill"></i>
            <span>후기 관리</span>
        </a>
        <a href="/admin/orders" class="${param.activeMenu eq 'orders' ? 'menu-active' : ''}">
            <i class="bi bi-receipt"></i>
            <span>주문 관리</span>
        </a>
        <a href="/admin/categories" class="${param.activeMenu eq 'categories' ? 'menu-active' : ''}">
            <i class="bi bi-grid"></i>
            <span>카테고리 관리</span>
        </a>
        <a href="/admin/notices" class="${param.activeMenu eq 'notices' ? 'menu-active' : ''}">
            <i class="bi bi-megaphone"></i>
            <span>공지사항 관리</span>
        </a>
    </nav>

    <div class="admin-sidebar-bottom">
        <a href="/product/main.do">
            <span class="admin-sidebar-bottom-left">
                <i class="bi bi-bag"></i>
                <span>쇼핑몰로 이동</span>
            </span>
            <i class="bi bi-chevron-right admin-sidebar-bottom-arrow"></i>
        </a>
    </div>

</aside>
