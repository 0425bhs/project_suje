window.onload = function(){

    initProductDescriptionEditor();
    initProductImagePreview();

    const bigCategory = document.getElementById("big_category_id");
    const smallCategory = document.getElementById("category_id");

    const deliveryFee = document.getElementById("delivery_fee");
    const freeShippingView = document.getElementById("free_shipping_view");
    const freeShipping = document.getElementById("free_shipping");
    const freeShippingHelp = document.getElementById("free_shipping_help");

    const discountRadios = document.querySelectorAll("input[name='sale_discount_type']");
    const saleStartAt = document.querySelector("input[name='sale_start_at']");
    const saleEndAt = document.querySelector("input[name='sale_end_at']");

    function getDiscountType(){
        const checked = document.querySelector("input[name='sale_discount_type']:checked");

        if(checked == null){
            return "none";
        }

        return checked.value;
    }

    function updateDiscountPeriodInput(){
        if(saleStartAt == null || saleEndAt == null){
            return;
        }

        let discountType = getDiscountType();

        if(discountType == "period"){
            saleStartAt.disabled = false;
            saleEndAt.disabled = false;
        } else {
            saleStartAt.value = "";
            saleEndAt.value = "";
            saleStartAt.disabled = true;
            saleEndAt.disabled = true;
        }
    }

    if(discountRadios != null){
        discountRadios.forEach(function(radio){
            radio.addEventListener("change", function(){
                updateDiscountPeriodInput();
            });
        });

        updateDiscountPeriodInput();
    }

    if(bigCategory != null && smallCategory != null){
        bigCategory.addEventListener("change", function(){
            let parentId = this.value;

            smallCategory.innerHTML = "<option value=''>하위 카테고리 선택</option>";

            if(parentId == ""){
                return;
            }

            fetch("/sub.do?parent_id=" + parentId)
                .then(res => res.json())
                .then(data => {
                    data.forEach(category => {
                        let option = document.createElement("option");

                        option.value = category.category_id;
                        option.innerText = category.name;

                        smallCategory.appendChild(option);
                    });
                });
        });
    }

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

        freeShippingView.addEventListener("input", function(){
            let value = this.value.replace(/,/g, "");

            if(value == ""){
                this.value = "";
                freeShipping.value = "0";
                updateShippingHelp();
                return;
            }

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

        deliveryFee.addEventListener("input", function(){
            checkDeliveryFeeInput();
        });

        checkDeliveryFeeInput();
    }
    
    function initProductImagePreview() {

        const mainImageInput = document.getElementById("image_l_file");
        const mainImagePreview = document.getElementById("image_l_preview");

        const detailImageInput = document.getElementById("image_s_file");
        const detailImagePreview = document.getElementById("image_s_preview");

        if (mainImageInput != null && mainImagePreview != null) {

            mainImageInput.addEventListener("change", function () {

                const file = this.files[0];

                if (file == null) {
                    return;
                }

                if (!file.type.startsWith("image/")) {
                    alert("이미지 파일만 선택할 수 있습니다.");
                    this.value = "";
                    return;
                }

                const imageUrl = URL.createObjectURL(file);

                mainImagePreview.innerHTML = "";

                const previewImage = document.createElement("img");

                previewImage.src = imageUrl;
                previewImage.alt = "대표 이미지 미리보기";

                previewImage.addEventListener("load", function () {
                    URL.revokeObjectURL(imageUrl);
                });

                mainImagePreview.appendChild(previewImage);
            });
        }

        if (detailImageInput != null && detailImagePreview != null) {

            detailImageInput.addEventListener("change", function () {

                const files = Array.from(this.files);

                if (files.length === 0) {
                    return;
                }

                const hasNotImage = files.some(function (file) {
                    return !file.type.startsWith("image/");
                });

                if (hasNotImage) {
                    alert("이미지 파일만 선택할 수 있습니다.");
                    this.value = "";
                    return;
                }

                detailImagePreview.innerHTML = "";

                files.forEach(function (file) {

                    const imageUrl = URL.createObjectURL(file);
                    const previewImage = document.createElement("img");

                    previewImage.src = imageUrl;
                    previewImage.alt = "상세 이미지 미리보기";

                    previewImage.addEventListener("load", function () {
                        URL.revokeObjectURL(imageUrl);
                    });

                    detailImagePreview.appendChild(previewImage);
                });
            });
        }
    }
};

function hasProductOptionValue() {
    const optionArea =
        document.getElementById("optionArea") ||
        document.getElementById("optionListBox");

    if (optionArea == null) {
        return false;
    }

    const optionInputs = optionArea.querySelectorAll(
        "input[name='option_name'], input[name='option_price'], input[name='option_stock']"
    );

    for (let input of optionInputs) {
        if (input.value.trim() !== "") {
            return true;
        }
    }

    return false;
}

function validateStockOptionRule(f) {
    const stock = Number(f.stock.value || 0);
    const optionWritten = hasProductOptionValue();

    if (optionWritten && stock > 0) {
        alert("옵션을 사용하는 상품은 상품 재고를 0으로 입력하거나 비워주세요.");
        f.stock.focus();
        return false;
    }

    return true;
}

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

    if (!validateStockOptionRule(f)) {
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

    const checkedDiscount = f.querySelector("input[name='sale_discount_type']:checked");
    let discountType = checkedDiscount == null ? "none" : checkedDiscount.value;

    let saleStartAt = f.sale_start_at.value;
    let saleEndAt = f.sale_end_at.value;

    if(discountType == "none"){
        salePrice = 0;
        f.sale_price.value = "0";
        f.sale_start_at.value = "";
        f.sale_end_at.value = "";
    }

    if(discountType == "always"){
        if(salePrice <= 0){
            alert("상시 할인을 선택한 경우 세일 가격을 입력해야 합니다.");
            f.sale_price.focus();
            return;
        }

        if(salePrice >= price){
            alert("세일 가격은 상품 가격보다 낮아야 합니다.");
            f.sale_price.focus();
            return;
        }

        f.sale_start_at.value = "";
        f.sale_end_at.value = "";
    }

    if(discountType == "period"){
        if(salePrice <= 0){
            alert("기간 할인을 선택한 경우 세일 가격을 입력해야 합니다.");
            f.sale_price.focus();
            return;
        }

        if(salePrice >= price){
            alert("세일 가격은 상품 가격보다 낮아야 합니다.");
            f.sale_price.focus();
            return;
        }

        if(saleStartAt == ""){
            alert("할인 시작일을 선택하세요.");
            f.sale_start_at.focus();
            return;
        }

        if(saleEndAt == ""){
            alert("할인 종료일을 선택하세요.");
            f.sale_end_at.focus();
            return;
        }

        if(saleEndAt < saleStartAt){
            alert("할인 종료일은 시작일보다 빠를 수 없습니다.");
            f.sale_end_at.focus();
            return;
        }
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

    fetch("/seller_product_modify.do", { method: "post", body: formData })
        .then(res => res.json())
        .then(data => {
            if(data.result == 1){
                alert("상품을 수정하셨습니다.");
                location.href = "/product_detail.do?product_id=" + data.product_id;
            } else {
                alert("상품 수정 적용이 실패하셨습니다. 관리자에게 문의 바랍니다.");
            }
        });
}

function initProductDescriptionEditor() {
    const editorBox = document.querySelector("#productDescriptionEditor");

    if (editorBox == null) {
        return;
    }

    const originDescription = document.getElementById("descriptionOrigin");
    let initialDescription = "";

    if (originDescription != null) {
        initialDescription = originDescription.value;
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

    if (initialDescription.trim() !== "") {
        window.productDescriptionEditor.setHTML(initialDescription);
    }
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

document.addEventListener("DOMContentLoaded", function () {

    const optionListBox = document.getElementById("optionListBox");
    const addOptionBtn = document.getElementById("addOptionBtn");

    if (optionListBox && addOptionBtn) {

        addOptionBtn.addEventListener("click", function () {
            const stockInput = document.getElementById("stock");

            if (stockInput != null && Number(stockInput.value || 0) > 0) {
                alert("상품 재고를 입력한 경우 옵션을 추가할 수 없습니다.");
                stockInput.focus();
                return;
            }

            const row = document.createElement("div");
            row.className = "option-row";

            row.innerHTML = `
                <input type="text"
                       name="option_name"
                       class="option-name-input"
                       placeholder="옵션명">

                <input type="text"
                       name="option_price"
                       class="option-price-input"
                       placeholder="추가금액">

                <input type="text"
                       name="option_stock"
                       class="option-stock-input"
                       placeholder="옵션재고">

                <button type="button" class="option-remove-btn">
                    삭제
                </button>
            `;

            optionListBox.appendChild(row);
        });

        optionListBox.addEventListener("click", function (e) {
            if (e.target.classList.contains("option-remove-btn")) {
                e.target.closest(".option-row").remove();
            }
        });
    }

});

document.addEventListener("DOMContentLoaded", function () {

    const form = document.querySelector("form");
    const stockInput = document.getElementById("stock");

    const optionArea =
        document.getElementById("optionArea") ||
        document.getElementById("optionListBox");

    const addOptionBtn = document.getElementById("addOptionBtn");

    if (form == null || stockInput == null || optionArea == null) {
        return;
    }

    function getOptionInputs() {
        return optionArea.querySelectorAll(
            "input[name='option_name'], input[name='option_price'], input[name='option_stock']"
        );
    }

    function hasOptionValue() {
        const optionInputs = getOptionInputs();

        for (let input of optionInputs) {
            if (input.value.trim() !== "") {
                return true;
            }
        }

        return false;
    }

    function setOptionDisabled(disabled) {
        const optionInputs = getOptionInputs();

        optionInputs.forEach(function (input) {
            input.disabled = disabled;

            if (disabled) {
                input.value = "";
            }
        });

        if (addOptionBtn != null) {
            addOptionBtn.disabled = disabled;
        }

        if (disabled) {
            optionArea.classList.add("option-disabled");
        } else {
            optionArea.classList.remove("option-disabled");
        }
    }

    function checkStockAndOptionState() {
        const stock = Number(stockInput.value || 0);

        if (stock > 0) {
            setOptionDisabled(true);
        } else {
            setOptionDisabled(false);
        }
    }

    stockInput.addEventListener("input", function () {
        checkStockAndOptionState();
    });

    optionArea.addEventListener("input", function () {
        if (hasOptionValue()) {
            stockInput.value = 0;
        }

        checkStockAndOptionState();
    });

    form.addEventListener("submit", function (event) {
        const stock = Number(stockInput.value || 0);
        const optionWritten = hasOptionValue();

        if (optionWritten && stock > 0) {
            alert("옵션을 사용하는 상품은 상품 재고를 0으로 입력하거나 비워주세요.");
            stockInput.focus();
            event.preventDefault();
            return;
        }

        if (stock > 0 && optionWritten) {
            alert("상품 재고를 입력한 경우 옵션을 사용할 수 없습니다.");
            event.preventDefault();
            return;
        }
    });

    checkStockAndOptionState();
});