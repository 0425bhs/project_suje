window.addEventListener("load",function (){
    productDetailImageSlider();
    productDetailQuantity();
    productDetailTabs();
    productWishButton();
    sellerWishButton();
    reviewButton();
});

function productDetailImageSlider(){
    const imageBox = document.querySelector(".store-main-image-box");
    const mainImage = document.getElementById("detailMainImage");
    const thumbButtons = document.querySelectorAll(".store-thumb-btn");
    const prevBtn = document.getElementById("detailImgPrev");
    const nextBtn = document.getElementById("detailImgNext");

    if (imageBox == null || mainImage == null){
        return;
    }

    const imageList = [];

    thumbButtons.forEach(function (btn){
        const imgSrc = btn.dataset.img;

        if (imgSrc != null && imgSrc !== "" && !imageList.includes(imgSrc)){
            imageList.push(imgSrc);
        }
    });

    if (imageList.length === 0){
        const currentSrc = mainImage.getAttribute("src");

        if (currentSrc != null && currentSrc !== ""){
            imageList.push(currentSrc);
        }
    }

    let currentIndex = 0;
    let isSliding = false;

    const slideTrack = document.createElement("div");
    slideTrack.className = "store-slide-track";

    imageList.forEach(function (src){
        const slideItem = document.createElement("div");
        slideItem.className = "store-slide-item";

        const img = document.createElement("img");
        img.src = src;
        img.alt = mainImage.alt;

        slideItem.appendChild(img);
        slideTrack.appendChild(slideItem);
    });

    mainImage.remove();

    if (nextBtn != null){
        imageBox.insertBefore(slideTrack, nextBtn);
    } else {
        imageBox.appendChild(slideTrack);
    }

    function updateThumbActive(){
        thumbButtons.forEach(function (btn){
            btn.classList.remove("active");

            if (btn.dataset.img === imageList[currentIndex]){
                btn.classList.add("active");
            }
        });
    }

    function updateArrowState(){
        if (prevBtn != null){
            prevBtn.classList.toggle("disabled", imageList.length <= 1);
        }

        if (nextBtn != null){
            nextBtn.classList.toggle("disabled", imageList.length <= 1);
        }
    }

    function moveSlide(index){
        slideTrack.style.transform = "translateX(-" + (index * 100) + "%)";
    }

    function slideTo(newIndex){
        if (imageList.length <= 1 || isSliding){
            return;
        }

        let targetIndex = newIndex;

        if (targetIndex < 0){
            targetIndex = imageList.length - 1;
        }

        if (targetIndex >= imageList.length){
            targetIndex = 0;
        }

        if (targetIndex === currentIndex){
            return;
        }

        isSliding = true;

        currentIndex = targetIndex;
        moveSlide(currentIndex);
        updateThumbActive();

        setTimeout(function (){
            isSliding = false;
        }, 650);
    }

    if (prevBtn != null){
        prevBtn.addEventListener("click", function (){
            slideTo(currentIndex - 1);
        });
    }

    if (nextBtn != null){
        nextBtn.addEventListener("click", function (){
            slideTo(currentIndex + 1);
        });
    }

    thumbButtons.forEach(function (btn){
        btn.addEventListener("click", function (){
            const imgSrc = btn.dataset.img;
            const newIndex = imageList.indexOf(imgSrc);

            if (newIndex === -1){
                return;
            }

            slideTo(newIndex);
        });
    });

    moveSlide(currentIndex);
    updateThumbActive();
    updateArrowState();
}

function productDetailQuantity(){

    const optionSelect = document.getElementById("option_id");
    const selectedOptionBox = document.getElementById("selectedOptionBox");

    const qtyInput = document.getElementById("detailQuantity");
    const qtyMinus = document.getElementById("qtyMinus");
    const qtyPlus = document.getElementById("qtyPlus");

    const totalCount = document.getElementById("detailTotalCount");
    const totalPrice = document.getElementById("detailTotalPrice");

    const cartBtn = document.getElementById("cartBtn");
    const orderBtn = document.getElementById("orderBtn");

    if(totalCount == null || totalPrice == null){
        return;
    }

    /*
        옵션 없는 상품은 기존 방식 사용
    */
    if(optionSelect == null){

        if(qtyInput == null || qtyMinus == null || qtyPlus == null){
            return;
        }

        const basePrice = Number(qtyInput.dataset.unitPrice || 0);

        function formatPrice(price){
            return Number(price).toLocaleString("ko-KR") + "원";
        }

        function updateNoOptionTotal(){

            let quantity = Number(qtyInput.value || 1);
            const max = Number(qtyInput.max || 1);

            if(quantity < 1){
                quantity = 1;
            }

            if(max > 0 && quantity > max){
                quantity = max;
            }

            qtyInput.value = quantity;

            totalCount.innerText = quantity;
            totalPrice.innerText = formatPrice(basePrice * quantity);

            qtyMinus.disabled = quantity <= 1 || qtyInput.disabled;
            qtyPlus.disabled = quantity >= max || qtyInput.disabled;
        }

        qtyMinus.addEventListener("click", function(){
            let quantity = Number(qtyInput.value || 1);

            if(quantity > 1){
                qtyInput.value = quantity - 1;
            }

            updateNoOptionTotal();
        });

        qtyPlus.addEventListener("click", function(){
            let quantity = Number(qtyInput.value || 1);
            const max = Number(qtyInput.max || 1);

            if(quantity >= max){
                alert("재고보다 많이 선택할 수 없습니다.");
                return;
            }

            qtyInput.value = quantity + 1;
            updateNoOptionTotal();
        });

        qtyInput.addEventListener("input", updateNoOptionTotal);

        updateNoOptionTotal();
        return;
    }

    const optionBasePriceInput = document.getElementById("optionBasePrice");

    let realBasePrice = 0;

    if(optionBasePriceInput != null){
        realBasePrice = Number(optionBasePriceInput.value || 0);
    } else {
        realBasePrice = Number(optionSelect.dataset.unitPrice || 0);
    }

    const selectedOptions = [];

    function formatPrice(price){
        return Number(price).toLocaleString("ko-KR") + "원";
    }

    function updateTotal(){

        let countSum = 0;
        let priceSum = 0;

        selectedOptions.forEach(function(item){
            countSum += item.quantity;
            priceSum += (realBasePrice + item.optionPrice) * item.quantity;
        });

        totalCount.innerText = countSum;
        totalPrice.innerText = formatPrice(priceSum);

        if(selectedOptions.length === 0){
            selectedOptionBox.style.display = "none";

            if(cartBtn != null){
                cartBtn.disabled = true;
            }

            if(orderBtn != null){
                orderBtn.disabled = true;
            }

            totalCount.innerText = 0;
            totalPrice.innerText = "0원";
        } else {
            selectedOptionBox.style.display = "block";

            if(cartBtn != null){
                cartBtn.disabled = false;
            }

            if(orderBtn != null){
                orderBtn.disabled = false;
            }
        }
    }

    function renderSelectedOptions(){

        selectedOptionBox.innerHTML = "";

        selectedOptions.forEach(function(item){

            const row = document.createElement("div");
            row.className = "store-option-box selected-option-item";
            row.dataset.optionId = item.optionId;

            row.innerHTML =
                '<div class="selected-option-top">' +
                    '<p class="store-option-name">' + item.optionName + '</p>' +
                    '<button type="button" class="selected-option-remove" data-option-id="' + item.optionId + '">×</button>' +
                '</div>' +

                '<div class="store-option-bottom">' +

                    '<div class="store-quantity-box">' +
                        '<button type="button" class="selected-qty-minus" data-option-id="' + item.optionId + '">−</button>' +
                        '<input type="number" value="' + item.quantity + '" readonly>' +
                        '<button type="button" class="selected-qty-plus" data-option-id="' + item.optionId + '">+</button>' +
                    '</div>' +

                    '<div class="store-option-price">' +
                        formatPrice((realBasePrice + item.optionPrice) * item.quantity) +
                    '</div>' +

                '</div>' +

                '<input type="hidden" name="option_id" value="' + item.optionId + '">' +
                '<input type="hidden" name="quantity" value="' + item.quantity + '">';

            selectedOptionBox.appendChild(row);
        });

        updateTotal();
    }

    optionSelect.addEventListener("change", function(){

        if(optionSelect.value === ""){
            return;
        }

        const selected = optionSelect.options[optionSelect.selectedIndex];

        const optionId = optionSelect.value;
        const optionName = selected.dataset.optionName || selected.textContent.trim();
        const optionPrice = Number(selected.dataset.price || 0);
        const optionStock = Number(selected.dataset.stock || 0);

        if(optionStock <= 0){
            alert("품절된 옵션입니다.");
            optionSelect.value = "";
            return;
        }

        const alreadySelected = selectedOptions.some(function(item){
            return item.optionId === optionId;
        });

        if(alreadySelected){
            alert("이미 선택한 옵션입니다.");
            optionSelect.value = "";
            return;
        }

        selectedOptions.push({
            optionId: optionId,
            optionName: optionName,
            optionPrice: optionPrice,
            stock: optionStock,
            quantity: 1
        });

        optionSelect.value = "";

        renderSelectedOptions();
    });

    selectedOptionBox.addEventListener("click", function(event){

        const target = event.target;
        const optionId = target.dataset.optionId;

        if(optionId == null){
            return;
        }

        const index = selectedOptions.findIndex(function(item){
            return item.optionId === optionId;
        });

        if(index === -1){
            return;
        }

        const item = selectedOptions[index];

        if(target.classList.contains("selected-option-remove")){
            selectedOptions.splice(index, 1);
            renderSelectedOptions();
            return;
        }

        if(target.classList.contains("selected-qty-plus")){

            if(item.quantity >= item.stock){
                alert("재고보다 많이 선택할 수 없습니다.");
                return;
            }

            item.quantity++;
            renderSelectedOptions();
            return;
        }

        if(target.classList.contains("selected-qty-minus")){

            if(item.quantity <= 1){
                return;
            }

            item.quantity--;
            renderSelectedOptions();
        }
    });

    selectedOptionBox.style.display = "none";

    if(cartBtn != null){
        cartBtn.disabled = true;
    }

    if(orderBtn != null){
        orderBtn.disabled = true;
    }

    totalCount.innerText = 0;
    totalPrice.innerText = "0원";
}

function productDetailTabs(){
    const tabWrap = document.querySelector(".store-detail-tab-wrap");
    const tabs = Array.from(document.querySelectorAll(".store-detail-tab[data-tab-target]"));
    const panels = Array.from(document.querySelectorAll(".store-tab-panel"));

    if(tabs.length == 0 || panels.length == 0){
        return;
    }

    // 모든 내용 항상 보이게
    panels.forEach(function(panel){
        panel.style.display = "block";
    });

    function getScrollOffset(){
        let offset = 90;

        if(tabWrap != null){
            offset += tabWrap.offsetHeight;
        }

        return offset;
    }

    function setActiveTab(targetId){
        tabs.forEach(function(tab){
            tab.classList.remove("active");

            if(tab.dataset.tabTarget === targetId){
                tab.classList.add("active");
            }
        });
    }

    function moveToSection(targetId){
        const targetPanel = document.getElementById(targetId);

        if(targetPanel == null){
            return;
        }

        const targetTop = targetPanel.getBoundingClientRect().top + window.pageYOffset - getScrollOffset();

        window.scrollTo({
            top: targetTop,
            behavior: "smooth"
        });

        setActiveTab(targetId);
    }

    tabs.forEach(function(tab){
        tab.addEventListener("click", function(){
            const targetId = tab.dataset.tabTarget;
            moveToSection(targetId);
        });
    });

    function updateActiveByScroll(){
        const scrollPoint = window.pageYOffset + getScrollOffset() + 20;
        let currentId = panels[0].id;

        panels.forEach(function(panel){
            if(panel.offsetTop <= scrollPoint){
                currentId = panel.id;
            }
        });

        setActiveTab(currentId);
    }

    window.addEventListener("scroll", updateActiveByScroll);
    window.addEventListener("resize", updateActiveByScroll);

    updateActiveByScroll();
}

function reviewButton(){
    const moreBtn = document.querySelector(".review-more-btn");

    // 더보기 버튼이 없는 상품이면 실행 안 함
    if(moreBtn == null){
        return;
    }

    moreBtn.addEventListener("click", function(event){
        event.preventDefault();

        // ✅ 수정: reviewSection 아님, 실제 id인 reviewBox 사용
        const reviewSection = document.getElementById("reviewBox");
        const tabWrap = document.querySelector(".store-detail-tab-wrap");

        if(reviewSection == null){
            return;
        }

        let offset = 90;

        if(tabWrap != null){
            offset += tabWrap.offsetHeight;
        }

        const targetTop =
            reviewSection.getBoundingClientRect().top +
            window.pageYOffset -
            offset;

        window.scrollTo({
            top: targetTop,
            behavior: "smooth"
        });

        // ✅ 수정: 주소도 #reviewBox
        history.replaceState(null, "", "#reviewBox");

        const tabs = document.querySelectorAll(".store-detail-tab[data-tab-target]");

        tabs.forEach(function(tab){
            tab.classList.remove("active");

            // ✅ 수정: 탭 target도 reviewBox
            if(tab.dataset.tabTarget === "reviewBox"){
                tab.classList.add("active");
            }
        });
    });
}

// 상품 찜 버튼
function productWishButton(){
    const productWishBtn = document.getElementById("productWishBtn");

    if(productWishBtn == null){
        return;
    }

    productWishBtn.addEventListener("click", function(){
        const product_id = productWishBtn.dataset.productId;

        fetch("/favorite_product.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "product_id=" + encodeURIComponent(product_id)
        })
        .then(function(res){
            return res.json();
        })
        .then(function(data){
            if(data.result === "login"){
                alert("로그인이 필요합니다.");
                location.href = "/login.do";
                return;
            }

            if(data.liked === true){
                productWishBtn.classList.add("active");
                productWishBtn.textContent = "♥";
            } else {
                productWishBtn.classList.remove("active");
                productWishBtn.textContent = "♡";
            }
        })
        .catch(function(){
            alert("상품 찜 처리 중 오류가 발생했습니다.");
        });
    });
}

function sellerWishButton() {
    const wishBtn = document.getElementById("sellerWishBtn");

    if (wishBtn == null) {
        return;
    }

    const sellerId = wishBtn.dataset.sellerId;

    if (sellerId == null || sellerId === "") {
        alert("판매자 정보를 찾을 수 없습니다.");
        return;
    }

    wishBtn.addEventListener("click", function () {
        fetch("/favorite_shop.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "seller_id=" + encodeURIComponent(sellerId)
        })
        .then(function (response) {
            return response.json();
        })
        .then(function (data) {
            if (data.result === "login") {
                alert("로그인 후 이용 가능합니다.");
                location.href = "/login.do";
                return;
            }

            const heart = wishBtn.querySelector(".wish-shop-heart");
            const text = wishBtn.querySelector(".wish-shop-text");

            if (data.liked === true) {
                wishBtn.classList.add("active");

                if (heart != null) {
                    heart.textContent = "♥";
                }

                if (text != null) {
                    text.textContent = "찜 취소";
                }
            } else {
                wishBtn.classList.remove("active");

                if (heart != null) {
                    heart.textContent = "♡";
                }

                if (text != null) {
                    text.textContent = "작가샵 찜하기";
                }
            }
        })
        .catch(function (error) {
            console.log(error);
            alert("찜 처리 중 오류가 발생했습니다.");
        });
    });
}

