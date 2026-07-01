<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<section class="coupon-page">

    <div class="coupon-page-head">
        <div>
            <h2>쿠폰함</h2>
            <p>보유 중인 작가샵 쿠폰과 사용 내역을 확인할 수 있습니다.</p>
        </div>

        <div class="coupon-page-path">
            마이쇼핑 홈 &gt; 쿠폰함
        </div>
    </div>

    <c:choose>
        <c:when test="${empty couponList}">
            <div class="coupon-empty-box">
                보유한 쿠폰이 없습니다.
            </div>
        </c:when>

        <c:otherwise>
            <div class="coupon-list">

                <c:forEach var="coupon" items="${couponList}">

                    <article class="coupon-card ${coupon.used_yn eq 'Y' ? 'used' : ''}">

                        <div class="coupon-left">
                            <span class="coupon-badge">
                                COUPON
                            </span>

                            <h3>${coupon.coupon_name}</h3>

                            <p>
                                <c:choose>
                                    <c:when test="${not empty coupon.company_name}">
                                        ${coupon.company_name} 작가샵 전용 쿠폰
                                    </c:when>

                                    <c:otherwise>
                                        작가샵 전용 쿠폰
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <div class="coupon-date">
                                발급일 : ${coupon.issued_at}
                            </div>
                        </div>

                        <div class="coupon-right">
                            <strong>
                                <fmt:formatNumber value="${coupon.discount_amount}" pattern="#,###"/>원
                            </strong>

                            <span>
                                할인
                            </span>

                            <c:choose>
                                <c:when test="${coupon.used_yn eq 'Y'}">
                                    <em class="coupon-status used">사용완료</em>
                                </c:when>

                                <c:otherwise>
                                    <em class="coupon-status available">사용가능</em>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </article>

                </c:forEach>

            </div>
        </c:otherwise>
    </c:choose>

</section>