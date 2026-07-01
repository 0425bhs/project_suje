<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>리뷰 수정</title>
    <link rel="stylesheet" href="/css/order-payment.css">
    <style>
        .community-page {
            min-height: calc(100vh - 153px);
        }

        .community-card {
            background: #fff;
            border: 1px solid #f0e5dc;
            padding: 30px;
        }

        .form-layout {
            display: grid;
            grid-template-columns: 260px minmax(0, 1fr);
            gap: 32px;
            align-items: start;
        }

        .product-panel {
            padding: 20px;
            background: #fffaf7;
            border: 1px solid #f0e5dc;
        }

        .product-panel img {
            width: 100%;
            aspect-ratio: 1 / 1;
            display: block;
            object-fit: cover;
            background: #f6f6f6;
            border: 1px solid #f0e5dc;
        }

        .product-panel span {
            display: inline-flex;
            height: 26px;
            padding: 0 10px;
            margin-bottom: 14px;
            align-items: center;
            background: #fff0e7;
            color: #d85b35;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
        }

        .product-panel strong {
            display: block;
            margin-top: 16px;
            color: #2b2b2b;
            font-size: 18px;
            font-weight: 900;
            line-height: 1.45;
        }

        .product-panel p {
            margin: 8px 0 0;
            color: #8a6b5a;
            font-size: 14px;
            line-height: 1.6;
        }

        .form-stack {
            display: grid;
            gap: 20px;
        }

        .form-field label {
            display: block;
            margin-bottom: 9px;
            color: #4b3b32;
            font-size: 14px;
            font-weight: 900;
        }

        .form-field textarea,
        .form-field select {
            width: 100%;
            border: 1px solid #ead8cc;
            background: #fff;
            color: #2b2b2b;
            font-size: 15px;
            outline: none;
        }

        .form-field textarea:focus,
        .form-field select:focus {
            border-color: #ff6f4f;
            box-shadow: 0 0 0 3px rgba(255, 111, 79, 0.12);
        }

        .form-field textarea {
            min-height: 220px;
            padding: 16px;
            resize: vertical;
            line-height: 1.7;
        }

        .form-field select {
            height: 48px;
            padding: 0 14px;
            appearance: none;
            background-image: linear-gradient(45deg, transparent 50%, #8a6b5a 50%), linear-gradient(135deg, #8a6b5a 50%, transparent 50%);
            background-position: calc(100% - 18px) 21px, calc(100% - 12px) 21px;
            background-size: 6px 6px, 6px 6px;
            background-repeat: no-repeat;
        }

        @media (max-width: 760px) {
            .form-layout {
                grid-template-columns: 1fr;
            }

            .community-card {
                padding: 22px;
            }

            .btn-row {
                flex-direction: column;
            }
        }


        #image-preview{
            display:flex;
            flex-wrap:wrap;
            gap:12px;
        }

        .image-card{
            width:120px;
            height:120px;
            position:relative;

            border-radius:10px;
            overflow:hidden;

            border:1px solid #ddd;
        }

        .preview-img{
            width:100%;
            height:100%;
            object-fit:cover;
        }

        .delete-btn{
            position: absolute;
            top: 3px;
            right: 6px;
            color: red;
            cursor: pointer;
        }
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const rating = document.getElementById("rating");

            if (rating) {
                rating.value = "${review.rating}";
            }
        });

        function send(f) {
            const content = f.content.value.trim();
            const rating = f.rating.value;

            if (content === "") {
                alert("내용을 입력해주세요.");
                f.content.focus();
                return;
            }

            if (rating === "") {
                alert("별점을 선택해주세요.");
                f.rating.focus();
                return;
            }

            f.action = "/review_update_form.do";
            f.method = "post";
            f.submit();
        }

        let previewImageList = [
            <c:forEach var="image" items="${review.imageList}" varStatus="st">
            {
                image_id : ${image.image_id},
                image_url: "${image.image_url}",
                file: null,
                isNew: false
            }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];

        let deleteImageIds = [];
        
        function addPreview(input) {
            for (const file of input.files) {
                if (previewImageList.length < 5) {
                    previewImageList.push({
                        image_id: null,
                        image_url: null,
                        file: file,
                        isNew: true
                    });
                } else {
                    alert("등록 가능한 이미지는 최대 5개입니다.");
                    return;
                }
            }

            renderPreview();
        }

        function deletePreview(index) {
            const image = previewImageList[index];

            if (!image.isNew) {
                deleteImageIds.push(image.image_id);
                document.getElementById("deleteImageIds").value = deleteImageIds.join(",");
            }

            previewImageList.splice(index, 1);
            renderPreview();
        }

        function renderPreview() {
            const preview = document.getElementById("image-preview");
            preview.innerHTML = "";

            for (let i = 0; i < previewImageList.length; i++) {
                const image = previewImageList[i];

                const card = document.createElement("div");
                card.classList.add("image-card");

                const del = document.createElement("span");
                del.innerHTML = "x";
                del.classList.add("delete-btn");
                del.onclick = function () {
                    deletePreview(i);
                };

                const img = document.createElement("img");

                if (image.isNew) {
                    img.src = URL.createObjectURL(image.file);
                } else {
                    img.src = "/upload/" + image.image_url;
                }

                img.classList.add("preview-img");

                card.appendChild(del);
                card.appendChild(img);
                preview.appendChild(card);
            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            renderPreview();

            const rating = document.getElementById("rating");
            if (rating) {
                rating.value = "${review.rating}";
            }
        });
    </script>
</head>

<body>
<header class="site-header">
    <div class="header-inner">
        <a class="brand" href="/main.do">HAND<span>MADE</span></a>

        <nav class="main-nav">
            <a href="/product/main.do">상품보기</a>
            <a href="/live_review_list.do">후기</a>
            <a href="/mypage/qna">문의</a>
            <a href="/notice_list.do">공지사항</a>
        </nav>

        <div class="header-actions">
            <a href="/myshop/reviewss">내 후기</a>
            <a href="/myshop/orders">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>REVIEW</span>
                <h2>리뷰 수정</h2>
                <p>작성한 후기 내용과 별점을 다시 정리할 수 있습니다.</p>
            </div>
        </div>

        <form class="community-card" enctype="multipart/form-data">
            <input type="hidden" name="review_id" value="${review.review_id}">
            <input type="hidden" name="deleteImageIds" id="deleteImageIds">

            <div class="form-layout">
                <aside class="product-panel">
                    <span>작가 상품</span>
                    <img src="/upload/${review.image_l}" alt="${review.product_name}">
                    <strong>${review.product_name}</strong>
                    <p>수정한 내용은 내 후기 목록에 바로 반영됩니다.</p>
                </aside>

                <div class="form-stack">
                    <div class="form-field">
                        <label for="content">리뷰 내용</label>
                        <textarea id="content" name="content" placeholder="리뷰 내용을 작성해주세요.">${review.content}</textarea>
                    </div>

                    <div class="form-field">
                        <label for="rating">별점</label>
                        <select id="rating" name="rating">
                            <option value="">별점 선택</option>
                            <option value="5">5점 - 매우 만족</option>
                            <option value="4">4점 - 만족</option>
                            <option value="3">3점 - 보통</option>
                            <option value="2">2점 - 아쉬움</option>
                            <option value="1">1점 - 불만족</option>
                        </select>
                    </div>

                    <div class="form-field">
                        <label>리뷰 사진</label>

                        <input type="file"
                               id="images"
                               name="images"
                               accept="image/*"
                               multiple
                               onchange="addPreview(this)"
                               hidden>
                               
                        <label for="images">
                            +
                        </label>

                        <div class="image-preview" id="image-preview">
                            <c:forEach var="image" items="${review.imageList}">
                                <div class="image-card" id="old-image-${image.image_id}">
                                    <span class="delete-btn" onclick="deleteOldImage('${image.image_id}')">x</span>
                                    <img src="/upload/${image.image_url}" class="preview-img">
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="btn-row">
                        <button type="button" class="btn primary" onclick="send(this.form)">수정 완료</button>
                        <button type="button" class="btn light" onclick="history.back()">취소</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<footer class="site-footer">
    <div class="footer-inner">
        <strong>HANDMADE</strong>
        <p>작가 상품을 둘러보고 구매 경험을 공유할 수 있습니다.</p>
    </div>
</footer>
</body>
</html>
