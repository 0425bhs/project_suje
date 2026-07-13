<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>신고 작성</title>
    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/order-payment.css">
    <script src="/js/product_main.js" defer></script>
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

        .report-target {
            padding: 18px;
            background: #fffaf7;
            border: 1px solid #f0e5dc;
        }

        .report-target-label {
            display: block;
            margin-bottom: 8px;
            color: #8a6b5a;
            font-size: 13px;
            font-weight: 900;
        }

        .report-target-body {
            display: flex;
            gap: 14px;
            align-items: flex-start;
        }

        .report-target-image,
        .report-target-placeholder {
            flex: 0 0 76px;
            width: 76px;
            height: 76px;
            border-radius: 8px;
            object-fit: cover;
        }

        .report-target-placeholder {
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f3ece7;
            color: #8a6b5a;
            font-size: 12px;
            font-weight: 900;
        }

        .report-target-content {
            min-width: 0;
        }

        .report-target-title {
            display: block;
            color: #2b2b2b;
            font-size: 16px;
            font-weight: 900;
            line-height: 1.45;
            word-break: break-all;
        }

        .report-target-meta,
        .report-target-preview {
            margin: 7px 0 0;
            color: #8a6b5a;
            font-size: 13px;
            line-height: 1.55;
            word-break: break-all;
        }

        .report-target-preview {
            color: #5f5149;
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

            f.action = "/report_form.do";
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
                <span>REPORT</span>
                <h2>신고 작성</h2>
                <p>검토가 필요한 상품, 리뷰, 문의에 대한 신고 사유를 남길 수 있습니다.</p>
            </div>
        </div>

        <div class="report-layout">
            <form class="community-card">
                <input type="hidden" name="target_type" value="${param.target_type}">
                <input type="hidden" name="target_id" value="${param.target_id}">

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
                    <div class="report-target">
                        <span class="report-target-label">
                            <c:choose>
                                <c:when test="${param.target_type eq 'PRODUCT'}">신고 대상 상품</c:when>
                                <c:when test="${param.target_type eq 'REVIEW'}">신고 대상 리뷰</c:when>
                                <c:when test="${param.target_type eq 'QNA'}">신고 대상 문의</c:when>
                                <c:otherwise>신고 대상</c:otherwise>
                            </c:choose>
                        </span>

                        <div class="report-target-body">
                            <c:choose>
                                <c:when test="${not empty reportTarget}">
                                    <c:choose>
                                        <c:when test="${not empty reportTarget.imageUrl}">
                                            <img class="report-target-image" src="${reportTarget.imageUrl}" alt="신고 대상 이미지">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="report-target-placeholder">NO IMAGE</div>
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="report-target-content">
                                        <strong class="report-target-title">${reportTarget.title}</strong>
                                        <p class="report-target-meta">${reportTarget.meta}</p>
                                        <p class="report-target-preview">${reportTarget.preview}</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="report-target-placeholder">TARGET</div>
                                    <div class="report-target-content">
                                        <strong class="report-target-title">대상 정보를 불러오는 중입니다.</strong>
                                        <p class="report-target-meta">대상 번호 #${param.target_id}</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
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
