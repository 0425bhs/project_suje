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
            grid-template-columns: minmax(0, 1fr);
            gap: 32px;
            align-items: start;
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

        .form-field input {
            height: 48px;
            padding: 0 15px;
        }

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

            f.action = "/inquiry_update_form.do";
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
            <a href="/inquiry_form.do">고객센터 문의</a>
            <a href="/notice_list.do">공지사항</a>
        </nav>

        <div class="header-actions">
            <a href="/myshop/inquiries">내 문의</a>
            <a href="/myshop/orders">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>CUSTOMER INQUIRY</span>
                <h2>고객센터 문의 수정</h2>
                <p>작성한 문의의 제목과 내용을 수정할 수 있습니다.</p>
            </div>
        </div>

        <form class="community-card">
            <input type="hidden" name="inquiry_id" value="${inquiry.inquiry_id}">

            <div class="form-layout">
                <div class="form-stack">
                    <div class="form-field">
                        <label for="inquiry_type">문의 유형</label>
                        <select id="inquiry_type" name="inquiry_type">
                            <option value="SERVICE" ${inquiry.inquiry_type eq 'SERVICE' ? 'selected' : ''}>서비스 이용</option>
                            <option value="ACCOUNT" ${inquiry.inquiry_type eq 'ACCOUNT' ? 'selected' : ''}>회원/계정</option>
                            <option value="PAYMENT" ${inquiry.inquiry_type eq 'PAYMENT' ? 'selected' : ''}>결제 오류</option>
                            <option value="SELLER" ${inquiry.inquiry_type eq 'SELLER' ? 'selected' : ''}>판매자센터</option>
                            <option value="POLICY" ${inquiry.inquiry_type eq 'POLICY' ? 'selected' : ''}>운영 정책</option>
                            <option value="ETC" ${inquiry.inquiry_type eq 'ETC' ? 'selected' : ''}>기타</option>
                        </select>
                    </div>

                    <div class="form-field">
                        <label for="title">제목</label>
                        <input id="title" name="title" value="${inquiry.title}" placeholder="문의 제목을 입력해주세요.">
                    </div>

                    <div class="form-field">
                        <label for="content">내용</label>
                        <textarea id="content" name="content" placeholder="문의 내용을 입력해주세요.">${inquiry.content}</textarea>
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
        <p>서비스 이용 중 궁금한 내용을 고객센터에 문의할 수 있습니다.</p>
    </div>
</footer>
</body>
</html>
