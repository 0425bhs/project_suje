function productToggle(btn, product_id, status) {

    let msg = "";

    if(status == "HIDDEN"){
        msg = "이 상품을 비활성화하시겠습니까?";
    } else{
        msg = "이 상품을 활성화하시겠습니까?";
    }

    if(!confirm(msg)){
        return;
    }

    fetch("/seller_product_toggle.do",{method:"post",headers:{"Content-Type": "application/x-www-form-urlencoded"},
        body:"product_id="+product_id+"&status="+status}).then(res=>res.json()).then(data=>{
        if (data.result == 1) {
            alert("상품 상태가 변경되었습니다.");
            location.href = "/seller_product_list.do";
        } else {
            alert("상품 상태 변경 실패");
        }
    })
}