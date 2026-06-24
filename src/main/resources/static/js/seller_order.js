window.addEventListener("load", function (){
    initSellerOrderViewSwitch();
    initSellerOrderStatusAutoSubmit();
    initSellerOrderModal();
});

/*
    카드형 / 심플형 전환
*/
function initSellerOrderViewSwitch(){
    const buttons = document.querySelectorAll(".view-icon-btn");
    const panels = document.querySelectorAll("[data-view-panel]");

    if (buttons.length === 0 || panels.length === 0){
        return;
    }

    let savedView = localStorage.getItem("sellerOrderView");

    if (savedView == null || savedView === ""){
        savedView = "card";
    }

    changeSellerOrderView(savedView);

    buttons.forEach(function (button){
        button.addEventListener("click", function (){
            const view = button.dataset.view;

            if (view == null || view === ""){
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

    buttons.forEach(function (button){
        button.classList.toggle("active", button.dataset.view === view);
    });

    panels.forEach(function (panel){
        panel.classList.toggle("active", panel.dataset.viewPanel === view);
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
    const openButtons = document.querySelectorAll("[data-modal-target]");
    const modal = document.getElementById("sellerOrderModal");
    const modalContent = document.getElementById("sellerOrderModalContent");
    const closeButtons = document.querySelectorAll("[data-modal-close]");

    if (modal == null || modalContent == null){
        return;
    }

    openButtons.forEach(function (button){
        button.addEventListener("click", function (){
            const targetId = button.dataset.modalTarget;
            const template = document.getElementById(targetId);

            if (template == null){
                return;
            }

            modalContent.innerHTML = template.innerHTML;
            modal.classList.add("active");
            document.body.classList.add("modal-open");
        });
    });

    closeButtons.forEach(function (button){
        button.addEventListener("click", function (){
            closeSellerOrderModal();
        });
    });

    window.addEventListener("keydown", function (event){
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