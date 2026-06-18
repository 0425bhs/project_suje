window.addEventListener("load", function(){
    initSellerWishButton();
});

function initSellerWishButton(){
    const sellerWishBtn = document.getElementById("sellerWishBtn");
    const countBox = document.getElementById("sellerFavoriteCount");

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

            let count = 0;

            if(countBox != null){
                count = Number(countBox.innerText || 0);
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
                    countBox.innerText = count + 1;
                }
            } else {
                sellerWishBtn.classList.remove("active");

                if(heart != null){
                    heart.innerText = "♡";
                }

                if(text != null){
                    text.innerText = "작가샵 찜하기";
                }

                if(countBox != null && count > 0){
                    countBox.innerText = count - 1;
                }
            }
        })
        .catch(function(){
            alert("판매자 찜 처리 중 오류가 발생했습니다.");
        });
    });
}