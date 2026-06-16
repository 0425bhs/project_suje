window.addEventListener("load",function (){
    initProductDetailImageSlider();
    initProductDetailQuantity();
    initProductDetailTabs();
    initProductWishButton();
    initSellerWishButton();
});

function initProductDetailImageSlider(){
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

function initProductDetailQuantity(){
    const qtyInput = document.getElementById("detailQuantity");
    const minusBtn = document.getElementById("qtyMinus");
    const plusBtn = document.getElementById("qtyPlus");
    const totalCount = document.getElementById("detailTotalCount");
    const totalPrice = document.getElementById("detailTotalPrice");

    if( qtyInput==null || minusBtn==null || plusBtn==null || totalCount==null || totalPrice==null ){
        return;
    }

    const unitPrice = Number(qtyInput.dataset.unitPrice || 0);
    const maxQty = Number(qtyInput.getAttribute("max") || 1);

    function updateTotal(){
        let qty = Number(qtyInput.value || 1);

        if(qty < 1){
            qty = 1;
        }

        if(maxQty > 0 && qty > maxQty){
            qty = maxQty;
        }

        qtyInput.value = qty;

        totalCount.innerText=qty;
        totalPrice.innerText=(unitPrice * qty).toLocaleString() + "원";
    }

    minusBtn.addEventListener("click",function(){
        qtyInput.value = Number(qtyInput.value || 1) - 1;
        updateTotal();
    });

    plusBtn.addEventListener("click",function(){
        qtyInput.value = Number(qtyInput.value || 1) + 1;
        updateTotal();
    });

    qtyInput.addEventListener("input",updateTotal);

    updateTotal();
}

function initProductDetailTabs(){
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

// 상품 찜 버튼
function initProductWishButton(){
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


// 판매자 찜 버튼
function initSellerWishButton(){
    const sellerWishBtn = document.getElementById("sellerWishBtn");

    if(sellerWishBtn == null){
        return;
    }

    sellerWishBtn.addEventListener("click", function(){
        const seller_id = sellerWishBtn.dataset.sellerId;

        fetch("/favorite_shop.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "seller_id=" + encodeURIComponent(seller_id)
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

            const heart = sellerWishBtn.querySelector(".wish-shop-heart");
            const text = sellerWishBtn.querySelector(".wish-shop-text");

            if(data.liked === true){
                sellerWishBtn.classList.add("active");

                if(heart != null){
                    heart.textContent = "♥";
                }

                if(text != null){
                    text.textContent = "작가샵 찜 완료";
                }
            } else {
                sellerWishBtn.classList.remove("active");

                if(heart != null){
                    heart.textContent = "♡";
                }

                if(text != null){
                    text.textContent = "작가샵 찜하기";
                }
            }
        })
        .catch(function(){
            alert("판매자 찜 처리 중 오류가 발생했습니다.");
        });
    });
}