<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

            <section class="admin-master-detail is-collapsed" id="adminMasterDetail">
                <div class="admin-card admin-list-panel">
                    <div class="admin-filter-box">
                        <form class="admin-filter-form" action="/admin/products" method="get">
                            <div class="admin-filter-tabs">
                                <a href="/admin/products?status=all&keyword=${keyword}"
                                    class="${status eq 'all' ? 'active' : ''}">전체</a>
                                <a href="/admin/products?status=pending&keyword=${keyword}"
                                    class="${status eq 'pending' ? 'active' : ''}">승인대기</a>
                                <a href="/admin/products?status=approved&keyword=${keyword}"
                                    class="${status eq 'approved' ? 'active' : ''}">판매중</a>
                                <a href="/admin/products?status=rejected&keyword=${keyword}"
                                    class="${status eq 'rejected' ? 'active' : ''}">반려</a>
                                <a href="/admin/products?status=hidden&keyword=${keyword}"
                                    class="${status eq 'hidden' ? 'active' : ''}">숨김</a>
                            </div>
                            <span class="admin-filter-count">전체 ${totalCount}건</span>
                            <input type="hidden" name="status" value="${status}" />
                            <input type="text" class="admin-search" name="keyword" placeholder="상품명, 판매자 검색"
                                value="${keyword}">
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
                                    <tr class="admin-clickable-row" data-product-id="${product.product_id}">
                                        <td>
                                            <span class="admin-thumb">
                                                <img src="/upload/${product.image_l}" />
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
                                        <td>${product.created_at}</td>
                                        <td class="admin-table-actions">
                                            <button type="button" class="admin-btn light admin-detail-btn">상세</button>
                                        </td>
                                    </tr>
                                </c:forEach>

                            </tbody>
                        </table>
                    </div>
                </div>

                <aside class="admin-card admin-detail-panel" id="adminDetailPanel" aria-labelledby="productDetailTitle">
                    <div class="admin-detail-panel-inner">
                        <div class="admin-detail-content" hidden>
                            <div class="admin-detail-head">
                                <div>
                                    <span class="admin-page-label">PRODUCT DETAIL</span>
                                    <h2 id="productDetailTitle">상품 상세</h2>
                                </div>
                                <button type="button" class="admin-detail-close" aria-label="닫기">&times;</button>
                            </div>
                            <dl class="admin-detail-grid">
                                <div>
                                    <dt>상품번호</dt>
                                    <dd id="productId">-</dd>
                                </div>
                                <div>
                                    <dt>판매자번호</dt>
                                    <dd id="sellerId">-</dd>
                                </div>
                                <div>
                                    <dt>카테고리번호</dt>
                                    <dd id="categoryName">-</dd>
                                </div>
                                <div>
                                    <dt>상품명</dt>
                                    <dd id="productName">-</dd>
                                </div>
                                <div>
                                    <dt>설명</dt>
                                    <dd id="description">-</dd>
                                </div>
                                <div>
                                    <dt>가격</dt>
                                    <dd id="price">-</dd>
                                </div>
                                <div>
                                    <dt>할인가</dt>
                                    <dd id="salePrice">-</dd>
                                </div>
                                <div>
                                    <dt>재고</dt>
                                    <dd id="stock">-</dd>
                                </div>
                                <div>
                                    <dt>대표이미지</dt>
                                    <dd id="imageL">-</dd>
                                </div>
                                <div>
                                    <dt>생성일</dt>
                                    <dd id="createdAt">-</dd>
                                </div>
                                <div>
                                    <dt>수정일</dt>
                                    <dd id="updatedAt">-</dd>
                                </div>
                                <div>
                                    <dt>무료배송금액</dt>
                                    <dd id="freeShipping">-</dd>
                                </div>
                                <div>
                                    <dt>할인가 수정일</dt>
                                    <dd id="salePriceUpdatedAt">-</dd>
                                </div>
                                <div>
                                    <dt>할인 시작일</dt>
                                    <dd id="saleStartAt">-</dd>
                                </div>
                                <div>
                                    <dt>할인 종료일</dt>
                                    <dd id="saleEndAt">-</dd>
                                </div>
                            </dl>
                        </div>
                    </div>
                </aside>
            </section>
        </main>
    </div>
</body>

</html>
