<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <script>
            function send() {
            const form = document.getElementById("productForm");
            const formData = new FormData(form);

            fetch("seller_product_insert.do",{method:"POST",body: formData}).then(response => response.json()).then(data => {
                if (data.result = 0) {
                    alert("상품이 등록되었습니다.");
                    location.href = "/product/list.do";
                } else {
                    alert("상품 등록에 실패했습니다.");
                }
            })
            .catch(error => {
                console.log(error);
                alert("등록 중 오류가 발생했습니다.");
            });
        }
        </script>
    </head>

    <body>
        <div >

            <h2>판매자 상품 등록</h2>

            <form id="productForm" method="post">

                <input type="hidden" name="seller_id" value="1">

                <input type="hidden" name="status" value="APPROVED">

                <table>
                    <tr>
                        <th>카테고리</th>
                        <td>
                            <select name="category_id">
                                <option value="1">캔들</option>
                                <option value="2">비누</option>
                                <option value="3">키링</option>
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
                    <input type="button" value="등록" onclick="send()">
                    <input type="button" value="목록" onclick="location.href='/product/list.do'">
                </div>

            </form>

        </div>
    </body>

</html>