<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>리뷰 작성</title>
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
    </style>
    <script>
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

            f.action = "review_form.do";
            f.method = "post";
            f.submit();
        }
    </script>
</head>

<body>
<header class="site-header">
    <div class="header-inner">
        <a class="brand" href="/main.do">HAND<span>MADE</span></a>

        <nav class="main-nav">
            <a href="/product/main.do">상품보기</a>
            <a href="/live_review_list.do">후기</a>
            <a href="/my_qna_list.do">문의</a>
            <a href="/notice_list.do">공지사항</a>
        </nav>

        <div class="header-actions">
            <a href="/my_review_list.do">내 후기</a>
            <a href="/order/my">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>REVIEW</span>
                <h2>리뷰 작성</h2>
                <p>받아본 작품의 만족도를 남겨주세요.</p>
            </div>
        </div>

        <form class="community-card">
            <input type="hidden" name="product_id" value="${product.product_id}">
            <input type="hidden" name="order_item_id" value="${order_item_id}">
            <div class="form-layout">
                <aside class="product-panel">
                    <span>작가 상품</span>
                    <img src="${product.image_s}" alt="${product.name}">
                    <strong>${product.name}</strong>
                    <p>상품을 선택한 뒤 리뷰 내용과 별점을 입력하면 내 후기 목록에 저장됩니다.</p>
                </aside>

                <div class="form-stack">
                    <div class="form-field">
                        <label for="content">리뷰 내용</label>
                        <textarea id="content" name="content" placeholder="리뷰 내용을 작성해주세요."></textarea>
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

                    <div class="btn-row">
                        <button type="button" class="btn primary" onclick="send(this.form)">작성</button>
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
