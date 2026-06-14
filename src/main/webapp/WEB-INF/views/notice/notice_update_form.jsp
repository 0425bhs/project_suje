<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>공지사항 수정</title>
    <link rel="stylesheet" href="/css/order-payment.css">
    <style>
        .community-page {
            min-height: calc(100vh - 153px);
        }

        .notice-form-card {
            max-width: 900px;
            background: #fff;
            border: 1px solid #f0e5dc;
            padding: 30px;
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
            min-height: 300px;
            padding: 16px;
            resize: vertical;
            line-height: 1.75;
        }

        @media (max-width: 640px) {
            .notice-form-card {
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
                alert("제목을 작성해주세요.");
                f.title.focus();
                return;
            }

            if (content === "") {
                alert("내용을 작성해주세요.");
                f.content.focus();
                return;
            }

            f.action = "notice_update_form.do";
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
            <a href="/notice_list.do">고객센터</a>
            <a href="/order/my">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>NOTICE</span>
                <h2>공지사항 수정</h2>
                <p>등록된 공지 제목과 내용을 수정할 수 있습니다.</p>
            </div>

            <a class="btn light" href="/notice_detail.do?notice_id=${notice.notice_id}">상세로</a>
        </div>

        <form class="notice-form-card">
            <input type="hidden" name="notice_id" value="${notice.notice_id}">

            <div class="form-stack">
                <div class="form-field">
                    <label for="title">제목</label>
                    <input id="title" name="title" value="${notice.title}" placeholder="공지 제목을 입력해주세요.">
                </div>

                <div class="form-field">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" placeholder="공지 내용을 입력해주세요.">${notice.content}</textarea>
                </div>

                <div class="btn-row">
                    <button type="button" class="btn primary" onclick="send(this.form)">수정 완료</button>
                    <button type="button" class="btn light" onclick="history.back()">취소</button>
                </div>
            </div>
        </form>
    </div>
</main>

<footer class="site-footer">
    <div class="footer-inner">
        <strong>HANDMADE</strong>
        <p>공지사항을 통해 서비스 안내와 운영 소식을 전달합니다.</p>
    </div>
</footer>
</body>
</html>
