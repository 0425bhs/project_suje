<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 빠른 메뉴 -->
<jsp:include page="/WEB-INF/views/myshop/common/myshop_quick_card.jsp" />

<c:set var="waitingCount" value="0" />
<c:set var="answeredCount" value="0" />

<c:forEach var="qna" items="${list}">
    <c:choose>
        <c:when test="${empty qna.answer}">
            <c:set var="waitingCount" value="${waitingCount + 1}" />
        </c:when>
        <c:otherwise>
            <c:set var="answeredCount" value="${answeredCount + 1}" />
        </c:otherwise>
    </c:choose>
</c:forEach>

<!-- 문의 상태 요약 -->
<section class="myshop-status-card myshop-status-card-compact">

    <button type="button"
            class="${empty status || status eq 'all' ? 'active' : ''}"
            onclick="location.href='/myshop/qnas'">
        <span>전체 문의</span>
        <strong>${empty totalCount ? 0 : totalCount}</strong>
    </button>

    <button type="button"
            class="${status eq 'wating' ? 'active' : ''}"
            onclick="location.href='/myshop/qnas?status=wating'">
        <span>답변 대기</span>
        <strong>${empty watingQnaCount ? 0 : watingQnaCount}</strong>
    </button>

    <button type="button"
            class="${status eq 'answered' ? 'active' : ''}"
            onclick="location.href='/myshop/qnas?status=answered'">
        <span>답변 완료</span>
        <strong>${empty answeredQnaCount ? 0 : answeredQnaCount}</strong>
    </button>

</section>

<!-- 내 문의 목록 -->
<section class="myshop-order-section myshop-qna-section">

    <div class="myshop-section-head">
        <div>
            <h2>내 문의 목록</h2>
            <p>상품 문의 내용과 답변 여부를 한눈에 확인할 수 있습니다.</p>
        </div>

        <a href="/product/main.do">상품 보러가기</a>
    </div>

    <c:choose>
        <c:when test="${empty list}">
            <div class="myshop-empty-order">
                아직 작성한 문의가 없습니다.
            </div>
        </c:when>

        <c:otherwise>
            <div class="myshop-qna-table">
                <div class="myshop-qna-table-head">
                    <span>상태</span>
                    <span>상품</span>
                    <span>문의 내용</span>
                    <span>작성일</span>
                    <span>관리</span>
                </div>

                <c:forEach var="qna" items="${list}">
                    <article class="myshop-qna-row">
                        <div class="myshop-qna-status-cell">
                            <strong class="myshop-status-badge ${empty qna.answer ? 'WATING' : 'DELIVERED'}">
                                <c:choose>
                                    <c:when test="${empty qna.answer}">답변 대기</c:when>
                                    <c:otherwise>답변 완료</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>

                        <a class="myshop-qna-product-cell"
                           href="/product_detail.do?product_id=${qna.product_id}">
                            <span class="myshop-qna-product-thumb">
                                <c:choose>
                                    <c:when test="${not empty qna.image_l}">
                                        <img src="/upload/${qna.image_l}" alt="${qna.product_name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/images/no_image.png" alt="이미지 없음">
                                    </c:otherwise>
                                </c:choose>
                            </span>
                            <strong>${qna.product_name}</strong>
                        </a>

                        <div class="myshop-qna-content-cell">
                            <a href="/qna_detail.do?qna_id=${qna.qna_id}">
                                ${qna.title}
                            </a>
                            <p>${qna.content}</p>

                            <c:if test="${not empty qna.answer}">
                                <div class="myshop-qna-answer">
                                    <span>최근 답변</span>
                                    <strong>${qna.answer}</strong>
                                </div>
                            </c:if>
                        </div>

                        <div class="myshop-qna-date-cell">
                            <span>${qna.created_at}</span>
                            <c:if test="${not empty qna.answered_at}">
                                <small>답변일 ${qna.answered_at}</small>
                            </c:if>
                        </div>

                        <div class="myshop-qna-actions">
                            <a href="/qna_detail.do?qna_id=${qna.qna_id}">
                                보기
                            </a>

                            <a href="/qna_update_form.do?qna_id=${qna.qna_id}">
                                수정
                            </a>

                            <form action="/qna_delete.do" method="post" style="display: contents;"
                                  onsubmit="return confirm('삭제하시겠습니까?');">
                                <input type="hidden" name="qna_id" value="${qna.qna_id}">
                                <button type="submit">삭제</button>
                            </form>
                        </div>

                    </article>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</section>
