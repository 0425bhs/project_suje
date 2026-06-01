<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang='kor'>
<head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Page Title</title>
    <script>
    </script>
</head>

<body>
    <form>
        <table border="1">
            <caption>공지사항 상세</caption>
            <tr>
                <th>제목</th>
                <td>
                    <input name="title" value="${notice.title}"/>
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <input name="content" value="${notice.content}"/>
                </td>
            </tr>
            <tr>
                <th>작성일</th>
                <td>
                    <input name="content" value="${notice.createdAt}"/>
                </td>
            </tr>
            <tr>
                <th>수정일</th>
                <td>
                    <input name="content" value="${notice.updatedAt}"/>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="button" value="수정" onclick=""/>
                    <input type="button" value="삭제" onclick=""/>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>

