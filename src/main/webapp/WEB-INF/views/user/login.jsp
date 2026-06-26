<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/login.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css">
</head>
<body>

<div class="login-container">
 <form onkeydown="if(event.key === 'Enter') send(event.currentTarget)">
    <div class="logo">HAND<span>MADE</span></div>

<div class="login-title">아이디로 로그인</div>

<%-- 아이디 로그인 --%>
<div id="idLogin">
    <div class="input-wrapper">
        <input type="text" name="login_id" placeholder="아이디" />
    </div>
    <div class="input-wrapper">
        <input name="password" id="passwordId" type="password" placeholder="비밀번호" />
        <button type="button" class="eye-btn" onclick="togglePwdVisibility1(event)">
    <i class="ti ti-eye-off" id="eyeIcon1"></i>
</button>
    </div>
</div>
  

<!-- 
qr코드로 로그인
<div id="qrLogin" style="display:none;">
    
</div>

-->


<div class="login-options">

    <a href="#" onclick="findInfo('login_id')">아이디 찾기</a>

<a href="#" onclick="findInfo('password')">비밀번호 찾기</a>

    <a href="join.do">회원가입</a>
    
</div>

        <input type="button" value="로그인" id = "loginbtn" class="loginbtn" onclick="send(this.form)" />

  </form>



    <div class="divider">간편 로그인/회원가입</div>
 <div class="social-wrap">
        <button type="button" class="btn-kakao" onclick="kakaoLogin()" title="카카오">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M12 3c-4.97 0-9 3.185-9 7.115 0 2.558 1.7 4.792 4.27 6.03-.18.663-.65 2.395-.74 2.74-.12.446.15.44.32.327.13-.087 2.11-1.43 2.95-2.003.7.195 1.44.306 2.2.306 4.97 0 9-3.185 9-7.115S16.97 3 12 3z"/>
            </svg>
        </button>
        <button type="button" class="btn-naver" onclick="naverLogin()" title="네이버">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M16.47 2H22v12.35L7.53 22H2v-12.35L16.47 2zM2 2h5.53l6.06 8.52V2H19.1v14.33l-6.06-8.52V22H2V2z"/>
            </svg>
        </button>
        
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>
