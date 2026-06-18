window.onload = function(){

    initProductDescriptionEditor();
    
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

    if(name.value == ""){
        alert("제품명을 등록해주세요.");
        name.focus();
        return;
    }

    if (window.productDescriptionEditor != null) {
        const editorContent = window.productDescriptionEditor.getHTML().trim();

        if (editorContent === "" || editorContent === "<p><br></p>") {
            alert("상품 설명을 입력하세요.");
            window.productDescriptionEditor.focus();
            return;
        }

        document.getElementById("description").value = editorContent;
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

    fetch("/seller_product_insert.do",{method:"post",body: formData}).then(res=>res.json()).then(data=>{
        if(data.result == 1){
            alert("상품을 등록하셨습니다.");
            location.href = "/seller_product_list.do";
        } else {
            alert("상품 등록이 실패했습니다. 관리자에게 문의 바랍니다.");
        }
    });
}

function initProductDescriptionEditor() {
    const editorBox = document.querySelector("#productDescriptionEditor");

    if (editorBox == null) {
        return;
    }

    const undoIcon =
        '<svg viewBox="0 0 24 24">' +
            '<path d="M9 14L4 9L9 4"></path>' +
            '<path d="M5 9H15C18 9 20 11 20 14C20 17 18 19 15 19H11"></path>' +
        '</svg>';

    const redoIcon =
        '<svg viewBox="0 0 24 24">' +
            '<path d="M15 14L20 9L15 4"></path>' +
            '<path d="M19 9H9C6 9 4 11 4 14C4 17 6 19 9 19H13"></path>' +
        '</svg>';

    const mediaIcon =
        '<svg viewBox="0 0 24 24">' +
            '<rect x="3" y="5" width="14" height="14" rx="2"></rect>' +
            '<path d="M17 9L21 7V17L17 15Z"></path>' +
            '<path d="M8 9L13 12L8 15Z"></path>' +
        '</svg>';

    const undoButton = createEditorIconButton(undoIcon, "되돌리기", function () {
        window.productDescriptionEditor.exec("undo");
        window.productDescriptionEditor.focus();
    });

    const redoButton = createEditorIconButton(redoIcon, "다시 실행", function () {
        window.productDescriptionEditor.exec("redo");
        window.productDescriptionEditor.focus();
    });

    const mediaButton = createEditorIconButton(mediaIcon, "영상 삽입", function () {
        insertProductMedia();
    });

    window.productDescriptionEditor = new toastui.Editor({
        el: editorBox,
        height: "500px",
        initialEditType: "wysiwyg",
        previewStyle: "vertical",
        placeholder: "상품 설명을 입력하세요.",

        customHTMLSanitizer: function (html) {
            return html;
        },

        hooks: {
            addImageBlobHook: function (blob, callback) {
                uploadEditorImage(blob, callback);
                return false;
            }
        },

        toolbarItems: [
            [
                {
                    name: "undoButton",
                    tooltip: "되돌리기",
                    el: undoButton
                },
                {
                    name: "redoButton",
                    tooltip: "다시 실행",
                    el: redoButton
                }
            ],
            ["heading", "bold", "italic", "strike"],
            ["hr", "quote"],
            ["ul", "ol", "task"],
            ["table", "image", "link"],
            [
                {
                    name: "mediaButton",
                    tooltip: "영상 삽입",
                    el: mediaButton
                }
            ],
            ["code", "codeblock"]
        ]
    });
}

function createEditorIconButton(iconSvg, title, clickEvent) {
    const button = document.createElement("button");

    button.type = "button";
    button.title = title;
    button.className = "custom-toolbar-btn";
    button.innerHTML = iconSvg;

    button.addEventListener("mousedown", function (e) {
        e.preventDefault();
    });

    button.addEventListener("click", function (e) {
        e.preventDefault();
        clickEvent();
    });

    return button;
}

function insertProductMedia() {
    const mediaUrl = prompt("유튜브 주소 또는 mp4 영상 주소를 입력하세요.");

    if (mediaUrl == null || mediaUrl.trim() === "") {
        return;
    }

    const url = mediaUrl.trim();
    const youtubeId = getYoutubeId(url);

    let mediaHtml = "";

    if (youtubeId !== "") {
        mediaHtml =
            '<p></p>' +
            '<div style="position:relative; padding-bottom:56.25%; height:0; overflow:hidden; max-width:100%;">' +
                '<iframe ' +
                    'src="https://www.youtube.com/embed/' + youtubeId + '" ' +
                    'style="position:absolute; top:0; left:0; width:100%; height:100%;" ' +
                    'frameborder="0" ' +
                    'allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" ' +
                    'allowfullscreen>' +
                '</iframe>' +
            '</div>' +
            '<p></p>';
    } else if (isVideoFile(url)) {
        mediaHtml =
            '<p></p>' +
            '<video controls style="max-width:100%; width:700px;">' +
                '<source src="' + escapeHtml(url) + '">' +
                '브라우저가 video 태그를 지원하지 않습니다.' +
            '</video>' +
            '<p></p>';
    } else {
        alert("유튜브 주소 또는 mp4/webm/ogg 영상 주소만 입력하세요.");
        return;
    }

    const currentHtml = window.productDescriptionEditor.getHTML();
    window.productDescriptionEditor.setHTML(currentHtml + mediaHtml);
    window.productDescriptionEditor.focus();
}

function getYoutubeId(url) {
    const regExp = /(?:youtube\.com\/(?:watch\?v=|embed\/|shorts\/)|youtu\.be\/)([^&?\/]+)/;
    const match = url.match(regExp);

    if (match && match[1]) {
        return match[1];
    }

    return "";
}

function isVideoFile(url) {
    return /\.(mp4|webm|ogg)(\?.*)?$/i.test(url);
}

function escapeHtml(str) {
    return str
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}

function uploadEditorImage(blob, callback) {
    const formData = new FormData();

    formData.append("image", blob);

    fetch("/editor/image/upload", {
        method: "post",
        body: formData
    })
    .then(res => res.json())
    .then(data => {
        if (data.result == 1) {
            callback(data.imageUrl, blob.name);
        } else {
            alert("이미지 업로드에 실패했습니다.");
        }
    })
    .catch(() => {
        alert("이미지 업로드 중 오류가 발생했습니다.");
    });
}