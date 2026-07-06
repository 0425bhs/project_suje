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

        /*
            select, form, 환불/반품 버튼 같은 실제 조작 요소를 누를 때는
            행/카드 모달이 열리지 않게 막음
        */
        const blockedElement = event.target.closest(
            "select, option, form, a, input, textarea, label, .simple-receipt-btn, .card-receipt-btn, .view-icon-btn, [data-modal-close]"
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
        }
    });
}

/*
    모달 닫기
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