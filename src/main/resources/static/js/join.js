
let nickCheck = false;
let idCheck = false;


//이메일 인증관련 변수들
let authNumber;
let email_valid = false;


function chknick() {
    nickCheck = false;

}

function chkid() {
    idCheck = false;

}



function toggleForm() {
    // 1. 라디오 버튼 요소 가져오기
    let isUserChecked = document.getElementById("user").checked;

    // 2. 제어할 테이블 요소 가져오기
    let userTable = document.getElementById("usertable");
    let sellerTable = document.getElementById("sellertable");

    //체크 상태에 따라 display 속성 변경

    nickCheck = false;

    if (isUserChecked) {
        userTable.style.display = "table";      // 일반회원 테이블 
        sellerTable.style.display = "none";    // 판매자 테이블 숨기기
    } else {
        userTable.style.display = "table";      // 일반회원 테이블 
        sellerTable.style.display = "table";    // 판매자 테이블 보이기
    }
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


//닉네임중복체크
function check_nick() {

    let nick_name = document.getElementById("nick_name").value.trim();

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
        body: 'nick_name=' + nick_name
    }).then(response => response.json())
        .then(data => {

            if (data.result === 'no') {
                alert(data.nick_name + "는 이미 사용중입니다");

            } else {
                alert(data.nick_name + "는 사용 가능합니다");
                nickCheck = true;
            }

        })
}

//아이디중복체크
function check_loginId() {

    let login_id = document.getElementById("login_id").value.trim();

    if (login_id === '') {
        alert("아이디를 입력하세요");
        document.getElementById("login_id").focus();
        return;
    }

    fetch('/checkLoginId.do', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'login_id=' + login_id
    }).then(response => response.json())
        .then(data => {

            if (data.result === 'no') {
                alert(data.login_id + "는 이미 사용중입니다");

            } else {
                alert(data.login_id + "는 사용 가능합니다");
                idCheck = true;
            }

        })
}


//메일주소 보내고 인증번호 확인
function mailCheck(f) {

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


function authCheck() {
    let authInput =
        document.getElementById("authInput").value.trim();

        if (!authNumber) {
        alert("먼저 이메일 전송 버튼을 눌러 인증번호를 받아주세요.");
        return;
    }

    if (authInput == String(authNumber).trim()) {
        alert("인증완료");
        email_valid = true;

        // 인증 완료되면 인증메일 입력창도 수정 못하게 잠가버리기
        document.getElementById("authEmail").readOnly = true;
        document.getElementById("authInput").disabled = true;
    } else {
        alert("인증번호를 다시 확인하세요");
    }

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

function checkPwdMatch() {
    let password = document.getElementById("password").value;
    let checkPassword = document.getElementById("checkPassword").value;
    let div = document.getElementById("pwd-match");

    let messages = [];

    if ( password === checkPassword) {
   
        div.innerHTML = "<span style='color:green'>✅ 일치합니다</span>";
    } else {
        div.innerHTML ="<span style='color:red'> 비밀번호가 일치하지 않습니다 </span>";
    }
}




//가입
function send(f) {

    let role = document.getElementById("role").value;
    let isUserChecked = (role === 'USER');
    let nick_name = f.nick_name.value.trim();
    let login_id = f.login_id.value.trim();

    if (login_id === "") {
        alert("아이디를 입력해 주세요.");
        f.login_id.focus();
        return;
    }

    //아이디 중복체크를 마쳤는지 확인
    if (!idCheck) {
        alert("아이디 중복체크를 하세요");
        f.nick_name.focus();
        return;
    }


    if (nick_name === "") {
        alert("닉네임을 입력해 주세요.");
        f.nick_name.focus();
        return;
    }

    //닉네임 중복체크를 마쳤는지 확인
    if (!nickCheck) {
        alert("닉네임 중복체크를 하세요");
        f.nick_name.focus();
        return;
    }

    
    //메일이 인증된 상태인지 확인
   
        if (!email_valid) {
            alert("이메일 인증을 완료해주세요");
            return;
        }

        // 이름 입력 확인
        if (f.name.value.trim() === "") {
            alert("이름을 입력해 주세요.");
            f.name.focus();
            return;
        }
        //비번 유효성검사
        let password = f.password.value.trim();
        let checkPassword = f.checkPassword.value.trim();
        let pwdReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

        if (password === "") {
            alert("비밀번호를 입력해 주세요.");
            f.password.focus();
            return;
        }
        if (!pwdReg.test(password)) {
            alert("비밀번호는 영문과 숫자를 포함하여 8자 이상이어야 합니다.");
            f.password.focus();
            return;

        }

        if (password !== checkPassword) {
            alert("비밀번호가 일치하지 않습니다");
            f.checkPassword.focus();
            return;

        }
    //이메일 유효성 검사
 let email = f.email.value.trim();
     let emailReg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

     if (email === '') {
        alert("email을 입력하세요");
        return;
    }

        if (!emailReg.test(email)) {
    alert("이메일 형식이 올바르지 않습니다");
    return;
}


   if(!isUserChecked) {


        if (f.company_name.value.trim() === "") {
            alert("상호명을 입력해 주세요.");
            f.company_name.focus();
            return;
        }
        if (f.business_number.value.trim() === "") {
            alert("사업자 등록번호를 입력해 주세요.");
            f.business_number.focus();
            return;
        }
        if (f.representative_name.value.trim() === "") {
            alert("대표자명을 입력해 주세요.");
            f.representative_name.focus();
            return;
        }
        if (f.opening_date.value === "") {
            alert("사업자 개업일자를 선택해 주세요.");
            f.opening_date.focus();
            return;
        }
        if (f.business_address.value.trim() === "") {
            alert("사업자 주소를 입력해 주세요.");
            f.business_address.focus();
            return;
        }
    }//사업자


    if(isUserChecked){

         f.action = "/join.do";

    }else{

        f.action = "/joinSeller.do"
    }
   
    f.method = "POST";
    f.submit();
}


