<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>공지사항 상세</title>
    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/notice/notice.css">
    <script>
        function del(notice_id) {
            if (!confirm("삭제하시겠습니까?")) {
                return;
            }

            location.href = "notice_delete.do?notice_id=" + notice_id;
        }
    </script>
</head>

<body>
<jsp:include page="/WEB-INF/views/product/product_header.jsp" />

<main class="notice-page">
    <div class="notice-inner">
        <div class="notice-title-row">
            <div>
                <span class="notice-eyebrow">NOTICE DETAIL</span>
                <h2>공지사항 상세</h2>
                <p>공지 내용을 확인하고 필요한 경우 관리자만 수정할 수 있습니다.</p>
            </div>
        </div>

        <article class="notice-panel notice-detail-panel">
            <div class="notice-detail-head">
                <span class="notice-id">#${notice.notice_id}</span>
                <h3><c:out value="${notice.title}" /></h3>

                <div class="notice-meta">
                    <span>작성일 ${notice.created_at}</span>
                    <span>
                        수정일
                        <c:choose>
                            <c:when test="${empty notice.updated_at}">-</c:when>
                            <c:otherwise>${notice.updated_at}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <div class="notice-content"><c:out value="${notice.content}" /></div>

            <div class="notice-actions">
                <a class="notice-btn" href="/notice_list.do">목록으로</a>
                <c:if test="${not empty sessionScope.user and sessionScope.user.role eq 'ADMIN'}">
                    <button type="button" class="notice-btn primary" onclick="location.href='notice_update_form.do?notice_id=${notice.notice_id}'">수정</button>
                    <button type="button" class="notice-btn dark" onclick="del('${notice.notice_id}')">삭제</button>
                </c:if>
            </div>
        </article>
    </div>
</main>
</body>
</html>
