<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디/비밀번호 찾기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/findInfo.css">
</head>
<body>

<div class="login-container">

    <div class="logo">HAND<span>MADE</span></div>

    <%-- 토글 버튼 --%>
    <div class="login-toggle">
        <button type="button" class="toggle-btn active" onclick="switchFind('id')">아이디 찾기</button>
        <button type="button" class="toggle-btn" onclick="switchFind('password')">패스워드 찾기/변경</button>
    </div>

    <%-- 아이디 찾기 --%>
    <form id="findIdForm">
        <div id="loginIdFind">
            <div class="input-wrapper">
                <input type="text" name="name" placeholder="이름" />
                <input name="email" id="email" placeholder="가입한 이메일" />
                <input type="button" value="확인" class="btn-secondary" onclick="nameMailCheck(this.form)" />
            </div>
        </div>
    </form>

    <%-- 패스워드 변경 --%>
    <form id="findPwdForm">
        <div id="pwdFind" style="display:none;">
            <div class="input-wrapper">

                <input name="phone" id="phone" placeholder="휴대폰번호" />

                <input name="email" id="pwdFindEmail" placeholder="가입한 email" />
                <div class="btn-row">
        
                    <input type="button" value="인증번호 전송" id="authSendbtn" 
                           class="btn-secondary" onclick="authSend(this.form)" />
                </div>

                <div class="input-row">
                    <input type="hidden" id="hiddenUserId" name="user_id" value="0">
                    <input id="authInput" placeholder="인증번호 6자리" maxlength="6" disabled="disabled" />
                    <input type="button" value="인증" class="btn-secondary" onclick="authCheck()" />
                </div>

                <input type="button" value="임시 비번 받기" id="newPwdSendBtn"
                       disabled="disabled" onclick="sendNewPwd(this.form)" />

            </div>
        </div>
    </form>

</div>

<script src="${pageContext.request.contextPath}/js/findInfo.js"></script>
</body>
</html>