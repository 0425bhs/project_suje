<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>문의 상세</title>
    <link rel="stylesheet" href="/css/order-payment.css">
    <style>
        .community-page {
            min-height: calc(100vh - 153px);
        }

        .detail-layout {
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

        .detail-head {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            align-items: flex-start;
            padding-bottom: 22px;
            border-bottom: 1px solid #f0e5dc;
        }

        .detail-head h3 {
            margin: 0 0 12px;
            color: #2b2b2b;
            font-size: 24px;
            font-weight: 900;
            line-height: 1.4;
        }

        .detail-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 8px 14px;
            color: #8a6b5a;
            font-size: 13px;
            font-weight: 800;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 82px;
            height: 30px;
            padding: 0 12px;
            background: #eef4ff;
            color: #2563eb;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .status-pill.empty {
            background: #fff0e7;
            color: #d85b35;
        }

        .detail-section {
            padding: 24px 0;
            border-bottom: 1px solid #f0e5dc;
        }

        .detail-section:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .detail-section h4 {
            margin: 0 0 12px;
            color: #4b3b32;
            font-size: 16px;
            font-weight: 900;
        }

        .detail-section p {
            margin: 0;
            color: #444;
            font-size: 15px;
            line-height: 1.8;
            white-space: pre-wrap;
            word-break: keep-all;
        }

        .product-summary img {
            width: 100%;
            aspect-ratio: 1 / 1;
            object-fit: cover;
            display: block;
            background: #f6f6f6;
            border: 1px solid #f0e5dc;
        }

        .product-summary strong {
            display: block;
            margin-top: 16px;
            color: #2b2b2b;
            font-size: 18px;
            font-weight: 900;
            line-height: 1.45;
        }

        .product-summary span {
            display: block;
            margin-top: 8px;
            color: #8a6b5a;
            font-size: 13px;
            font-weight: 800;
        }

        .side-actions {
            display: grid;
            gap: 10px;
            margin-top: 20px;
        }

        @media (max-width: 860px) {
            .detail-layout {
                grid-template-columns: 1fr;
            }

            .detail-head {
                flex-direction: column;
            }
        }
    </style>
    <script>
        function del(qna_id) {
            if (!confirm("삭제하시겠습니까?")) {
                return;
            }

            location.href = "qna_delete.do?qna_id=" + qna_id;
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
                <span>QNA DETAIL</span>
                <h2>문의 상세</h2>
                <p>작성한 문의 내용과 판매자 답변을 확인할 수 있습니다.</p>
            </div>

            <a class="btn light" href="/mypage/qna">목록으로</a>
        </div>

        <div class="detail-layout">
            <article class="community-card">
                <div class="detail-head">
                    <div>
                        <h3>${qna.title}</h3>
                        <div class="detail-meta">
                            <span>작성일 ${qna.created_at}</span>
                            <span>
                                답변일
                                <c:choose>
                                    <c:when test="${empty qna.answered_at}">-</c:when>
                                    <c:otherwise>${qna.answered_at}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty qna.answer}">
                            <span class="status-pill empty">답변 대기</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-pill">답변 완료</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <section class="detail-section">
                    <h4>문의 내용</h4>
                    <p>${qna.content}</p>
                </section>

                <section class="detail-section">
                    <h4>답변</h4>
                    <p>
                        <c:choose>
                            <c:when test="${empty qna.answer}">아직 답변이 등록되지 않았습니다.</c:when>
                            <c:otherwise>${qna.answer}</c:otherwise>
                        </c:choose>
                    </p>
                </section>
            </article>

            <aside class="community-card product-summary">
                <img src="${qna.image_l}" alt="${qna.product_name}">
                <strong>${qna.product_name}</strong>
                <span>문의 상품</span>

                <div class="side-actions">
                    <button type="button" class="btn primary full" onclick="location.href='qna_update_form.do?qna_id=${qna.qna_id}'">수정</button>
                    <button type="button" class="btn dark full" onclick="del('${qna.qna_id}')">삭제</button>
                    <button type="button" class="btn light full" onclick="history.back()">이전 화면</button>
                </div>
            </aside>
        </div>
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
