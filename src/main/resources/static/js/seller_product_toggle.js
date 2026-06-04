function productToggle(product_id, status) {

    if (status==="HIDDEN"){
        if (!confirm("상품을 판매중지로 변경하시겠습니까?")) {
            return;
        }
    }

    if (status==="APPROVED"){
        if (!confirm("상품을 다시 판매중으로 변경하시겠습니까?")) {
            return;
        }
    }

    fetch("/seller_product_toggle.do",{method:"post",headers:{"Content-Type":"application/x-www-form-urlencoded"},
        body:"product_id="+encodeURIComponent(product_id)+"&status="+encodeURIComponent(status)})
    .then(res=>res.json()).then(data=>{
        if (data.result == 1) {
            alert("상품 상태가 변경되었습니다.");
            location.href = "/seller_product_list.do";
        } else {
            alert("상품 상태 변경 실패");
        }
    });
}    

// 체크된 상품 번호 가져오기
function getCheckedProductIds() {
    const checkedList = document.querySelectorAll(".product-check:checked");
    return Array.from(checkedList).map(check => check.value);
}

// 전체 체크
function allCheck(checkAll) {
    const checkList = document.querySelectorAll(".product-check");
    checkList.forEach(check => {
        check.checked = checkAll.checked;
    });
}

// 개별 체크 눌렀을 때 전체 체크 상태 맞추기
function checkOne() {
    const checkAll = document.getElementById("checkAll");
    const checkList = document.querySelectorAll(".product-check");
    const checkedList = document.querySelectorAll(".product-check:checked");

    checkAll.checked = checkList.length === checkedList.length;
}

// 선택 수정
function selectedModify() {
    const ids = getCheckedProductIds();

    if (ids.length === 0) {
        alert("수정할 상품을 선택하세요.");
        return;
    }

    if (ids.length > 1) {
        alert("수정은 상품 1개만 선택할 수 있습니다.");
        return;
    }

    location.href = "/seller_product_modify.do?product_id=" + ids[0];
}


// 선택 삭제
function selectedDelete() {
    const ids = getCheckedProductIds();

    if (ids.length === 0) {
        alert("삭제할 상품을 선택하세요.");
        return;
    }

    if (!confirm(ids.length + "개의 상품을 삭제하시겠습니까?")) {
        return;
    }

    const form = document.getElementById("productManageForm");

    form.action = "/seller_product_delete_selected.do";
    form.method = "post";
    form.submit();
}

function productDelete(product_id) {

    if (!confirm("정말 이 상품을 삭제하시겠습니까?")) {
        return;
    }

    fetch("/seller_product_delete.do", {
        method: "post",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "product_id=" + encodeURIComponent(product_id)
    })
    .then(res => res.json())
    .then(data => {
        if (data.result == 1) {
            alert("상품이 삭제되었습니다.");
            location.href = "/seller_product_list.do";
        } else {
            alert("상품 삭제 실패");
        }
    });
}
