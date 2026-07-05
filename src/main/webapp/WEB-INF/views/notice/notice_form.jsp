<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>공지사항 작성</title>
    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/notice/notice.css">
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

            f.action = "notice_form.do";
            f.method = "post";
            f.submit();
        }
    </script>
</head>

<body>
<jsp:include page="/WEB-INF/views/product/product_header.jsp" />

<main class="notice-page">
    <div class="notice-inner">
        <div class="notice-title-row">
            <div>
                <span class="notice-eyebrow">NOTICE</span>
                <h2>공지사항 작성</h2>
                <p>고객에게 안내할 공지 제목과 내용을 입력해주세요.</p>
            </div>
        </div>

        <form class="notice-panel notice-form-panel">
            <div class="notice-form-grid">
                <div class="notice-field">
                    <label for="title">제목</label>
                    <input id="title" name="title" placeholder="공지 제목을 입력해주세요.">
                </div>

                <div class="notice-field">
                    <label for="content">내용</label>
                    <textarea id="content" name="content" placeholder="공지 내용을 입력해주세요."></textarea>
                </div>

                <div class="notice-actions">
                    <button type="button" class="notice-btn primary" onclick="send(this.form)">등록</button>
                    <button type="button" class="notice-btn" onclick="history.back()">취소</button>
                </div>
            </div>
        </form>
    </div>
</main>
</body>
</html>
