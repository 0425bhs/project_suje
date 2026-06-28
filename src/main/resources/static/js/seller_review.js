document.addEventListener("DOMContentLoaded", function(){

    const productFilter = document.getElementById("productFilter");
    const tabs = document.querySelectorAll(".review-tab");
    const reviewCards = document.querySelectorAll(".seller-review-card");

    let currentTab = "all";

    updateReviewCounts();
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

        reviewCards.forEach(function(card){
            const cardProductId = card.dataset.productId;
            const isReplied = card.dataset.replied === "true";
            const hasPhoto = card.dataset.hasPhoto === "true";

            let productMatched = selectedProductId === "all" || selectedProductId === cardProductId;
            let tabMatched = true;

            if(currentTab === "waiting"){
                tabMatched = !isReplied;
            }

            if(currentTab === "completed"){
                tabMatched = isReplied;
            }

            if(currentTab === "photo"){
                tabMatched = hasPhoto;
            }

            if(productMatched && tabMatched){
                card.style.display = "block";
            } else {
                card.style.display = "none";
            }
        });
    }

    function updateReviewCounts(){
        let totalCount = reviewCards.length;
        let waitingCount = 0;
        let completedCount = 0;
        let photoCount = 0;

        reviewCards.forEach(function(card){
            const isReplied = card.dataset.replied === "true";
            const hasPhoto = card.dataset.hasPhoto === "true";

            if(isReplied){
                completedCount++;
            } else {
                waitingCount++;
            }

            if(hasPhoto){
                photoCount++;
            }
        });

        setText("totalReviewCount", totalCount + "개");
        setText("waitingReviewCount", waitingCount);
        setText("completedReviewCount", completedCount);
        setText("photoReviewCount", photoCount);

        setText("waitingTabCount", "(" + waitingCount + ")");
        setText("completedTabCount", "(" + completedCount + ")");
        setText("photoTabCount", "(" + photoCount + ")");
    }

    function setText(id, value){
        const target = document.getElementById(id);

        if(target != null){
            target.textContent = value;
        }
    }

});