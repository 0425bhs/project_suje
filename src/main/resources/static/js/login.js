let currentLogin = 'id';


/*function switchLogin(type) {
    currentLogin = type;

    const emailDiv = document.getElementById('idLogin');
    const qrDiv = document.getElementById('qrLogin');
    const loginbtn = document.getElementById('loginbtn');
    const btns = document.querySelectorAll('.toggle-btn');

    if (type === 'id') {
        emailDiv.style.display = 'block';
        qrDiv.style.display = 'none';
        btns[0].classList.add('active');
        btns[1].classList.remove('active');
    } else {
        emailDiv.style.display = 'none';
        qrDiv.style.display = 'block';
        btns[0].classList.remove('active');
        btns[1].classList.add('active');
    }
}
*/

function togglePwdVisibility1(e) {
    e.preventDefault();
    let passwordInput = document.getElementById("passwordId");
    let icon = document.getElementById("eyeIcon1");

    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        icon.className = "ti ti-eye";
    } else {
        passwordInput.type = "password";
        icon.className = "ti ti-eye-off";
    }
}



function send(f) {

    let login_id = f.login_id.value.trim();
    let password = document.getElementById('passwordId').value.trim();
   
    let pwdReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
        

    if (login_id === '') {
        alert("ID를 입력하세요");
        return;
    }

    if (password === '') {
        alert("비밀번호를 입력하세요");
        return;
    }

    if (!pwdReg.test(password)) {
            alert("비밀번호는 영문과 숫자를 포함하여 8자 이상이어야 합니다.");
            return;
        }


    let formData = new URLSearchParams(new FormData(f));
    fetch("/idLogin.do", { method: "post", body: formData })
    .then(res => res.json())
    .then(data => {

        console.log("=== 서버가 보낸 리얼 데이터 확인 ===");

console.log(data); 

        if (data.param == 'noLoginId') {
            alert("아이디를 확인하세요");
        } else if (data.param == 'noPassword') {
            alert("비밀번호가 일치하지 않습니다");
        } else if (data.param === 'clear') { //자바에서 보낸 "clear"와 일치할 때만 성공 처리
            location.href = "/";
        } else {
            // 그 외에 서버에서 예상치 못한 값이나 에러가 왔을 경우
            alert("로그인 처리 중 오류가 발생했습니다.");
        }
    })
    .catch(err => {
        console.error("Fetch 통신 에러 발생:", err);
    });

}


function findInfo(type) {
    location.href = '/findInfo.do?type=' + type;
}


function kakaoLogin() {
    const CLIENT_ID = '33aac57d1dfd2b5b7498004ba718b9d1';
    const REDIRECT_URI = 'http://localhost:9090/kakao/callback.do';
    location.href = `https://kauth.kakao.com/oauth/authorize?client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&response_type=code`;
}

function naverLogin() {
    const CLIENT_ID = 'WRlrhlhNnY73Y1Qixajm';
    const REDIRECT_URI = 'http://localhost:9090/naver/callback.do';
    const STATE = Math.random().toString(36).substring(2); // 보안용 랜덤값
    location.href = `https://nid.naver.com/oauth2.0/authorize?client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&response_type=code&state=${STATE}`;
}