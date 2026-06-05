function openCancelModal(orderId, amount) {
    // 결제취소 모달 전체 영역
    const modal = document.getElementById("cancelModal");

    // form으로 서버에 보낼 주문번호 hidden input
    const orderIdInput = document.getElementById("cancelOrderId");

    // 모달 화면에 보여줄 주문번호 영역
    const orderIdText = document.getElementById("cancelOrderIdText");

    // 모달 화면에 보여줄 결제금액 영역
    const amountText = document.getElementById("cancelAmountText");

    // 취소 사유 select
    const reason = document.getElementById("cancelReason");

    // 상세 사유 textarea
    const detail = document.getElementById("cancelDetail");

    // 안내사항 확인 체크박스
    const agree = document.getElementById("cancelAgree");

    if (modal == null) {
        return;
    }

    orderIdInput.value = orderId;
    orderIdText.innerText = "#" + orderId;

    const numberAmount = Number(String(amount).replaceAll(",", ""));

    if (isNaN(numberAmount)) {
        amountText.innerText = amount + "원";
    } else {
        amountText.innerText = numberAmount.toLocaleString("ko-KR") + "원";
    }

    reason.value = "";
    detail.value = "";
    agree.checked = false;

    modal.classList.add("open");
}


function closeCancelModal() {
    const modal = document.getElementById("cancelModal");

    if (modal != null) {
        modal.classList.remove("open");
    }
}


function submitCancelForm() {
    
    // 취소 사유 select
    const reason = document.getElementById("cancelReason");

    // 상세 사유 textarea
    const detail = document.getElementById("cancelDetail");

    // 안내사항 확인 체크박스
    const agree = document.getElementById("cancelAgree");

    // 서버로 보낼 취소 사유 hidden input
    const reasonInput = document.getElementById("cancelReasonInput");

    // 실제로 submit 되는 form
    const form = document.getElementById("cancelForm");

    if (reason.value === "") {
        alert("취소 사유를 선택해주세요.");
        reason.focus();
        return;
    }

    if (reason.value === "기타" && detail.value.trim() === "") {
        alert("기타 사유를 선택한 경우 상세 사유를 입력해주세요.");
        detail.focus();
        return;
    }

    if (!agree.checked) {
        alert("결제취소 안내사항을 확인해주세요.");
        agree.focus();
        return;
    }

    const confirmCancel = confirm("결제취소를 요청하시겠습니까?");

    if (!confirmCancel) {
        return;
    }

    let finalReason = reason.value;

    if (detail.value.trim() !== "") {
        finalReason += " - " + detail.value.trim();
    }

    reasonInput.value = finalReason;

    form.submit();
}


window.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        closeCancelModal();
    }
});