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
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성일</th>
                <th>수정일</th>
            </tr>
        </thead>
        <tbody>

        <c:forEach var="notice" items="#{list}">
            <tr>
                <td>${notice.notice_id}</td>
                <td>
                    <a href="/notice_detail.do?notice_id=${notice.notice_id}">${notice.title}</a></td>
                <td>${notice.created_at}</td>
                <td>${notice.updated_at}</td>
            </tr>
        </c:forEach>
            <tr>
                <td colspan="4">
                    <input type="button" value="공지사항 작성" onclick="location.href='notice_form.do'">
                </td>
            </tr>
        </tbody>
    </table>
</body>
</html>