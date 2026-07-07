<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>배송지 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/myshop/address_list.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" />
    <script>
        function modify(f){
            f.action = "/modifyAddress.do";
            f.method = "get";
            f.submit();
        }

        function del(f){
            f.action = "/deleteAddress.do";
            f.method = "post";
            f.submit();
        }
    </script>
</head>

<body>



<div class="address-list-page-wrap">

    <div id="addressList">
        <div class="list-header">
            <span class="list-title">배송지 관리</span>
            <input type="button" value="+ 배송지 추가하기" class="btn-add" onclick="location.href='/insertAddress.do'"/>
        </div>

        <ul>
            <c:forEach var="address" items="${list}">
            <li>
                <form>
                    <c:if test="${address.is_default == 'true'}">
                        <span>기본배송지</span>
                    </c:if>

                    <div class="recipient-name">
                            ${not empty address.recipient_name ? address.recipient_name : '이름 없음'} 
                            (${not empty address.address_name ? address.address_name : '배송지'})
                        </div>
                    <div class="address-phone">${not empty address.phone ? address.phone : ''}</div>
                        <div class="address-addr">
                            (${not empty address.zipcode ? address.zipcode : ''}) 
                            ${not empty address.address ? address.address : ''} 
                            ${not empty address.detail_address ? address.detail_address : ''}
                        </div>
                        <input type="hidden" name="address_id" value="${address.address_id}"/>
                        <div class="card-actions">
                            <input type="button" value="수정" class="btn-outline" onclick="modify(this.form)"/>
                            <input type="button" value="삭제" class="btn-outline" onclick="del(this.form)"/>
                        </div>
                </form>
            </li>
            </c:forEach>
        </ul>
    </div>

</div>

</body>
</html>