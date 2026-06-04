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
                    <p>판매자가 등록한 상품을 최근 등록순으로 확인할 수 있습니다.</p>
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
                                    <th>대표 이미지</th>
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
                                            <input type="checkbox" name="product_id" class="product-check" value="${vo.product_id}" onclick="checkOne()">
                                        </td>

                                        <td class="product-id">#${vo.product_id}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                                    <img src="${vo.image_l}" class="product-thumb" alt="${vo.name}">
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
                                            <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
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
                                                <button type="button" id="statusBadge_${vo.product_id}"
                                                        class="status-badge status-approved status-toggle"
                                                        onclick="productToggle('${vo.product_id}', 'HIDDEN')">
                                                    활성화
                                                </button>
                                            </c:if>

                                            <c:if test="${vo.status eq 'HIDDEN'}">
                                                <button type="button" id="statusBadge_${vo.product_id}"
                                                        class="status-badge status-hidden status-toggle"
                                                        onclick="productToggle('${vo.product_id}', 'APPROVED')">
                                                    비활성화
                                                </button>
                                            </c:if>

                                            <!-- 승인 대기 / 승인 거절은 판매자가 직접 변경 못 하게 클릭 안 되게 둠 -->
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
                    </form>
                </c:otherwise>
            </c:choose>

        </section>

    </main>

</div>

</body>
</html>