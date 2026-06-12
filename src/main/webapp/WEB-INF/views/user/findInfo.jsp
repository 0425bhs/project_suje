<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디/비밀번호 찾기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/findInfo.css">

    <script>

 function switchFind(type) {
    currentFind = type;

    const IdDiv = document.getElementById('loginIdFind');
    const pwdDiv = document.getElementById('pwdFind');
    

    if (type === 'id') {
        IdDiv.style.display = 'block';
        pwdDiv.style.display = 'none';
        
    } else {
        IdDiv.style.display = 'none';
        pwdDiv.style.display = 'block';
        
    }
}

function nameMailCheck(f){

    let name = f.name.value.trim();
     let email = f.email.value.trim();
     let authSendbtn = document.getElementById("authSendbtn");



    if (name === '') {
        alert("이름을 입력하세요");
        return;
    }
    if (email === '') {
        alert("이메일을 입력하세요");
        return;
    }

    let formData = new URLSearchParams(new FormData(f));
    fetch("/findLoginId.do", { method: "post", body: formData })
    .then(res => res.json())
    .then(data => {

        console.log("=== 서버가 보낸 리얼 데이터 확인 ===");

console.log(data); 

        if (data.param == 'no') {
            alert("일치하는 정보가 없습니다");
        } else if(data.param === 'clear') { //자바에서 보낸 "clear"와 일치할 때만 성공 처리
         
            authSendbtn.disabled = false;
        } else {
            // 그 외에 서버에서 예상치 못한 값이나 에러가 왔을 경우
            alert("처리 중 오류가 발생했습니다.");
        }
    })
    .catch(err => {
        console.error("Fetch 통신 에러 발생:", err);
    });    
}




function authSend(f) {

    let formData = new FormData(f);

    fetch("/mailCheck.do", {
        method: "post",
        body: formData
    })
        .then(result => result.json())
        .then(data => {

            alert("인증코드가 입력하신 이메일로 전송되었습니다");

            //인증번호 입력창 활성화
            let authInput = document.getElementById("authInput");

            authInput.disabled = false;
            authInput.focus();

            authNumber = data.authNumber;

        });

}


function findPwd(){

    let email = f.email.value.trim();

    let phone = document.getElementById('phone').value.trim();

    if (email === '') {
        alert("email을 입력하세요");
        return;
    }
    if (phone === '') {
        alert("휴대폰을 입력하세요");
        return;
    }

    let formData = new URLSearchParams(new FormData(f));
    fetch("/emailLogin.do", { method: "post", body: formData })
    .then(res => res.json())
    .then(data => {

        console.log("=== 서버가 보낸 리얼 데이터 확인 ===");

console.log(data); 

        if (data.param == 'noEmail') {
            alert("이메일을 확인하세요");
        } else if (data.param == 'noPhone') {
            alert("휴대폰번호가 일치하지 않습니다");
        } else if (data.param === 'clear') { //자바에서 보낸 "clear"와 일치할 때만 성공 처리               
            location.href = "/login.do";
        } else {
            // 그 외에 서버에서 예상치 못한 값이나 에러가 왔을 경우
            alert("처리 중 오류가 발생했습니다.");
        }
    })
    .catch(err => {
        console.error("Fetch 통신 에러 발생:", err);
    });

}

    </script>
    
</head>
<body>

<div class="login-container">

    <div class="logo">HAND<span>MADE</span></div>


<form id="findForm">  
    <%-- 토글 버튼 --%>
<div class="login-toggle">
    <button type="button" class="toggle-btn active" onclick="switchFind('id')">아이디 찾기</button>
    <button type="button" class="toggle-btn" onclick="switchFind('password')">패스워드 찾기/변경</button>
</div>


<%-- 아이디 찾기 --%>
<div id="loginIdFind">
    
    <div class="input-wrapper">
        <input type="text" name="name" placeholder="이름" />
        </div>

        <div>  
        <input name="email" id="email"  placeholder="가입한 이메일" />
        <input type="button" value="확인" class="btn-secondary" onclick="nameMailCheck(this.form)" />
        </div>

        <div>
          <input type="button" value="인증번호 받기" id="authSendbtn"
          class="btn-secondary" onclick="authSend(this.form)" disabled="disabled"/>   
        </div>

        <div class="input-row">
            <input id="authInput" placeholder="인증번호 6자리" maxlength="6" disabled="disabled" />
            <input type="button" value="인증" class="btn-secondary" onclick="mailCheck(this.form)"/>
        </div>

    </div>
</div>

<%-- 패스워드 찾기 --%>


<div id="pwdFind" style="display:none;">

    <div class="input-wrapper">
        <input name="phone" id="phone"  placeholder="휴대폰번호" />
</div>

                      <div class="input-row">
                        <input name="email" id="authEmail" placeholder="가입한 email" />
                        <input type="button" value="전송" class="btn-secondary" onclick="mailCheck(this.form)" />
                    </div>
                    <div class="input-row">
                        <input id="authInput" placeholder="인증번호 6자리" maxlength="6" disabled="disabled" />
                        <input type="button" value="인증" class="btn-secondary" />
                    </div>
                  
<input type="button" value="찾기" id = "pwdfindbtn" class="findbtn" onclick="findPwd()" />

</div>

</form>