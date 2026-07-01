<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            align-items: center;
            color: #8a6b5a;
            font-size: 13px;
            font-weight: 800;
        }

        .qna-type-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 76px;
            height: 28px;
            padding: 0 11px;
            background: #fff6ef;
            color: #d85b35;
            border: 1px solid #ffd8c6;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
            white-space: nowrap;
        }

        .qna-type-pill.delivery {
            background: #eef4ff;
            color: #2563eb;
            border-color: #cfe0ff;
        }

        .qna-type-pill.order {
            background: #f1f8ee;
            color: #3f8f46;
            border-color: #d5ebcf;
        }

        .qna-type-pill.cancel {
            background: #fff0f0;
            color: #d14343;
            border-color: #ffd0d0;
        }

        .qna-type-pill.etc {
            background: #f5f5f5;
            color: #666;
            border-color: #e1e1e1;
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

        .answer-empty {
            color: #9b7b68 !important;
            font-weight: 800;
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

        .btn.report {
            background: #fff5f3;
            color: #d14343;
            border: 1px solid #ffd4cc;
        }

        .btn.report:hover {
            background: #ffeae6;
        }

        .report-modal-bg {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 1000;
            background: rgba(0, 0, 0, 0.42);
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .report-modal-bg.active {
            display: flex;
        }

        .report-modal {
            width: min(520px, 100%);
            background: #fff;
            border-radius: 18px;
            border: 1px solid #f0e5dc;
            box-shadow: 0 18px 55px rgba(0, 0, 0, 0.18);
            overflow: hidden;
        }

        .report-modal-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 20px 22px;
            border-bottom: 1px solid #f0e5dc;
            background: #fffaf7;
        }

        .report-modal-head strong {
            color: #2b2b2b;
            font-size: 18px;
            font-weight: 900;
        }

        .report-close {
            border: none;
            background: transparent;
            color: #8a6b5a;
            font-size: 24px;
            font-weight: 900;
            cursor: pointer;
        }

        .report-modal-body {
            padding: 22px;
        }

        .report-field {
            margin-bottom: 16px;
        }

        .report-field label {
            display: block;
            margin-bottom: 8px;
            color: #4b3b32;
            font-size: 14px;
            font-weight: 900;
        }

        .report-field select,
        .report-field textarea {
            width: 100%;
            border: 1px solid #ead8cc;
            background: #fff;
            color: #2b2b2b;
            font-size: 15px;
            outline: none;
        }

        .report-field select {
            height: 46px;
            padding: 0 14px;
        }

        .report-field textarea {
            min-height: 120px;
            padding: 14px;
            resize: vertical;
            line-height: 1.6;
        }

        .report-field select:focus,
        .report-field textarea:focus {
            border-color: #ff6f4f;
            box-shadow: 0 0 0 3px rgba(255, 111, 79, 0.12);
        }

        .report-guide {
            margin: 0 0 18px;
            color: #8a6b5a;
            font-size: 13px;
            font-weight: 700;
            line-height: 1.6;
        }

        .report-modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding: 18px 22px;
            border-top: 1px solid #f0e5dc;
            background: #fff;
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

        function openReportModal() {
            const modal = document.getElementById("reportModal");
            if (modal == null) {
                return;
            }

            modal.classList.add("active");
        }

        function closeReportModal() {
            const modal = document.getElementById("reportModal");
            if (modal == null) {
                return;
            }

            modal.classList.remove("active");
        }

        function sendReport(f) {
            const reportType = f.report_type.value.trim();
            const reportReason = f.report_reason.value.trim();

            if (reportType === "") {
                alert("신고 사유를 선택해주세요.");
                f.report_type.focus();
                return;
            }

            if (reportReason === "") {
                alert("신고 내용을 입력해주세요.");
                f.report_reason.focus();
                return;
            }

            if (!confirm("해당 문의를 신고하시겠습니까?")) {
                return;
            }

            f.action = "qna_report.do";
            f.method = "post";
            f.submit();
        }

        window.addEventListener("keydown", function(event) {
            if (event.key === "Escape") {
                closeReportModal();
            }
        });
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

            <a class="btn light" href="/myshop/qnas">목록으로</a>
        </div>

        <div class="detail-layout">
            <article class="community-card">
                <div class="detail-head">
                    <div>
                        <h3>${qna.title}</h3>

                        <div class="detail-meta">
                            <c:choose>
                                <c:when test="${qna.qna_type eq 'DELIVERY'}">
                                    <span class="qna-type-pill delivery">배송 문의</span>
                                </c:when>

                                <c:when test="${qna.qna_type eq 'ORDER'}">
                                    <span class="qna-type-pill order">주문 문의</span>
                                </c:when>

                                <c:when test="${qna.qna_type eq 'CANCEL'}">
                                    <span class="qna-type-pill cancel">취소/환불 문의</span>
                                </c:when>

                                <c:when test="${qna.qna_type eq 'ETC'}">
                                    <span class="qna-type-pill etc">기타 문의</span>
                                </c:when>

                                <c:otherwise>
                                    <span class="qna-type-pill">상품 문의</span>
                                </c:otherwise>
                            </c:choose>

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

                    <c:choose>
                        <c:when test="${empty qna.answer}">
                            <p class="answer-empty">아직 답변이 등록되지 않았습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <p>${qna.answer}</p>
                        </c:otherwise>
                    </c:choose>
                </section>
            </article>

            <aside class="community-card product-summary">
                <c:choose>
                    <c:when test="${empty qna.image_l}">
                        <img src="/images/no_image.png" alt="${qna.product_name}">
                    </c:when>
                    <c:otherwise>
                        <img src="/upload/${qna.image_l}" alt="${qna.product_name}">
                    </c:otherwise>
                </c:choose>

                <strong>${qna.product_name}</strong>
                <span>문의 상품</span>

                <div class="side-actions">
                    <button type="button" class="btn primary full" onclick="location.href='qna_update_form.do?qna_id=${qna.qna_id}'">수정</button>
                    <button type="button" class="btn dark full" onclick="del('${qna.qna_id}')">삭제</button>
                    <button type="button" class="btn report full" onclick="openReportModal()">문의 신고</button>
                    <button type="button" class="btn light full" onclick="history.back()">이전 화면</button>
                </div>
            </aside>
        </div>
    </div>
</main>

<div id="reportModal" class="report-modal-bg" onclick="closeReportModal()">
    <form class="report-modal" onclick="event.stopPropagation()">
        <input type="hidden" name="qna_id" value="${qna.qna_id}">

        <div class="report-modal-head">
            <strong>문의 신고</strong>
            <button type="button" class="report-close" onclick="closeReportModal()">×</button>
        </div>

        <div class="report-modal-body">
            <p class="report-guide">
                부적절한 문의라고 판단되는 경우 신고할 수 있습니다.
                허위 신고 또는 반복 신고는 제한될 수 있습니다.
            </p>

            <div class="report-field">
                <label for="report_type">신고 사유</label>
                <select id="report_type" name="report_type">
                    <option value="">신고 사유를 선택해주세요.</option>
                    <option value="ABUSE">욕설/비방</option>
                    <option value="SPAM">도배/스팸</option>
                    <option value="AD">광고/홍보성 내용</option>
                    <option value="PERSONAL_INFO">개인정보 노출</option>
                    <option value="IRRELEVANT">상품과 관련 없는 문의</option>
                    <option value="ETC">기타</option>
                </select>
            </div>

            <div class="report-field">
                <label for="report_reason">신고 내용</label>
                <textarea id="report_reason" name="report_reason" placeholder="신고 내용을 입력해주세요."></textarea>
            </div>
        </div>

        <div class="report-modal-actions">
            <button type="button" class="btn light" onclick="closeReportModal()">취소</button>
            <button type="button" class="btn report" onclick="sendReport(this.form)">신고하기</button>
        </div>
    </form>
</div>

<footer class="site-footer">
    <div class="footer-inner">
        <strong>HANDMADE</strong>
        <p>상품 문의와 답변을 통해 구매 전 궁금한 내용을 확인할 수 있습니다.</p>
    </div>
</footer>
</body>
</html>