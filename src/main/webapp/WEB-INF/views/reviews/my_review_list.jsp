<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang='kor'>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Page Title</title>
</head>

<body>
    <table border="1">
        <caption>내 리뷰 목록</caption>
        <thead>
            <tr>
                <th>상품 번호</th>
                <th>리뷰 내용</th>
                <th>별점</th>
                <th>작성 일시</th>
            </tr>
        </thead>

        <tbody>

        <c:forEach var="review" items="${list}">
            <tr>
                <td>${review.productId}</td>
                <td>${review.content}</td>
                <td>${review.rating}</td>
                <td>${review.createdAt}</td>
            </tr>
        </c:forEach>
        
        </tbody>
    </table>
</body>
</html>

