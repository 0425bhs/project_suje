function cartInsert(){

    let product_id=document.getElementById("product_id").value;
    let quantity=document.getElementById("quantity").value;

    if (quantity=="" || Number(quantity)<=0){
        quantity=1;
    }

    fetch("/cart_insert.do",{method:"POST",headers:{"Content-Type":"application/x-www-form-urlencoded"},
        body:"product_id="+product_id+"&quantity="+quantity}).then(response=>response.json()).then(data=>{

        if(data.result == "login"){
            alert("로그인 후 이용 가능합니다.");
            location.href = "/login.do";
            return;
        }

        if(data.result=="success"){
            if (confirm("장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")){
                location.href = "/cart_list.do";
            }
            return;
        }

        alert("장바구니 담기에 실패했습니다.");
    })
}