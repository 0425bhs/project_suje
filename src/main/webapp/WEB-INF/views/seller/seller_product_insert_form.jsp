<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <script>
            window.onload=function () {
            const freeShippingView=document.getElementById("free_shipping_view");
            const freeShipping=document.getElementById("free_shipping");
            const freeShippingText=document.getElementById("free_shipping_text");

            freeShippingView.addEventListener("input", function () {
                let value=this.value.replace(/[^0-9]/g, "");

                if (value=="") {
                    this.value = "";
                    freeShipping.value = "0";
                    freeShippingText.innerText = "0";
                    return;
                }

                // 서버로 보낼 값: 콤마 없는 숫자
                freeShipping.value = value;

                // 화면에 보여줄 값: 콤마 있는 숫자
                let commaValue = Number(value).toLocaleString();

                this.value = commaValue;
                freeShippingText.innerText = commaValue;
            });
        }

        function send(f) {
            const imageL=f.image_l_file;
            const imageS=f.image_s_file;

            if (imageL.value=="") {
                alert("대표 이미지를 등록해주세요.");
                imageL.focus();
                return;
            }

            if (imageS.value=="") {
                alert("상세 이미지를 등록해주세요.");
                imageS.focus();
                return;
            }

            const freeShippingView=document.getElementById("free_shipping_view");
            const freeShipping=document.getElementById("free_shipping");

            freeShipping.value=freeShippingView.value.replace(/[^0-9]/g, "");

            if (freeShipping.value=="") {
                freeShipping.value="0";
            }

            let formData=new FormData(f);

            fetch("/seller_product_insert.do",{method:"post",body:formData}).then(res=>res.json()).then(data=>{
                if (data.result==1) {
                    alert("상품 등록이 되었습니다.");
                    location.href="/product/list.do";
                } else {
                    alert("상품 등록이 실패되어 관리자에게 문의바랍니다.");
                }
            })
        }
        </script>
    </head>

    <body>
        <div >

            <form method="post" enctype="multipart/form-data">

                <!-- 테스트용 판매자 번호,삭제예정 -->
                <input type="hidden" name="seller_id" value="1"/>
                <input type="hidden" name="status" value="APPROVED">

                <table border="1" align="center">
                    <caption>판매자 상품 등록</caption>
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
                            <input type="number" name="stock"/>
                        </td>
                    </tr>

                    <tr>
                        <th>배송비</th>
                        <td>
                            <input type="number" name="delivery_fee"/>
                        </td>
                    </tr>

                    <tr>
                        <th>무료배송 기준 금액</th>
                        <td>
                            <!-- 화면에 보여줄 입력창 -->
                            <input type="text" id="free_shipping_view" placeholder="무료배송 기준 금액 입력"/>
                            <!-- 실제 서버로 넘어갈 값 -->
                            <input type="hidden" name="free_shipping" id="free_shipping" value="0"/>

                            <p><span id="free_shipping_text">0</span>원 이상 구매 시 무료배송으로 설정됩니다.</p>
                        </td>
                    </tr>

                    <tr>
                        <th>대표 이미지</th>
                        <td>
                            <input type="file" name="image_l_file">
                        </td>
                    </tr>

                    <tr>
                        <th>상세 이미지</th>
                        <td>
                            <input type="file" name="image_s_file">
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <input type="button" value="등록" onclick="send(this.form)">
                            <input type="button" value="취소" onclick="location.href='/'">
                        </td>
                    </tr>
                </table>

            </form>

        </div>
    </body>

</html>