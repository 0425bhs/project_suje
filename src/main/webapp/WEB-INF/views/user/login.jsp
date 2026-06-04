<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

<div class="login-container">
    <form>
        <table class="login-table">
            <tr>
                <th colspan="3" class="table-title">로그인</th>
            </tr>
            <tr>
                <td class="label-cell">이메일</td>
                <td class="input-cell">
                    <input type="text" name="email" placeholder="example@naver.com" />
                </td>
                <td rowspan="2" class="btn-cell">
                    <input type="button" value="로그인" class="loginbtn" onclick="send(this.form)"/>
                </td>
            </tr>

            <tr>
                <td class="label-cell">비밀번호</td>
                <td class="input-cell">
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <input name="password" id="password" type="password" placeholder="비밀번호 입력" style="flex: 1;" />
                        <button type="button" id="toggleBtn" onclick="togglePwdVisibility(event)" style="background: none; border: none; cursor: pointer; font-size: 18px; padding: 4px;">
                            👁️
                        </button>
                    </div>
                </td>
            </tr>
          
        </table>
        
        <div class="sub-button-container">
            <input type="button" value="회원가입" class="sub-btn join-btn" onclick="location.href = 'join.do'"/> 
            <input type="button" value="카카오톡 로그인" class="sub-btn kakao-btn" onclick="location.href = 'kakaologin.do'"/> 
        </div>
    </form>
</div>

<script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>