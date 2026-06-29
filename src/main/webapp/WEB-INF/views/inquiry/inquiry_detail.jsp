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
            grid-template-columns: minmax(0, 1fr);
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

        .side-actions {
            display: grid;
            gap: 10px;
            grid-template-columns: repeat(3, max-content);
            justify-content: flex-end;
            margin-top: 24px;
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
        function del(inquiry_id) {
            if (!confirm("삭제하시겠습니까?")) {
                return;
            }

            location.href = "/inquiry_delete.do?inquiry_id=" + inquiry_id;
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
                <h2>고객센터 문의 상세</h2>
                <p>작성한 문의 내용과 관리자 답변을 확인할 수 있습니다.</p>
            </div>

            <a class="btn light" href="/myshop/inquiries">목록으로</a>
        </div>

        <div class="detail-layout">
            <article class="community-card">
                <div class="detail-head">
                    <div>
                        <h3>${inquiry.title}</h3>
                        <div class="detail-meta">
                            <span>
                                문의 유형
                                <c:choose>
                                    <c:when test="${inquiry.inquiry_type eq 'SERVICE'}">서비스 이용</c:when>
                                    <c:when test="${inquiry.inquiry_type eq 'ACCOUNT'}">회원/계정</c:when>
                                    <c:when test="${inquiry.inquiry_type eq 'PAYMENT'}">결제 오류</c:when>
                                    <c:when test="${inquiry.inquiry_type eq 'SELLER'}">판매자센터</c:when>
                                    <c:when test="${inquiry.inquiry_type eq 'POLICY'}">운영 정책</c:when>
                                    <c:otherwise>기타</c:otherwise>
                                </c:choose>
                            </span>
                            <span>작성일 ${inquiry.created_at}</span>
                            <span>
                                답변일
                                <c:choose>
                                    <c:when test="${empty inquiry.answered_at}">-</c:when>
                                    <c:otherwise>${inquiry.answered_at}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${inquiry.status eq 'WAITING'}">
                            <span class="status-pill empty">답변 대기</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-pill">답변 완료</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <section class="detail-section">
                    <h4>문의 내용</h4>
                    <p>${inquiry.content}</p>
                </section>

                <section class="detail-section">
                    <h4>답변</h4>
                    <p>
                        <c:choose>
                            <c:when test="${empty inquiry.answer}">아직 답변이 등록되지 않았습니다.</c:when>
                            <c:otherwise>${inquiry.answer}</c:otherwise>
                        </c:choose>
                    </p>
                </section>
            </article>

        </div>

        <div class="side-actions">
            <button type="button" class="btn primary" onclick="location.href='/inquiry_update_form.do?inquiry_id=${inquiry.inquiry_id}'">수정</button>
            <button type="button" class="btn dark" onclick="del('${inquiry.inquiry_id}')">삭제</button>
            <button type="button" class="btn light" onclick="history.back()">이전 화면</button>
        </div>
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
