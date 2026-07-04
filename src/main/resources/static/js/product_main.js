window.addEventListener("load",function(){

    const categoryWrap = document.querySelector(".all-category-wrap");
    const categoryBtn = document.querySelector(".all-category-btn");

    if(categoryWrap != null && categoryBtn != null){

        categoryBtn.addEventListener("click",function(){
            categoryWrap.classList.toggle("open");
        });

        document.addEventListener("click",function (e){
            if (!categoryWrap.contains(e.target)){
                categoryWrap.classList.remove("open");
            }
        });

    }

});

function favoriteToggle(event, productId, heartBtn){
    event.preventDefault();
    event.stopPropagation();

    fetch("/favorite_product.do",{method:"POST",headers:{"Content-Type": "application/x-www-form-urlencoded"},
        body: "product_id=" + encodeURIComponent(productId)
    }).then(function (response){return response.json();}).then(function (data){
        if (data.result === "login"){
            alert("로그인 후 이용 가능합니다.");
            location.href = "/login.do";
            return;
        }

        if (data.liked === true){
            heartBtn.textContent = "♥";
            heartBtn.classList.add("active");
        } else {
            heartBtn.textContent = "♡";
            heartBtn.classList.remove("active");
        }
    })
}