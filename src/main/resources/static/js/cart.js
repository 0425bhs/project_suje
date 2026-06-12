function cartInsert(){

    let productInput = document.getElementById("product_id");
    let quantityInput = document.getElementById("detailQuantity");

    if(productInput == null){
        alert("상품 정보를 찾을 수 없습니다.");
        return;
    }

    let product_id = productInput.value;
    let quantity = 1;

    if(quantityInput != null){
        quantity = quantityInput.value;
    }

    if(quantity == "" || Number(quantity) <= 0){
        quantity = 1;
    }

    const params = new URLSearchParams();
    params.append("product_id", product_id);
    params.append("quantity", quantity);

    fetch("/cart_insert.do", {
        method: "POST",
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: params.toString()
    }).then(response => response.json()).then(data => {

        if(data.result == "login"){
            alert("로그인 후 이용 가능합니다.");
            location.href = "/login.do";
            return;
        }

        if(data.result == "success"){
            if(confirm("장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")){
                location.href = "/cart_list.do";
            }
            return;
        }

        alert("장바구니 담기에 실패했습니다.");
    }).catch(error => {
        console.log(error);
        alert("장바구니 처리 중 오류가 발생했습니다.");
    });
}


function allCartCheck(){

    const allCheck = document.getElementById("allCheck");
    const sellerChecks = document.querySelectorAll(".seller-check");
    const checks = document.querySelectorAll(".cart-check");

    sellerChecks.forEach(chk => {
        chk.checked = allCheck.checked;
    });

    checks.forEach(chk => {
        chk.checked = allCheck.checked;
    });

    calcCartTotal();
}


function sellerCartCheck(sellerCheck){

    const sellerId = sellerCheck.dataset.sellerId;
    const checks = document.querySelectorAll(".cart-check[data-seller-id='" + sellerId + "']");

    checks.forEach(chk => {
        chk.checked = sellerCheck.checked;
    });

    calcCartTotal();
}


function calcCartTotal(){

    const allChecks = document.querySelectorAll(".cart-check");
    const checked = document.querySelectorAll(".cart-check:checked");
    const sellerChecks = document.querySelectorAll(".seller-check");

    let originTotal = 0;
    let productTotal = 0;
    let discountTotal = 0;
    let couponTotal = 0;
    let deliveryTotal = 0;

    let hasFreeShipping = false;
    let maxDeliveryFee = 0;
    let appliedSellerId = "";

    checked.forEach(chk => {

        let itemTotal = Number(chk.dataset.price || 0);
        let originPrice = Number(chk.dataset.originPrice || 0);
        let discountPrice = Number(chk.dataset.discount || 0);
        let deliveryFee = Number(chk.dataset.deliveryFee || 0);
        let freeShipping = Number(chk.dataset.freeShipping || 0);
        let sellerId = chk.dataset.sellerId;

        originTotal += originPrice;
        productTotal += itemTotal;
        discountTotal += discountPrice;

        if(deliveryFee == 0 || (freeShipping > 0 && itemTotal >= freeShipping)){
            hasFreeShipping = true;
        }

        if(deliveryFee > maxDeliveryFee){
            maxDeliveryFee = deliveryFee;
            appliedSellerId = sellerId;
        }
    });

    if(checked.length == 0){
        deliveryTotal = 0;
    }else if(hasFreeShipping){
        deliveryTotal = 0;
    }else{
        deliveryTotal = maxDeliveryFee;
    }

    let orderTotal = productTotal + deliveryTotal - couponTotal;

    setMoneyText("originTotal", originTotal, "");
    setMoneyText("discountTotal", discountTotal, "-");
    setMoneyText("couponTotal", couponTotal, "-");
    setMoneyText("deliveryTotal", deliveryTotal, "+");
    setMoneyText("orderTotal", orderTotal, "");

    updateSellerOrderSummary(hasFreeShipping, appliedSellerId, maxDeliveryFee);

    const orderCountBadge = document.getElementById("orderCountBadge");

    if(orderCountBadge != null){
        orderCountBadge.innerText = checked.length;
    }

    sellerChecks.forEach(sellerCheck => {

        const sellerId = sellerCheck.dataset.sellerId;
        const sellerItems = document.querySelectorAll(".cart-check[data-seller-id='" + sellerId + "']");
        const sellerChecked = document.querySelectorAll(".cart-check[data-seller-id='" + sellerId + "']:checked");

        sellerCheck.checked = sellerItems.length > 0 && sellerItems.length == sellerChecked.length;
    });

    const allCheck = document.getElementById("allCheck");

    if(allCheck != null){
        allCheck.checked = allChecks.length > 0 && allChecks.length == checked.length;
    }
}


function updateSellerOrderSummary(hasFreeShipping, appliedSellerId, maxDeliveryFee){

    const sellerRows = document.querySelectorAll(".seller-delivery-row");

    sellerRows.forEach(row => {

        const sellerBox = row.closest(".seller-cart-box");

        if(sellerBox == null){
            return;
        }

        const sellerId = sellerBox.dataset.sellerId;
        const sellerChecked = document.querySelectorAll(".cart-check[data-seller-id='" + sellerId + "']:checked");

        let sellerProductTotal = 0;

        sellerChecked.forEach(chk => {
            sellerProductTotal += Number(chk.dataset.price || 0);
        });

        let sellerDeliveryFee = 0;

        if(sellerChecked.length == 0){
            sellerDeliveryFee = 0;
        }else if(hasFreeShipping){
            sellerDeliveryFee = 0;
        }else if(sellerId == appliedSellerId){
            sellerDeliveryFee = maxDeliveryFee;
        }else{
            sellerDeliveryFee = 0;
        }

        let sellerOrderTotal = sellerProductTotal + sellerDeliveryFee;

        const mainDeliveryText = row.querySelector(".seller-main-delivery-text");
        const summaryTotal = row.querySelector(".seller-summary-total");
        const detailProductTotal = row.querySelector(".seller-detail-product-total");
        const detailDeliveryFee = row.querySelector(".seller-detail-delivery-fee");
        const detailFinalTotal = row.querySelector(".seller-detail-final-total");

        if(mainDeliveryText != null){
            if(sellerDeliveryFee == 0){
                mainDeliveryText.innerText = "무료";
                mainDeliveryText.classList.add("delivery-free");
            }else{
                mainDeliveryText.innerText = sellerDeliveryFee.toLocaleString() + "원";
                mainDeliveryText.classList.remove("delivery-free");
            }
        }

        if(summaryTotal != null){
            summaryTotal.innerText = sellerOrderTotal.toLocaleString() + "원";
        }

        if(detailProductTotal != null){
            detailProductTotal.innerText = sellerProductTotal.toLocaleString() + "원";
        }

        if(detailDeliveryFee != null){
            detailDeliveryFee.innerText = sellerDeliveryFee.toLocaleString() + "원";
        }

        if(detailFinalTotal != null){
            detailFinalTotal.innerText = sellerOrderTotal.toLocaleString() + "원";
        }
    });
}


function setMoneyText(id, value, prefix){

    const el = document.getElementById(id);

    if(el != null){
        el.innerText = prefix + value.toLocaleString() + "원";
    }
}


function cartQtyMinus(btn){

    const box = btn.closest(".cart-quantity-box");
    const input = box.querySelector(".cart-qty-input");

    let quantity = Number(input.value);

    if(quantity <= 1){
        alert("최소 수량은 1개입니다.");
        quantity = 1;
    }else{
        quantity--;
    }

    input.value = quantity;
    cartQtyUpdate(input);
}


function cartQtyPlus(btn){

    const box = btn.closest(".cart-quantity-box");
    const input = box.querySelector(".cart-qty-input");

    let quantity = Number(input.value);
    let max = Number(input.max);

    if(max > 0 && quantity >= max){
        alert("재고 수량을 초과할 수 없습니다.");
        quantity = max;
    }else{
        quantity++;
    }

    input.value = quantity;
    cartQtyUpdate(input);
}


function cartQtyUpdate(input){

    let cart_id = input.dataset.cartId;
    let quantity = Number(input.value);
    let max = Number(input.max);

    if(cart_id == null || cart_id == ""){
        alert("장바구니 정보를 찾을 수 없습니다.");
        return;
    }

    if(quantity <= 0 || isNaN(quantity)){
        quantity = 1;
    }

    if(max > 0 && quantity > max){
        alert("재고 수량을 초과할 수 없습니다.");
        quantity = max;
    }

    input.value = quantity;

    location.href = "/cart_quantity_update.do?cart_id=" + cart_id + "&quantity=" + quantity;
}


function deleteSelectedCart(){

    const checked = document.querySelectorAll(".cart-check:checked");

    if(checked.length == 0){
        alert("삭제할 상품을 선택하세요.");
        return;
    }

    if(!confirm("선택한 상품을 삭제하시겠습니까?")){
        return;
    }

    document.cartForm.action = "/cart_delete_selected.do";
    document.cartForm.method = "post";
    document.cartForm.submit();
}


function goProductDetail(row){

    let product_id = row.dataset.productId;

    if(product_id == null || product_id == ""){
        alert("상품 정보를 찾을 수 없습니다.");
        return;
    }

    location.href = "/product_detail.do?product_id=" + product_id;
}


function toggleSellerOrderSummary(btn){

    const row = btn.closest(".seller-delivery-row");
    const arrow = row.querySelector(".seller-order-arrow");

    row.classList.toggle("is-open");

    if(row.classList.contains("is-open")){
        arrow.innerText = "∧";
    }else{
        arrow.innerText = "∨";
    }
}


window.addEventListener("load", function(){
    calcCartTotal();
});

function toggleDeliveryTip(event, btn) {
    event.stopPropagation();

    const wrap = btn.closest(".delivery-tip-wrap");

    if (wrap == null) {
        return;
    }

    document.querySelectorAll(".delivery-tip-wrap.is-open").forEach(item => {
        if (item !== wrap) {
            item.classList.remove("is-open");
        }
    });

    wrap.classList.toggle("is-open");
}

function closeDeliveryTip(event, btn) {
    event.stopPropagation();

    const wrap = btn.closest(".delivery-tip-wrap");

    if (wrap != null) {
        wrap.classList.remove("is-open");
    }
}

document.addEventListener("click", function () {
    document.querySelectorAll(".delivery-tip-wrap.is-open").forEach(item => {
        item.classList.remove("is-open");
    });
});

function cartOrderCheck() {

    const checkedList = document.querySelectorAll(".cart-check:checked");

    if (checkedList.length === 0) {
        alert("주문할 상품을 선택해주세요.");
        return false;
    }

    return true;
}