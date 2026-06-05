<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <link rel="stylesheet" href="/css/seller/seller_form_common.css">
    </head>

    <body>
        <div class="seller-board">

            <jsp:include page="seller_sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard" />
                <jsp:param name="sidebarTitle" value="판매자 대시보드" />
            </jsp:include>  
            
            

        </div>
    </body>

</html>
