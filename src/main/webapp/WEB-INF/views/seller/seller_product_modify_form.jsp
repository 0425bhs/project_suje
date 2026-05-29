<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <script>
            window.onload=function(){
                const free_shipping=document.getElementById("free_shipping");
                const free_shipping_text=document.getElementById("free_shipping_text");

                if (free_shipping.value !== ""){
                    let value = free_shipping.value.replace(/[^0-9]/g, "");

                    if (value !== ""){
                        let commaValue = Number(value).toLocaleString();
                        free_shipping.value = commaValue;
                        free_shipping_text.innerText = commaValue;
                    }
                }

                free_shipping.addEventListener("input", function () {
                    let value=this.value.replace(/[^0-9]/g, "");

                    if (value===""){
                        this.value="";
                        free_shipping_text.innerText = "0";
                        return;
                    }

                    let commaValue=Number(value).toLocaleString();

                    this.value=commaValue;
                    free_shipping_text.innerText=commaValue;
                });
            }

            function delImgL(){
                let image_l_div=document.getElementById("image_l_div");
                let ori_image_l=document.getElementById("ori_image_l");

                ori_image_l.value="no_file";
                image_l_div.style.display="none";
            }

            function delImgS(){
                let image_s_div=document.getElementById("image_s_div");
                let ori_image_s=document.getElementById("ori_image_s");

                ori_image_s.value="no_file";
                image_s_div.style.display="none";
            }

            function send(f){
                const imageL=f.image_l_file;
                const imageS=f.image_s_file;

                if (imageL.value==""){
                    alert("대표 이미지를 등록해주세요.");
                    imageL.focus();
                    return;
                }

                if (imageS.value==""){
                    alert("상세 이미지를 등록해주세요.");
                    imageS.focus();
                    return;
                }

                const free_shipping=document.getElementById("free_shipping");

                free_shipping.value=free_shipping.value.replace(/,/g, "");

                let formData=new FormData(f);

                fetch("/seller_product_modify.do",{method:"post",body:formData}).then(res=>res.json()).then(data=>{
                    if (data.result==1) {
                        alert("상품을 수정하셨습니다.");
                        location.href="/product_detail.do?product_id=" + data.product_id;
                    } else {
                        alert("상품 수정 적용이 실패하셨습니다. 관리자에게 문의 바랍니다.");
                    }
                })
            }
        </script>
    </head>

    <body>
        <div>

            <form method="post" enctype="multipart/form-data">

                <input type="hidden" name="product_id" value="${vo.product_id}">
                <input type="hidden" name="seller_id" value="${vo.seller_id}">

                <input type="hidden" name="ori_image_l" id="ori_image_l" value="${vo.image_l}">
                <input type="hidden" name="ori_image_s" id="ori_image_s" value="${vo.image_s}">
                <input type="hidden" name="del_image_l" value="${vo.image_l}">
                <input type="hidden" name="del_image_s" value="${vo.image_s}">

                <div>
                    
                    <span>상품 수정</span>
                    <div>
                        <span>카테고리</span>
                        
                        <select name="category_id" value="${vo.category_id}">
                            <option value="1" ${vo.category_id==1 ? 'selected' : ''}>패션/주얼리</option>
                            <option value="2" ${vo.category_id==2 ? 'selected' : ''}>홈리빙</option>
                            <option value="3" ${vo.category_id==3 ? 'selected' : ''}>뷰티</option>
                            <option value="4" ${vo.category_id==4 ? 'selected' : ''}>식품</option>
                            <option value="5" ${vo.category_id==5 ? 'selected' : ''}>공예</option>
                            <option value="6" ${vo.category_id==6 ? 'selected' : ''}>반려동물</option>
                        </select>
                    </div>    
                </div>
                   
                <div>
                    <span>상품명</span>
                    <input name="name" value="${vo.name}"/>
                </div>

                <div>
                    <th>상품 설명</th>
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
                    <th>배송비</th>
                    <input type="number" name="delivery_fee" value="${vo.delivery_fee}"/>
                </div>

                <div>
                    <div>무료배송 기준 금액</div>
                    <input type="text" name="free_shipping" id="free_shipping" value="${vo.free_shipping}" placeholder="무료배송 기준 금액"/>
                    <c:if test="${vo.free_shipping>0}">
                    <p><span><fmt:formatNumber value="${vo.free_shipping}" pattern="#,###" /></span>원 이상 구매 시 무료배송으로 설정됩니다.</p>
                    </c:if>
                    <c:if test="${free_shipping==0}">
                    <p>무료배송으로 설정됩니다.</p>
                    </c:if>
                </div>

                <div>
                    <div>대표 이미지</div>
                    <c:if test="${vo.image_l ne 'no_file'}">
                        <div id="image_l_div">
                            <img src="${vo.image_l}"/>
                            <input type="button" value="X" onclick="delImgL()"/>
                        </div>
                    </c:if>
                    
                    <input type="file" name="image_l_file">
                </div>

                <div>
                    <div>상세 이미지</div>
                    <c:if test="${vo.image_s ne 'no_file'}">
                        <div id="image_s_div">
                            <img src="${vo.image_s}" width="100"/>
                            <input type="button" value="X" onclick="delImgS()"/>
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