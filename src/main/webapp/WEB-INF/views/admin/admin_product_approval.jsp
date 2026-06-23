<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 상품 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="products" />
        <jsp:param name="sidebarTitle" value="상품 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">PRODUCT MANAGEMENT</span>
                <h1>상품 관리</h1>
                <p>등록된 상품 정보를 확인하고 판매 상태를 빠르게 파악합니다.</p>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <form class="admin-filter-form" action="/admin/products" method="get">
                    <div class="admin-filter-tabs">
                        <a href="/admin/products?status=all&keyword=${keyword}" class="${status eq 'all' ? 'active' : ''}">전체</a>
                        <a href="/admin/products?status=pending&keyword=${keyword}" class="${status eq 'pending' ? 'active' : ''}">승인대기</a>
                        <a href="/admin/products?status=approved&keyword=${keyword}" class="${status eq 'approved' ? 'active' : ''}">판매중</a>
                        <a href="/admin/products?status=rejected&keyword=${keyword}" class="${status eq 'rejected' ? 'active' : ''}">반려</a>
                        <a href="/admin/products?status=hidden&keyword=${keyword}" class="${status eq 'hidden' ? 'active' : ''}">숨김</a>
                    </div>
                    <input type="hidden" name="status" value="${status}"/>
                    <input type="text" class="admin-search" name="keyword" 
                           placeholder="상품명, 판매자 검색" value="${keyword}">
                </form>
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th>이미지</th>
                        <th>상품명</th>
                        <th>판매자</th>
                        <th>카테고리</th>
                        <th>가격</th>
                        <th>상태</th>
                        <th>등록일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="product" items="${productList}">
                    <tr>
                        <td>
                            <span class="admin-thumb">
                                <img src="/upload/${product.image_l}"/>
                            </span>
                        </td>
                        <td class="left"><strong>${product.name}</strong></td>
                        <td>${product.company_name}</td>
                        <td>${product.category_name}</td>
                        <td>${product.price}</td>
                        <td>
                            <c:choose>
                                <c:when test="${product.status eq 'PENDING'}">
                                    <span class="admin-status pending">승인대기</span>
                                </c:when>

                                <c:when test="${product.status eq 'APPROVED'}">
                                    <span class="admin-status approved">판매중</span>
                                </c:when>

                                <c:when test="${product.status eq 'REJECTED'}">
                                    <span class="admin-status rejected">반려</span>
                                </c:when>

                                <c:when test="${product.status eq 'HIDDEN'}">
                                    <span class="admin-status hidden">숨김</span>
                                </c:when>

                                <c:otherwise>
                                    <span class="admin-status muted">${product.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>2026-06-16</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                        </td>
                    </tr>
                    </c:forEach>

                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
