window.addEventListener("load", function () {
    initProductDetailImageSlider();
    initProductDetailQuantity();
});

function initProductDetailImageSlider() {
    const imageBox = document.querySelector(".store-main-image-box");
    const mainImage = document.getElementById("detailMainImage");
    const thumbButtons = document.querySelectorAll(".store-thumb-btn");
    const prevBtn = document.getElementById("detailImgPrev");
    const nextBtn = document.getElementById("detailImgNext");

    if (imageBox == null || mainImage == null) {
        return;
    }

    const imageList = [];

    thumbButtons.forEach(function (btn) {
        const imgSrc = btn.dataset.img;

        if (imgSrc != null && imgSrc !== "" && !imageList.includes(imgSrc)) {
            imageList.push(imgSrc);
        }
    });

    if (imageList.length === 0) {
        const currentSrc = mainImage.getAttribute("src");

        if (currentSrc != null && currentSrc !== "") {
            imageList.push(currentSrc);
        }
    }

    let currentIndex = 0;
    let isAnimating = false;

    function updateThumbActive() {
        thumbButtons.forEach(function (btn) {
            btn.classList.toggle("active", btn.dataset.img === imageList[currentIndex]);
        });
    }

    function updateNavState() {
        if (imageList.length <= 1) {
            if (prevBtn != null) {
                prevBtn.classList.add("disabled");
            }

            if (nextBtn != null) {
                nextBtn.classList.add("disabled");
            }
        }
    }

    function showImage(index, direction) {
        if (imageList.length <= 1 || isAnimating) {
            return;
        }

        if (index < 0) {
            index = imageList.length - 1;
        }

        if (index >= imageList.length) {
            index = 0;
        }

        if (index === currentIndex) {
            return;
        }

        isAnimating = true;

        const motionClass = direction === "prev"
            ? "is-changing-prev"
            : "is-changing-next";

        imageBox.classList.add(motionClass);

        setTimeout(function () {
            currentIndex = index;
            mainImage.src = imageList[currentIndex];

            updateThumbActive();

            requestAnimationFrame(function () {
                imageBox.classList.remove("is-changing-prev");
                imageBox.classList.remove("is-changing-next");

                setTimeout(function () {
                    isAnimating = false;
                }, 220);
            });
        }, 160);
    }

    thumbButtons.forEach(function (btn, index) {
        btn.addEventListener("click", function () {
            const direction = index > currentIndex ? "next" : "prev";
            showImage(index, direction);
        });
    });

    if (prevBtn != null) {
        prevBtn.addEventListener("click", function () {
            showImage(currentIndex - 1, "prev");
        });
    }

    if (nextBtn != null) {
        nextBtn.addEventListener("click", function () {
            showImage(currentIndex + 1, "next");
        });
    }

    updateThumbActive();
    updateNavState();
}

function initProductDetailQuantity() {
    const qtyInput = document.getElementById("detailQuantity");
    const minusBtn = document.getElementById("qtyMinus");
    const plusBtn = document.getElementById("qtyPlus");
    const totalCount = document.getElementById("detailTotalCount");
    const totalPrice = document.getElementById("detailTotalPrice");

    if (
        qtyInput == null ||
        minusBtn == null ||
        plusBtn == null ||
        totalCount == null ||
        totalPrice == null
    ) {
        return;
    }

    const unitPrice = Number(qtyInput.dataset.unitPrice || 0);
    const maxQty = Number(qtyInput.getAttribute("max") || 1);

    function updateTotal() {
        let qty = Number(qtyInput.value || 1);

        if (qty < 1) {
            qty = 1;
        }

        if (qty > maxQty) {
            qty = maxQty;
        }

        qtyInput.value = qty;

        totalCount.innerText = qty;
        totalPrice.innerText = (unitPrice * qty).toLocaleString() + "원";
    }

    minusBtn.addEventListener("click", function () {
        qtyInput.value = Number(qtyInput.value || 1) - 1;
        updateTotal();
    });

    plusBtn.addEventListener("click", function () {
        qtyInput.value = Number(qtyInput.value || 1) + 1;
        updateTotal();
    });

    qtyInput.addEventListener("input", updateTotal);

    updateTotal();
}