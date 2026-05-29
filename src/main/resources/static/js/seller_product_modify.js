window.onload=function(){
    const free_shipping=document.getElementById("free_shipping");
    const free_shipping_text=document.getElementById("free_shipping_text");

    if (free_shipping.value !== ""){
        let value = free_shipping.value.replace(/[^0-9]/g, "");

        if (value !== ""){
            let commaValue = Number(value).toLocaleString();
            free_shipping.value = commaValue;
            free_shipping_text.innerText = commaValue;
        }
    }

    free_shipping.addEventListener("input", function(){
        let value=this.value.replace(/[^0-9]/g,"");

        if (value===""){
            this.value="";
            free_shipping_text.innerText = "0";
            return;
        }

        let commaValue=Number(value).toLocaleString();

        this.value=commaValue;
        free_shipping_text.innerText=commaValue;
    });
}

function send(f){

    const category_id=f.category_id;
    const name=f.name;
    const description=f.description;
    const stock=Number(f.stock.value);

    if (category_id.value=="") {
        alert("카테고리를 선택해주세요.");
        category_id.focus();
        return;
    }

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

    if (stock>0) {
        alert("재고 수량을 등록해주세요.");
        stock.focus();
        return;
    }


    let price = Number(f.price.value);
    let salePrice = Number(f.sale_price.value || 0);

    if (price <= 0) {
        alert("상품 가격은 1원 이상 입력해야 합니다.");
        f.price.focus();
        return;
    }

    if (salePrice > 0 && salePrice >= price) {
        alert("세일가격은 상품 가격보다 낮아야 합니다.");
        f.sale_price.focus();
        return;
    }

    let deliveryFee = Number(f.delivery_fee.value || 0);
    let freeShippingValue = f.free_shipping.value.replace(/,/g, "");

    if (deliveryFee < 0) {
        alert("배송비는 0원 이상 입력해야 합니다.");
        f.delivery_fee.focus();
        return;
    }

    if (freeShippingValue == "") {
        freeShippingValue = "0";
    }

    // 서버로 보내기 전에 input 값 자체를 정리
    f.price.value = String(price);
    f.sale_price.value = String(salePrice);
    f.delivery_fee.value = String(deliveryFee);
    f.free_shipping.value = freeShippingValue;

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