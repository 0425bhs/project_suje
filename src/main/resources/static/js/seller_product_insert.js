window.onload=function () {
    const freeShippingView=document.getElementById("free_shipping_view");
    const freeShipping=document.getElementById("free_shipping");
    const freeShippingText=document.getElementById("free_shipping_text");
    const bigCategory = document.getElementById("big_category_id");
    const smallCategory = document.getElementById("category_id");

    freeShippingView.addEventListener("input",function(){
        let value=this.value.replace(/[^0-9]/g, "");

        if (value==""){
            this.value = "";
            freeShipping.value = "0";
            freeShippingText.innerText = "0";
            return;
        }

        // 서버로 보낼 값: 콤마 없는 숫자
        freeShipping.value = value;

        // 화면에 보여줄 값: 콤마 있는 숫자
        let commaValue = Number(value).toLocaleString();

        this.value = commaValue;
        freeShippingText.innerText = commaValue;
    });    


    if (bigCategory != null && smallCategory != null) {
        bigCategory.addEventListener("change",function(){
            let parentId = this.value;

            smallCategory.innerHTML = "<option value=''>하위 카테고리 선택</option>";

            if (parentId == "") {
                return;
            }

            fetch("/sub.do?parent_id="+parentId).then(res=>res.json()).then(data=>{
                data.forEach(category=>{
                    let option = document.createElement("option");

                    option.value = category.category_id;
                    option.innerText = category.name;

                    smallCategory.appendChild(option);
                });
            });
        });
    }
};


function send(f) {

    const bigCategory = document.getElementById("big_category_id");
    const category_id=f.category_id;
    const name=f.name;
    const description=f.description;
    const imageL=f.image_l_file;
    const imageS=f.image_s_file;

    if (bigCategory.value == "") {
        alert("대분류 카테고리를 선택하세요.");
        bigCategory.focus();
        return;
    }

    if (category_id.value == "") {
        alert("하위 카테고리를 선택하세요.");
        category_id.focus();
        return;
    }

    if (name.value=="") {
        alert("제품명을 미기입하셨습니다.");
        name.focus();
        return;
    }

    if (description.value=="") {
        alert("상세 내용을 미기입하셨습니다.");
        description.focus();
        return;
    }

    if (f.stock.value == "") {
        alert("재고 수량을 미기입하셨습니다.");
        f.stock.focus();
        return;
    }
    
    let stockValue = Number(f.stock.value);
    if (stockValue < 0) {
        alert("올바른 재고 수량을 기입해주세요.");
        f.stock.focus();
        return;
    }


    // 콤마 제거 후 숫자로 변환
    let price = Number(f.price.value.replace(/,/g, ""));
    let salePrice = Number((f.sale_price.value || "0").replace(/,/g, ""));

    if (price <= 0) {
        alert("상품 가격을 미기입하셨습니다.");
        f.price.focus();
        return;
    }

    if (salePrice < 0) {
        alert("할인 가격을 올바르게 입력해주세요.");
        f.sale_price.focus();
        return;
    }

    if (salePrice>0 && salePrice>=price) {
        alert("할인 가격이 잘못 기입되었습니다.");
        f.sale_price.focus();
        return;
    }

    let deliveryFee = Number(f.delivery_fee.value || 0);

    if (deliveryFee < 0) {
        alert("배송비를 올바르게 입력해주세요.");
        f.delivery_fee.focus();
        return;
    }

    // 배송비 화면 값에서 숫자만 뽑아서 hidden input에 넣기
    const freeShippingView = document.getElementById("free_shipping_view");
    const freeShipping = document.getElementById("free_shipping");

    freeShipping.value = freeShippingView.value.replace(/[^0-9]/g, "");

    if (freeShipping.value=="") {
        freeShipping.value="0";
    }

    let freeShippingValue = Number(freeShipping.value);

    if (freeShippingValue < 0) {
        alert("무료배송 기준 금액을 올바르게 입력해주세요.");
        freeShippingView.focus();
        return;
    }

    if (deliveryFee==0) {
        freeShippingValue = 0;
    }

    if (imageL.value == "") {
        alert("대표 이미지를 등록해주세요.");
        imageL.focus();
        return;
    }

    if (imageS.value == "") {
        alert("상세 이미지를 등록해주세요.");
        imageS.focus();
        return;
    }


    // 서버로 보내기 전에 콤마 제거
    f.price.value = String(price);
    f.sale_price.value = String(salePrice);

    f.stock.value = String(stockValue);
    f.delivery_fee.value = String(deliveryFee);
    f.free_shipping.value = String(freeShippingValue);

    let formData = new FormData(f);

    fetch("/seller_product_insert.do",{method:"post",body:formData}).then(res=>res.json()).then(data=>{
        if (data.result==1) {
            alert("상품 등록이 되었습니다.");
            location.href="/all_list.do";
        } else {
            alert("상품 등록이 실패되어 관리자에게 문의바랍니다.");
        }
    });
}