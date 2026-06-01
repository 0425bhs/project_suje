<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>

        <script src="${pageContext.request.contextPath}/js/seller_product_insert.js"></script>

    </head>

    <body>
        <div >
            <form method="post" enctype="multipart/form-data">

                <!-- 테스트용 판매자 번호,삭제예정 -->
                <input type="hidden" name="seller_id" value="1"/>
                <input type="hidden" name="status" value="APPROVED">

                <div>
                    <h2>판매자 상품 등록</h2>
                    <div>
                        <div>카테고리</div>
                        <select id="big_category_id">
                            <option value="">대분류 카테고리 선택</option>
                            <c:forEach var="category" items="${bigCategoryList}">
                                <option value="${category.category_id}">
                                    ${category.name}
                                </option>
                            </c:forEach>
                        </select>

                        <select id="category_id" name="category_id">
                            <option value="">하위 카테고리 선택</option>
                        </select>

                    </div>


                    <div>
                        <div>상품명</div>
                        <input name="name"/>
                    </div>

                    <div>
                        <div>상품 설명</div>
                        <textarea name="description" placeholder="상품 설명을 입력하세요"></textarea>
                    </div>

                    <div>
                        <div>판매 가격</div>
                        <input type="number" name="price"/>
                    </div>

                    <div>
                        <div>세일 가격</div>
                        <input type="number" name="sale_price"/>
                    </div>

                    <div>
                        <div>재고</div>
                        <input type="number" name="stock"/>
                    </div>

                    <div>
                        <div>배송비</div>
                        <input type="number" name="delivery_fee"/>
                    </div>

                    <div>
                        <div>무료배송 기준 금액</div>
                        <!-- 화면에 보여줄 입력창 -->
                        <input type="text" id="free_shipping_view" placeholder="무료배송 기준 금액 입력"/>
                        <!-- 실제 서버로 넘어갈 값 -->
                        <input type="hidden" name="free_shipping" id="free_shipping" value="0"/>

                        <p><span id="free_shipping_text">0</span>원 이상 구매 시 무료배송으로 설정됩니다.</p>
                    </div>

                    <div>
                        <div>대표 이미지</div>
                            <input type="file" name="image_l_file">
                    </div>

                    <div>
                        <div>상세 이미지</div>
                            <input type="file" name="image_s_file">
                    </div>

                    <div>
                        <input type="button" value="등록" onclick="send(this.form)">
                        <input type="button" value="취소" onclick="location.href='/'">
                    </div>
                </div>
            </form>
        </div>
    </body>
</html>