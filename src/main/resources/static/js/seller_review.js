document.addEventListener("DOMContentLoaded", function () {

const productFilter = document.getElementById("productFilter");

if (productFilter == null) {
    return;
}

productFilter.addEventListener("change", function () {
    const selectedProductId = this.value;
    const reviewCards = document.querySelectorAll(".seller-review-card");

    reviewCards.forEach(function (card) {
        const cardProductId = card.dataset.productId;

        if (selectedProductId === "all" || selectedProductId === cardProductId) {
            card.style.display = "block";
        } else {
            card.style.display = "none";
        }
    });
});

});

    