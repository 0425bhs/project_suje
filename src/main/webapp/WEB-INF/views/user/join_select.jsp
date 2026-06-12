<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/join_select.css" />
</head>
<body>
<div class="join-select-container">
    <div class="logo">HAND<span>MADE</span>에 오신 것을<br>환영해요</div>
    <p class="subtitle">지금 회원 가입 하신 후</span>HANDMADE의<span></span> 다양한 서비스를 만나보세요!</p>

    <form method="get" action="joinForm.do">

        <label class="option-card selected" id="card-user">
            <span class="radio-circle"></span>
            <input type="radio" name="role" value="USER" id="role-user" checked hidden>
            <div class="option-info">
                <p class="option-title">일반회원 가입</p>
                <p class="option-desc">상품을 구매하고 혜택을 받아보세요</p>
            </div>
        </label>

        <label class="option-card" id="card-seller">
            <span class="radio-circle"></span>
            <input type="radio" name="role" value="SELLER" id="role-seller" hidden>
            <div class="option-info">
                <p class="option-title">판매자 회원가입</p>
                <p class="option-desc">입점하여 상품을 판매해보세요</p>
            </div>
        </label>

        <button type="submit" class="btn-main">다음으로</button>
    </form>

    <div class="login-link">이미 계정이 있으신가요? <a href="login.do">로그인하기</a></div>
</div>

<script>
    document.querySelectorAll('.option-card').forEach(card => {
        card.addEventListener('click', () => {
            document.querySelectorAll('.option-card').forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
        });
    });
</script>
</body>
</html>