<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang='ko'>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Page Title</title>
    <script>
        function send(f) {
            let title = f.title.value.trim();

            if (title == '') {
                alert("제목을 입력해주세요.");
                return;
            }

            f.action = "qna_form.do";
            f.method = "post";
            f.submit();
        }
    </script>
</head>
<body>
    <form>
        <table border="1">
            <caption>문의 작성</caption>
            <tr>
                <th>상품 번호</th>
                <td>${productId}</td>
            </tr>
            <tr>
                <th>제목</th>
                <td><input name="title"/></td>
            </tr>
            <tr>
                <th>내용</th>
                <td><textarea name="content"></textarea></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="button" value="작성" onclick="send(this.form)">
                    <input type="button" value="취소" onclick="history.back()">
                </td>    
            </tr>
        </table>
    </form>
</body>
</html>