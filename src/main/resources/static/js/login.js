function togglePwdVisibility(e) {
    e.preventDefault();
    let passwordInput = document.getElementById("password");
    let icon = document.getElementById("eyeIcon");

    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        icon.className = "ti ti-eye";
    } else {
        passwordInput.type = "password";
        icon.className = "ti ti-eye-off";
    }
}


function send(f) {
    let email = f.email.value.trim();
    let password = f.password.value.trim();
    
    let pwdReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;


    if (email === '') {
        alert("email을 입력하세요");
        return;
    }
    if (password === '') {
        alert("비밀번호를 입력하세요");
        return;
    }

    /* if (!pwdReg.test(password)) {
            alert("비밀번호는 영문과 숫자를 포함하여 8자 이상이어야 합니다.");
            f.password.focus();
            return;
        }
       */

    let formData = new URLSearchParams(new FormData(f));
    fetch("/login.do", { method: "post", body: formData })
    .then(res => res.json())
    .then(data => {

        console.log("=== 서버가 보낸 리얼 데이터 확인 ===");

console.log(data); 

        if (data.param == 'noEmail') {
            alert("이메일을 확인하세요");
        } else if (data.param == 'noPassword') {
            alert("비밀번호가 일치하지 않습니다");
        } else if (data.param === 'clear') { // ◀ 자바에서 보낸 "clear"와 일치할 때만 성공 처리
            alert("성공");
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
