<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
</head>


<body>

    <div id = "addressList">
        <caption>배송지 관리</caption>

        <input type = "button" value = "+배송지 추가하기"/>

        <ol>
<c:forEach var="addr" 
               items="${ address }"
               varStatus="address.">

<li>${ cnt.index }.${ fru }</li>

</c:forEach>
</ul>
        <div>

        </div>

    

    </div>

</body>