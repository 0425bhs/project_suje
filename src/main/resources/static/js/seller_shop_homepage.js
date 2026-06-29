window.addEventListener("load", function(){
    initSellerWishButton();
});

// 숫자를 1.1천 / 1.4만 형태로 바꾸는 함수
function compactCount(count){
    count = Number(count);

    if(isNaN(count) || count < 0){
        count = 0;
    }

    if(count < 1000){
        return String(count);
    }

    if(count < 10000){
        const value = Math.ceil(count / 100) / 10;
        return value.toFixed(1) + "천";
    }

    const value = Math.ceil(count / 1000) / 10;
    return value.toFixed(1) + "만";
}

function initSellerWishButton(){
    const sellerWishBtn = document.getElementById("sellerWishBtn");
    const countBox = document.getElementById("sellerFavoriteCount");

    if(sellerWishBtn == null){
        return;
    }

    sellerWishBtn.addEventListener("click", function(){
        const seller_id = sellerWishBtn.dataset.sellerId;

        // 찜이 안 된 상태에서만 쿠폰 안내
        const isFavorite = sellerWishBtn.classList.contains("active");

        if(!isFavorite){
            const confirmCoupon = confirm("작가샵을 처음 찜하면 500원 쿠폰이 지급됩니다.\n찜하시겠습니까?");

            if(!confirmCoupon){
                return;
            }
        }

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

            let rawCount = 0;

            if(countBox != null){
                rawCount = Number(countBox.dataset.rawCount || 0);

                if(isNaN(rawCount)){
                    rawCount = 0;
                }
            }

            if(data.liked === true){
                sellerWishBtn.classList.add("active");

                if(heart != null){
                    heart.innerText = "♥";
                }

                if(text != null){
                    text.innerText = "찜 취소";
                }

                if(countBox != null){
                    rawCount = rawCount + 1;
                    countBox.dataset.rawCount = rawCount;
                    countBox.innerText = compactCount(rawCount);
                }

                // 첫 찜 쿠폰 발급 안내
                if(data.couponIssued === true){
                    alert("작가샵 첫 찜 500원 쿠폰이 지급되었습니다.");
                }

            } else {
                sellerWishBtn.classList.remove("active");

                if(heart != null){
                    heart.innerText = "♡";
                }

                if(text != null){
                    text.innerText = "작가샵 찜하기";
                }

                if(countBox != null){
                    rawCount = rawCount - 1;

                    if(rawCount < 0){
                        rawCount = 0;
                    }

                    countBox.dataset.rawCount = rawCount;
                    countBox.innerText = compactCount(rawCount);
                }
            }
        })
        .catch(function(){
            alert("판매자 찜 처리 중 오류가 발생했습니다.");
        });
    });
}