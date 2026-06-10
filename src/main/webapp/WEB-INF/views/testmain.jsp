<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>테스트 메뉴</title>
</head>
<body>
    <input type="button" value="후기 작성(1번 상품)" onclick="location.href='review_form.do?order_item_id=1'">
    <input type="button" value="내 후기 목록" onclick="location.href='my_review_list.do'">
    <input type="button" value="실시간 후기" onclick="location.href='live_review_list.do'">
    <hr>
    <input type="button" value="상품 문의 작성(1번 상품)" onclick="location.href='qna_form.do?product_id=1'">
    <input type="button" value="내가 쓴 문의" onclick="location.href='my_qna_list.do'">
    <hr>
    <input type="button" value="공지사항 목록" onclick="location.href='notice_list.do'">
    <hr>
    <input type="button" value="상품 신고" onclick="location.href='report_form.do?target_type=PRODUCT&target_id=1'">
    <input type="button" value="후기 신고" onclick="location.href='report_form.do?target_type=REVIEW&target_id=1'">
    <input type="button" value="문의 신고" onclick="location.href='report_form.do?target_type=QNA&target_id=1'">
    <hr>
    <input type="button" value="내 찜 목록" onclick="location.href='my_favorite_list.do'">
    <hr>
    <input type="button" value="간편 로그인" onclick="location.href='login.do'">
    <hr>
</body>
</html>
