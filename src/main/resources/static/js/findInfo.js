     let checkuser_id;
        let currentFind;
         let authNumber;

// 페이지 로드 시 URL 파라미터 확인해서 탭 전환
window.onload = function() {
    const params = new URLSearchParams(window.location.search);
    const type = params.get('type');
    if (type === 'password') {
        switchFind('password');
    }
};

function switchFind(type) {
    currentFind = type;

    const IdDiv = document.getElementById('loginIdFind');
    const pwdDiv = document.getElementById('pwdFind');
    const btns = document.querySelectorAll('.toggle-btn');

    // 토글 버튼 active 클래스 변경 추가
    document.querySelectorAll('.toggle-btn').forEach(btn => btn.classList.remove('active'));
    
    // event.target 대신 type으로 직접 active 처리
    if (type === 'id') {
        IdDiv.style.display = 'block';
        pwdDiv.style.display = 'none';
        btns[0].classList.add('active');
        btns[1].classList.remove('active');
    } else {
        IdDiv.style.display = 'none';
        pwdDiv.style.display = 'block';
        btns[0].classList.remove('active');
        btns[1].classList.add('active');
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
         alert("가입하신 아이디는" + data.login_id + "입니다")
            
        } else {
            // 그 외에 서버에서 예상치 못한 값이나 에러가 왔을 경우
            alert("처리 중 오류가 발생했습니다.");
        }
    })
    .catch(err => {
        console.error("Fetch 통신 에러 발생:", err);
    });    
}


function phoneMailCheck(f){

    
    let email = document.getElementById('pwdFindEmail').value.trim();

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
    fetch("/phoneMailCheck.do", { method: "post", body: formData })
    .then(res => res.json())
    .then(data => {

        console.log("=== 서버가 보낸 리얼 데이터 확인 ===");

console.log(data); 

        if (data.param == 'no') {
            alert("일치하는 정보가 없습니다");
        } else if (data.param === 'clear') { //자바에서 보낸 "clear"와 일치할 때만 성공 처리     
   
        checkuser_id = data.user.user_id;
     
document.getElementById('hiddenUserId').value = checkuser_id; 
        
           let authSendbtn = document.getElementById("authSendbtn");
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

   let formData = new URLSearchParams(new FormData(f));

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

        })
            .catch(err => console.error("인증 메일 전송 오류:", err));
        }


//인증번호확인
            function authCheck(){
                let authInput = document.getElementById("authInput").value;

                if( authInput == authNumber ){
                    alert("일치");
                    // 최종 임시 비번 발급 버튼을 활성화해 줍니다.
                document.getElementById("newPwdSendBtn").disabled = false;
                    
                }else{
                    alert("인증번호를 다시 확인하세요");
                }

            }//change_input()

function sendNewPwd(f) {

    let formData = new URLSearchParams(new FormData(f));

    fetch("/newPwdSend.do", {
        method: "post",
        body: formData
    })
        .then(result => result.json())
        .then(data => {

            if(data.res == 1){
                alert("임시 비밀번호가 이메일로 전송되었습니다. 로그인 페이지로 이동합니다.");
                    location.href = "/login.do";
            }
            else{
                alert("비밀번호 변경 처리 중 오류가 발생했습니다.");
               }
            })
            .catch(err => console.error("임시비번 전송 오류:", err));
        }
           