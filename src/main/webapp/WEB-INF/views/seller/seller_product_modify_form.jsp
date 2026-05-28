<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <script>
            function delImgL() {
                let image_l_div = document.getElementById("image_l_div");
                let ori_image_l = document.getElementById("ori_image_l");

                ori_image_l.value = "no_file";
                image_l_div.style.display = "none";
            }

            function delImgS() {
                let image_s_div = document.getElementById("image_s_div");
                let ori_image_s = document.getElementById("ori_image_s");

                ori_image_s.value = "no_file";
                image_s_div.style.display = "none";
            }

            function send(f) {
                let formData = new FormData(f);

                fetch("/seller_product_modify.do", {method: "post",body: formData}).then(res => res.json()).then(data => {
                    if (data.result==1) {
                        alert("상품 수정 성공");
                        location.href="/product_detail.do?product_id="+data.product_id;
                    } else {
                        alert("상품 수정 실패");
                    }
                })
            }
        </script>
    </head>

    <body>
        <div >

            <h2>상품 수정</h2>

            <form method="post" enctype="multipart/form-data">

                <input type="hidden" name="seller_id" value="${vo.product_id}">
                <input type="hidden" name="status" value="${vo.seller_id}">

                <input type="hidden" name="ori_image_l" value="${vo.image_l}">
                <input type="hidden" name="ori_image_s" value="${vo.image_s}">
                <input type="hidden" name="del_image_l" value="${vo.image_l}">
                <input type="hidden" name="del_image_s" value="${vo.image_s}">

                <table>
                    <tr>
                        <th>카테고리</th>
                        <td>
                            <select name="category_id">
                                <option value="1">패션/주얼리</option>
                                <option value="2">홈리빙</option>
                                <option value="3">뷰티</option>
                                <option value="4">식품</option>
                                <option value="5">공예</option>
                                <option value="6">반려동물</option>
                            </select>
                        </td>
                    </tr>

                    <tr>
                        <th>상품명</th>
                        <td>
                            <input name="name"/>
                        </td>
                    </tr>

                    <tr>
                        <th>상품 설명</th>
                        <td>
                            <textarea name="description" placeholder="상품 설명을 입력하세요"></textarea>
                        </td>
                    </tr>

                    <tr>
                        <th>판매 가격</th>
                        <td>
                            <input type="number" name="price"/>
                        </td>
                    </tr>

                    <tr>
                        <th>세일 가격</th>
                        <td>
                            <input type="number" name="sale_price"/>
                        </td>
                    </tr>

                    <tr>
                        <th>재고</th>
                        <td>
                            <input type="number" name="stock" value="0"/>
                        </td>
                    </tr>

                    <tr>
                        <th>배송비</th>
                        <td>
                            <input type="number" name="delivery_fee" value="3000"/>
                        </td>
                    </tr>

                    <tr>
                        <th>대표 이미지</th>
                        <td>
                            <input type="file" name="image_l">
                        </td>
                    </tr>

                    <tr>
                        <th>상세 이미지</th>
                        <td>
                            <input type="file" name="image_s">
                        </td>
                    </tr>
                </table>

                <div class="btn-box">
                    <input type="button" value="수정" onclick="send()">
                    <input type="button" value="취소" onclick="location.href='/product/list.do'">
                </div>

            </form>

        </div>
    </body>

</html>