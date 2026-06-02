window.onload = function () {

    // 상품 이미지가 깨졌을 때 기본 이미지로 변경
    const productImages = document.querySelectorAll(".product-card img");

    productImages.forEach(function (img) {
        img.onerror = function () {
            this.src = "/images/no_image.png";
        };
    });

    // 상품 카드 클릭 시 상세페이지 이동
    const productCards = document.querySelectorAll(".product-card");

    productCards.forEach(function (card) {
        card.addEventListener("click", function (e) {

            // 상품명 a태그를 직접 클릭한 경우는 기본 링크 그대로 동작
            if (e.target.tagName.toLowerCase() === "a") {
                return;
            }

            const productId = this.dataset.productId;

            if (productId != null && productId !== "") {
                location.href = "/product_detail.do?product_id=" + productId;
            }
        });
    });
};