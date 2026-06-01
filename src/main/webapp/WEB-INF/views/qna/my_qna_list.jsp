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
                <th>상품 번호</th>
                <th>제목</th>
                <th>내용</th>
                <th>답변</th>
                <th>상태</th>
                <th>작성일</th>
                <th>답변일</th>
            </tr>
        </thead>

        <tbody>
        <c:forEach var="qna" items="${list}">
            <tr>
                <td>${qna.productId}</td>
                <td>
                    <a href="qna_detail.do?qnaId=${qna.qnaId}">${qna.title}</a>
                </td>
                <td>${qna.content}</td>
                <td>${qna.answer}</td>
                <td>${qna.status}</td>
                <td>${qna.createdAt}</td>
                <td>${qna.answeredAt}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</body>
</html>