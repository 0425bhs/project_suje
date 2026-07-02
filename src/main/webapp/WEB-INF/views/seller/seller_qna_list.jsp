<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>상품 문의 답변 관리</title>

    <link rel="stylesheet" href="/css/seller/seller_form_common.css">
    <link rel="stylesheet" href="/css/seller/seller_product_list.css">
    <link rel="stylesheet" href="/css/seller/seller_qna.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <script src="/js/seller_qna.js" defer></script>
</head>

    <body>
        <div class="seller-page">

            <jsp:include page="seller_sidebar.jsp">
                <jsp:param name="activeMenu" value="qnaList" />
                <jsp:param name="sidebarTitle" value="상품 문의 답변 관리" />
            </jsp:include>

            <div class="seller-content qna-content">

                <section class="qna-top-section">
                    <div class="qna-title-wrap">
                        <span class="page-label">QNA MANAGEMENT</span>
                        <h1>문의 관리</h1>
                        <p>고객이 남긴 상품 문의를 확인하고 빠르게 답변을 등록할 수 있습니다.</p>
                    </div>

                    <div class="qna-dashboard-grid">
                        <div class="qna-summary-card total">
                            <div class="qna-summary-icon">
                                <i class="bi bi-chat-dots"></i>
                            </div>
                            <div>
                                <strong>전체 문의</strong>
                                <span id="totalQnaCount">${fn:length(qnaList)}개</span>
                                <em>등록된 전체 문의</em>
                            </div>
                        </div>

                        <div class="qna-summary-card waiting">
                            <div class="qna-summary-icon">
                                <i class="bi bi-hourglass-split"></i>
                            </div>
                            <div>
                                <strong>답변 대기</strong>
                                <span id="waitingQnaCount">0개</span>
                                <em>답변이 필요한 문의</em>
                            </div>
                        </div>

                        <div class="qna-summary-card completed">
                            <div class="qna-summary-icon">
                                <i class="bi bi-check2-circle"></i>
                            </div>
                            <div>
                                <strong>답변 완료</strong>
                                <span id="completedQnaCount">0개</span>
                                <em>처리 완료된 문의</em>
                            </div>
                        </div>
                    </div>

                    <div class="qna-control-panel">
                        <div class="qna-filter-field">
                            <label for="productFilter">상품 필터</label>
                            <select id="productFilter" class="qna-filter-select">
                                <option value="all">전체 상품</option>

                                <c:forEach var="product" items="${productList}">
                                    <option value="${product.product_id}">
                                        <c:choose>
                                            <c:when test="${not empty product.product_name}">
                                                ${product.product_name}
                                            </c:when>
                                            <c:otherwise>
                                                ${product.name}
                                            </c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="qna-filter-field">
                            <label for="qnaTypeFilter">문의 유형</label>
                            <select id="qnaTypeFilter" class="qna-filter-select">
                                <option value="all">전체 유형</option>
                                <option value="PRODUCT">상품 문의</option>
                                <option value="DELIVERY">배송 문의</option>
                                <option value="ORDER">주문 문의</option>
                                <option value="CANCEL">취소/환불 문의</option>
                                <option value="ETC">기타 문의</option>
                            </select>
                        </div>

                        <div class="qna-search-field">
                            <label for="qnaSearchInput">검색</label>
                            <div class="qna-search-box">
                                <i class="bi bi-search"></i>
                                <input id="qnaSearchInput" type="text" placeholder="상품명, 작성자, 문의 내용 검색">
                            </div>
                        </div>

                        <button type="button" id="qnaResetBtn" class="qna-reset-btn">
                            <i class="bi bi-arrow-clockwise"></i>
                            초기화
                        </button>
                    </div>
                </section>

                <c:if test="${empty qnaList}">
                    <div class="empty-qna-box">
                        <i class="bi bi-chat-square-text"></i>
                        <strong>아직 등록된 문의가 없습니다.</strong>
                        <p>상품 문의가 등록되면 이곳에서 확인하고 답변할 수 있습니다.</p>
                    </div>
                </c:if>

                <c:if test="${not empty qnaList}">
                    <section class="qna-split-layout">

                        <div class="qna-list-panel">
                            <div class="qna-list-head">
                                <div class="qna-tab-box">
                                    <button type="button" class="qna-tab active" data-tab="all">
                                        전체 문의 <span id="allTabCount">(${fn:length(qnaList)})</span>
                                    </button>

                                    <button type="button" class="qna-tab" data-tab="waiting">
                                        답변 대기 <span id="waitingTabCount">(0)</span>
                                    </button>

                                    <button type="button" class="qna-tab" data-tab="completed">
                                        답변 완료 <span id="completedTabCount">(0)</span>
                                    </button>
                                </div>

                                <div class="qna-sort-tabs" id="qnaSortTabs">
                                    <button type="button" class="qna-sort-tab active" data-sort="latest">
                                        최신순
                                    </button>

                                    <span class="qna-sort-divider"></span>

                                    <button type="button" class="qna-sort-tab" data-sort="oldest">
                                        오래된순
                                    </button>
                                </div>
                            </div>

                            <div class="qna-list-scroll">

                                <c:forEach var="qna" items="${qnaList}" varStatus="status">

                                    <c:set var="answered" value="${not empty qna.answer}" />
                                    <c:set var="qnaType" value="${empty qna.qna_type ? 'PRODUCT' : qna.qna_type}" />

                                    <c:choose>
                                        <c:when test="${qnaType eq 'DELIVERY'}">
                                            <c:set var="typeText" value="배송 문의" />
                                            <c:set var="typeClass" value="delivery" />
                                        </c:when>
                                        <c:when test="${qnaType eq 'ORDER'}">
                                            <c:set var="typeText" value="주문 문의" />
                                            <c:set var="typeClass" value="order" />
                                        </c:when>
                                        <c:when test="${qnaType eq 'CANCEL'}">
                                            <c:set var="typeText" value="취소/환불 문의" />
                                            <c:set var="typeClass" value="cancel" />
                                        </c:when>
                                        <c:when test="${qnaType eq 'ETC'}">
                                            <c:set var="typeText" value="기타 문의" />
                                            <c:set var="typeClass" value="etc" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="typeText" value="상품 문의" />
                                            <c:set var="typeClass" value="product" />
                                        </c:otherwise>
                                    </c:choose>

                                    <c:choose>
                                        <c:when test="${empty qna.image_l}">
                                            <c:set var="qnaImagePath" value="/images/no_image.png" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="qnaImagePath" value="/upload/${qna.image_l}" />
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="qna-list-item ${status.first ? 'active' : ''}"
                                        data-product-id="${qna.product_id}"
                                        data-answered="${answered}"
                                        data-qna-type="${qnaType}"
                                        data-search-text="${fn:escapeXml(qna.product_name)} ${fn:escapeXml(qna.title)} ${fn:escapeXml(qna.content)} ${fn:escapeXml(qna.user_name)} ${fn:escapeXml(qna.nick_name)}"
                                        data-qna-id="${qna.qna_id}"
                                        data-title="${fn:escapeXml(empty qna.title ? '문의 내용' : qna.title)}"
                                        data-product-name="${fn:escapeXml(qna.product_name)}"
                                        data-option-name="${fn:escapeXml(qna.option_name)}"
                                        data-writer-name="${fn:escapeXml(empty qna.nick_name ? qna.user_name : qna.nick_name)}"
                                        data-created-at="${fn:escapeXml(qna.created_at_text)}"
                                        data-created-raw="${fn:escapeXml(qna.created_at)}"
                                        data-question="${fn:escapeXml(qna.content)}"
                                        data-answer="${fn:escapeXml(qna.answer)}"
                                        data-type-text="${typeText}"
                                        data-type-class="${typeClass}"
                                        data-image="${qnaImagePath}">

                                        <div class="qna-list-thumb">
                                            <c:choose>
                                                <c:when test="${empty qna.image_l}">
                                                    <img src="/images/no_image.png" alt="${qna.product_name}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="/upload/${qna.image_l}" alt="${qna.product_name}">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="qna-list-info">
                                            <div class="qna-list-meta">
                                                <span class="qna-type-badge ${typeClass}">${typeText}</span>

                                                <c:choose>
                                                    <c:when test="${answered}">
                                                        <span class="qna-mini-status completed">답변 완료</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="qna-mini-status waiting">답변 대기</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <h3>
                                                <c:choose>
                                                    <c:when test="${not empty qna.title}">
                                                        ${qna.title}
                                                    </c:when>
                                                    <c:otherwise>
                                                        문의 내용
                                                    </c:otherwise>
                                                </c:choose>
                                            </h3>

                                            <p>${qna.product_name}</p>

                                            <div class="qna-list-sub">
                                                <span>
                                                    <i class="bi bi-person-circle"></i>
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
                                                <span>${qna.created_at_text}</span>
                                            </div>
                                        </div>
                                    </div>

                                </c:forEach>

                            </div>

                            <div class="qna-no-result" id="qnaNoResult">
                                조건에 맞는 문의가 없습니다.
                            </div>
                        </div>

                        <div class="qna-detail-panel">
                            <div class="qna-detail-top">
                                <div class="qna-detail-product">
                                    <div class="qna-detail-thumb">
                                        <img id="detailImage" src="/images/no_image.png" alt="상품 이미지">
                                    </div>

                                    <div class="qna-detail-info">
                                        <div class="qna-detail-badges">
                                            <span id="detailTypeBadge" class="qna-type-badge product">상품 문의</span>
                                            <span id="detailStatusBadge" class="detail-status waiting">
                                                <i class="bi bi-hourglass-split"></i>
                                                답변 대기
                                            </span>
                                        </div>

                                        <h2 id="detailTitle">문의를 선택해주세요.</h2>

                                        <div class="qna-detail-meta">
                                            <span id="detailProductName">상품명</span>
                                            <span id="detailOptionName"></span>
                                            <span id="detailWriterName">작성자</span>
                                            <span id="detailCreatedAt">작성일</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="qna-detail-top-actions">
                                    <a href="#" id="detailProductLink" class="detail-product-link">
                                        상품 상세 보기
                                        <i class="bi bi-chevron-right"></i>
                                    </a>

                                    <button type="button" class="qna-report-btn detail-report-btn" id="detailReportBtn">
                                        <i class="bi bi-flag"></i>
                                        신고
                                    </button>
                                </div>
                            </div>

                            <div class="qna-detail-box customer">
                                <div class="qna-detail-box-head">
                                    <strong>
                                        <i class="bi bi-chat-left-text"></i>
                                        고객 문의
                                    </strong>
                                    <span id="detailQuestionDate"></span>
                                </div>

                                <div class="qna-detail-question" id="detailQuestion">
                                    문의 내용을 선택해주세요.
                                </div>
                            </div>

                            <div class="qna-detail-box answer">
                                <div class="qna-detail-box-head">
                                    <strong>
                                        <i class="bi bi-shop"></i>
                                        판매자 답변
                                    </strong>

                                    <span id="answerModeText">답변 대기</span>
                                </div>

                                <!-- 답변이 없을 때 보이는 영역 -->
                                <div class="answer-waiting-view" id="answerWaitingView">
                                    <p>
                                        아직 등록된 답변이 없습니다.<br>
                                        고객 문의에 답변을 작성해 주세요.
                                    </p>

                                    <button type="button" class="answer-write-btn" id="detailAnswerWriteBtn">
                                        답변 작성
                                    </button>
                                </div>

                                <div class="answer-complete-view" id="answerCompleteView">
                                    <div class="answer-complete-content" id="detailAnswerText"></div>

                                    <button type="button" class="answer-edit-btn" id="detailAnswerEditBtn">
                                        답변 수정
                                    </button>
                                </div>

                                <form action="/seller_qna_answer.do" method="post" id="answerForm" class="qna-answer-form-area">
                                    <input type="hidden" name="qna_id" id="answerQnaId">

                                    <textarea name="answer"
                                            id="answerTextarea"
                                            maxlength="1000"
                                            placeholder="고객 문의에 대한 답변을 입력하세요."></textarea>

                                    <div class="answer-bottom-row">
                                        <div class="answer-guide">
                                            <p>· 고객에게 친절하고 정확한 정보를 제공해 주세요.</p>
                                            <p>· 연락처, 주소 등 개인정보는 답변에 포함하지 마세요.</p>
                                        </div>

                                        <div class="answer-count">
                                            <span id="answerCount">0</span> / 1000
                                        </div>
                                    </div>

                                    <div class="qna-detail-actions">
                                        <button type="button" class="answer-cancel-btn" id="answerClearBtn">
                                            취소
                                        </button>

                                        <button type="submit" class="answer-submit-btn" id="answerSubmitBtn">
                                            답변 등록
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                    </section>
                </c:if>

            </div>
        </div>

        <div id="qnaReportModal" class="qna-report-modal-bg">
            <div class="qna-report-modal">
                <input type="hidden" id="reportQnaId">

                <div class="qna-report-modal-head">
                    <div>
                        <strong>문의 신고</strong>
                        <p>부적절한 문의라고 판단되는 경우 신고할 수 있습니다.</p>
                    </div>

                    <button type="button" class="qna-report-close-btn">
                        <i class="bi bi-x-lg"></i>
                    </button>
                </div>

                <div class="qna-report-field">
                    <label for="reportType">신고 사유</label>
                    <select id="reportType">
                        <option value="">신고 사유를 선택해주세요.</option>
                        <option value="ABUSE">욕설/비방</option>
                        <option value="SPAM">도배/스팸</option>
                        <option value="AD">광고/홍보성 내용</option>
                        <option value="PERSONAL_INFO">개인정보 노출</option>
                        <option value="IRRELEVANT">상품과 관련 없는 내용</option>
                        <option value="ETC">기타</option>
                    </select>
                </div>

                <div class="qna-report-field">
                    <label for="reportReason">신고 내용</label>
                    <textarea id="reportReason" placeholder="문의 신고 내용을 입력해주세요."></textarea>
                </div>

                <div class="qna-report-modal-actions">
                    <button type="button" class="qna-report-cancel-btn">취소</button>
                    <button type="button" class="qna-report-submit-btn">신고하기</button>
                </div>
            </div>
        </div>

    </body>
</html>