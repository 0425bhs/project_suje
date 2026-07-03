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





function toggleForm() {
    // 1. 라디오 버튼 요소 가져오기
    let isExchangeChecked = document.getElementById("EXCHANGE").checked;

    // 2. 제어할 div 요소 가져오기
    let exchangeDiv = document.getElementById("exchangeDiv");
    let returnDiv = document.getElementById("returnDiv");

    //체크 상태에 따라 display 속성 변경

    if (isExchangeChecked) {
        exchangeDiv.style.display = "block";
        returnDiv.style.display = "none";
    } else {
        exchangeDiv.style.display = "none";
        returnDiv.style.display = "block";
    }
}


function openCsModal(orderItemId, price) {

   
    const csModal = document.getElementById("csModal");
    const exchangeOrderId = document.getElementById("exchangeOrderIdText");
    const returnOrderId = document.getElementById("returnOrderIdText");
    const exchangePrice = document.getElementById("exchangePrice");
    const returnPrice = document.getElementById("returnPrice");
    const exchangeReason = document.getElementById("exchangeReason");
    const exchangeDetail = document.getElementById("exchangeDetail");
    const returnReason = document.getElementById("returnReason");
    const returnDetail = document.getElementById("returnDetail");
    const exchangeAgree = document.getElementById("exchangeAgree");   
    const returnAgree = document.getElementById("returnAgree");       
    const exchangeRadio = document.getElementById("EXCHANGE"); 

    console.log("openCsModal 호출됨", orderItemId, price); 
    console.log("모달:", csModal, "교환ID:", exchangeOrderId, "반품ID:", returnOrderId);

   

    if (
       csModal == null ||
        exchangeOrderId == null ||
        returnOrderId == null ||
        exchangePrice == null ||
        returnPrice == null ||
        exchangeReason == null ||
        exchangeDetail == null ||
        returnReason == null ||
        returnDetail == null ||
        exchangeAgree == null ||       
        returnAgree == null ||         
        exchangeRadio == null  
    ) {
        return;
    }

    exchangeOrderId.value = orderItemId;
    returnOrderId.value = orderItemId;
    exchangePrice.value = price;
    returnPrice.value = price;

    exchangeReason.value = "";
    exchangeDetail.value = "";
    returnReason.value = "";
    returnDetail.value = "";

    exchangeAgree.checked = false;
returnAgree.checked = false;

exchangeRadio.checked = true;    // 항상 '교환'부터 시작
    toggleForm();                  

    csModal.classList.add("open");

}


function closeCsModal() {
    const csModal = document.getElementById("csModal");

    if (csModal != null) {
        csModal.classList.remove("open");
    }
}


function submitExchangeForm(f) {

    const reason = document.getElementById("exchangeReason");
    const detail = document.getElementById("exchangeDetail");
    const agree = document.getElementById("exchangeAgree");

    if (reason == null || detail == null || agree == null) {
        return;
    }

    if (reason.value === "") {
        alert("교환 사유를 선택해주세요.");
        reason.focus();
        return;
    }

    if (reason.value === "기타" && detail.value.trim() === "") {
        alert("기타 사유를 선택한 경우 상세 사유를 입력해주세요.");
        detail.focus();
        return;
    }

    if (!agree.checked) {
        alert("교환신청 안내사항을 확인해주세요.");
        agree.focus();
        return;
    }

    const confirmExchange = confirm("교환을 신청하시겠습니까?");

    if (!confirmExchange) {
        return;
    }

    const formData = new FormData(f);
    const params = new URLSearchParams(formData).toString();

    fetch('/insertClaim.do', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params
    }).then(response => response.json())
        .then(data => {

            if (data.result === 'Success_ExchangeRequest') {
                alert("교환신청이 완료되었습니다");

            } else {
                alert("교환신청이 실패하습니다. 다시 시도하여주세요");
            }
 } )
  }


function submitReturnForm(f) {

    const reasonR = document.getElementById("returnReason");
    const detailR = document.getElementById("returnDetail");
    const agreeR = document.getElementById("returnAgree");

    if (reasonR == null || detailR == null || agreeR == null) {
        return;
    }

    if (reasonR.value === "") {
        alert("환불 사유를 선택해주세요.");
        reasonR.focus();
        return;
    }

    if (reasonR.value === "기타" && detailR.value.trim() === "") {
        alert("기타 사유를 선택한 경우 상세 사유를 입력해주세요.");
        detailR.focus();
        return;
    }

    if (!agreeR.checked) {
        alert("환불신청 안내사항을 확인해주세요.");
        agreeR.focus();
        return;
    }

    const confirmReturn = confirm("환불을 신청하시겠습니까?");

    if (!confirmReturn) {
        return;
    }
    const formData = new FormData(f);
    const params = new URLSearchParams(formData).toString();

    fetch('/insertClaim.do', {
        method: 'post',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params
    }).then(response => response.json())
        .then(data => {

            if (data.result === 'Success_ReturnRequest') {
                alert("환불신청이 완료되었습니다");

            } else {
                alert("환불신청이 실패하습니다. 다시 시도하여주세요");

            } 
 } )
            }



