<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>판매자센터 - 상품 등록</title>

        <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css">

        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="/css/seller/seller_product_insert.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        
        <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

        <script src="/js/seller_product_insert.js"></script>
    </head>

    <body>

        <div class="seller-board">

            <jsp:include page="seller_sidebar.jsp">
                <jsp:param name="activeMenu" value="productInsert" />
                <jsp:param name="sidebarTitle" value="상품등록" />
            </jsp:include>

            <main class="seller-main">

                <section class="product-insert-box">

                    <form class="product-insert-form" action="/seller_product_insert.do" method="post" enctype="multipart/form-data">

                        <!-- 테스트용 판매자 번호, 삭제 예정 -->
                        <input type="hidden" name="seller_id" value="1">
                        <input type="hidden" name="status" value="APPROVED">

                        <div class="form-section">

                            <div class="form-row category-row">
                                <label>대분류 카테고리</label>

                                <select id="big_category_id" class="category-select">
                                    <option value="">대분류 선택</option>
                                    <option value="1">패션/주얼리</option>
                                    <option value="2">홈리빙</option>
                                    <option value="3">뷰티</option>
                                    <option value="4">식품</option>
                                    <option value="5">공예</option>
                                    <option value="6">반려동물</option>
                                </select>
                            </div>

                            <div class="form-row category-row">
                                <label>소분류 카테고리</label>

                                <select name="category_id" id="category_id" class="category-select">
                                    <option value="">하위 카테고리 선택</option>
                                </select>
                            </div>

                            <div class="form-row">
                                <label>상품명</label>
                                <input type="text" name="name" placeholder="상품명을 입력하세요">
                            </div>

                            <div class="form-section">
                                <label>상품 옵션</label>

                                <p class="form-help">
                                    옵션이 필요 없으면 비워두세요.
                                </p>

                                <div id="optionListBox">

                                    <div class="option-row">
                                        <input type="text" name="option_name" class="option-name-input" placeholder="옵션명">

                                        <input type="text" name="option_price" class="option-price-input" placeholder="추가금액">

                                        <input type="text" name="option_stock" class="option-stock-input" placeholder="옵션재고">

                                        <button type="button" class="option-remove-btn">
                                            삭제
                                        </button>
                                    </div>

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

                                <p class="form-help">
                                    상품 설명을 자세히 입력하세요. 이미지, 링크, 표 등을 사용할 수 있습니다.
                                </p>
                            </div>

                        </div>

                        <div class="form-section price-section">

                            <div class="form-grid">

                                <div class="form-row">
                                    <label>판매 가격</label>
                                    <input type="number" name="price" placeholder="판매 가격">
                                </div>

                                <div class="form-row">
                                    <label>세일 가격</label>
                                    <input type="number" name="sale_price" placeholder="세일 가격">
                                </div>

                                <div class="form-row">
                                    <label>재고</label>
                                    <input type="number" name="stock" placeholder="재고 수량">
                                </div>

                                <div class="form-row shipping-section">
                                    <label>배송비</label>
                                    <input type="number" id="delivery_fee" name="delivery_fee" placeholder="배송비">
                                </div>

                            </div>

                            <!-- 할인 설정 -->
                            <div class="form-row discount-setting-box">
                                <label>할인 설정</label>

                                <div class="discount-type-box">
                                    <label>
                                        <input type="radio" name="sale_discount_type" value="none" checked>
                                        할인 없음
                                    </label>

                                    <label>
                                        <input type="radio" name="sale_discount_type" value="always">
                                        상시 할인
                                    </label>

                                    <label>
                                        <input type="radio" name="sale_discount_type" value="period">
                                        기간 할인
                                    </label>
                                </div>

                                <p class="form-help discount-help">
                                    기간 할인 선택 시, 할인 기간을 설정할 수 있습니다.
                                </p>

                                <div class="discount-period-grid">

                                    <div class="form-row">
                                        <label>할인 시작일</label>
                                        <input type="date" name="sale_start_at">
                                    </div>

                                    <div class="form-row">
                                        <label>할인 종료일</label>
                                        <input type="date" name="sale_end_at">
                                    </div>

                                </div>

                            </div>

                            <div class="form-row free-shipping-row">
                                <label>무료배송 기준 금액</label>

                                <input type="text" id="free_shipping_view" class="free-shipping-input" placeholder="무료배송 기준 금액 입력">

                                <input type="hidden" name="free_shipping" id="free_shipping" value="0">

                                <p class="form-help free-shipping-help" id="free_shipping_help">
                                    택배비란에 공백이나 0일 경우 무료배송으로 설정됩니다.
                                </p>
                            </div>

                        </div>

                        <div class="form-section image-section">

                            <div class="image-upload-area">

                                <div class="image-upload-box">
                                    <label>대표 이미지</label>

                                    <div class="file-input-box">
                                        <input type="file" name="image_l_file">
                                    </div>

                                    <p class="form-help">
                                        JPG, PNG 파일을 등록할 수 있습니다.
                                    </p>
                                </div>

                                <div class="image-upload-box">
                                    <label>상세 이미지</label>

                                    <div class="file-input-box">
                                        <input type="file" name="image_s_file" multiple accept="image/*">
                                    </div>

                                    <p class="form-help">
                                        JPG, PNG 파일을 등록할 수 있습니다.
                                    </p>
                                </div>

                            </div>

                        </div>

                        <div class="form-actions">
                            <input type="button" value="등록" class="btn btn-primary" onclick="send(this.form)">

                            <input type="button" value="취소" class="btn btn-white" onclick="location.href='/seller_product_list.do'">
                        </div>

                    </form>

                </section>

            </main>

        </div>

    </body>
</html>