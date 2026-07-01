<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 상품 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
    <script src="/js/admin_detail_common.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const master = document.getElementById("adminMasterDetail");
            const rows = document.querySelectorAll(".admin-clickable-row");

            rows.forEach((row) => {
                row.addEventListener("click", () => {
                    if (!master.classList.contains("is-collapsed") && row.classList.contains("selected")) {
                        closeDetailPanel(master, row);
                        return;
                    }

                    openDetailPanel(master, rows, row);

                    const productId = row.dataset.productId;

                    fetch("/admin/products/detail?product_id=" + encodeURIComponent(productId))
                    .then(res => res.json())
                    .then(data => {
                        const product = data.product;

                        setText("productId", product.product_id);
                        setText("productName", product.name);
                        setText("companyName", product.company_name);
                        setText("sellerId", product.seller_id);
                        setText("categoryId", product.category_name || product.category_id);
                        // setText("description", product.description);
                        setText("price", product.price);
                        setText("salePrice", product.sale_price);
                        setText("stock", product.stock);
                        setText("deliveryFee", product.delivery_fee);
                        setText("status", product.status);
                        document.getElementById("imageL").src = "/upload/" + product.image_l;
                        setText("createdAt", product.created_at);
                        setText("updatedAt", product.updated_at);
                        setText("freeShipping", product.free_shipping);
                        setText("salePriceUpdatedAt", product.sale_price_updated_at);
                        setText("saleStartAt", product.sale_start_at);
                        setText("saleEndAt", product.sale_end);
                        highlightAdminKeyword(document.getElementById("adminDetailPanel"));
                        
                    })
                })
            })
        })
    </script>
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

            <div class="admin-filter-box admin-filter-modern">
                <form class="admin-filter-form" action="/admin/products" method="get">
                    <div class="admin-filter-main-row">
                        <div class="admin-filter-tabs">
                            <a href="/admin/products?status=all&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                class="${status eq 'all' ? 'active' : ''}">전체</a>
                            <a href="/admin/products?status=pending&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                class="${status eq 'pending' ? 'active' : ''}">승인대기</a>
                            <a href="/admin/products?status=approved&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                class="${status eq 'approved' ? 'active' : ''}">판매중</a>
                            <a href="/admin/products?status=rejected&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                class="${status eq 'rejected' ? 'active' : ''}">반려</a>
                            <a href="/admin/products?status=hidden&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                class="${status eq 'hidden' ? 'active' : ''}">숨김</a>
                        </div>

                        <div class="admin-search-wrap">
                            <input type="text" id="keyword" class="admin-search" name="keyword"
                                placeholder="상품명, 판매자 검색" value="${keyword}">
                            <span class="admin-search-icon" aria-hidden="true"></span>
                        </div>
                        <button type="submit" class="admin-btn admin-search-submit">검색</button>
                        <button type="button" class="admin-btn light admin-filter-toggle">상세 검색</button>
                        <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                            <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                            <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                            <option value="name" ${sort eq 'name' ? 'selected' : ''}>이름순</option>
                        </select>
                        <select id="pageSize" class="admin-filter-control admin-page-size-control" name="size">
                            <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                            <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                            <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                        </select>
                    </div>

                    <div class="admin-filter-detail-row">
                        <label class="admin-filter-field">
                            <span>상태</span>
                            <select class="admin-filter-control" name="status">
                                <option value="all" ${status eq 'all' ? 'selected' : ''}>전체</option>
                                <option value="pending" ${status eq 'pending' ? 'selected' : ''}>승인대기</option>
                                <option value="approved" ${status eq 'approved' ? 'selected' : ''}>판매중</option>
                                <option value="rejected" ${status eq 'rejected' ? 'selected' : ''}>반려</option>
                                <option value="hidden" ${status eq 'hidden' ? 'selected' : ''}>숨김</option>
                            </select>
                        </label>
                        <label class="admin-filter-field admin-filter-date-range">
                            <span>등록일 범위</span>
                            <input type="date" class="admin-filter-control" name="startDate" value="${startDate}">
                            <em>~</em>
                            <input type="date" class="admin-filter-control" name="endDate" value="${endDate}">
                        </label>
                        <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                    </div>

                    <c:if test="${status ne 'all' || not empty keyword || not empty startDate || not empty endDate}">
                        <div class="admin-filter-applied">
                            <span class="admin-filter-applied-label">적용된 조건:</span>
                            <c:if test="${status ne 'all'}">
                                <a class="admin-filter-chip"
                                    href="/admin/products?status=all&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                    상태:
                                    ${status eq 'pending' ? '승인대기' : status eq 'approved' ? '판매중' : status eq 'rejected' ? '반려' : '숨김'}
                                    <span aria-hidden="true">&times;</span>
                                </a>
                            </c:if>
                            <c:if test="${not empty keyword}">
                                <a class="admin-filter-chip" href="/admin/products?status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                    검색어: ${keyword}
                                    <span aria-hidden="true">&times;</span>
                                </a>
                            </c:if>
                            <c:if test="${not empty startDate || not empty endDate}">
                                <a class="admin-filter-chip" href="/admin/products?status=${status}&keyword=${keyword}&sort=${sort}&size=${pagination.size}&page=1">
                                    등록일: ${startDate} ~ ${endDate}
                                    <span aria-hidden="true">&times;</span>
                                </a>
                            </c:if>
                            <a class="admin-filter-clear" href="/admin/products">전체 해제</a>
                        </div>
                    </c:if>

                    <input type="hidden" name="page" value="1">
                </form>
            </div>

            <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
                <div class="admin-card admin-list-panel">
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
                                        <td class="left admin-highlight-target"><strong>${product.name}</strong></td>
                                        <td class="admin-highlight-target">${product.company_name}</td>
                                        <td class="admin-highlight-target">${product.category_name}</td>
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

                <aside class="admin-card admin-detail-panel" id="adminDetailPanel">
                    <div class="admin-detail-panel-inner">
                        <div class="admin-detail-content">
                            <div class="admin-detail-head">
                                <div>
                                    <span class="admin-page-label">PRODUCT DETAIL</span>
                                    <h2 id="productDetailTitle">상품 상세</h2>
                                </div>
                                <button type="button" class="admin-detail-close" aria-label="닫기">&times;</button>
                            </div>
                            <dl class="admin-detail-grid">
                                <div>
                                    <dt>대표 이미지</dt>
                                    <dd>
                                        <img id="imageL" src="" alt="대표이미지" style="width:80px;">
                                    </dd>
                                </div>      
                                <div>
                                    <dt>상품번호</dt>
                                    <dd id="productId">-</dd>
                                </div>
                                <div>
                                    <dt>상품명</dt>
                                    <dd id="productName" class="admin-highlight-target">-</dd>
                                </div>
                                <div>
                                    <dt>판매자</dt>
                                    <dd id="companyName" class="admin-highlight-target">-</dd>
                                </div>
                                <div>
                                    <dt>판매자번호</dt>
                                    <dd id="sellerId">-</dd>
                                </div>
                                <div>
                                    <dt>카테고리번호</dt>
                                    <dd id="categoryId">-</dd>
                                </div>
                                
                                <!-- <div>
                                    <dt>설명</dt>
                                    <dd id="description">-</dd>
                                </div> -->
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
                                    <dt>배송비</dt>
                                    <dd id="deliveryFee">-</dd>
                                </div>
                                <div>
                                    <dt>상태</dt>
                                    <dd id="status">-</dd>
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

            <div class="admin-pagination">
                <div class="admin-pagination-pages">
                    <c:if test="${pagination.totalPage > 0}">
                        <c:if test="${pagination.hasPrev}">
                            <a href="/admin/products?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                                이전
                            </a>
                        </c:if>
                        <c:if test="${!pagination.hasPrev}">
                            <span class="disabled">이전</span>
                        </c:if>

                        <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                            <a href="/admin/products?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                                class="${pagination.page == i ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:forEach>

                        <c:if test="${pagination.hasNext}">
                            <a href="/admin/products?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
                                다음
                            </a>
                        </c:if>
                        <c:if test="${!pagination.hasNext}">
                            <span class="disabled">다음</span>
                        </c:if>
                    </c:if>
                </div>
                <span class="admin-filter-count">전체 ${totalCount}건</span>
            </div>
        </main>
    </div>
</body>

</html>
