<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang='ko'>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Page Title</title>
    <script>
        function del(qna_id) {
            if (!confirm("삭제하시겠습니까?")) {
                return;
            }

            location.href="qna_delete.do?qna_id=" + qna_id;
        }
    </script>
</head>
<body>
    <form>
        <table border="1">
            <caption>문의 정보</caption>
            <tr>
                <th>상품 이미지</th>
                <td><img src="${qna.image_s}" /></td>
            </tr>
            <tr>
                <th>상품 이름</th>
                <td>${qna.product_name}</td>
            </tr>
            <tr>
                <th>제목</th>
                <td>${qna.title}</td>
            </tr>
            <tr>
                <th>내용</th>
                <td>${qna.content}</td>
            </tr>
            <tr>
                <th>상태</th>
                <td>${qna.status}</td>
            </tr>
            <tr>
                <th>작성일</th>
                <td>${qna.created_at}</td>
            </tr>
            <tr>
                <th>답변</th>
                <td>${qna.answer}</td>
            </tr>
            <tr>
                <th>답변일</th>
                <td>${qna.answered_at}</td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="button" value="수정" onclick="location.href='qna_update_form.do?qna_id=${qna.qna_id}'">
                    <input type="button" value="삭제" onclick="del('${qna.qna_id}')">
                </td>    
            </tr>
        </table>
    </form>
</body>
</html>