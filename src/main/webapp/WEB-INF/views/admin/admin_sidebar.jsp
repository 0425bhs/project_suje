<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="admin-sidebar">

    <div class="admin-sidebar-logo">
        <a href="/admin/dashboard">HAND<span>MADE</span></a>
    </div>

    <div class="admin-sidebar-title">
        ${empty param.sidebarTitle ? '관리자 센터' : param.sidebarTitle}
    </div>

    <nav class="admin-sidebar-menu">
        <a href="/admin/dashboard" class="${param.activeMenu eq 'dashboard' ? 'menu-active' : ''}">
            관리자 대시보드(미구현)
        </a>
        <a href="/admin/members" class="${param.activeMenu eq 'members' ? 'menu-active' : ''}">
            회원 관리(진행중)
        </a>
        <a href="/admin/sellers" class="${param.activeMenu eq 'sellers' ? 'menu-active' : ''}">
            판매자 관리(진행중)
        </a>
        <a href="/admin/products" class="${param.activeMenu eq 'products' ? 'menu-active' : ''}">
            상품 관리(진행중)
        </a>
        <a href="/admin/reviews" class="${param.activeMenu eq 'reviews' ? 'menu-active' : ''}">
            후기 관리(진행중)
        </a>
        <a href="/admin/inquiries" class="${param.activeMenu eq 'inquiries' ? 'menu-active' : ''}">
            고객센터 문의 관리(진행중)
        </a>
        <a href="/admin/reports" class="${param.activeMenu eq 'reports' ? 'menu-active' : ''}">
            신고 관리(진행중)
        </a>
        <a href="/admin/categories" class="${param.activeMenu eq 'categories' ? 'menu-active' : ''}">
            카테고리 관리(진행중)
        </a>
        <a href="/admin/notices" class="${param.activeMenu eq 'notices' ? 'menu-active' : ''}">
            공지사항 관리(진행중)
        </a>
        <a href="/admin/statistics" class="${param.activeMenu eq 'statistics' ? 'menu-active' : ''}">
            기본 통계(미구현)
        </a>
    </nav>

    <div class="admin-sidebar-bottom">
        <a href="/product/main.do">쇼핑몰로 이동</a>
    </div>

</aside>
