<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/withdraw.css" />
<div class="withdraw-container">
    <h2>회원 탈퇴 안내</h2>
    <p class="warning-title">정말 탈퇴하시겠습니까? 탈퇴 전 아래 내용을 반드시 확인해 주세요.</p>
    
    <div class="warning-box">
        <ul>
            <li>탈퇴 후 회원정보 및 이용기록은 모두 삭제되며, 다시 복구할 수 없습니다.</li>
            <li>작성한 구매후기와 결제 내역은 이용약관과 관련법에 의해 보관됩니다.</li>
            <li>보유하고 계신 적립금, 쿠폰 등 모든 혜택은 자동 소멸됩니다.</li>
            <li>진행 중인 주문, 배송, 반품, 교환 건이 있는 경우 탈퇴가 불가능할 수 있습니다.</li>
        </ul>
    </div>

    <div class="agree-zone">
        <label>
            <input type="checkbox" id="agreeCheck"> 안내 사항을 모두 확인하였으며, 이에 동의합니다.
        </label>
    </div>

    <div class="btn-zone">
        <button type="button" class="btn-cancel" onclick="location.href='/myshop'">취소하기</button>
        <button type="button" class="btn-withdraw" onclick="proceedWithdraw()">탈퇴하기</button>
    </div>
</div>

<script>
function proceedWithdraw() {
    // 1. 순수 자바스크립트로 체크박스 요소 가져오기
    const agreeCheck = document.getElementById("agreeCheck");
    
    // 2. 체크박스가 체크되어 있지 않다면
    if (!agreeCheck.checked) {
        alert("안내 사항에 동의하셔야 탈퇴가 가능합니다.");
        return;
    }

    // 3. 최종 확인 팝업
    if (confirm("정말 탈퇴를 진행하시겠습니까?\n이 작업은 되돌릴 수 없습니다.")) {
        
        
        fetch("/withdraw.do", {
            method: "POST"
        })
        .then(response => {
            
            return response.json();
        })
        .then(data => {
            // 컨트롤러가 리턴한 Map의 결과(data.result)
            if (data.result === "success") {
                alert("회원 탈퇴가 정상적으로 처리되었습니다. 그동안 이용해 주셔서 감사합니다.");
                location.href = "/"; 
            }    else if (data.result === "notDeliverYet") {
                alert("배송이 완료되지 않은 상품이 있습니다.");
                location.href = "/login.do";
            } else if (data.result === "noSession") {
                alert("로그인 세션이 만료되었습니다. 다시 로그인해 주세요.");
                location.href = "/login.do";
            } else {
                alert("탈퇴 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
            }
        })
        .catch(error => {
            // 네트워크 연결 실패 등 에러 발생 시
            console.error("Error:", error);
            alert("서버 통신 오류가 발생했습니다.");
        });
    }
}
</script>