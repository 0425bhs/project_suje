window.addEventListener("load", function (){
    initSellerOrderViewSwitch();
    initSellerOrderStatusAutoSubmit();
    initSellerOrderModal();
});

/*
    리스트 형태 전환
*/
function initSellerOrderViewSwitch(){
    const buttons = document.querySelectorAll(".view-icon-btn");
    const panels = document.querySelectorAll("[data-view-panel]");

    if (buttons.length === 0 || panels.length === 0){
        return;
    }

    let savedView = localStorage.getItem("sellerOrderView");

    if (savedView !== "simple" && savedView !== "card"){
        savedView = "simple";
    }

    changeSellerOrderView(savedView);

    buttons.forEach(function(button){
        button.addEventListener("click", function(event){
            event.preventDefault();

            const view = button.getAttribute("data-view");

            if (view !== "simple" && view !== "card"){
                return;
            }

            localStorage.setItem("sellerOrderView", view);
            changeSellerOrderView(view);
        });
    });
}

/*
    화면 형태 변경
*/
function changeSellerOrderView(view){
    const buttons = document.querySelectorAll(".view-icon-btn");
    const panels = document.querySelectorAll("[data-view-panel]");

    buttons.forEach(function(button){
        const buttonView = button.getAttribute("data-view");

        if (buttonView === view){
            button.classList.add("active");
        } else {
            button.classList.remove("active");
        }
    });

    panels.forEach(function(panel){
        const panelView = panel.getAttribute("data-view-panel");

        if (panelView === view){
            panel.classList.add("active");
        } else {
            panel.classList.remove("active");
        }
    });
}

/*
    주문 상태 select 변경 시 바로 submit
*/
function initSellerOrderStatusAutoSubmit(){
    const statusSelectList = document.querySelectorAll(".seller-status-select");

    statusSelectList.forEach(function (select){
        select.addEventListener("change", function (){
            const form = select.closest("form");

            if (form == null){
                return;
            }

            select.classList.add("is-changing");
            form.submit();
        });
    });
}

/*
    주문 상품 모달
*/
function initSellerOrderModal(){
    const modal = document.getElementById("sellerOrderModal");
    const modalContent = document.getElementById("sellerOrderModalContent");
    const closeButtons = document.querySelectorAll("[data-modal-close]");

    if (modal == null || modalContent == null){
        return;
    }

    document.addEventListener("click", function(event){
        const modalTargetElement = event.target.closest("[data-modal-target]");

        if (modalTargetElement == null){
            return;
        }

        const blockedElement = event.target.closest(
            "select, option, form, a, input, textarea, label, .simple-receipt-btn, .card-receipt-btn, .seller-direct-claim-open-btn, .buyer-claim-open-btn, .view-icon-btn, [data-modal-close]"
        );

        if (blockedElement != null){
            return;
        }

        event.preventDefault();

        const targetId = modalTargetElement.getAttribute("data-modal-target");
        const template = document.getElementById(targetId);

        if (template == null){
            return;
        }

        modalContent.innerHTML = template.innerHTML;
        modal.classList.add("active");
        document.body.classList.add("modal-open");
    });

    closeButtons.forEach(function(button){
        button.addEventListener("click", function(){
            closeSellerOrderModal();
        });
    });

    window.addEventListener("keydown", function(event){
        if (event.key === "Escape"){
            closeSellerOrderModal();
            closeSellerDirectClaimModal();
            closeBuyerRequestClaimModal();
        }
    });
}

/*
    주문 상품 모달 닫기
*/
function closeSellerOrderModal(){
    const modal = document.getElementById("sellerOrderModal");
    const modalContent = document.getElementById("sellerOrderModalContent");

    if (modal == null || modalContent == null){
        return;
    }

    modal.classList.remove("active");
    modalContent.innerHTML = "";
    document.body.classList.remove("modal-open");
}

/*
    상품관리 탭: 판매자 직접 반품/교환 처리 모달 열기
*/
function openSellerDirectClaimModal(event, button){
    if(event != null){
        event.preventDefault();
        event.stopPropagation();
    }

    const claimType = button.getAttribute("data-claim-type");
    const orderId = button.getAttribute("data-order-id");
    const itemTemplateId = button.getAttribute("data-item-template-id");

    const modal = document.getElementById("sellerDirectClaimModal");
    const itemTemplate = document.getElementById(itemTemplateId);
    const itemSelect = document.getElementById("sellerDirectOrderItemSelect");

    if(modal == null || itemTemplate == null || itemSelect == null){
        return;
    }

    document.getElementById("sellerDirectOrderId").value = orderId;
    itemSelect.innerHTML = itemTemplate.innerHTML;

    if(itemSelect.options.length > 0){
        itemSelect.selectedIndex = 0;
    }

    changeSellerDirectItemPrice(itemSelect);

    document.getElementById("sellerDirectReason").value = "";
    document.getElementById("sellerDirectDetailReason").value = "";
    document.getElementById("sellerDirectSellerAnswer").value = "";
    document.getElementById("sellerDirectAgree").checked = false;

    changeSellerDirectClaimType(claimType);

    modal.classList.add("open");
    document.body.classList.add("modal-open");
}

/*
    상품관리 탭: 직접 처리 상품 변경 시 금액 변경
*/
function changeSellerDirectItemPrice(select){
    const priceInput = document.getElementById("sellerDirectPrice");

    if(select == null || priceInput == null){
        return;
    }

    const selectedOption = select.options[select.selectedIndex];

    if(selectedOption == null){
        priceInput.value = "0원";
        return;
    }

    const price = selectedOption.getAttribute("data-price");
    priceInput.value = formatSellerClaimPrice(price);
}

/*
    상품관리 탭: 직접 처리 모달 닫기
*/
function closeSellerDirectClaimModal(){
    const modal = document.getElementById("sellerDirectClaimModal");

    if(modal == null){
        return;
    }

    modal.classList.remove("open");
    document.body.classList.remove("modal-open");
}

/*
    상품관리 탭: 반품/교환 타입 변경
*/
function changeSellerDirectClaimType(claimType){
    const statusInput = document.getElementById("sellerDirectClaimStatus");
    const returnRadio = document.getElementById("sellerDirectClaimReturn");
    const exchangeRadio = document.getElementById("sellerDirectClaimExchange");
    const title = document.getElementById("sellerDirectClaimModalTitle");
    const reasonLabel = document.getElementById("sellerDirectReasonLabel");
    const reasonSelect = document.getElementById("sellerDirectReason");
    const guideTitle = document.getElementById("sellerDirectGuideTitle");
    const guideList = document.getElementById("sellerDirectGuideList");
    const submitBtn = document.getElementById("sellerDirectSubmitBtn");

    if(statusInput == null || reasonSelect == null){
        return;
    }

    if(claimType === "RETURN"){
        statusInput.value = "RETURN_DONE";

        if(returnRadio != null){
            returnRadio.checked = true;
        }

        if(title != null){
            title.innerText = "반품 직접 처리";
        }

        if(reasonLabel != null){
            reasonLabel.innerText = "반품 처리 사유";
        }

        if(guideTitle != null){
            guideTitle.innerText = "반품 처리 안내";
        }

        if(submitBtn != null){
            submitBtn.innerText = "반품처리";
        }

        reasonSelect.innerHTML =
            '<option value="">반품 처리 사유를 선택해주세요</option>' +
            '<option value="단순 변심">단순 변심</option>' +
            '<option value="배송 지연">배송 지연</option>' +
            '<option value="상품 불량">상품 불량</option>' +
            '<option value="판매자 직접 처리">판매자 직접 처리</option>' +
            '<option value="기타">기타</option>';

        if(guideList != null){
            guideList.innerHTML =
                '<li>저장하면 상태가 <b>반품완료</b>로 바로 변경됩니다.</li>' +
                '<li>이 처리는 구매자 요청이 아니라 판매자 직접 처리 건입니다.</li>' +
                '<li>판매자가 선택한 상품과 사유가 저장됩니다.</li>';
        }
    } else {
        statusInput.value = "EXCHANGE_DONE";

        if(exchangeRadio != null){
            exchangeRadio.checked = true;
        }

        if(title != null){
            title.innerText = "교환 직접 처리";
        }

        if(reasonLabel != null){
            reasonLabel.innerText = "교환 처리 사유";
        }

        if(guideTitle != null){
            guideTitle.innerText = "교환 처리 안내";
        }

        if(submitBtn != null){
            submitBtn.innerText = "교환처리";
        }

        reasonSelect.innerHTML =
            '<option value="">교환 처리 사유를 선택해주세요</option>' +
            '<option value="잘못된 상품 배송">잘못된 상품 배송</option>' +
            '<option value="상품 불량">상품 불량</option>' +
            '<option value="옵션 변경">옵션 변경</option>' +
            '<option value="판매자 직접 처리">판매자 직접 처리</option>' +
            '<option value="기타">기타</option>';

        if(guideList != null){
            guideList.innerHTML =
                '<li>저장하면 상태가 <b>교환완료</b>로 바로 변경됩니다.</li>' +
                '<li>이 처리는 구매자 요청이 아니라 판매자 직접 처리 건입니다.</li>' +
                '<li>판매자가 선택한 상품과 사유가 저장됩니다.</li>';
        }
    }
}

function submitSellerDirectClaimForm(){
    const statusInput = document.getElementById("sellerDirectClaimStatus");
    const itemSelect = document.getElementById("sellerDirectOrderItemSelect");
    const reasonSelect = document.getElementById("sellerDirectReason");
    const detailReasonInput = document.getElementById("sellerDirectDetailReason");
    const sellerAnswerInput = document.getElementById("sellerDirectSellerAnswer");
    const agreeInput = document.getElementById("sellerDirectAgree");

    if(statusInput == null || itemSelect == null || reasonSelect == null || detailReasonInput == null || sellerAnswerInput == null || agreeInput == null){
        alert("처리 폼 정보를 찾을 수 없습니다.");
        return false;
    }

    const status = statusInput.value;
    const orderItemId = itemSelect.value;
    const reason = reasonSelect.value;
    const detailReason = detailReasonInput.value;
    const sellerAnswer = sellerAnswerInput.value;

    if(orderItemId == null || orderItemId.trim() === ""){
        alert("처리할 상품을 선택해주세요.");
        return false;
    }

    if(reason == null || reason.trim() === ""){
        alert("처리 사유를 선택해주세요.");
        return false;
    }

    if(detailReason == null || detailReason.trim() === ""){
        alert("판매자 상세 사유를 입력해주세요.");
        return false;
    }

    if(sellerAnswer == null || sellerAnswer.trim() === ""){
        alert("판매자 처리 안내를 입력해주세요.");
        return false;
    }

    if(agreeInput.checked === false){
        alert("처리 안내사항을 확인해주세요.");
        return false;
    }

    if(status === "RETURN_DONE"){
        return confirm("선택한 상품을 반품완료로 바로 처리하시겠습니까?");
    }

    if(status === "EXCHANGE_DONE"){
        return confirm("선택한 상품을 교환완료로 바로 처리하시겠습니까?");
    }

    alert("처리 상태가 올바르지 않습니다.");
    return false;
}

/*
    반품/교환 탭: 구매자 요청 처리 모달 열기
*/
function openBuyerRequestClaimModal(event, button){
    if(event != null){
        event.preventDefault();
        event.stopPropagation();
    }

    const claimType = button.getAttribute("data-claim-type");
    const claimId = button.getAttribute("data-claim-id");
    const orderItemId = button.getAttribute("data-order-item-id");
    const price = button.getAttribute("data-price");
    const requestReason = button.getAttribute("data-request-reason");
    const requestDetail = button.getAttribute("data-request-detail");
    const requestedAt = button.getAttribute("data-requested-at");

    const modal = document.getElementById("buyerRequestClaimModal");

    if(modal == null){
        return;
    }

    document.getElementById("buyerRequestClaimId").value = claimId;
    document.getElementById("buyerRequestOrderItemIdText").value = orderItemId;
    document.getElementById("buyerRequestPrice").value = formatSellerClaimPrice(price);
    document.getElementById("buyerRequestRequestedAt").value = requestedAt == null ? "" : requestedAt;
    document.getElementById("buyerRequestReason").value = requestReason == null ? "" : requestReason;
    document.getElementById("buyerRequestDetail").value = requestDetail == null ? "" : requestDetail;
    document.getElementById("buyerRequestSellerAnswer").value = "";
    document.getElementById("buyerRequestAgree").checked = false;

    if(claimType === "RETURN"){
        document.getElementById("buyerRequestClaimStatus").value = "RETURN_DONE";
        document.getElementById("buyerRequestClaimTitle").innerText = "반품 요청 처리";
        document.getElementById("buyerRequestReasonLabel").innerText = "구매자 반품 사유";
        document.getElementById("buyerRequestSubmitBtn").innerText = "반품처리";

        document.getElementById("buyerRequestGuideList").innerHTML =
            '<li>처리하면 상태가 <b>반품완료</b>로 변경됩니다.</li>' +
            '<li>구매자가 작성한 반품 사유는 수정하지 않습니다.</li>' +
            '<li>판매자 처리 안내만 저장됩니다.</li>';
    } else {
        document.getElementById("buyerRequestClaimStatus").value = "EXCHANGE_DONE";
        document.getElementById("buyerRequestClaimTitle").innerText = "교환 요청 처리";
        document.getElementById("buyerRequestReasonLabel").innerText = "구매자 교환 사유";
        document.getElementById("buyerRequestSubmitBtn").innerText = "교환처리";

        document.getElementById("buyerRequestGuideList").innerHTML =
            '<li>처리하면 상태가 <b>교환완료</b>로 변경됩니다.</li>' +
            '<li>구매자가 작성한 교환 사유는 수정하지 않습니다.</li>' +
            '<li>판매자 처리 안내만 저장됩니다.</li>';
    }

    modal.classList.add("open");
    document.body.classList.add("modal-open");
}

/*
    반품/교환 탭: 구매자 요청 처리 모달 닫기
*/
function closeBuyerRequestClaimModal(){
    const modal = document.getElementById("buyerRequestClaimModal");

    if(modal == null){
        return;
    }

    modal.classList.remove("open");
    document.body.classList.remove("modal-open");
}

/*
    반품/교환 탭: 구매자 요청 처리 submit 검증
*/
function submitBuyerRequestClaimForm(){
    const statusInput = document.getElementById("buyerRequestClaimStatus");
    const answerInput = document.getElementById("buyerRequestSellerAnswer");
    const agreeInput = document.getElementById("buyerRequestAgree");

    if(statusInput == null || answerInput == null || agreeInput == null){
        alert("처리 폼 정보를 찾을 수 없습니다.");
        return false;
    }

    const status = statusInput.value;
    const answer = answerInput.value;

    if(answer == null || answer.trim() === ""){
        alert("판매자 처리 안내를 입력해주세요.");
        return false;
    }

    if(agreeInput.checked === false){
        alert("처리 내용을 확인해주세요.");
        return false;
    }

    if(status === "RETURN_DONE"){
        return confirm("구매자의 반품요청을 반품완료로 처리하시겠습니까?");
    }

    if(status === "EXCHANGE_DONE"){
        return confirm("구매자의 교환요청을 교환완료로 처리하시겠습니까?");
    }

    alert("처리 상태가 올바르지 않습니다.");
    return false;
}

/*
    금액 포맷
*/
function formatSellerClaimPrice(price){
    const numberPrice = Number(price);

    if(Number.isNaN(numberPrice)){
        return "0원";
    }

    return numberPrice.toLocaleString("ko-KR") + "원";
}