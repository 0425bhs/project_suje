<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang='kor'>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Page Title</title>
</head>

<!-- 컬럼명	데이터 타입	제약조건 / 기본값	설명
review_id	BIGINT	PK, AUTO_INCREMENT	후기 고유 ID
user_id	BIGINT	FK, NOT NULL	작성자 회원 ID
product_id	BIGINT	FK, NOT NULL	후기가 작성된 상품 ID
order_item_id	BIGINT	FK, NOT NULL	실제 구매 내역(주문 상세) ID
rating	INT	CHECK (1~5)	별점 (1부터 5까지)
content	TEXT	NOT NULL	후기 내용
created_at	TIMESTAMP	DEFAULT CURRENT_TIMESTAMP	후기 작성 일시 -->
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

