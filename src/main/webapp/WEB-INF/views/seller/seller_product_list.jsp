<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>판매자 관리보드 - 내 상품 관리</title>
    
    <link rel="stylesheet" href="/css/seller/seller_form_common.css">
    <link rel="stylesheet" href="/css/seller/seller_product_list.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <script src="/js/seller_product_toggle.js"></script>
</head>

<body>

<div class="seller-board">

    <!-- 왼쪽 메뉴 -->
    <jsp:include page="seller_sidebar.jsp">
        <jsp:param name="activeMenu" value="productList" />
        <jsp:param name="sidebarTitle" value="내 상품 관리" />
    </jsp:include>

    <!-- 오른쪽 본문 -->
    <main class="seller-main">

        <header class="seller-main-header">
            <div>
                <span class="page-label">판매자 상품 관리</span>
                <h1>내 상품 관리</h1>
                <p>등록한 상품을 확인하고 상품 정보, 가격, 재고를 수정할 수 있습니다.</p>
            </div>

            <div class="header-actions">
                <a href="/seller_product_insert.do" class="btn btn-primary">상품 등록</a>

                <button type="button" class="btn btn-secondary" onclick="selectedModify()">선택 수정</button>

                <button type="button" class="btn btn-danger" onclick="selectedDelete()">선택 삭제</button>
            </div>
        </header>

        <!-- 상품 목록 -->
        <section class="product-manage-box">

            <div class="product-manage-header">
                <div>
                    <h2>상품 목록</h2>
                    <br/>
                </div>
            </div>

            <div class="view-switch-buttons">

                <!-- 1번: 이미지 없는 테이블 -->
                <button type="button" class="view-icon-btn active" data-view="noImage" title="이미지 없는 형태">
                    <span class="view-icon icon-table"></span>
                </button>

                <!-- 2번: 이미지 있는 테이블 -->
                <button type="button" class="view-icon-btn" data-view="image" title="이미지 있는 형태">
                    <span class="view-icon icon-list"></span>
                </button>

                <!-- 3번: 카드형 -->
                <button type="button" class="view-icon-btn" data-view="card" title="카드형태">
                    <span class="view-icon icon-grid"></span>
                </button>

            </div>   

            <div class="filter-box">

                <form class="product-search-form" action="/seller_product_list.do" method="get">
                    <input type="hidden" name="status" value="${status}">
                    <input type="hidden" name="sort" value="${empty sort ? 'new' : sort}">

                    <div class="product-search-wrap">
                        <i class="bi bi-search"></i>
                        <input type="text"
                            name="keyword"
                            value="${keyword}"
                            placeholder="상품명 또는 상품번호 검색">
                        <button type="submit">검색</button>
                    </div>
                </form>

                <div class="filter-buttons">

                    <a href="/seller_product_list.do?sort=${sort}&keyword=${keyword}" class="${empty status ? 'active' : ''}">
                        전체
                    </a>

                    <a href="/seller_product_list.do?status=APPROVED&sort=${sort}&keyword=${keyword}" class="${status eq 'APPROVED' ? 'active' : ''}">
                        판매중
                    </a>

                    <a href="/seller_product_list.do?status=HIDDEN&sort=${sort}&keyword=${keyword}" class="${status eq 'HIDDEN' ? 'active' : ''}">
                        판매중지
                    </a>

                    <a href="/seller_product_list.do?status=PENDING&sort=${sort}&keyword=${keyword}" class="${status eq 'PENDING' ? 'active' : ''}">
                        승인대기
                    </a>

                    <a href="/seller_product_list.do?status=REJECTED&sort=${sort}&keyword=${keyword}" class="${status eq 'REJECTED' ? 'active' : ''}">
                        승인거절
                    </a>

                    <span class="filter-divider"></span>

                    <a href="/seller_product_list.do?status=${status}&sort=new&keyword=${keyword}" class="${sort eq 'new' or empty sort ? 'active' : ''}">
                        최신순
                    </a>

                    <a href="/seller_product_list.do?status=${status}&sort=lowPrice&keyword=${keyword}" class="${sort eq 'lowPrice' ? 'active' : ''}">
                        낮은가격순
                    </a>

                    <a href="/seller_product_list.do?status=${status}&sort=highPrice&keyword=${keyword}" class="${sort eq 'highPrice' ? 'active' : ''}">
                        높은가격순
                    </a>

                    <a href="/seller_product_list.do?status=${status}&sort=lowStock&keyword=${keyword}" class="${sort eq 'lowStock' ? 'active' : ''}">
                        재고적은순
                    </a>

                </div>

            </div>


            <c:choose>
                <c:when test="${empty list}">
                    <div class="empty-box">
                        등록된 상품이 없습니다.<br>
                        상품 등록 버튼을 눌러 새 상품을 등록해보세요.
                    </div>
                </c:when>

                <c:otherwise>
                    <form id="productManageForm" method="post">

                    <table class="product-manage-table">

                        <colgroup>
                            <col class="col-check">
                            <col class="col-id">
                            <col class="col-img">
                            <col class="col-name">
                            <col class="col-price">
                            <col class="col-sale">
                            <col class="col-stock">
                            <col class="col-delivery">
                            <col class="col-free">
                            <col class="col-status">
                            <col class="col-date">
                        </colgroup>

                        <thead>
                            <tr>
                                <th><input type="checkbox" id="checkAll" onclick="allCheck(this)"></th>
                                <th>상품번호</th>
                                <th class="image-column">대표 이미지</th>
                                <th>상품명</th>
                                <th>가격</th>
                                <th>세일가격</th>
                                <th>재고</th>
                                <th>배송비</th>
                                <th>무료배송 기준</th>
                                <th>상태</th>
                                <th>등록일/수정일</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="vo" items="${list}">
                                <tr>
                                    <td>
                                        <input type="checkbox" name="product_id" class="product-check table-check" value="${vo.product_id}" onclick="checkOne()">
                                    </td>

                                    <td class="product-id">#${vo.product_id}</td>

                                    <td class="image-column" align="center">
                                        <c:choose>
                                            <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                                <div style="width: 70px;">
                                                    <img src="/upload/${vo.image_l}" class="product-thumb" alt="${vo.name}">
                                                </div>
                                            </c:when>

                                            <c:otherwise>
                                                <div class="no-image">이미지 없음</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="product-name">
                                        ${vo.name}
                                    </td>

                                    <td>
                                        <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${vo.sale_price > 0}">
                                                <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        ${vo.stock}개
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${vo.delivery_fee == 0}">
                                                무료배송
                                            </c:when>

                                            <c:otherwise>
                                                <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${vo.free_shipping > 0}">
                                                <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상
                                            </c:when>

                                            <c:otherwise>
                                                조건 없음
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:if test="${vo.status eq 'APPROVED'}">
                                            <button type="button" class="status-badge status-approved status-toggle" onclick="productToggle('${vo.product_id}', 'HIDDEN')">
                                                판매중
                                            </button>
                                        </c:if>

                                        <c:if test="${vo.status eq 'HIDDEN'}">
                                            <button type="button" class="status-badge status-hidden status-toggle" onclick="productToggle('${vo.product_id}', 'APPROVED')">
                                                판매중지
                                            </button>
                                        </c:if>

                                        <c:if test="${vo.status eq 'PENDING'}">
                                            <span class="status-badge status-pending">
                                                승인 대기
                                            </span>
                                        </c:if>

                                        <c:if test="${vo.status eq 'REJECTED'}">
                                            <span class="status-badge status-rejected">
                                                승인 거절
                                            </span>
                                        </c:if>
                                    </td>

                                    <td class="date-info">
                                        <div>
                                            <c:choose>
                                                <c:when test="${not empty vo.created_at}">
                                                    ${fn:substring(vo.created_at, 0, 10)}
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div>
                                            <c:choose>
                                                <c:when test="${not empty vo.updated_at}">
                                                    ${fn:substring(vo.updated_at, 0, 10)}
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>


                    <!-- 카드형: seller_homepage 느낌 -->
                    <div class="product-card-view">

                        <c:forEach var="vo" items="${list}">
                            <div class="seller-product-card">

                                <div class="card-check-area">
                                    <input type="checkbox" name="product_id" class="product-check card-check" value="${vo.product_id}" onclick="checkOne()">
                                </div>

                                <div class="card-image-box">
                                    <c:choose>
                                        <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                            <img src="/upload/${vo.image_l}" class="card-product-image" alt="${vo.name}">
                                        </c:when>

                                        <c:otherwise>
                                            <div class="card-no-image">이미지 없음</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="card-content">
                                    <div class="card-top">
                                        <span class="card-product-id">#${vo.product_id}</span>

                                        <c:if test="${vo.status eq 'APPROVED'}">
                                            <button type="button" class="status-badge status-approved status-toggle" onclick="productToggle('${vo.product_id}', 'HIDDEN')">
                                                판매중
                                            </button>
                                        </c:if>

                                        <c:if test="${vo.status eq 'HIDDEN'}">
                                            <button type="button" class="status-badge status-hidden status-toggle" onclick="productToggle('${vo.product_id}', 'APPROVED')">
                                                판매중지
                                            </button>
                                        </c:if>

                                        <c:if test="${vo.status eq 'PENDING'}">
                                            <span class="status-badge status-pending">
                                                승인 대기
                                            </span>
                                        </c:if>

                                        <c:if test="${vo.status eq 'REJECTED'}">
                                            <span class="status-badge status-rejected">
                                                승인 거절
                                            </span>
                                        </c:if>
                                    </div>

                                    <div class="card-product-name">
                                        ${vo.name}
                                    </div>

                                    <div class="card-price-manage-box">

                                        <div class="price-manage-row">
                                            <span>정가</span>
                                            <strong>
                                                <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                            </strong>
                                        </div>

                                        <div class="price-manage-row">
                                            <span>할인가</span>
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${vo.sale_price > 0}">
                                                        <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </div>

                                        <div class="price-manage-row">
                                            <span>할인율</span>
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${vo.sale_price > 0}">
                                                        ${vo.sale_rate}%
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </div>

                                    </div>

                                    <div class="card-info-grid">
                                        <div>
                                            <span>재고</span>
                                            <strong>${vo.stock}개</strong>
                                        </div>

                                        <div>
                                            <span>배송비</span>
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${vo.delivery_fee == 0}">
                                                        무료배송
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                                                    </c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </div>

                                        <div>
                                            <span>무료배송 기준</span>
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${vo.free_shipping > 0}">
                                                        <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상
                                                    </c:when>
                                                    <c:otherwise>
                                                        조건 없음
                                                    </c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </div>

                                        <div>
                                            <span>등록일/수정일</span>
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${not empty vo.created_at}">
                                                        ${fn:substring(vo.created_at, 0, 10)}<br/>
                                                        ${fn:substring(vo.updated_at, 0, 10)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </div>
                                    </div>

                                    <div class="card-action-area">
                                        <a href="/seller_product_modify.do?product_id=${vo.product_id}" class="card-modify-btn">
                                            수정하기
                                        </a>
                                    </div>
                                </div>

                            </div>
                        </c:forEach>

                    </div>

                    <c:if test="${pagination.totalPage > 1}">
                        <div class="seller-page-menu">

                            <c:choose>
                                <c:when test="${pagination.hasPrev}">
                                    <a href="/seller_product_list.do?page=${pagination.prevPage}&size=${pagination.size}&status=${status}&sort=${sort}&keyword=${keyword}">
                                        ◀
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-disabled">◀</span>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                                <c:choose>
                                    <c:when test="${pagination.page == i}">
                                        <span class="page-current">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="/seller_product_list.do?page=${i}&size=${pagination.size}&status=${status}&sort=${sort}&keyword=${keyword}">
                                            ${i}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${pagination.hasNext}">
                                    <a href="/seller_product_list.do?page=${pagination.nextPage}&size=${pagination.size}&status=${status}&sort=${sort}&keyword=${keyword}">
                                        ▶
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-disabled">▶</span>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </c:if>
                </form>
                </c:otherwise>
            </c:choose>

        </section>

    </main>

</div>

</body>
</html>