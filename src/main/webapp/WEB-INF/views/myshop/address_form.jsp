<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>배송지 등록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myshop/address_form.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" />
<script>


function search(){


}

function send(f){

     if (f.recipient_name.value.trim() === "") {
            alert("수령인을 입력해 주세요.");
            f.company_name.focus();
            return;
        }
        if (f.zipcode.value.trim() === "") {
            alert("우편번호를 입력해 주세요.");
            f.business_number.focus();
            return;
        }
        if (f.address.value.trim() === "") {
            alert("주소를 입력해 주세요.");
            f.representative_name.focus();
            return;
        }
        if (f.detail_address.value.trim() === "") {
            alert("상세주소를 입력해 주세요.");
            f.representative_name.focus();
            return;
        }
        if (f.phone.value === "") {
            alert("휴대폰 번호를 선택해 주세요.");
            f.opening_date.focus();
            return;
        }
        if (f.address_name.trim() === "") {
            alert("배송지명을 입력해 주세요.");
            f.business_address.focus();
            return;
        }

    

    f.action = "/insertAddress.do";
    f.method = "POST";
    f.submit();



}

</script>

</head>
<body>
<div class="join-container">
    <form method="post" enctype="multipart/form-data">

        <table id = "address_input">      

            <input type="hidden" name="login_id"   id="login_id"   value="${user.login_id}" />
            
           <tr>
                <th>수령인</th>
                <td><input name="recipient_name" /></td>
            </tr>
            <tr>
                <th>우편번호</th>
                <td><input name="zipcode" />
                <input type="button" value="검색" class="btn-main" onclick="search(this.form)" />
            </td>
            </tr>
            <tr>
                <th>주소</th>
                <td><input name="address" /></td>
                
            </tr>
            <tr>
                <th>상세주소</th>
                <td><input name="detail_address" /></td>
            </tr>
            <tr>
                <th>휴대폰</th>
                <td><input name="phone" /></td>
            </tr>

              <tr>
                <th>배송지명</th>
                <td><input name="address_name" /></td>
            </tr>

          <tr>
    <td colspan="2">
        <input type="checkbox" name="is_default" value="true" id="is_default" />
        <label for="is_default">기본 배송지로 설정</label>
    </td>
</tr>
        </table>
     

        <table class="apply-table">
            <tr>
                <td colspan="2" align="center" style="padding-top: 30px;">
                    <input type="button" value="등록" class="btn-main" 
                    onclick="send(this.form)" />
                    <input type="button" value="취소" class="btn-cancel" 
                    onclick="history.back()" />
                </td>
            </tr>
        </table>

    </form>
</div>


</body>
</html>