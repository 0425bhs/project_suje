function openCancelModal(orderId, amount) {
    const modal = document.getElementById("cancelModal");
    const orderIdInput = document.getElementById("cancelOrderId");
    const orderIdText = document.getElementById("cancelOrderIdText");
    const amountText = document.getElementById("cancelAmountText");
    const reason = document.getElementById("cancelReason");
    const detail = document.getElementById("cancelDetail");
    const agree = document.getElementById("cancelAgree");

    if (
        modal == null ||
        orderIdInput == null ||
        orderIdText == null ||
        amountText == null ||
        reason == null ||
        detail == null ||
        agree == null
    ) {
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
    const reason = document.getElementById("cancelReason");
    const detail = document.getElementById("cancelDetail");
    const agree = document.getElementById("cancelAgree");
    const reasonInput = document.getElementById("cancelReasonInput");
    const form = document.getElementById("cancelForm");

    if (
        reason == null ||
        detail == null ||
        agree == null ||
        reasonInput == null ||
        form == null
    ) {
        return;
    }

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

function toggleOrderItems(button) {
    if (button == null) {
        return;
    }

    const panel = button.nextElementSibling;

    if (panel == null) {
        return;
    }

    const count = button.dataset.count;
    const text = button.querySelector(".toggle-text");

    panel.classList.toggle("open");
    button.classList.toggle("active");

    const isOpen = panel.classList.contains("open");

    if (text != null) {
        if (isOpen) {
            text.textContent = "총 " + count + "건 주문 접기";
        } else {
            text.textContent = "총 " + count + "건 주문 펼쳐보기";
        }
    }
}