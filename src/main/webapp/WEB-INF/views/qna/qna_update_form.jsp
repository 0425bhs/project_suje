<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>문의 수정</title>
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
            background: #eef4ff;
            color: #2563eb;
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

        .form-field input,
        .form-field textarea {
            width: 100%;
            border: 1px solid #ead8cc;
            background: #fff;
            color: #2b2b2b;
            font-size: 15px;
            outline: none;
        }

        .form-field input:focus,
        .form-field textarea:focus {
            border-color: #ff6f4f;
            box-shadow: 0 0 0 3px rgba(255, 111, 79, 0.12);
        }

        .form-field input {
            height: 48px;
            padding: 0 15px;
        }

        .form-field textarea {
            min-height: 230px;
            padding: 16px;
            resize: vertical;
            line-height: 1.7;
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
            const title = f.title.value.trim();
            const content = f.content.value.trim();

            if (title === "") {
                alert("제목을 입력해주세요.");
                f.title.focus();
                return;
            }

            if (content === "") {
                alert("내용을 입력해주세요.");
                f.content.focus();
                return;
            }

            f.action = "qna_update_form.do";
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
            <a href="/mypage/qna">문의</a>
            <a href="/notice_list.do">공지사항</a>
        </nav>

        <div class="header-actions">
            <a href="/mypage/qna">내 문의</a>
            <a href="/myshop/orders">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>QNA</span>
                <h2>문의 수정</h2>
                <p>작성한 문의의 제목과 내용을 수정할 수 있습니다.</p>
            </div>
        </div>

        <form class="community-card">
            <input type="hidden" name="qna_id" value="${qna.qna_id}">

            <div class="form-layout">
                <aside class="product-panel">
                    <span>문의 상품</span>
                    <img src="/upload/${qna.image_l}" alt="${qna.product_name}">
                    <strong>${qna.product_name}</strong>
                    <p>답변 전 문의라면 내용을 다시 정리해서 저장할 수 있습니다.</p>
                </aside>

                <div class="form-stack">
                    <div class="form-field">
                        <label for="title">제목</label>
                        <input id="title" name="title" value="${qna.title}" placeholder="문의 제목을 입력해주세요.">
                    </div>

                    <div class="form-field">
                        <label for="content">내용</label>
                        <textarea id="content" name="content" placeholder="문의 내용을 입력해주세요.">${qna.content}</textarea>
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
        <p>상품 문의와 답변을 통해 구매 전 궁금한 내용을 확인할 수 있습니다.</p>
    </div>
</footer>
</body>
</html>
