<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>내 찜 목록</title>
</head>
<body>
    <table>
        <caption>내 찜 목록</caption>

        <thead>
            <tr>
                <th>찜 번호</th>
                <th>판매자 번호</th>
                <th>찜 날짜</th>
            </tr>
        </thead>

        <tbody>
            <c:forEach var="favorite" items="${list}">
            <tr>
                <td>${favorite.favorite_id}</td>
                <td>${favorite.seller_id}</td>
                <td>${favorite.created_at}</td>
            </tr>
            </c:forEach>
            
        </tbody>

    </table>
</body>
</html>
