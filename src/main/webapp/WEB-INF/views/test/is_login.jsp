<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.user}">
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "/login.do";
    </script>
</c:if>