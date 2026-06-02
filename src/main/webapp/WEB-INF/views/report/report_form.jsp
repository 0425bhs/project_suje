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
        <caption>
            ${report.target_type} 신고 작성
        </caption>
        <tr>
            <th>타겟유형</th>
            <td>${report.target_type}</td>
        </tr>
        <tr>
            <th>타겟번호</th>
            <td>${report.target_id}</td>
        </tr>
        <tr>
            <th>이유</th>
            <td><input value="${report.reason}"/></td>
        </tr>
        <tr>
            <td colspan="2">
                <input type="button" value="등록" onclick="send(this.form)"/>
                <input type="button" value="취소" onclick="history.back()"/>
            </td>
        </tr>
    </table>
</body>
</html>