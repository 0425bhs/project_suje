window.onload=function(){

    const bigCategory = document.getElementById("big_category_id");
    const smallCategory = document.getElementById("category_id");

    if (bigCategory != null && smallCategory != null){
        bigCategory.addEventListener("change",function(){
            let parentId = this.value;

            smallCategory.innerHTML = "<option value=''>하위 카테고리 선택</option>";

            if (parentId == "") {
                return;
            }

            fetch("/sub.do?parent_id="+parentId).then(res=>res.json()).then(data=>{data.forEach(category=>{
                    let option = document.createElement("option");

                    option.value = category.category_id;
                    option.innerText = category.name;

                    smallCategory.appendChild(option);
                });
            });
        });
    }
    
    const freeShippingView = document.getElementById("free_shipping_view");
    const freeShipping = document.getElementById("free_shipping");
    const freeShippingText = document.getElementById("free_shipping_text");

    if (freeShippingView != null && freeShipping != null && freeShippingText != null) {
        freeShippingView.addEventListener("input", function(){
            let value = this.value.replace(/[^0-9]/g, "");

            if (value == ""){
                this.value = "";
                freeShipping.value = "0";
                freeShippingText.innerText = "0";
                return;
            }

            freeShipping.value = value;

            let commaValue = Number(value).toLocaleString();

            this.value = commaValue;
            freeShippingText.innerText = commaValue;
        });
    }
};

function send(f){

    const name=f.name;
    const description=f.description;

    if (name.value=="") {
        alert("제품명를 등록해주세요.");
        name.focus();
        return;
    }

    if (description.value=="") {
        alert("상세 내용을 등록해주세요.");
        description.focus();
        return;
    }
    
    let stockValue = Number(f.stock.value || 0);

    if (stockValue < 0) {
        alert("올바른 재고 수량을 입력해주세요.");
        f.stock.focus();
        return;
    }

    let price = Number(f.price.value || 0);
    let salePrice = Number(f.sale_price.value || 0);

    if (price <= 0) {
        alert("상품 가격은 1원 이상 입력해야 합니다.");
        f.price.focus();
        return;
    }

    if (salePrice < 0) {
        alert("세일 가격은 음수로 입력할 수 없습니다.");
        f.sale_price.focus();
        return;
    }

    if (salePrice > 0 && salePrice >= price) {
        alert("세일 가격은 상품 가격보다 낮아야 합니다.");
        f.sale_price.focus();
        return;
    }

    let deliveryFee = Number(f.delivery_fee.value || 0);

    if (deliveryFee < 0) {
        alert("배송비는 0원 이상 입력해야 합니다.");
        f.delivery_fee.focus();
        return;
    }

    const freeShippingView=document.getElementById("free_shipping_view");
    const freeShipping=document.getElementById("free_shipping");

    let freeShippingValue=freeShippingView.value.replace(/[^0-9]/g, "");

    if (freeShippingValue==""){
        freeShippingValue="0";
    }

    if (deliveryFee == 0){
        freeShippingValue="0";
    }

    f.price.value=String(price);
    f.sale_price.value=String(salePrice);
    f.stock.value=String(stockValue);
    f.delivery_fee.value=String(deliveryFee);
    f.free_shipping.value=freeShippingValue;

    let formData=new FormData(f);

    fetch("/seller_product_modify.do",{method:"post",body:formData}).then(res=>res.json()).then(data=>{
        if (data.result==1) {
            alert("상품을 수정하셨습니다.");
            location.href="/product_detail.do?product_id=" + data.product_id;
        } else {
            alert("상품 수정 적용이 실패하셨습니다. 관리자에게 문의 바랍니다.");
        }
    })
}