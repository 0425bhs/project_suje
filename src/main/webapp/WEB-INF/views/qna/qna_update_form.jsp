<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의 수정</title>
    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/order-payment.css">
    <script src="/js/product_main.js" defer></script>

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
        .form-field select,
        .form-field textarea {
            width: 100%;
            border: 1px solid #ead8cc;
            background: #fff;
            color: #2b2b2b;
            font-size: 15px;
            outline: none;
        }

        .form-field input:focus,
        .form-field select:focus,
        .form-field textarea:focus {
            border-color: #ff6f4f;
            box-shadow: 0 0 0 3px rgba(255, 111, 79, 0.12);
        }

        .form-field input,
        .form-field select {
            height: 48px;
            padding: 0 15px;
        }

        .form-field textarea {
            min-height: 230px;
            padding: 16px;
            resize: vertical;
            line-height: 1.7;
        }

        .type-help {
            margin-top: 7px;
            color: #9b7b68;
            font-size: 12px;
            font-weight: 700;
            line-height: 1.5;
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
            const qnaType = f.qna_type.value.trim();
            const title = f.title.value.trim();
            const content = f.content.value.trim();

            if (qnaType === "") {
                alert("문의 유형을 선택해주세요.");
                f.qna_type.focus();
                return;
            }

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
<jsp:include page="/WEB-INF/views/product/product_header.jsp" />

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>QNA</span>
                <h2>문의 수정</h2>
                <p>작성한 문의의 유형, 제목, 내용을 수정할 수 있습니다.</p>
            </div>
        </div>

        <form class="community-card">
            <input type="hidden" name="qna_id" value="${qna.qna_id}">

            <div class="form-layout">
                <aside class="product-panel">
                    <span>문의 상품</span>

                    <c:choose>
                        <c:when test="${empty qna.image_l}">
                            <img src="/images/no_image.png" alt="${qna.product_name}">
                        </c:when>
                        <c:otherwise>
                            <img src="/upload/${qna.image_l}" alt="${qna.product_name}">
                        </c:otherwise>
                    </c:choose>

                    <strong>${qna.product_name}</strong>
                    <p>답변 전 문의라면 내용을 다시 정리해서 저장할 수 있습니다.</p>
                </aside>

                <div class="form-stack">

                    <div class="form-field">
                        <label>공개 여부</label>

                        <div class="qna-open-radio-box">
                            <label class="qna-open-radio">
                                <input type="radio" name="is_private" value="0" ${qna.is_private == 0 ? 'checked' : ''}>
                                <span>
                                    <strong>공개 문의</strong>
                                    <em>상품 상세페이지에서 다른 회원도 문의 내용을 볼 수 있습니다.</em>
                                </span>
                            </label>

                            <label class="qna-open-radio">
                                <input type="radio" name="is_private" value="1" ${qna.is_private == 1 ? 'checked' : ''}>
                                <span>
                                    <strong>비공개 문의</strong>
                                    <em>상품 상세페이지에서 문의 내용이 비공개로 표시됩니다.</em>
                                </span>
                            </label>
                        </div>
                    </div>

                    <div class="form-field">
                        <label for="qna_type">문의 유형</label>
                        <select id="qna_type" name="qna_type">
                            <option value="">문의 유형을 선택해주세요.</option>
                            <option value="PRODUCT" ${empty qna.qna_type || qna.qna_type eq 'PRODUCT' ? 'selected' : ''}>상품 문의</option>
                            <option value="DELIVERY" ${qna.qna_type eq 'DELIVERY' ? 'selected' : ''}>배송 문의</option>
                            <option value="ORDER" ${qna.qna_type eq 'ORDER' ? 'selected' : ''}>주문 문의</option>
                            <option value="CANCEL" ${qna.qna_type eq 'CANCEL' ? 'selected' : ''}>취소/환불 문의</option>
                            <option value="ETC" ${qna.qna_type eq 'ETC' ? 'selected' : ''}>기타 문의</option>
                        </select>
                        <div class="type-help">문의 성격에 맞게 유형을 선택해주세요.</div>
                    </div>

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
