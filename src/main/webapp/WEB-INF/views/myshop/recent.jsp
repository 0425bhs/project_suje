<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/WEB-INF/views/myshop/common/myshop_user_card.jsp">
    <jsp:param name="label" value="RECENT VIEW" />
    <jsp:param name="count" value="${fn:length(recentList)}" />
</jsp:include>

<jsp:include page="/WEB-INF/views/myshop/common/myshop_quick_card.jsp" />

<section class="myshop-recent-section">

    <div class="myshop-section-head">
        <div>
            <h2>최근 본 상품</h2>
            <p>최근에 확인한 상품을 최신순으로 모아볼 수 있습니다.</p>
        </div>

        <a href="/main.do">상품 둘러보기</a>
    </div>

    <c:choose>
        <c:when test="${empty recentList}">
            <div class="myshop-empty-order">
                최근 본 상품이 없습니다.
            </div>
        </c:when>

        <c:otherwise>
            <div class="myshop-recent-grid common-product-wrap">
                <c:forEach var="vo" items="${recentList}">
                    <c:set var="rawImageL" value="" />
                    <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</section>
