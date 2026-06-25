<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>판매자센터 - 상품 수정</title>

        <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">

        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="/css/seller/seller_product_modify.css">

        <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
        <script src="/js/seller_product_modify.js"></script>
    </head>


    <body>

    <div class="seller-board">

        <aside class="seller-sidebar">

            <div class="sidebar-logo">
                HAND<span>MADE</span>
            </div>

            <div class="sidebar-title">
                판매자 관리보드
            </div>

            <nav class="sidebar-menu">

                <a href="#" class="menu-disabled" onclick="return false;">
                    판매자 대시보드
                </a>

                <a href="#" class="menu-disabled" onclick="return false;">
                    판매자 홈페이지
                </a>
                
                <a href="/seller_product_list.do" class="menu-active">
                    내 상품 관리
                </a>

                <a href="/seller_product_insert.do">
                    상품 등록
                </a>

                <a href="#" class="menu-disabled" onclick="return false;">
                    판매자 주문 관리
                </a>

                <a href="#" class="menu-disabled" onclick="return false;">
                    상품 문의 답변 관리
                </a>

                <a href="#" class="menu-disabled" onclick="return false;">
                    판매자 매출 통계
                </a>

            </nav>

            <div class="sidebar-bottom">
                <a href="/product/main.do">쇼핑몰로 이동</a>
            </div>

        </aside>

        <main class="seller-main">

            <section class="product-modify-box">

                <form class="product-modify-form" method="post" enctype="multipart/form-data">

                    <input type="hidden" name="product_id" value="${vo.product_id}">
                    <input type="hidden" name="seller_id" value="${vo.seller_id}">

                    <input type="hidden" name="ori_image_l" id="ori_image_l" value="${vo.image_l}">
                    
                    <div class="form-section">

                        <div class="form-row category-row">
                            <label>카테고리</label>

                            <select name="category_id" class="category-select">
                                <option value="1" ${vo.category_id == 1 ? 'selected' : ''}>패션/주얼리</option>
                                <option value="2" ${vo.category_id == 2 ? 'selected' : ''}>홈리빙</option>
                                <option value="3" ${vo.category_id == 3 ? 'selected' : ''}>뷰티</option>
                                <option value="4" ${vo.category_id == 4 ? 'selected' : ''}>식품</option>
                                <option value="5" ${vo.category_id == 5 ? 'selected' : ''}>공예</option>
                                <option value="6" ${vo.category_id == 6 ? 'selected' : ''}>반려동물</option>
                            </select>
                        </div>

                        <div class="form-row">
                            <label>상품명</label>
                            <input type="text" name="name" value="${vo.name}" placeholder="상품명을 입력하세요">
                        </div>

                        <div class="form-section">
                            <label>상품 옵션</label>

                            <p class="form-help">
                                옵션이 필요 없으면 비워두세요.
                            </p>

                            <div id="optionListBox">

                                <c:choose>
                                    <c:when test="${not empty vo.optionList}">

                                        <c:forEach var="option" items="${vo.optionList}">
                                            <div class="option-row">
                                                <input type="text" name="option_name" class="option-name-input" value="${option.option_name}" placeholder="옵션명">

                                                <input type="text" name="option_price" class="option-price-input" value="${option.option_price}" placeholder="추가금액">

                                                <input type="text" name="option_stock" class="option-stock-input" value="${option.option_stock}" placeholder="옵션재고">

                                                <button type="button" class="option-remove-btn">
                                                    삭제
                                                </button>
                                            </div>
                                        </c:forEach>

                                    </c:when>

                                    <c:otherwise>
                                        <div class="option-row">
                                            <input type="text"
                                                name="option_name"
                                                class="option-name-input"
                                                placeholder="옵션명">

                                            <input type="text"
                                                name="option_price"
                                                class="option-price-input"
                                                placeholder="추가금액">

                                            <input type="text"
                                                name="option_stock"
                                                class="option-stock-input"
                                                placeholder="옵션재고">

                                            <button type="button" class="option-remove-btn">
                                                삭제
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                            </div>

                            <button type="button" id="addOptionBtn" class="option-add-btn">
                                + 옵션 추가
                            </button>
                        </div>

                        <div class="form-row">
                            <label>상품 설명</label>

                            <!-- Toast UI Editor가 보이는 영역 -->
                            <div id="productDescriptionEditor"></div>

                            <!-- 실제 Controller로 넘어가는 값 -->
                            <input type="hidden" id="description" name="description">

                            <!-- 기존 DB 상품 설명 값 -->
                            <textarea id="descriptionOrigin" style="display:none;"><c:out value="${vo.description}" /></textarea>

                            <p class="form-help">
                                상품 설명을 수정하세요. 이미지, 링크, 표, 영상 등을 사용할 수 있습니다.
                            </p>
                        </div>

                    </div>

                    <div class="form-section price-section">

                        <div class="form-grid">

                            <div class="form-row">
                                <label>판매 가격</label>
                                <input type="number" name="price" value="${vo.price}" placeholder="판매 가격">
                            </div>

                            <div class="form-row">
                                <label>세일 가격</label>
                                <input type="number" name="sale_price" value="${vo.sale_price}" placeholder="세일 가격">
                            </div>

                            <div class="form-row">
                                <label>재고</label>
                                <input type="number" name="stock" value="${vo.stock}" placeholder="재고 수량">
                            </div>

                            <div class="form-row shipping-section">
                                <label>배송비</label>
                                <input type="number" id="delivery_fee" name="delivery_fee" value="${vo.delivery_fee}" placeholder="배송비">
                            </div>

                        </div>

                         <!--할인 설정-->
                        <div class="form-row discount-setting-box">
                            <label>할인 설정</label>

                            <div class="discount-type-box">
                                <label>
                                    <input type="radio" name="sale_discount_type" value="none"
                                        ${vo.sale_price == 0 ? 'checked' : ''}>
                                    할인 없음
                                </label>

                                <label>
                                    <input type="radio" name="sale_discount_type" value="always"
                                        ${vo.sale_price > 0 and empty vo.sale_start_at and empty vo.sale_end_at ? 'checked' : ''}>
                                    상시 할인
                                </label>

                                <label>
                                    <input type="radio" name="sale_discount_type" value="period"
                                        ${vo.sale_price > 0 and not empty vo.sale_start_at and not empty vo.sale_end_at ? 'checked' : ''}>
                                    기간 할인
                                </label>
                            </div>

                            <p class="form-help discount-help">
                                기간 할인 선택 시, 할인 기간을 설정할 수 있습니다.
                            </p>

                            <div class="discount-period-grid">

                                <div class="form-row">
                                    <label>할인 시작일</label>
                                    <input type="date" 
                                           name="sale_start_at"
                                           value="${not empty vo.sale_start_at ? fn:substring(vo.sale_start_at, 0, 10) : ''}">
                                </div>

                                <div>
                                    <label>할인 종료일</label>
                                    <input type="date" 
                                           name="sale_end_at"
                                           value="${not empty vo.sale_end_at ? fn:substring(vo.sale_end_at, 0, 10) : ''}">
                                </div>
                            </div>

                        </div>

                        <div class="form-row free-shipping-row">
                            <label>무료배송 기준 금액</label>

                            <input type="text" id="free_shipping_view" class="free-shipping-input" value="<fmt:formatNumber value='${vo.free_shipping}' pattern='#,###' />" placeholder="무료배송 기준 금액">

                            <input type="hidden" name="free_shipping" id="free_shipping" value="${vo.free_shipping}">

                            <p class="form-help free-shipping-help" id="free_shipping_help">
                                택배비란에 공백이나 0일 경우 무료배송으로 설정됩니다.
                            </p>
                        </div>

                    </div>

                    <div class="form-section image-section">

                        <div class="image-upload-area">

                            <div class="image-upload-box">
                                <label>대표 이미지</label>

                                <c:if test="${vo.image_l ne 'no_file'}">
                                    <div class="image-preview" id="image_l_div">
                                        <img src="/upload/${vo.image_l}" alt="대표 이미지">
                                    </div>
                                </c:if>

                                <div class="file-input-box">
                                    <input type="file" name="image_l_file">
                                </div>
                            </div>

                            <div class="image-upload-box">
                                <label>상세 이미지</label>

                                <c:if test="${not empty vo.imageList}">
                                    <div class="image-preview" id="image_s_div">
                                        <c:forEach var="img" items="${vo.imageList}">
                                            <img src="/upload/${img.image_url}" alt="상세 이미지">
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <div class="file-input-box">
                                    <input type="file" name="image_s_file" multiple accept="image/*">
                                </div>
                            </div>

                        </div>

                    </div>

                    <div class="form-actions">
                        <input type="button"
                            value="수정"
                            class="btn btn-primary"
                            onclick="send(this.form)">

                        <input type="button"
                            value="취소"
                            class="btn btn-white"
                            onclick="location.href='/seller_product_list.do'">
                    </div>

                </form>

            </section>

        </main>

    </div>

    </body>
</html>