<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang='ko'>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Page Title</title>
</head>
<body>
    <input type="button" value="리뷰 작성" onclick="location.href='review_form.do?productId=1'">
    <input type="button" value="내 리뷰 목록" onclick="location.href='my_review_list.do'">
    <input type="button" value="실시간 리뷰" onclick="location.href='live_review_list.do'">
</body>
</html>