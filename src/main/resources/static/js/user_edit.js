let nickCheck = true;
let isPwdVerified = false;
function chk() {
    let currentNick = document.getElementById("nick_name").value.trim();
    // 지우고 다시 썼을때 원래 본인 닉네임과 같다면 중복체크 패스
    if (currentNick === "${user.nick_name}") {
        nickCheck = true;
    } else {
        nickCheck = false;
    }
}

function chk2() {
    isPwdVerified = false;
    document.getElementById("password").value = "";
    document.getElementById("checkPassword").value = "";
    document.getElementById("password").disabled = true;
    document.getElementById("checkPassword").disabled = true;
}


function check_nick() {

    let nick_name_el = document.getElementById("nick_name");
    let nick_name = nick_name_el.value.trim();

    if (nick_name === '') {
        alert("닉네임을 입력하세요");
        document.getElementById("nick_name").focus();
        return;
    }

    fetch('/checkNick.do', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'nick_name=' + encodeURIComponent(nick_name)
    }).then(response => response.json())
        .then(data => {

            if (data.result === 'no') {
                alert(data.nick_name + "는 이미 사용중입니다");

            } else {
                alert(data.nick_name + "는 사용 가능합니다");
                nickCheck = true;
            }

        }).catch(err => {
            alert("중복 체크 중 오류가 발생했습니다.");
        });
}


function check_func() {
    let ori_password_el = document.getElementById("ori_password");
    let ori_password = ori_password_el.value;
    let password = document.getElementById("password");
    let checkPassword = document.getElementById("checkPassword");

    let correct_password = "${user.password}";

    if (ori_password.trim() === "") {
        alert("현재 비밀번호를 입력해주세요.");
        ori_password_el.focus();
        return;
    }


    fetch("/check_currPassword.do", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "ori_password=" + encodeURIComponent(ori_password)
    })
        .then(res => res.json())
        .then(data => {
            if (data.isValid === true) {
                alert("비밀번호가 확인되었습니다.");
                isPwdVerified = true;
                // 검증 성공 시 새 비밀번호 창 활성화
                password.disabled = false;
                checkPassword.disabled = false;
                password.focus();
            } else {
                alert("현재 비밀번호가 일치하지 않습니다.");
                isPwdVerified = false;
                ori_password.value = "";
                ori_password.focus();
            }
        })
        .catch(err => {
            console.error("오류 발생:", err);
            alert("비밀번호 확인 중 오류가 발생했습니다.");
        });
}

function checkPwdRules() {
    let password = document.getElementById("password").value;
    let div = document.getElementById("pwd-rules");

    let messages = [];

    if (password.length < 8)
        messages.push("8자 이상이어야 합니다");

    if (!/[A-Za-z]/.test(password))
        messages.push("영문이 포함되어야 합니다");

    if (!/[0-9]/.test(password))
        messages.push("숫자가 포함되어야 합니다");

    if (messages.length === 0) {
        div.innerHTML = "<span style='color:green'>✅ 사용 가능한 비밀번호입니다</span>";
    } else {
        div.innerHTML = messages.map(m => `<span style='color:red'>${m}</span>`).join("<br>");
    }
}


function send(f) {
    //닉네임
    let nick_name = f.nick_name.value.trim();
    if (nick_name === "") {
        alert("닉네임을 입력해주세요.");
        f.nick_name.focus();
        return;
    }
    if (!nickCheck) {
        alert("닉네임 중복체크를 완료해주세요.");
        return;
    }

    //이름 공백 검증
    if (f.name.value.trim() === "") {
        alert("이름을 입력해주세요.");
        f.name.focus();
        return;
    }

    //비밀번호 유효성 검증
    let ori_password = document.getElementById("ori_password").value.trim();
    let password = f.password.value.trim();
    let checkPassword = f.checkPassword.value.trim();

    // 현재 비밀번호 창에 무언가 입력되었거나, 새 비밀번호를 세팅하려고 할 때
    if (ori_password !== "" || password !== "") {
        if (!isPwdVerified) {
            alert("현재 비밀번호 확인을 먼저 완료해주세요.");
            return;
        }

        // 새 비밀번호 형식 검사 (영문, 숫자 포함 8자 이상)
        let pwdReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
        if (!pwdReg.test(password)) {
            alert("새 비밀번호는 영문과 숫자를 포함하여 8자 이상이어야 합니다.");
            f.password.focus();
            return;
        }

        if (password !== checkPassword) {
            alert("새 비밀번호가 일치하지 않습니다.");
            f.checkPassword.focus();
            return;
        }
    }

    f.password.disabled = false;
    f.checkPassword.disabled = false;

    let formData = new FormData(f);

    fetch("/user_modify.do", {
        method: "post",
        body: formData
    })
        .then(res => res.json())
        .then(data => {

            if (data.result == 1) {
                alert("수정성공");
                location.href = "/user_mypage.do";
            } else {
                alert("수정실패");
            }
        })

}

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

function togglePwdVisibility2(e) {
    e.preventDefault();
    let chPasswordInput = document.getElementById("checkPassword");
    let icon = document.getElementById("eyeIcon2");

    if (chPasswordInput.type === "password") {
        chPasswordInput.type = "text";
        icon.className = "ti ti-eye";
    } else {
        chPasswordInput.type = "password";
        icon.className = "ti ti-eye-off";
    }
}
function togglePwdVisibility3(e) {
    e.preventDefault(); // 

    let passwordInput = document.getElementById("ori_password");
    let icon = document.getElementById("eyeIcon3");

    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        icon.className = "ti ti-eye";
    } else {
        passwordInput.type = "password";
        icon.className = "ti ti-eye-off";
    }
}




function deletePhoto() {
    let photo_div =
        document.getElementById("photo_div");

    let ori_photo_name =
        document.getElementById("ori_photo_name");

    ori_photo_name.value = "no_file";
    photo_div.style.display = 'none';
}

function sellerModify(f) {
    f.action = "/addSeller.do";
    f.submit();
}
