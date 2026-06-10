function cartInsert(){

    let productInput=document.getElementById("product_id");
    let quantityInput=document.getElementById("detailQuantity");

    if(productInput == null){
        alert("상품 정보를 찾을 수 없습니다.");
        return;
    }

    let product_id=productInput.value;
    let quantity=1;

    if(quantityInput != null){
        quantity=quantityInput.value;
    }

    if(quantity=="" || Number(quantity)<=0){
        quantity=1;
    }

    const params=new URLSearchParams();
    params.append("product_id",product_id);
    params.append("quantity",quantity);

    fetch("/cart_insert.do",{
        method:"POST",
        headers:{"Content-Type":"application/x-www-form-urlencoded"},
        body:params.toString()
    }).then(response=>response.json()).then(data=>{

        if(data.result=="login"){
            alert("로그인 후 이용 가능합니다.");
            location.href="/login.do";
            return;
        }

        if(data.result=="success"){
            if(confirm("장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")){
                location.href="/cart_list.do";
            }
            return;
        }

        alert("장바구니 담기에 실패했습니다.");
    }).catch(error=>{
        console.log(error);
        alert("장바구니 처리 중 오류가 발생했습니다.");
    });
}

function allCartCheck(){

    const allCheck=document.getElementById("allCheck");
    const sellerChecks=document.querySelectorAll(".seller-check");
    const checks=document.querySelectorAll(".cart-check");

    sellerChecks.forEach(chk=>{
        chk.checked=allCheck.checked;
    });

    checks.forEach(chk=>{
        chk.checked=allCheck.checked;
    });

    calcCartTotal();
}

function sellerCartCheck(sellerCheck){

    const sellerId=sellerCheck.dataset.sellerId;
    const checks=document.querySelectorAll(".cart-check[data-seller-id='" + sellerId + "']");

    checks.forEach(chk=>{
        chk.checked=sellerCheck.checked;
    });

    calcCartTotal();
}

function calcCartTotal(){

    const allChecks=document.querySelectorAll(".cart-check");
    const checked=document.querySelectorAll(".cart-check:checked");
    const sellerChecks=document.querySelectorAll(".seller-check");

    let originTotal=0;
    let productTotal=0;
    let discountTotal=0;
    let couponTotal=0;
    let deliveryTotal=0;

    let selectedSellerIds=[];

    checked.forEach(chk=>{
        originTotal += Number(chk.dataset.originPrice || 0);
        productTotal += Number(chk.dataset.price || 0);
        discountTotal += Number(chk.dataset.discount || 0);

        let sellerId=chk.dataset.sellerId;

        if(!selectedSellerIds.includes(sellerId)){
            selectedSellerIds.push(sellerId);
        }
    });

    selectedSellerIds.forEach(sellerId=>{
        const deliveryInput=document.querySelector(".seller-delivery-fee[data-seller-id='" + sellerId + "']");
        if(deliveryInput != null){
            deliveryTotal += Number(deliveryInput.value || 0);
        }
    });

    let orderTotal=productTotal + deliveryTotal - couponTotal;

    setMoneyText("originTotal", originTotal, "");
    setMoneyText("discountTotal", discountTotal, "-");
    setMoneyText("couponTotal", couponTotal, "-");
    setMoneyText("deliveryTotal", deliveryTotal, "+");
    setMoneyText("orderTotal", orderTotal, "");
    const orderSummaryPreview = document.getElementById("orderSummaryPreview");

    const orderCountBadge=document.getElementById("orderCountBadge");

    if(orderCountBadge != null){
        orderCountBadge.innerText=checked.length;
    }

    sellerChecks.forEach(sellerCheck=>{

        const sellerId=sellerCheck.dataset.sellerId;
        const sellerItems=document.querySelectorAll(".cart-check[data-seller-id='" + sellerId + "']");
        const sellerChecked=document.querySelectorAll(".cart-check[data-seller-id='" + sellerId + "']:checked");

        sellerCheck.checked=sellerItems.length > 0 && sellerItems.length == sellerChecked.length;
    });

    const allCheck=document.getElementById("allCheck");

    if(allCheck != null){
        allCheck.checked=allChecks.length > 0 && allChecks.length == checked.length;
    }
}

function setMoneyText(id, value, prefix){

    const el=document.getElementById(id);

    if(el != null){
        el.innerText=prefix + value.toLocaleString() + "원";
    }
}

function cartQtyMinus(btn){

    const box=btn.closest(".cart-quantity-box");
    const input=box.querySelector(".cart-qty-input");

    let quantity=Number(input.value);

    if(quantity <= 1){
        alert("최소 수량은 1개입니다.");
        quantity=1;
    }else{
        quantity--;
    }

    input.value=quantity;
    cartQtyUpdate(input);
}

function cartQtyPlus(btn){

    const box=btn.closest(".cart-quantity-box");
    const input=box.querySelector(".cart-qty-input");

    let quantity=Number(input.value);
    let max=Number(input.max);

    if(max > 0 && quantity >= max){
        alert("재고 수량을 초과할 수 없습니다.");
        quantity=max;
    }else{
        quantity++;
    }

    input.value=quantity;
    cartQtyUpdate(input);
}

function cartQtyUpdate(input){

    let cart_id=input.dataset.cartId;
    let quantity=Number(input.value);
    let max=Number(input.max);

    if(cart_id == null || cart_id == ""){
        alert("장바구니 정보를 찾을 수 없습니다.");
        return;
    }

    if(quantity <= 0 || isNaN(quantity)){
        quantity=1;
    }

    if(max > 0 && quantity > max){
        alert("재고 수량을 초과할 수 없습니다.");
        quantity=max;
    }

    input.value=quantity;

    location.href="/cart_quantity_update.do?cart_id=" + cart_id + "&quantity=" + quantity;
}

function deleteSelectedCart(){

    const checked=document.querySelectorAll(".cart-check:checked");

    if(checked.length == 0){
        alert("삭제할 상품을 선택하세요.");
        return;
    }

    if(!confirm("선택한 상품을 삭제하시겠습니까?")){
        return;
    }

    document.cartForm.action="/cart_delete_selected.do";
    document.cartForm.method="post";
    document.cartForm.submit();
}

window.addEventListener("load", function(){
    calcCartTotal();
});

function goProductDetail(row){

    let product_id = row.dataset.productId;

    if(product_id == null || product_id == ""){
        alert("상품 정보를 찾을 수 없습니다.");
        return;
    }

    location.href = "/product_detail.do?product_id=" + product_id;
}

function toggleOrderSummary() {
    const detail = document.getElementById("orderSummaryDetail");
    const arrow = document.getElementById("orderSummaryArrow");

    if (detail.style.display === "none" || detail.style.display === "") {
        detail.style.display = "block";
        arrow.textContent = "∧";
    } else {
        detail.style.display = "none";
        arrow.textContent = "∨";
    }
}

function toggleSellerOrderSummary(btn) {
    const row = btn.closest(".seller-delivery-row");
    const detail = row.querySelector(".seller-order-detail");
    const arrow = row.querySelector(".seller-order-arrow");

    if (detail.style.display === "none" || detail.style.display === "") {
        detail.style.display = "block";
        arrow.innerText = "∧";
    } else {
        detail.style.display = "none";
        arrow.innerText = "∨";
    }
}