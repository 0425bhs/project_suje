<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">

    <link rel="stylesheet" href="/css/seller/seller_form_common.css">
    <link rel="stylesheet" href="/css/seller/seller_product_list.css">
    <link rel="stylesheet" href="/css/seller/seller_qna.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <script src="/js/seller_qna.js" defer></script>
</head>

<body>
<div class="seller-board">

    <jsp:include page="seller_sidebar.jsp">
        <jsp:param name="activeMenu" value="qnaList" />
        <jsp:param name="sidebarTitle" value="상품 문의 답변 관리" />
    </jsp:include>

    <div class="seller-main">

        <div class="seller-main-header">
            <div>
                <span class="page-label">QNA MANAGEMENT</span>
                <h1>문의 관리</h1>
                <p>판매자 상품에 등록된 문의를 확인하고 답변을 관리할 수 있습니다.</p>
            </div>
        </div>

        <div class="qna-summary-box">

            <div class="qna-summary-item total">
                <div>
                    <strong>전체 문의</strong>
                    <span id="totalQnaCount">${fn:length(qnaList)}개</span>
                </div>
            </div>

            <div class="qna-summary-item waiting">
                <i class="bi bi-chat-square-text"></i>
                <div>
                    <strong>답변 대기</strong>
                    <span id="waitingQnaCount">0</span>
                </div>
            </div>

            <div class="qna-summary-item completed">
                <i class="bi bi-check-lg"></i>
                <div>
                    <strong>답변 완료</strong>
                    <span id="completedQnaCount">0</span>
                </div>
            </div>

            <div class="qna-filter-wrap">
                <label for="productFilter">상품 필터</label>

                <select id="productFilter" class="qna-filter-select">
                    <option value="all">전체 상품 문의</option>

                    <c:forEach var="product" items="${productList}">
                        <option value="${product.product_id}">
                            ${product.product_name}
                        </option>
                    </c:forEach>
                </select>
            </div>

        </div>

        <c:if test="${empty qnaList}">
            <div class="empty-qna-box">
                아직 등록된 문의가 없습니다.
            </div>
        </c:if>

        <c:if test="${not empty qnaList}">
            <div class="seller-qna-wrap">

                <div class="qna-tab-box">
                    <button type="button" class="qna-tab active" data-tab="all">
                        전체 문의
                    </button>

                    <button type="button" class="qna-tab" data-tab="waiting">
                        답변 대기 <span id="waitingTabCount">(0)</span>
                    </button>

                    <button type="button" class="qna-tab" data-tab="completed">
                        답변 완료 <span id="completedTabCount">(0)</span>
                    </button>
                </div>

                <div class="seller-qna-list">

                    <c:forEach var="qna" items="${qnaList}">

                        <div class="seller-qna-card" data-product-id="${qna.product_id}" data-answered="false">//false고치기

                            <div class="qna-card-top">

                                <div class="qna-user-area">

                                    <div class="qna-user-photo-box">
                                        <c:choose>
                                            <c:when test="${not empty qna.photo_name}">
                                                <c:choose>
                                                    <c:when test="${fn:startsWith(qna.photo_name, '/upload/')}">
                                                        <img src="${qna.photo_name}">
                                                    </c:when>

                                                    <c:otherwise>
                                                        <img src="/upload/${qna.photo_name}">
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>

                                            <c:otherwise>
                                                <img src="/images/no_profile.png">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="qna-user-info">

                                        <div class="qna-user-line">
                                            <span class="qna-user-name">
                                                <c:choose>
                                                    <c:when test="${not empty qna.nick_name}">
                                                        ${qna.nick_name}
                                                    </c:when>

                                                    <c:when test="${not empty qna.user_name and fn:length(qna.user_name) >= 2}">
                                                        ${fn:substring(qna.user_name, 0, 1)}*${fn:substring(qna.user_name, 2, fn:length(qna.user_name))}
                                                    </c:when>

                                                    <c:otherwise>
                                                        ${qna.user_name}
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>

                                            <span class="qna-write-date">
                                                ${qna.created_at_text}
                                            </span>
                                        </div>

                                        <div class="qna-product-line">
                                            <span class="qna-product-title">${qna.product_name}</span>

                                            <c:if test="${not empty qna.option_name}">
                                                <span class="qna-option-title">
                                                    옵션 : ${qna.option_name}
                                                </span>
                                            </c:if>
                                        </div>

                                    </div>
                                </div>

                                <div class="qna-status-area">
                                    <span class="answer-status waiting-status">
                                        <i class="bi bi-chat-square-text"></i>
                                        답변 대기
                                    </span>

                                    <span class="answer-status complete-status">
                                        <i class="bi bi-check-lg"></i>
                                        답변 완료
                                    </span>

                                    <button type="button" class="qna-more-btn">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </button>
                                </div>

                            </div>

                            <div class="qna-bottom-grid">

                                <div class="qna-content-box">
                                    <div class="qna-content-title">
                                        문의 내용
                                    </div>

                                    <div class="qna-content">
                                        ${qna.content}
                                    </div>
                                </div>

                                <div class="seller-answer-box">

                                    <div class="answer-waiting-box">
                                        <strong>고객 문의에 답변해보세요</strong>

                                        <p>
                                            문의 답변을 작성하면 고객이 상품 구매를 결정하는 데 도움이 됩니다.<br>
                                            정확하고 친절한 답변을 남겨주세요.
                                        </p>

                                        <button type="button" class="answer-write-btn" data-qna-id="${qna.qna_id}">
                                            답변 작성
                                        </button>
                                    </div>

                                    <div class="answer-complete-box">
                                        <div class="answer-complete-head">
                                            <strong>판매자 답변</strong>
                                            <span>답변 완료</span>
                                        </div>

                                        <div class="answer-complete-content">
                                            등록된 판매자 답변입니다.
                                        </div>

                                        <button type="button" class="answer-edit-btn" data-qna-id="${qna.qna_id}">
                                            답변 수정
                                        </button>
                                    </div>

                                </div>

                            </div>

                        </div>

                    </c:forEach>

                </div>

            </div>
        </c:if>

    </div>

</div>
</body>
</html>