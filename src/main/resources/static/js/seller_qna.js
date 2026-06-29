document.addEventListener("DOMContentLoaded", function(){

    const productFilter = document.getElementById("productFilter");
    const tabs = document.querySelectorAll(".qna-tab");
    const qnaCards = document.querySelectorAll(".seller-qna-card");

    let currentTab = "all";

    updateQnaCounts();
    applyFilter();

    if(productFilter != null){
        productFilter.addEventListener("change", function(){
            applyFilter();
        });
    }

    tabs.forEach(function(tab){
        tab.addEventListener("click", function(){
            tabs.forEach(function(item){
                item.classList.remove("active");
            });

            this.classList.add("active");
            currentTab = this.dataset.tab;

            applyFilter();
        });
    });

    function applyFilter(){
        const selectedProductId = productFilter == null ? "all" : productFilter.value;

        qnaCards.forEach(function(card){
            const cardProductId = card.dataset.productId;
            const isAnswered = card.dataset.answered === "true";

            let productMatched = selectedProductId === "all" || selectedProductId === cardProductId;
            let tabMatched = true;

            if(currentTab === "waiting"){
                tabMatched = !isAnswered;
            }

            if(currentTab === "completed"){
                tabMatched = isAnswered;
            }

            if(productMatched && tabMatched){
                card.style.display = "block";
            } else {
                card.style.display = "none";
            }
        });
    }

    function updateQnaCounts(){
        let totalCount = qnaCards.length;
        let waitingCount = 0;
        let completedCount = 0;

        qnaCards.forEach(function(card){
            const isAnswered = card.dataset.answered === "true";

            if(isAnswered){
                completedCount++;
            } else {
                waitingCount++;
            }
        });

        setText("totalQnaCount", totalCount + "개");
        setText("waitingQnaCount", waitingCount);
        setText("completedQnaCount", completedCount);

        setText("waitingTabCount", "(" + waitingCount + ")");
        setText("completedTabCount", "(" + completedCount + ")");
    }

    function setText(id, value){
        const target = document.getElementById(id);

        if(target != null){
            target.textContent = value;
        }
    }

});