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
        <caption>실시간 리뷰</caption>
        <thead>
            <tr>
                <th>상품 이미지</th>
                <th>상품명</th>
                <th>리뷰 내용</th>
                <th>별점</th>
                <th>작성 일시</th>
                <th>비고</th>
            </tr>
        </thead>

        <tbody>
        <c:forEach var="review" items="${list}">
            <tr>
                <td><img src="${review.image_s}"/></td>
                <td>${review.product_name}</td>
                <td>${review.content}</td>
                <td>${review.rating}</td>
                <td>${review.created_at}</td>
                <td><input type="button" value="신고" onclick="location.href='report_form.do?target_type=REVIEW&target_id=${review.review_id}'"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</body>
</html>

