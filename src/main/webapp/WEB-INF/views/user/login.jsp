<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/login.css">
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
            
        </div>

                <div class="social-wrap">
    <button type="button" class="btn-kakao" onclick="alert('카카오 간편 로그인은 현재 준비 중입니다!');" title="카카오톡으로 로그인">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M12 3c-4.97 0-9 3.185-9 7.115 0 2.558 1.7 4.792 4.27 6.03-.18.663-.65 2.395-.74 2.74-.12.446.15.44.32.327.13-.087 2.11-1.43 2.95-2.003.7.195 1.44.306 2.2.306 4.97 0 9-3.185 9-7.115S16.97 3 12 3z"/>
        </svg>
    </button>

    <button type="button" class="btn-naver" onclick="alert('네이버 간편 로그인은 현재 준비 중입니다!');" title="네이버로 로그인">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M16.47 2H22v12.35L7.53 22H2v-12.35L16.47 2zM2 2h5.53l6.06 8.52V2H19.1v14.33l-6.06-8.52V22H2V2z"/>
        </svg>
    </button>

    <button type="button" class="btn-toss" onclick="alert('토스 간편 로그인은 현재 준비 중입니다!');" title="토스아이디로 로그인">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm4.65 11.65l-4 4c-.2.2-.45.3-.65.3s-.45-.1-.65-.3l-4-4c-.4-.4-.4-1.05 0-1.45s1.05-.4 1.45 0L11 14.55V7c0-.55.45-1 1-1s1 .45 1 1v7.55l2.2-2.2c.4-.4 1.05-.4 1.45 0s.4 1.05 0 1.45z"/>
        </svg>
    </button>
</div>
    </form>
</div>

<script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>