<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>

        <script src="${pageContext.request.contextPath}/js/seller_product_modify.js"></script>

    </head>


    <body>
        <div>

            <form method="post" enctype="multipart/form-data">

                <input type="hidden" name="product_id" value="${vo.product_id}">
                <input type="hidden" name="seller_id" value="${vo.seller_id}">
                <input type="hidden" name="status" value="APPROVED"><!-- <input type="hidden" name="status" value="${vo.status}"> -->
                

                <input type="hidden" name="ori_image_l" id="ori_image_l" value="${vo.image_l}">
                <input type="hidden" name="ori_image_s" id="ori_image_s" value="${vo.image_s}">
                <input type="hidden" name="del_image_l" value="${vo.image_l}">
                <input type="hidden" name="del_image_s" value="${vo.image_s}">

                <div>
                    
                    <span>상품 수정</span>
                    <div>
                        <span>카테고리</span>
                        
                        <select id="big_category_id">
                            <option value="">대분류 카테고리 선택</option>

                            <c:forEach var="category" items="${bigCategoryList}">
                                <option value="${category.category_id}"
                                    <c:if test="${category.category_id eq selectedBigCategoryId}">selected</c:if>>
                                    ${category.name}
                                </option>
                            </c:forEach>
                        </select>

                        <select id="category_id" name="category_id">
                            <option value="">하위 카테고리 선택</option>

                            <c:forEach var="category" items="${smallCategoryList}">
                                <option value="${category.category_id}"
                                    <c:if test="${category.category_id eq vo.category_id}">selected</c:if>>
                                    ${category.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>    
                </div>
                   
                <div>
                    <span>상품명</span>
                    <input name="name" value="${vo.name}"/>
                </div>

                <div>
                    <div>상품 설명</div>
                    <textarea name="description"  placeholder="상품 설명을 입력하세요">${vo.description}</textarea>
                </div>

                <div>
                    <div>판매 가격</div>
                    <input type="number" name="price" value="${vo.price}"/>
                </div>

                <div>
                    <div>세일 가격</div>
                    <input type="number" name="sale_price" value="${vo.sale_price}"/>
                </div>

                <div>
                    <div>재고</div>
                    <input type="number" name="stock" value="${vo.stock}"/>
                </div>

                <div>
                    <div>배송비</div>
                    <input type="number" name="delivery_fee" value="${vo.delivery_fee}"/>
                </div>

                <div>
                    <div>무료배송 기준 금액</div>

                    <!-- 화면에 보여줄 입력창 -->
                    <input type="text" id="free_shipping_view"
                        value="<fmt:formatNumber value='${vo.free_shipping}' pattern='#,###' />"
                        placeholder="무료배송 기준 금액"/>

                    <!-- 실제 서버로 넘어갈 값 -->
                    <input type="hidden" name="free_shipping" id="free_shipping" value="${vo.free_shipping}"/>

                    <p><span id="free_shipping_text"><fmt:formatNumber value="${vo.free_shipping}" pattern="#,###" /></span>원 이상 구매 시 무료배송으로 설정됩니다.</p>
                </div>

                <div>
                    <div>대표 이미지</div>
                    <c:if test="${vo.image_l ne 'no_file'}">
                        <div id="image_l_div">
                            <img src="${vo.image_l}"/>
                        </div>
                    </c:if>
                    
                    <input type="file" name="image_l_file">
                </div>

                <div>
                    <div>상세 이미지</div>
                    <c:if test="${vo.image_s ne 'no_file'}">
                        <div id="image_s_div">
                            <img src="${vo.image_s}"/>
                        </div>
                    </c:if>

                    <input type="file" name="image_s_file">
                </div>

                <div>
                    <input type="button" value="수정" onclick="send(this.form)">
                    <input type="button" value="취소" onclick="location.href='/'">
                </div>
            </form>
        </div>
    </body>

</html>