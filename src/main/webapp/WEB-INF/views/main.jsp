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
    <input type="button" value="리뷰 작성(1번 상품)" onclick="location.href='review_form.do?productId=1'">
    <input type="button" value="내 리뷰 목록" onclick="location.href='my_review_list.do'">
    <input type="button" value="실시간 리뷰" onclick="location.href='live_review_list.do'">
    <hr>
    <input type="button" value="상품 문의 작성(1번 상품)" onclick="location.href='qna_form.do?productId=1'">
    <input type="button" value="내가 쓴 문의" onclick="location.href='my_qna_list.do'">
    <hr>
    <input type="button" value="공지사항 작성" onclick="location.href='notice_form.do'">
    <input type="button" value="공지사항 목록" onclick="location.href='notice_list.do'">
    <hr>
    <input type="button" value="상품/후기/문의 신고 작성" onclick="location.href='report_form.do'">
    <hr>
    <input type="button" value="간편 로그인" onclick="location.href='login.do'">
    <hr>
</body>
</html>