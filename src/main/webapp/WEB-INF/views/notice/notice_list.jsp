<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>공지사항</title>
    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/notice/notice.css">
</head>

<body>
<jsp:include page="/WEB-INF/views/product/product_header.jsp" />

<main class="notice-page">
    <div class="notice-inner">
        <div class="notice-title-row">
            <div>
                <span class="notice-eyebrow">NOTICE</span>
                <h2>공지사항</h2>
                <p>서비스 운영 안내와 주요 소식을 확인할 수 있습니다.</p>
            </div>

            <c:if test="${not empty sessionScope.user and sessionScope.user.role eq 'ADMIN'}">
                <a class="notice-btn primary" href="/notice_form.do">공지사항 작성</a>
            </c:if>
        </div>

        <section class="notice-panel">
            <c:choose>
                <c:when test="${empty list}">
                    <div class="notice-empty">등록된 공지사항이 없습니다.</div>
                </c:when>

                <c:otherwise>
                    <div class="notice-list">
                        <c:forEach var="notice" items="${list}">
                            <article class="notice-item">
                                <span class="notice-id">#${notice.notice_id}</span>
                                <a class="notice-link" href="/notice_detail.do?notice_id=${notice.notice_id}">
                                    <c:out value="${notice.title}" />
                                </a>
                                <span class="notice-date">작성일 ${notice.created_at}</span>
                                <span class="notice-date">
                                    수정일
                                    <c:choose>
                                        <c:when test="${empty notice.updated_at}">-</c:when>
                                        <c:otherwise>${notice.updated_at}</c:otherwise>
                                    </c:choose>
                                </span>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </div>
</main>
</body>
</html>
