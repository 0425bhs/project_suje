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

    <div class="logo">HAND<span>MADE</div>
    <p class="login-notice">로그인이 필요한 서비스입니다.</p>

    <div class="divider">간편 로그인/회원가입</div>

    <button type="button" class="btn-kakao-full" onclick="alert('준비 중입니다!')">
        💬 카카오 3초만에 시작하기
    </button>
    <button type="button" class="btn-email-join" onclick="location.href='join.do'">
        이메일로 가입하기
    </button>

    <div class="social-wrap">
        <button type="button" class="btn-kakao" onclick="alert('준비 중입니다!')" title="카카오">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M12 3c-4.97 0-9 3.185-9 7.115 0 2.558 1.7 4.792 4.27 6.03-.18.663-.65 2.395-.74 2.74-.12.446.15.44.32.327.13-.087 2.11-1.43 2.95-2.003.7.195 1.44.306 2.2.306 4.97 0 9-3.185 9-7.115S16.97 3 12 3z"/>
            </svg>
        </button>
        <button type="button" class="btn-naver" onclick="alert('준비 중입니다!')" title="네이버">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M16.47 2H22v12.35L7.53 22H2v-12.35L16.47 2zM2 2h5.53l6.06 8.52V2H19.1v14.33l-6.06-8.52V22H2V2z"/>
            </svg>
        </button>
        <button type="button" class="btn-toss" onclick="alert('준비 중입니다!')" title="토스">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm4.65 11.65l-4 4c-.2.2-.45.3-.65.3s-.45-.1-.65-.3l-4-4c-.4-.4-.4-1.05 0-1.45s1.05-.4 1.45 0L11 14.55V7c0-.55.45-1 1-1s1 .45 1 1v7.55l2.2-2.2c.4-.4 1.05-.4 1.45 0s.4 1.05 0 1.45z"/>
            </svg>
        </button>
    </div>

    <div class="divider">이메일 로그인</div>

    <form>
        <div class="input-wrapper">
            <input type="text" name="email" placeholder="이메일" />
        </div>

        <div class="input-wrapper">
            <input name="password" id="password" type="password" placeholder="비밀번호" />
            <button type="button" class="eye-btn" onclick="togglePwdVisibility(event)">
                <i class="ti ti-eye-off" id="eyeIcon"></i>
            </button>
        </div>

<div class="login-options">
    <a href="#">아이디 / 비밀번호 찾기</a>
</div>

        <input type="button" value="로그인" class="loginbtn" onclick="send(this.form)" />
    </form>

</div>

<script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>