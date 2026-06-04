<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>판매자센터 - 상품 수정</title>

        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
        <link rel="stylesheet" href="/css/seller/seller_product_modify.css">

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
                    <input type="hidden" name="ori_image_s" id="ori_image_s" value="${vo.image_s}">

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

                        <div class="form-row">
                            <label>상품 설명</label>
                            <textarea name="description" placeholder="상품 설명을 입력하세요">${vo.description}</textarea>
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
                                <input type="number" name="delivery_fee" value="${vo.delivery_fee}" placeholder="배송비">
                            </div>

                        </div>

                        <div class="form-row free-shipping-row">
                            <label>무료배송 기준 금액</label>

                            <input type="text"
                                name="free_shipping"
                                id="free_shipping"
                                class="free-shipping-input"
                                value="${vo.free_shipping}"
                                placeholder="무료배송 기준 금액">

                            <p class="form-help free-shipping-help">
                                <span id="free_shipping_text">
                                    <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###" />
                                </span>원 이상 구매 시 무료배송으로 설정됩니다.
                            </p>
                        </div>

                    </div>

                    <div class="form-section image-section">

                        <div class="image-upload-area">

                            <div class="image-upload-box">
                                <label>대표 이미지</label>

                                <c:if test="${vo.image_l ne 'no_file'}">
                                    <div class="image-preview" id="image_l_div">
                                        <img src="${vo.image_l}" alt="대표 이미지">
                                    </div>
                                </c:if>

                                <div class="file-input-box">
                                    <input type="file" name="image_l_file">
                                </div>
                            </div>

                            <div class="image-upload-box">
                                <label>상세 이미지</label>

                                <c:if test="${vo.image_s ne 'no_file'}">
                                    <div class="image-preview" id="image_s_div">
                                        <img src="${vo.image_s}" alt="상세 이미지">
                                    </div>
                                </c:if>

                                <div class="file-input-box">
                                    <input type="file" name="image_s_file">
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