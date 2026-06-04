<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>판매자센터 - 상품 등록</title>

        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="/css/seller/seller_product_insert.css">

        <script src="/js/seller_product_insert.js"></script>
    </head>

    <body>

    <div class="seller-board">

        <jsp:include page="seller_sidebar.jsp">
            <jsp:param name="activeMenu" value="orderInsert" />
            <jsp:param name="sidebarTitle" value="상품 등록" />
        </jsp:include>

        <main class="seller-main">

            <section class="product-insert-box">

                <form class="product-insert-form" method="post" enctype="multipart/form-data">

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

                        <div class="form-row">
                            <label>상품 설명</label>
                            <textarea name="description" placeholder="상품 설명을 입력하세요"></textarea>
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
                                <input type="number" name="delivery_fee" placeholder="배송비">
                            </div>

                        </div>

                        <div class="form-row free-shipping-row">
                            <label>무료배송 기준 금액</label>

                            <input type="text"
                                id="free_shipping_view"
                                class="free-shipping-input"
                                placeholder="무료배송 기준 금액 입력">

                            <input type="hidden"
                                name="free_shipping"
                                id="free_shipping"
                                value="0">

                            <p class="form-help free-shipping-help">
                                <span id="free_shipping_text">0</span>원 이상 구매 시 무료배송으로 설정됩니다.
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
                            </div>

                            <div class="image-upload-box">
                                <label>상세 이미지</label>

                                <div class="file-input-box">
                                    <input type="file" name="image_s_file">
                                </div>
                            </div>

                        </div>

                    </div>

                    <div class="form-actions">
                        <input type="button"
                            value="등록"
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