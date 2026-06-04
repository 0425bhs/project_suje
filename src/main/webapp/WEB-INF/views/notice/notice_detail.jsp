<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>공지사항 상세</title>
    <link rel="stylesheet" href="/css/order-payment.css">
    <style>
        .community-page {
            min-height: calc(100vh - 153px);
        }

        .notice-detail-card {
            max-width: 960px;
            background: #fff;
            border: 1px solid #f0e5dc;
            padding: 34px;
        }

        .notice-detail-head {
            padding-bottom: 24px;
            border-bottom: 2px solid #2b2b2b;
        }

        .notice-detail-head > span {
            display: inline-flex;
            height: 28px;
            padding: 0 12px;
            margin-bottom: 14px;
            align-items: center;
            background: #fff0e7;
            color: #d85b35;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
        }

        .notice-detail-head h3 {
            margin: 0 0 14px;
            color: #2b2b2b;
            font-size: 28px;
            font-weight: 900;
            line-height: 1.4;
        }

        .notice-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px 18px;
            color: #8a6b5a;
            font-size: 13px;
            font-weight: 800;
        }

        .notice-content {
            min-height: 280px;
            padding: 30px 0;
            color: #444;
            font-size: 15px;
            line-height: 1.85;
            white-space: pre-wrap;
            word-break: keep-all;
            border-bottom: 1px solid #f0e5dc;
        }

        .notice-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 24px;
        }

        @media (max-width: 640px) {
            .notice-detail-card {
                padding: 24px;
            }

            .notice-actions {
                flex-direction: column;
            }
        }
    </style>
    <script>
        function del(notice_id) {
            if (!confirm("삭제하시겠습니까?")) {
                return;
            }

            location.href = "notice_delete.do?notice_id=" + notice_id;
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
            <a href="/notice_list.do">고객센터</a>
            <a href="/order/my">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>NOTICE DETAIL</span>
                <h2>공지사항 상세</h2>
                <p>공지 내용을 확인하고 필요한 경우 수정할 수 있습니다.</p>
            </div>

            <a class="btn light" href="/notice_list.do">목록으로</a>
        </div>

        <article class="notice-detail-card">
            <div class="notice-detail-head">
                <span>#${notice.notice_id}</span>
                <h3>${notice.title}</h3>

                <div class="notice-meta">
                    <span>작성일 ${notice.created_at}</span>
                    <span>
                        수정일
                        <c:choose>
                            <c:when test="${empty notice.updated_at}">-</c:when>
                            <c:otherwise>${notice.updated_at}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <div class="notice-content">${notice.content}</div>

            <div class="notice-actions">
                <button type="button" class="btn primary" onclick="location.href='notice_update_form.do?notice_id=${notice.notice_id}'">수정</button>
                <button type="button" class="btn dark" onclick="del('${notice.notice_id}')">삭제</button>
                <button type="button" class="btn light" onclick="history.back()">이전 화면</button>
            </div>
        </article>
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
