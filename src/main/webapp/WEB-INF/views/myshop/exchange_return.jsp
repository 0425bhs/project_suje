<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!-- 빠른 메뉴 -->
                <jsp:include page="/WEB-INF/views/myshop/common/myshop_quick_card.jsp" />

                <!-- 교환/환불내역 -->
                <section class="myshop-order-section">

                    <div class="myshop-section-head">
                        <div>
                            <h2>교환/환불내역</h2>
                            <p>신청한 교환/환불 건의 진행 상태를 확인할 수 있습니다.</p>
                        </div>

                    </div>

                    <c:choose>
                        <c:when test="${empty claimList}">
                            <div class="myshop-empty-order">
                                교환/환불 신청 내역이 없습니다.
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="myshop-order">

                                <c:forEach var="claim" items="${claimList}">

                                    <c:choose>
                                        <c:when test="${claim.status eq 'EXCHANGE_REQUEST'}">
                                            <c:set var="statusText" value="교환 접수" />
                                        </c:when>

                                        <c:when test="${claim.status eq 'EXCHANGE_DONE'}">
                                            <c:set var="statusText" value="교환 완료" />
                                        </c:when>

                                        <c:when test="${claim.status eq 'RETURN_REQUEST'}">
                                            <c:set var="statusText" value="환불 접수" />
                                        </c:when>

                                        <c:when test="${claim.status eq 'RETURN_DONE'}">
                                            <c:set var="statusText" value="환불 완료" />
                                        </c:when>

                                        <c:when test="${claim.status eq 'EXCHANGE_REJECTED'}">
                                            <c:set var="statusText" value="교환 반려" />
                                        </c:when>

                                        <c:when test="${claim.status eq 'RETURN_REJECTED'}">
                                            <c:set var="statusText" value="환불 반려" />
                                        </c:when>
                                        
                                        <c:otherwise>
                                            <c:set var="statusText" value="${claim.status}" />
                                        </c:otherwise>
                                    </c:choose>

                                    <article class="myshop-order-card">

                                        <div class="myshop-order-top">

                                            <div>
                                                <strong class="myshop-status-badge ${claim.status}">
                                                    ${statusText}
                                                </strong>
                                            </div>

                                        </div>

                                        <div class="myshop-order-body">

                                            <div class="myshop-product-thumb">
                                                <c:choose>
                                                    <c:when
                                                        test="${not empty claim.imageL and claim.imageL ne 'no_file'}">
                                                        <img src="/upload/${claim.imageL}" alt="${claim.productName}">
                                                    </c:when>

                                                    <c:otherwise>
                                                        <img src="/images/no_image.png" alt="이미지 없음">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- 기본으로는 접수일 / 상품명만 표시 -->
                                            <div class="myshop-product-info">

                                                <c:choose>
                                                    <c:when
                                                        test="${not empty claim.requested_at and fn:length(claim.requested_at) ge 16}">
                                                        <span class="myshop-order-date-text">
                                                            ${fn:substring(claim.requested_at, 0, 16)} 접수
                                                        </span>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <span class="myshop-order-date-text">
                                                            ${claim.requested_at} 접수
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>

                                                <strong class="myshop-product-name-text">
                                                    ${claim.productName}
                                                </strong>

                                            </div>

                                            <div class="myshop-order-actions">

                                                <c:if
                                                    test="${claim.status eq 'EXCHANGE_REQUEST' or claim.status eq 'RETURN_REQUEST'}">
                                                    <form action="/cancelClaim.do" method="post" class="inline-form">
                                                        <input type="hidden" name="claim_id" value="${claim.claim_id}">
                                                        <button type="submit"
                                                            onclick="return confirm('교환/환불 신청을 취소하시겠습니까?');">
                                                            신청취소
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <!-- 문의하기 버튼 -->
                                                <button type="button" class="myshop-order-action-btn qna"
                                                    onclick="location.href='/qna_form.do?product_id=${claim.product_id}'">
                                                    문의하기
                                                </button>

                                            </div>

                                        </div> <!-- myshop-order-body 닫는 태그 -->

                                        <!-- 펼쳐보기 토글 버튼 (order_list.css의 myshop-order-toggle 재사용) -->
                                        <button type="button" class="myshop-order-toggle"
                                            onclick="toggleClaimDetail(this)">
                                            <span class="toggle-text">자세히 보기</span>
                                            <span class="toggle-arrow"></span>
                                        </button>

                                        <!-- 자세히 보기 눌렀을 때만 펼쳐지는 상세 정보 패널 -->
                                        <div class="claim-detail-panel">
                                            <div class="claim-detail-row">
                                                <span>사유</span>
                                                <strong>
                                                    ${claim.reason}
                                                    <c:if test="${not empty claim.detail_reason}">
                                                        (${claim.detail_reason})
                                                    </c:if>
                                                </strong>
                                            </div>

                                            <c:if
                                                test="${claim.status eq 'EXCHANGE_REQUEST' or claim.status eq 'EXCHANGE_DONE'}">
                                                <div class="claim-detail-row">
                                                    <span>상품 금액</span>
                                                    <strong>
                                                        <fmt:formatNumber value="${claim.price * claim.quantity}"
                                                            pattern="#,###" />원
                                                    </strong>
                                                </div>
                                            </c:if>

                                            <c:if test="${claim.status eq 'RETURN_REQUEST'}">
                                                <div class="claim-detail-row">
                                                    <span>환불 예정 금액</span>
                                                    <strong>
                                                        <fmt:formatNumber value="${claim.price * claim.quantity}"
                                                            pattern="#,###" />원
                                                    </strong>
                                                </div>
                                            </c:if>

                                            <c:if test="${claim.status eq 'RETURN_DONE'}">
                                                <div class="claim-detail-row">
                                                    <span>환불 금액</span>
                                                    <strong>
                                                        <fmt:formatNumber value="${claim.price * claim.quantity}"
                                                            pattern="#,###" />원
                                                    </strong>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty claim.seller_answer}">
                                                <div class="claim-detail-row">
                                                    <span>판매자 답변</span>
                                                    <strong>${claim.seller_answer}</strong>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty claim.completed_at}">
                                                <div class="claim-detail-row">
                                                    <span>처리 완료</span>
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${fn:length(claim.completed_at) ge 16}">
                                                                ${fn:substring(claim.completed_at, 0, 16)}
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${claim.completed_at}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                </div>
                                            </c:if>
                                        </div>

                                    </article>

                                </c:forEach>

                            </div>
                        </c:otherwise>
                    </c:choose>

                </section>

                <script>
                    // 자세히 보기 토글 
                    function toggleClaimDetail(btn) {
                        var card = btn.closest('.myshop-order-card');
                        var panel = card.querySelector('.claim-detail-panel');
                        var text = btn.querySelector('.toggle-text');

                        panel.classList.toggle('open');
                        btn.classList.toggle('active');   // 화살표 회전 (order_list.css의 .active 스타일 재사용)
                        text.textContent = panel.classList.contains('open') ? '접기' : '자세히 보기';
                    }
                </script>
