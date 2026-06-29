<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<section class="point-page">

    <div class="point-page-head">
        <div class="point-page-title">
            <h2>포인트 내역</h2>
            <p>적립, 사용, 복구된 포인트 내역을 확인할 수 있습니다.</p>
        </div>

        <div class="point-page-path">
            마이쇼핑 홈 &gt; 포인트 내역
        </div>
    </div>

    <section class="point-summary-card">
        <div class="point-summary-left">
            <div class="point-coin-icon">
                P
            </div>

            <div class="point-balance-text">
                <span>현재 보유 포인트</span>
                <strong>
                    <fmt:formatNumber value="${empty pointBalance ? 0 : pointBalance}" pattern="#,###"/> P
                </strong>
            </div>
        </div>

        <div class="point-guide-box">
            <div class="point-guide-row">
                <span class="point-guide-badge earn">P</span>
                <strong>적립</strong>
                <span>구매확정으로 적립된 포인트입니다.</span>
            </div>

            <div class="point-guide-row">
                <span class="point-guide-badge use">−</span>
                <strong>사용</strong>
                <span>주문 결제에 사용한 포인트입니다.</span>
            </div>

            <div class="point-guide-row">
                <span class="point-guide-badge refund">+</span>
                <strong>복구</strong>
                <span>결제취소로 복구된 포인트입니다.</span>
            </div>
        </div>
    </section>

    <c:choose>
        <c:when test="${empty pointHistoryList}">
            <div class="point-empty-box">
                포인트 내역이 없습니다.
            </div>
        </c:when>

        <c:otherwise>

            <div class="point-list-head">
                <span>구분</span>
                <span>내역</span>
                <span>포인트</span>
                <span>적립/사용일</span>
            </div>

            <div class="point-history-list">

                <c:forEach var="point" items="${pointHistoryList}">

                    <c:choose>
                        <c:when test="${point.type eq 'EARN'}">
                            <c:set var="pointClass" value="earn" />
                            <c:set var="pointIcon" value="+" />
                            <c:set var="pointTypeText" value="적립" />
                            <c:set var="pointTitle" value="구매확정 적립" />
                            <c:set var="pointDesc" value="상품 구매확정으로 포인트가 적립되었습니다." />
                            <c:set var="pointSign" value="+" />
                        </c:when>

                        <c:when test="${point.type eq 'USE'}">
                            <c:set var="pointClass" value="use" />
                            <c:set var="pointIcon" value="−" />
                            <c:set var="pointTypeText" value="사용" />
                            <c:set var="pointTitle" value="주문 결제 사용" />
                            <c:set var="pointDesc" value="주문 결제에 포인트를 사용했습니다." />
                            <c:set var="pointSign" value="-" />
                        </c:when>

                        <c:when test="${point.type eq 'REFUND'}">
                            <c:set var="pointClass" value="refund" />
                            <c:set var="pointIcon" value="+" />
                            <c:set var="pointTypeText" value="복구" />
                            <c:set var="pointTitle" value="결제취소 복구" />
                            <c:set var="pointDesc" value="결제취소로 사용 포인트가 복구되었습니다." />
                            <c:set var="pointSign" value="+" />
                        </c:when>

                        <c:otherwise>
                            <c:set var="pointClass" value="earn" />
                            <c:set var="pointIcon" value="P" />
                            <c:set var="pointTypeText" value="변동" />
                            <c:set var="pointTitle" value="포인트 변동" />
                            <c:set var="pointDesc" value="포인트 내역이 변경되었습니다." />
                            <c:set var="pointSign" value="+" />
                        </c:otherwise>
                    </c:choose>

                    <div class="point-history-row">

                        <div class="point-type-box">
                            <span class="point-type-icon ${pointClass}">
                                ${pointIcon}
                            </span>

                            <span class="point-type-text ${pointClass}">
                                ${pointTypeText}
                            </span>
                        </div>

                        <div class="point-history-info">
                            <strong>${pointTitle}</strong>
                            <p>${pointDesc}</p>
                        </div>

                        <div class="point-amount ${pointClass}">
                            ${pointSign}<fmt:formatNumber value="${point.point_amount}" pattern="#,###"/> P
                        </div>

                        <div class="point-date">
                            ${point.created_at}
                        </div>

                    </div>

                </c:forEach>

            </div>

        </c:otherwise>
    </c:choose>

</section>