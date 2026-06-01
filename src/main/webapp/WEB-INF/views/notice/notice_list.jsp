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
                <th>내용</th>
                <th>작성일</th>
                <th>수정일</th>
            </tr>
        </thead>
        <tbody>

        <c:forEach var="notice" items="#{list}">
            <tr>
                <td>${notice.noticeId}</td>
                <td>
                    <a href="/notice_detail.do?noticeId=${notice.noticeId}">${notice.title}</a></td>
                <td>${notice.content}</td>
                <td>${notice.createdAt}</td>
                <td>${notice.updatedAt}</td>
            </tr>
        </c:forEach>

        </tbody>
    </table>
</body>
</html>