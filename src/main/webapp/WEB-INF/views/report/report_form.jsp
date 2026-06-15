<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>신고 작성</title>
    <link rel="stylesheet" href="/css/order-payment.css">
    <style>
        .community-page {
            min-height: calc(100vh - 153px);
        }

        .report-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 320px;
            gap: 28px;
            align-items: start;
        }

        .community-card {
            background: #fff;
            border: 1px solid #f0e5dc;
            padding: 28px;
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

        .form-field textarea {
            width: 100%;
            min-height: 220px;
            padding: 16px;
            border: 1px solid #ead8cc;
            background: #fff;
            color: #2b2b2b;
            font-size: 15px;
            line-height: 1.7;
            resize: vertical;
            outline: none;
        }

        .form-field textarea:focus {
            border-color: #ff6f4f;
            box-shadow: 0 0 0 3px rgba(255, 111, 79, 0.12);
        }

        .report-summary {
            display: grid;
            gap: 14px;
        }

        .report-summary div {
            padding: 18px;
            background: #fffaf7;
            border: 1px solid #f0e5dc;
        }

        .report-summary span {
            display: block;
            margin-bottom: 8px;
            color: #8a6b5a;
            font-size: 13px;
            font-weight: 900;
        }

        .report-summary strong {
            color: #2b2b2b;
            font-size: 18px;
            font-weight: 900;
        }

        .guide-box {
            margin-top: 18px;
            padding: 18px;
            background: #eef4ff;
            border: 1px solid #d8e4ff;
            color: #31548f;
            font-size: 14px;
            line-height: 1.7;
            font-weight: 700;
        }

        @media (max-width: 820px) {
            .report-layout {
                grid-template-columns: 1fr;
            }

            .btn-row {
                flex-direction: column;
            }
        }
    </style>
    <script>
        function send(f) {
            const reason = f.reason.value.trim();

            if (reason === "") {
                alert("신고 이유를 입력해주세요.");
                f.reason.focus();
                return;
            }

            alert("신고 등록 기능은 아직 서버에 연결되어 있지 않습니다.");
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
            <a href="/mypage/review">내 후기</a>
            <a href="/myshop/orders">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>REPORT</span>
                <h2>신고 작성</h2>
                <p>검토가 필요한 리뷰나 문의에 대한 신고 사유를 남길 수 있습니다.</p>
            </div>
        </div>

        <div class="report-layout">
            <form class="community-card">
                <input type="hidden" name="target_type" value="${report.target_type}">
                <input type="hidden" name="target_id" value="${report.target_id}">

                <div class="form-stack">
                    <div class="form-field">
                        <label for="reason">신고 이유</label>
                        <textarea id="reason" name="reason" placeholder="신고 이유를 구체적으로 입력해주세요.">${report.reason}</textarea>
                    </div>

                    <div class="btn-row">
                        <button type="button" class="btn primary" onclick="send(this.form)">등록</button>
                        <button type="button" class="btn light" onclick="history.back()">취소</button>
                    </div>
                </div>
            </form>

            <aside class="community-card">
                <div class="report-summary">
                    <div>
                        <span>대상 유형</span>
                        <strong>${report.target_type}</strong>
                    </div>

                    <div>
                        <span>대상 번호</span>
                        <strong>#${report.target_id}</strong>
                    </div>
                </div>

                <div class="guide-box">
                    허위 신고를 줄이기 위해 신고 사유는 검토 가능한 내용으로 작성해주세요.
                </div>
            </aside>
        </div>
    </div>
</main>

<footer class="site-footer">
    <div class="footer-inner">
        <strong>HANDMADE</strong>
        <p>건전한 커뮤니티 운영을 위해 신고 내용을 확인합니다.</p>
    </div>
</footer>
</body>
</html>
