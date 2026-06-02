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
    <table border="1">
        <caption>내가 쓴 문의</caption>
        <thead>
            <tr>
                <th>상품 이미지</th>
                <th>상품 이름</th>
                <th>제목</th>
                <th>답변</th>
                <th>상태</th>
                <th>작성일</th>
                <th>답변일</th>
            </tr>
        </thead>

        <tbody>
        <c:forEach var="qna" items="${list}">
            <tr>
                <td><img src="${qna.image_s}"/></td>
                <td>${qna.product_name}</td>
                <td>
                    <a href="qna_detail.do?qna_id=${qna.qna_id}">${qna.title}</a>
                </td>
                <td>${qna.answer}</td>
                <td>${qna.status}</td>
                <td>${qna.created_at}</td>
                <td>${qna.answered_at}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</body>
</html>