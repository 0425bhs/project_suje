<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 회원 요약 카드 -->
<jsp:include page="/WEB-INF/views/myshop/common/myshop_user_card.jsp">
    <jsp:param name="label" value="MY QNA" />
    <jsp:param name="count" value="${totalCount}" />
</jsp:include>

<!-- 빠른 메뉴 -->
<jsp:include page="/WEB-INF/views/myshop/common/myshop_quick_card.jsp" />

<!-- 내 문의 -->
<section class="myshop-review-section myshop-qna-section">

    <div class="myshop-section-head">
        <div>
            <h2>내 문의</h2>
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
            <div class="myshop-order-list">
                <c:forEach var="qna" items="${list}">
                    <article class="myshop-order-card">

                        <div class="myshop-order-top">
                            <div>
                                <strong class="myshop-status-badge ${empty qna.answer ? 'PENDING' : 'DELIVERED'}">
                                    <c:choose>
                                        <c:when test="${empty qna.answer}">답변 대기</c:when>
                                        <c:otherwise>답변 완료</c:otherwise>
                                    </c:choose>
                                </strong>

                                <span>${qna.created_at}</span>
                            </div>

                            <a href="/qna_detail.do?qna_id=${qna.qna_id}">
                                문의상세 &gt;
                            </a>
                        </div>

                        <div class="myshop-order-body">
                            <div class="myshop-product-thumb">
                                <c:choose>
                                    <c:when test="${not empty qna.image_s}">
                                        <img src="${qna.image_s}" alt="${qna.product_name}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="/images/no_image.png" alt="이미지 없음">
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="myshop-product-info">
                                <a href="/qna_detail.do?qna_id=${qna.qna_id}">
                                    ${qna.title}
                                </a>

                                <p>${qna.product_name}</p>

                                <strong>
                                    <c:choose>
                                        <c:when test="${empty qna.answer}">
                                            아직 답변이 등록되지 않았습니다.
                                        </c:when>
                                        <c:otherwise>
                                            ${qna.answer}
                                        </c:otherwise>
                                    </c:choose>
                                </strong>
                            </div>

                            <div class="myshop-order-actions">
                                <a href="/qna_detail.do?qna_id=${qna.qna_id}">
                                    상세
                                </a>

                                <a href="/qna_update_form.do?qna_id=${qna.qna_id}">
                                    수정
                                </a>

                                <button type="button"
                                        onclick="if (confirm('삭제하시겠습니까?')) location.href='/qna_delete.do?qna_id=${qna.qna_id}';">
                                    삭제
                                </button>
                            </div>
                        </div>

                    </article>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</section>
