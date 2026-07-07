    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<div class="product-home">

  
<div class="join-container">
    <form>

        <input type = "hidden" value = "${sessionUser.user_id}" name = "user_id"/>

    <table id="sellertable" class="sellertable" >
        <caption>판매자 신청</caption>
            <tr>
                <th>상호</th>
                <td><input name="company_name" /></td>
            </tr>
            <tr>
                <th>사업자 등록번호</th>
                <td><input name="business_number" type="number" /></td>
            </tr>
            <tr>
                <th>대표자명</th>
                <td><input name="representative_name" /></td>
            </tr>
            <tr>
                <th>사업자 개업일자</th>
                <td><input name="opening_date" type="date" /></td>
            </tr>
            <tr>
                <th>사업자 주소</th>
                <td><input name="business_address" /></td>
            </tr>
        </table>
        

        
<div class="btn-area">
    <input type="button" value="가입" class="btn-main" onclick="send(this.form)" />
    <input type="button" value="취소" class="btn-cancel" onclick="history.back()" />
</div>
    </form>
</div>
</div>


<link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/update_seller.css" />
 <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/user_edit.css" />
<script src="${pageContext.request.contextPath}/js/user_edit.js"></script>

<script>
    function send(f) {
        f.action = "/update_seller.do";
        f.method = "post";
        f.submit();
    }
</script>
 