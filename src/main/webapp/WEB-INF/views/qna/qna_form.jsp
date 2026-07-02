<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의 작성</title>
    <link rel="stylesheet" href="/css/order-payment.css">

    <link rel="stylesheet" href="/css/qna/qna_form.css">

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const titleInput = document.getElementById("title");
            const contentInput = document.getElementById("content");
            const titleCount = document.getElementById("titleCount");
            const contentCount = document.getElementById("contentCount");

            bindLimit(titleInput, titleCount, 100);
            bindLimit(contentInput, contentCount, 2000);
        });

        function bindLimit(input, countBox, maxLength) {
            if (input == null || countBox == null) {
                return;
            }

            input.setAttribute("maxlength", maxLength);

            input.addEventListener("beforeinput", function (event) {
                const value = input.value;
                const start = input.selectionStart == null ? value.length : input.selectionStart;
                const end = input.selectionEnd == null ? value.length : input.selectionEnd;

                const selectedLength = end - start;
                const currentLength = value.length - selectedLength;

                const insertText = event.data == null ? "" : event.data;

                if (insertText !== "" && currentLength + insertText.length > maxLength) {
                    event.preventDefault();
                }
            });

            input.addEventListener("input", function () {
                if (input.value.length > maxLength) {
                    input.value = input.value.substring(0, maxLength);
                }

                countBox.textContent = input.value.length + " / " + maxLength;
            });
        }

        function send(f) {
            const checkedType = f.querySelector("input[name='qna_type']:checked");
            const title = f.title.value.trim();
            const content = f.content.value.trim();

            if (checkedType == null) {
                return;
            }

            if (title === "") {
                f.title.focus();
                return;
            }

            if (content === "") {
                f.content.focus();
                return;
            }

            f.action = "qna_form.do";
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
            <a href="/mypage/qna">내 문의</a>
            <a href="/myshop/orders">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="qna-hero">
            <div class="qna-breadcrumb">
                <a href="/product/main.do">홈</a>
                <span>›</span>
                <a href="/myshop/qnas">마이페이지</a>
                <span>›</span>
                <a href="/myshop/qnas">문의내역</a>
                <span>›</span>
                <strong>문의 작성</strong>
            </div>

            <div class="qna-hero-title">
                <span>QNA</span>
                <em></em>
                <h2>문의 작성</h2>
            </div>

            <p>해당 상품에 대한 문의를 남겨주시면 작가님이 답변드립니다.</p>
        </div>

        <form class="community-card">
            <input type="hidden" name="product_id" value="${product.product_id}">

            <div class="form-layout">

                <a class="product-panel" href="/product_detail.do?product_id=${product.product_id}">
                    <span class="product-panel-title">상품 정보</span>

                    <c:choose>
                        <c:when test="${empty product.image_l}">
                            <img src="/images/no_image.png" alt="${product.name}">
                        </c:when>
                        <c:otherwise>
                            <img src="/upload/${product.image_l}" alt="${product.name}">
                        </c:otherwise>
                    </c:choose>

                    <strong>${product.name}</strong>

                    <c:if test="${not empty product.price}">
                        <span class="product-price">
                            <fmt:formatNumber value="${product.price}" pattern="#,###"/>원
                        </span>
                    </c:if>

                    <div class="product-help-box">
                        <div class="product-help-title">문의 전 확인해주세요</div>
                        <ul>
                            <li>판매자가 확인 후 답변을 드립니다.</li>
                            <li>답변은 마이페이지 &gt; 문의 내역에서 확인하실 수 있습니다.</li>
                            <li>비공개 문의는 판매자와 작성자만 확인할 수 있습니다.</li>
                        </ul>
                    </div>

                    <div class="product-detail-link">
                        상품 상세 보기
                    </div>
                </a>

                <div class="form-stack">

                    <div class="form-section">
                        <div class="form-section-title">
                            문의 유형 <span class="required">*</span>
                        </div>

                        <div class="qna-type-chip-box">
                            <label class="qna-type-chip">
                                <input type="radio" name="qna_type" value="PRODUCT" checked>
                                <span>상품문의</span>
                            </label>

                            <label class="qna-type-chip">
                                <input type="radio" name="qna_type" value="DELIVERY">
                                <span>배송문의</span>
                            </label>

                            <label class="qna-type-chip">
                                <input type="radio" name="qna_type" value="ORDER">
                                <span>주문/결제문의</span>
                            </label>

                            <label class="qna-type-chip">
                                <input type="radio" name="qna_type" value="CANCEL">
                                <span>교환/반품문의</span>
                            </label>

                            <label class="qna-type-chip">
                                <input type="radio" name="qna_type" value="ETC">
                                <span>기타문의</span>
                            </label>
                        </div>

                        <div class="type-help">문의 유형을 선택하면 판매자가 더 빠르게 확인할 수 있습니다.</div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title">
                            공개 여부 <span class="required">*</span>
                        </div>

                        <div class="qna-open-radio-box">
                            <label class="qna-open-radio">
                                <input type="radio" name="is_private" value="0" checked>
                                <div class="qna-open-radio-card">
                                    <div class="qna-open-icon public-icon">
                                        <span></span>
                                    </div>
                                    <div class="qna-open-text">
                                        <strong>공개</strong>
                                        <em>다른 회원이 문의 내용과 답변을 볼 수 있습니다.</em>
                                    </div>
                                    <div class="qna-open-check"></div>
                                </div>
                            </label>

                            <label class="qna-open-radio">
                                <input type="radio" name="is_private" value="1">
                                <div class="qna-open-radio-card">
                                    <div class="qna-open-icon private-icon">
                                        <span></span>
                                    </div>
                                    <div class="qna-open-text">
                                        <strong>비공개</strong>
                                        <em>문의 내용과 답변이 나에게만 보입니다.</em>
                                    </div>
                                    <div class="qna-open-check"></div>
                                </div>
                            </label>
                        </div>

                        <div class="type-help">공개 문의는 다른 회원분들께도 도움이 될 수 있습니다.</div>
                    </div>

                    <div class="form-field">
                        <label for="title">제목 <span class="required">*</span></label>
                        <input id="title" name="title" maxlength="100" placeholder="제목을 입력해주세요.">
                        <span id="titleCount" class="text-count">0 / 100</span>
                    </div>

                    <div class="form-field">
                        <label for="content">내용 <span class="required">*</span></label>
                        <textarea id="content" name="content" maxlength="2000" placeholder="문의 내용을 상세히 입력해주시면 작가님께서 답변드리는데 많은 도움이 됩니다."></textarea>
                        <span id="contentCount" class="text-count textarea-count">0 / 2000</span>
                    </div>

                    <div class="qna-notice-box">
                        <strong>알려드려요</strong>
                        비공개 문의는 상품 상세 페이지에 노출되지 않으며, 작성자와 판매자만 확인할 수 있습니다.<br>
                        개인 정보(연락처, 주소 등)는 문의 내용에 남기지 말아주세요.
                    </div>

                    <div class="btn-row">
                        <button type="button" class="btn primary" onclick="send(this.form)">작성</button>
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