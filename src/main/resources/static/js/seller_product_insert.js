window.onload = function(){

    const bigCategory = document.getElementById("big_category_id");
    const smallCategory = document.getElementById("category_id");

    if(bigCategory != null && smallCategory != null){
        bigCategory.addEventListener("change",function(){
            let parentId = this.value;

            smallCategory.innerHTML = "<option value=''>하위 카테고리 선택</option>";

            if(parentId == ""){
                return;
            }

            fetch("/sub.do?parent_id=" + parentId)
                .then(res=>res.json())
                .then(data=>{
                    data.forEach(category=>{
                        let option = document.createElement("option");

                        option.value = category.category_id;
                        option.innerText = category.name;

                        smallCategory.appendChild(option);
                    });
                });
        });
    }

    const deliveryFee = document.getElementById("delivery_fee");
    const freeShippingView = document.getElementById("free_shipping_view");
    const freeShipping = document.getElementById("free_shipping");
    const freeShippingHelp = document.getElementById("free_shipping_help");

    function updateShippingHelp(){
        if(freeShippingHelp == null){
            return;
        }

        let deliveryValue = deliveryFee.value.trim();
        let freeValue = freeShippingView.value.trim().replace(/,/g, "");

        if(deliveryValue == "" || (!isNaN(deliveryValue) && Number(deliveryValue) == 0)){
            freeShippingHelp.innerText = "택배비란에 공백이나 0일 경우 무료배송으로 설정됩니다.";
            return;
        }

        if(deliveryValue != "" && isNaN(deliveryValue)){
            freeShippingHelp.innerText = "배송비는 숫자만 입력할 수 있습니다.";
            return;
        }

        if(freeValue == "" || (!isNaN(freeValue) && Number(freeValue) == 0)){
            freeShippingHelp.innerText = "무료배송 기준 금액이 공백이나 0일 경우 유료배송으로 설정됩니다.";
            return;
        }

        if(freeValue != "" && isNaN(freeValue)){
            freeShippingHelp.innerText = "무료배송 기준 금액은 숫자만 입력할 수 있습니다.";
            return;
        }

        freeShippingHelp.innerText = Number(freeValue).toLocaleString() + "원 이상 구매 시 무료배송으로 설정됩니다.";
    }

    function checkDeliveryFeeInput(){
        let deliveryValue = deliveryFee.value.trim();

        if(deliveryValue == "" || (!isNaN(deliveryValue) && Number(deliveryValue) == 0)){
            freeShippingView.value = "";
            freeShipping.value = "0";
            freeShippingView.disabled = true;
            freeShippingView.placeholder = "택배비를 입력해야 무료배송 기준 금액을 설정할 수 있습니다.";
        } else {
            freeShippingView.disabled = false;
        }

        updateShippingHelp();
    }

    if(deliveryFee != null && freeShippingView != null && freeShipping != null){

        freeShippingView.addEventListener("input",function(){
            let value = this.value.replace(/,/g, "");

            if(value == ""){
                this.value = "";
                freeShipping.value = "0";
                updateShippingHelp();
                return;
            }

            // 글자가 들어오면 여기서 지우지 않음
            // 수정 버튼 눌렀을 때 alert 띄우기 위함
            if(isNaN(value)){
                freeShipping.value = "0";
                updateShippingHelp();
                return;
            }

            freeShipping.value = value;

            let commaValue = Number(value).toLocaleString();

            this.value = commaValue;
            updateShippingHelp();
        });

        deliveryFee.addEventListener("input",function(){
            checkDeliveryFeeInput();
        });

        // 수정 페이지는 기존 DB 값이 들어와 있으니까 처음 열릴 때도 체크
        checkDeliveryFeeInput();
    }
};

function send(f){

    const name = f.name;
    const description = f.description;

    if(name.value == ""){
        alert("제품명을 등록해주세요.");
        name.focus();
        return;
    }

    if(description.value == ""){
        alert("상세 내용을 등록해주세요.");
        description.focus();
        return;
    }

    let stockValue = Number(f.stock.value || 0);

    if(stockValue < 0){
        alert("올바른 재고 수량을 입력해주세요.");
        f.stock.focus();
        return;
    }

    let price = Number(f.price.value || 0);
    let salePrice = Number(f.sale_price.value || 0);

    if(price <= 0){
        alert("상품 가격은 1원 이상 입력해야 합니다.");
        f.price.focus();
        return;
    }

    if(salePrice < 0){
        alert("세일 가격은 음수로 입력할 수 없습니다.");
        f.sale_price.focus();
        return;
    }

    if(salePrice > 0 && salePrice >= price){
        alert("세일 가격은 상품 가격보다 낮아야 합니다.");
        f.sale_price.focus();
        return;
    }

    let deliveryFeeValue = f.delivery_fee.value.trim();

    const freeShippingView = document.getElementById("free_shipping_view");
    const freeShipping = document.getElementById("free_shipping");

    let freeShippingTextValue = freeShippingView.value.trim();
    let freeShippingValue = freeShippingTextValue.replace(/,/g, "");

    if(deliveryFeeValue == "" && freeShippingTextValue != ""){
        alert("택배비를 입력하지 않으면 무료배송 조건을 입력할 수 없습니다.");
        f.delivery_fee.focus();
        return;
    }

    if(deliveryFeeValue != "" && isNaN(deliveryFeeValue)){
        alert("배송비는 숫자만 입력할 수 있습니다.");
        f.delivery_fee.focus();
        return;
    }

    if(freeShippingValue != "" && isNaN(freeShippingValue)){
        alert("무료배송 조건은 숫자만 입력할 수 있습니다.");
        freeShippingView.focus();
        return;
    }

    if(deliveryFeeValue == ""){
        deliveryFeeValue = "0";
    }

    let deliveryFee = Number(deliveryFeeValue);

    if(deliveryFee < 0){
        alert("배송비는 0원 이상 입력해야 합니다.");
        f.delivery_fee.focus();
        return;
    }

    if(freeShippingValue == ""){
        freeShippingValue = "0";
    }

    freeShippingValue = Number(freeShippingValue);

    if(freeShippingValue < 0){
        alert("무료배송 기준 금액을 올바르게 입력해주세요.");
        freeShippingView.focus();
        return;
    }

    
    let productPriceForShipping = price;

    if(salePrice > 0){
        productPriceForShipping = salePrice;
    }

    if(deliveryFee > 0 && freeShippingValue > 0 && freeShippingValue < productPriceForShipping){
        alert("무료배송 기준 금액은 상품 가격보다 낮게 설정할 수 없습니다.");
        freeShippingView.focus();
        return;
    }

    if(deliveryFee == 0){
        freeShippingValue = 0;
    }

    f.price.value = String(price);
    f.sale_price.value = String(salePrice);
    f.stock.value = String(stockValue);
    f.delivery_fee.value = String(deliveryFee);
    f.free_shipping.value = String(freeShippingValue);

    let formData = new FormData(f);

    fetch("/seller_product_modify.do",{method:"post",body:formData}).then(res=>res.json()).then(data=>{
            if(data.result == 1){
                alert("상품을 수정하셨습니다.");
                location.href = "/product_detail.do?product_id=" + data.product_id;
            } else {
                alert("상품 수정 적용이 실패하셨습니다. 관리자에게 문의 바랍니다.");
            }
        });
}