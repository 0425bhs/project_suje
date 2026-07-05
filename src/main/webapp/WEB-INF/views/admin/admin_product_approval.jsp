<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                            const statusLabels = {
                                PENDING: "승인대기",
                                APPROVED: "판매중",
                                REJECTED: "반려",
                                HIDDEN: "숨김"
                            };

                            function formatProductPrice(value) {
                                const number = Number(value || 0);

                                return number.toLocaleString("ko-KR") + "원";
                            }

                            function getProductImageSrc(imageName) {
                                const value = String(imageName || "").trim();
                                return "/upload/" + value;
                            }

                            function setProductImage(product) {
                                const image = document.getElementById("imageL");

                                if (!image) {
                                    return;
                                }

                                image.src = getProductImageSrc(product.image_l);
                                image.alt = product.name || "product image";
                            }

                            function renderProductOptions(options) {
                                const target = document.getElementById("productOptions");

                                if (!target) {
                                    return;
                                }

                                if (!options || !options.length) {
                                    target.textContent = "없음";
                                    return;
                                }

                                const list = document.createElement("div");
                                list.className = "admin-product-option-list";

                                options.forEach((option) => {
                                    const row = document.createElement("div");
                                    row.className = "admin-product-option-item";
                                    row.innerHTML =
                                        "<dt>" + (option.option_name || "없음") + "</dt>" +
                                        "<dd>추가금액 " + formatProductPrice(option.option_price) +
                                        " · 재고 " + (option.option_stock || 0) + "</dd>";
                                    list.appendChild(row);
                                });

                                target.replaceChildren(list);
                            }
                            const managePanel = initAdminDetailManage({
                                targetType: "PRODUCT",
                                statusUrl: "/admin/products/status",
                                idParam: "product_id",
                                statusBadgeId: "productDetailStatusBadge",
                                statusLabels
                            });

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
                                            const statusKey = String(product.status || "").toUpperCase();
                                            const statusLabel = statusLabels[statusKey] || "알 수 없음";

                                            setDetailTitleBlock(
                                                "productDetailTitle",
                                                "productDetailMeta",
                                                product.name || "상품 상세",
                                                (product.company_name || "-") + " · " + (product.category_name || "-")
                                            );
                                            setDetailStatusBadge("productDetailStatusBadge", product.status, statusLabel);
                                            setText("productName", product.name);
                                            setText("companyName", product.company_name);
                                            setText("categoryId", product.category_name || product.category_id);
                                            // setText("description", product.description);
                                            setText("price", formatProductPrice(product.price));
                                            setText("salePrice", formatProductPrice(product.sale_price));
                                            setText("stock", product.stock);
                                            setText("deliveryFee", formatProductPrice(product.delivery_fee));
                                            setText("status", statusLabel);
                                            setProductImage(product);
                                            setText("createdAt", product.created_at);
                                            setText("updatedAt", product.updated_at);
                                            setText("freeShipping", formatProductPrice(product.free_shipping));
                                            setText("salePriceUpdatedAt", product.sale_price_updated_at);
                                            setText("saleStartAt", product.sale_start_at);
                                            setText("saleEndAt", product.sale_end_at);
                                            setText("reviewCount", product.review_count);
                                            setText("orderCount", product.order_count);
                                            setText("salesQuantity", product.sales_quantity);
                                            setText("favoriteCount", product.favorite_count);
                                            setText("reportCount", product.report_count);
                                            renderProductOptions(data.optionList);
                                            managePanel.setTarget(product.product_id, statusKey, row);

                                            document.getElementById("productSellerLink").href =
                                                "/admin/sellers?seller_id=" + encodeURIComponent(product.seller_id);
                                            document.getElementById("productReviewLink").href =
                                                "/admin/reviews?product_id=" + encodeURIComponent(product.product_id);
                                            document.getElementById("productOrderLink").href =
                                                "/admin/orders?product_id=" + encodeURIComponent(product.product_id);
                                            document.getElementById("productReportLink").href =
                                                "/admin/reports?targetType=PRODUCT&target_id=" + encodeURIComponent(product.product_id);
                                            document.getElementById("productPublicLink").href =
                                                "/product_detail.do?product_id=" + encodeURIComponent(product.product_id);

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

                        <main class="admin-main admin-main-fixed">
                            <header class="admin-main-header">
                                <div>
                                    <span class="admin-page-label">PRODUCT MANAGEMENT</span>
                                    <h1>상품 관리</h1>
                                </div>
                            </header>

                            <div class="admin-fixed-list-layout">
                                <div class="admin-filter-box admin-filter-modern">
                                    <form class="admin-filter-form" action="/admin/products" method="get">
                                        <div class="admin-filter-main-row">
                                            <div class="admin-filter-tabs">
                                                <a href="/admin/products?status=all&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                                    class="${status eq 'all' ? 'active' : ''}">전체</a>
                                                <a href="/admin/products?status=pending&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                                    class="${status eq 'pending' ? 'active' : ''}">승인대기</a>
                                                <a href="/admin/products?status=approved&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                                    class="${status eq 'approved' ? 'active' : ''}">판매중</a>
                                                <a href="/admin/products?status=rejected&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                                    class="${status eq 'rejected' ? 'active' : ''}">반려</a>
                                                <a href="/admin/products?status=hidden&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                                    class="${status eq 'hidden' ? 'active' : ''}">숨김</a>
                                            </div>

                                            <div class="admin-search-wrap">
                                                <input type="text" id="keyword" class="admin-search" name="keyword"
                                                    placeholder="상품명, 판매자 검색" value="${keyword}">
                                                <span class="admin-search-icon" aria-hidden="true"></span>
                                            </div>
                                            <button type="submit" class="admin-btn admin-search-submit">검색</button>
                                            <button type="button" class="admin-btn light admin-filter-toggle">상세
                                                검색</button>
                                            <select class="admin-filter-control admin-sort-control" id="sort"
                                                name="sort">
                                                <option value="latest" ${sort eq 'latest' ? 'selected' : '' }>최신순
                                                </option>
                                                <option value="oldest" ${sort eq 'oldest' ? 'selected' : '' }>오래된순
                                                </option>
                                                <option value="name" ${sort eq 'name' ? 'selected' : '' }>이름순</option>
                                                <option value="reviews" ${sort eq 'reviews' ? 'selected' : '' }>후기 많은 순
                                                </option>
                                                <option value="orders" ${sort eq 'orders' ? 'selected' : '' }>주문 많은 순
                                                </option>
                                                <option value="favorites" ${sort eq 'favorites' ? 'selected' : '' }>찜 많은
                                                    순</option>
                                            </select>
                                            <select id="pageSize" class="admin-filter-control admin-page-size-control"
                                                name="size">
                                                <option value="10" ${pagination.size==10 ? 'selected' : '' }>10개씩
                                                </option>
                                                <option value="30" ${pagination.size==30 ? 'selected' : '' }>30개씩
                                                </option>
                                                <option value="50" ${pagination.size==50 ? 'selected' : '' }>50개씩
                                                </option>
                                            </select>
                                        </div>

                                        <div class="admin-filter-detail-row">
                                            <label class="admin-filter-field">
                                                <span>상태</span>
                                                <select class="admin-filter-control" name="status">
                                                    <option value="all" ${status eq 'all' ? 'selected' : '' }>전체
                                                    </option>
                                                    <option value="pending" ${status eq 'pending' ? 'selected' : '' }>
                                                        승인대기</option>
                                                    <option value="approved" ${status eq 'approved' ? 'selected' : '' }>
                                                        판매중</option>
                                                    <option value="rejected" ${status eq 'rejected' ? 'selected' : '' }>
                                                        반려</option>
                                                    <option value="hidden" ${status eq 'hidden' ? 'selected' : '' }>숨김
                                                    </option>
                                                </select>
                                            </label>
                                            <label class="admin-filter-field admin-filter-date-range">
                                                <span>등록일 범위</span>
                                                <input type="date" class="admin-filter-control" name="startDate"
                                                    value="${startDate}">
                                                <em>~</em>
                                                <input type="date" class="admin-filter-control" name="endDate"
                                                    value="${endDate}">
                                            </label>
                                            <label class="admin-filter-field">
                                                <span>카테고리</span>
                                                <select class="admin-filter-control" name="category_id">
                                                    <option value="">전체</option>
                                                    <c:forEach var="category" items="${categoryList}">
                                                        <option value="${category.category_id}"
                                                            ${category_id==category.category_id ? 'selected' : '' }>
                                                            ${category.name}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </label>
                                            <label class="admin-filter-field admin-filter-date-range">
                                                <span>가격 범위</span>
                                                <input type="number" class="admin-filter-control" name="minPrice"
                                                    value="${minPrice}" min="0" placeholder="최소">
                                                <em>~</em>
                                                <input type="number" class="admin-filter-control" name="maxPrice"
                                                    value="${maxPrice}" min="0" placeholder="최대">
                                            </label>
                                            <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                                        </div>

                                        <c:if
                                            test="${status ne 'all' || not empty keyword || not empty seller_id || not empty product_id || not empty category_id || not empty minPrice || not empty maxPrice || not empty startDate || not empty endDate}">
                                            <div class="admin-filter-applied">
                                                <span class="admin-filter-applied-label">적용된 조건:</span>
                                                <c:if test="${status ne 'all'}">
                                                    <a class="admin-filter-chip"
                                                        href="/admin/products?status=all&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                                        상태:
                                                        ${status eq 'pending' ? '승인대기' : status eq 'approved' ? '판매중' :
                                                        status eq 'rejected' ? '반려' : '숨김'}
                                                        <span aria-hidden="true">&times;</span>
                                                    </a>
                                                </c:if>
                                                <c:if test="${not empty keyword}">
                                                    <a class="admin-filter-chip"
                                                        href="/admin/products?status=${status}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                                        검색어: ${keyword}
                                                        <span aria-hidden="true">&times;</span>
                                                    </a>
                                                </c:if>
                                                <c:if test="${not empty seller_id}">
                                                    <a class="admin-filter-chip"
                                                        href="/admin/products?status=${status}&keyword=${keyword}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                                        판매자:
                                                        <c:choose>
                                                            <c:when test="${not empty filterSeller}">
                                                                ${filterSeller.company_name} ·
                                                                ${filterSeller.representative_name}
                                                            </c:when>
                                                            <c:otherwise>${seller_id}</c:otherwise>
                                                        </c:choose>
                                                        <span aria-hidden="true">&times;</span>
                                                    </a>
                                                </c:if>
                                                <c:if test="${not empty product_id}">
                                                    <a class="admin-filter-chip"
                                                        href="/admin/products?status=${status}&keyword=${keyword}&seller_id=${seller_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                                        상품:
                                                        <c:choose>
                                                            <c:when test="${not empty filterProduct}">
                                                                ${filterProduct.name}
                                                            </c:when>
                                                            <c:otherwise>${product_id}</c:otherwise>
                                                        </c:choose>
                                                        <span aria-hidden="true">&times;</span>
                                                    </a>
                                                </c:if>
                                                <c:if test="${not empty category_id}">
                                                    <a class="admin-filter-chip"
                                                        href="/admin/products?status=${status}&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                                        카테고리: ${filterCategoryName}
                                                        <span aria-hidden="true">&times;</span>
                                                    </a>
                                                </c:if>
                                                <c:if test="${not empty minPrice || not empty maxPrice}">
                                                    <a class="admin-filter-chip"
                                                        href="/admin/products?status=${status}&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                                        가격: ${minPrice} ~ ${maxPrice}
                                                        <span aria-hidden="true">&times;</span>
                                                    </a>
                                                </c:if>
                                                <c:if test="${not empty startDate || not empty endDate}">
                                                    <a class="admin-filter-chip"
                                                        href="/admin/products?status=${status}&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&sort=${sort}&size=${pagination.size}&page=1">
                                                        등록일: ${startDate} ~ ${endDate}
                                                        <span aria-hidden="true">&times;</span>
                                                    </a>
                                                </c:if>
                                                <a class="admin-filter-clear" href="/admin/products">전체 해제</a>
                                            </div>
                                        </c:if>

                                        <input type="hidden" name="seller_id" value="${seller_id}">
                                        <input type="hidden" name="product_id" value="${product_id}">
                                        <input type="hidden" name="page" value="1">
                                    </form>
                                </div>

                                <section class="admin-master-detail admin-master-detail-filtered is-collapsed"
                                    id="adminMasterDetail">
                                    <div class="admin-card admin-list-panel">
                                        <div class="admin-table-wrap">
                                            <table class="admin-table">
                                                <thead>
                                                    <tr>
                                                        <th>번호</th>
                                                        <th>이미지</th>
                                                        <th>상품명</th>
                                                        <th>판매자</th>
                                                        <th>카테고리</th>
                                                        <th>가격</th>
                                                        <th>재고</th>
                                                        <th>후기</th>
                                                        <th>주문</th>
                                                        <th>상태</th>
                                                        <th>등록일</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:if test="${empty productList}">
                                                        <tr>
                                                            <td colspan="11">상품 목록이 없습니다.</td>
                                                        </tr>
                                                    </c:if>
                                                    <c:forEach var="product" items="${productList}" varStatus="loop">
                                                        <tr class="admin-clickable-row"
                                                            data-product-id="${product.product_id}">
                                                            <td>${pagination.offset + loop.index + 1}</td>
                                                            <td>
                                                                <span class="admin-thumb">
                                                                    <img src="/upload/${product.image_l}" alt="${product.name}">
                                                                </span>
                                                            </td>
                                                            <td class="left admin-highlight-target">
                                                                <strong>${product.name}</strong></td>
                                                            <td class="admin-highlight-target">${product.company_name}
                                                            </td>
                                                            <td class="admin-highlight-target">${product.category_name}
                                                            </td>
                                                            <td>
                                                                <fmt:formatNumber value="${product.price}"
                                                                    pattern="#,###" />원
                                                            </td>
                                                            <td>${product.stock}</td>
                                                            <td>${product.review_count}</td>
                                                            <td>${product.order_count}</td>
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
                                                                        <span class="admin-status muted">알 수 없음</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${product.created_at}</td>
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
                                                    <div class="admin-detail-head-main">
                                                        <div class="admin-detail-title-block">
                                                            <div class="admin-detail-title-line">
                                                                <h2 id="productDetailTitle">상품 상세</h2>
                                                                <span class="admin-detail-status-badge"
                                                                    id="productDetailStatusBadge">-</span>
                                                            </div>
                                                            <p id="productDetailMeta">목록에서 상품을 선택하세요.</p>
                                                        </div>
                                                        <div class="admin-detail-toolbar">
                                                            <button type="button" class="admin-detail-close"
                                                                aria-label="닫기">&times;</button>
                                                        </div>
                                                    </div>
                                                    <div class="admin-detail-tabs">
                                                        <button type="button" class="admin-detail-tab active"
                                                            data-detail-tab="info">
                                                            정보
                                                        </button>
                                                        <button type="button" class="admin-detail-tab"
                                                            data-detail-tab="manage">
                                                            관리
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="admin-detail-tab-body">
                                                    <div class="admin-detail-tab-panel active" data-detail-panel="info">
                                                        <div class="admin-detail-info-scroll">
                                                            <div
                                                                class="admin-detail-manage-section admin-detail-quick-link-section">
                                                                <div class="admin-detail-section-head">
                                                                    <h3>바로가기</h3>
                                                                </div>
                                                                <div class="admin-detail-link-list">
                                                                    <a href="#" id="productSellerLink">
                                                                        <span>판매자 관리</span>
                                                                    </a>
                                                                    <a href="#" id="productReviewLink">
                                                                        <span>후기 관리</span>
                                                                    </a>
                                                                    <a href="#" id="productOrderLink">
                                                                        <span>주문 관리</span>
                                                                    </a>
                                                                    <a href="#" id="productReportLink">
                                                                        <span>신고 관리</span>
                                                                    </a>
                                                                    <a href="#" id="productPublicLink">
                                                                        <span>상품 페이지</span>
                                                                    </a>
                                                                </div>
                                                            </div>
                                                            <dl class="admin-detail-grid">
                                                                <div class="admin-product-image-field">
                                                                    <dt>상품 이미지</dt>
                                                                    <dd>
                                                                        <span class="admin-product-detail-image">
                                                                            <img id="imageL" alt="product image">
                                                                        </span>
                                                                    </dd>
                                                                </div>
                                                                <div>
                                                                    <dt>상품명</dt>
                                                                    <dd id="productName" class="admin-highlight-target">
                                                                        -</dd>
                                                                </div>
                                                                <div>
                                                                    <dt>판매자</dt>
                                                                    <dd id="companyName" class="admin-highlight-target">
                                                                        -</dd>
                                                                </div>
                                                                <div>
                                                                    <dt>카테고리</dt>
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
                                                                <div>
                                                                    <dt>후기 수</dt>
                                                                    <dd id="reviewCount">-</dd>
                                                                </div>
                                                                <div>
                                                                    <dt>주문 수</dt>
                                                                    <dd id="orderCount">-</dd>
                                                                </div>
                                                                <div>
                                                                    <dt>판매 수량</dt>
                                                                    <dd id="salesQuantity">-</dd>
                                                                </div>
                                                                <div>
                                                                    <dt>찜 수</dt>
                                                                    <dd id="favoriteCount">-</dd>
                                                                </div>
                                                                <div>
                                                                    <dt>신고 수</dt>
                                                                    <dd id="reportCount">-</dd>
                                                                </div>
                                                                <div>
                                                                    <dt>옵션</dt>
                                                                    <dd id="productOptions">-</dd>
                                                                </div>
                                                            </dl>
                                                        </div>
                                                    </div>
                                                    <div class="admin-detail-tab-panel" data-detail-panel="manage">
                                                        <div class="admin-detail-manage">
                                                            <div
                                                                class="admin-detail-manage-section admin-detail-status-section">
                                                                <div class="admin-detail-section-head">
                                                                    <h3>상태 관리</h3>
                                                                </div>
                                                                <div class="admin-detail-setting-row">
                                                                    <label class="admin-detail-control">
                                                                        <span>상품 상태</span>
                                                                        <select
                                                                            class="admin-filter-control admin-detail-status-control">
                                                                            <option value="PENDING">승인대기</option>
                                                                            <option value="APPROVED">판매중</option>
                                                                            <option value="REJECTED">반려</option>
                                                                            <option value="HIDDEN">숨김</option>
                                                                        </select>
                                                                    </label>
                                                                </div>
                                                                <textarea
                                                                    class="admin-detail-memo admin-detail-status-reason"
                                                                    rows="3" placeholder="상태 변경 사유를 입력하세요."></textarea>
                                                                <div class="admin-detail-section-actions">
                                                                    <button type="button" class="admin-btn light">변경
                                                                        취소</button>
                                                                    <button type="button"
                                                                        class="admin-btn admin-detail-status-change">상태
                                                                        변경</button>
                                                                </div>
                                                            </div>

                                                            <div class="admin-detail-manage-section">
                                                                <div class="admin-detail-section-head">
                                                                    <h3>관리 메모</h3>
                                                                </div>
                                                                <textarea class="admin-detail-memo" rows="5"
                                                                    placeholder="관리 중 필요한 메모를 입력하세요."></textarea>
                                                                <div class="admin-detail-section-actions">
                                                                    <button type="button" class="admin-btn light">메모
                                                                        저장</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </aside>
                                </section>

                                <div class="admin-pagination">
                                    <div class="admin-pagination-pages">
                                        <c:if test="${pagination.totalPage > 0}">
                                            <c:if test="${pagination.hasPrev}">
                                                <a
                                                    href="/admin/products?status=${status}&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                                                    이전
                                                </a>
                                            </c:if>
                                            <c:if test="${!pagination.hasPrev}">
                                                <span class="disabled">이전</span>
                                            </c:if>

                                            <c:forEach var="i" begin="${pagination.startPage}"
                                                end="${pagination.endPage}">
                                                <a href="/admin/products?status=${status}&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                                                    class="${pagination.page == i ? 'active' : ''}">
                                                    ${i}
                                                </a>
                                            </c:forEach>

                                            <c:if test="${pagination.hasNext}">
                                                <a
                                                    href="/admin/products?status=${status}&keyword=${keyword}&seller_id=${seller_id}&product_id=${product_id}&category_id=${category_id}&minPrice=${minPrice}&maxPrice=${maxPrice}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
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
                            </div>
                        </main>
                    </div>
                </body>

                </html>
