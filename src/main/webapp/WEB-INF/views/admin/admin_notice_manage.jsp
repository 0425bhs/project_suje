<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 공지사항 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
    <script src="/js/admin_detail_common.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const master = document.getElementById("adminMasterDetail");
            const rows = document.querySelectorAll(".admin-clickable-row");

            rows.forEach((row) => {
                row.addEventListener("click", () => {
                    if (!master.classList.contains("is-collapsed") && row.classList.contains("selected")) {
                        closeDetailPanel(master, row);
                        return;
                    }

                    openDetailPanel(master, rows, row);

                    const noticeId = row.dataset.noticeId;

                    fetch("/admin/notices/detail?notice_id=" + encodeURIComponent(noticeId))
                    .then(res => res.json())
                    .then(data => {
                        const notice = data.notice;

                        setText("noticeId", notice.notice_id);
                        setText("title", notice.title);
                        setText("content", notice.content);
                        setText("createdAt", notice.created_at);
                        setText("updatedAt", notice.updated_at);
                    });
                });
            });
        });
    </script>
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="notices" />
        <jsp:param name="sidebarTitle" value="공지사항 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">NOTICE MANAGEMENT</span>
                <h1>공지사항 관리</h1>
                <p>쇼핑몰 공지사항을 확인하고 관리합니다.</p>
            </div>
            <div class="admin-header-actions">
                <a href="/notice_form.do" class="admin-btn">공지 등록</a>
                <a href="/notice_list.do" class="admin-btn light">사용자 공지 보기</a>
            </div>
        </header>

        <section class="admin-master-detail is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-card-head">
                    <h3>공지사항 목록</h3>
                </div>
                <div class="admin-filter-box">
                    <form class="admin-filter-form" action="/admin/notices" method="get">
                        <div class="admin-filter-tabs">
                            <button type="button" class="active">전체</button>
                            <button type="button">공지</button>
                        </div>
                        <input type="hidden" name="size" value="${pagination.size}">
                        <input type="hidden" name="page" value="1">
                        <input type="text" class="admin-search" name="keyword" placeholder="제목 검색" value="${keyword}">
                    </form>
                </div>
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>유형</th>
                            <th>제목</th>
                            <th>상태</th>
                            <th>등록일</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="notice" items="${noticeList}">
                        <tr class="admin-clickable-row" data-notice-id="${notice.notice_id}">
                            <td>${notice.notice_id}</td>
                            <td>공지(미구현)</td>
                            <td class="left"><strong>${notice.title}</strong></td>
                            <td><span class="admin-status active">노출(미구현)</span></td>
                            <td>${notice.created_at}</td>
                            <td class="admin-table-actions">
                                <a href="/notice_update_form.do?notice_id=${notice.notice_id}" class="admin-btn light">수정</a>
                                <button type="button" class="admin-btn light">상세</button>
                            </td>
                        </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <aside class="admin-card admin-detail-panel" id="adminDetailPanel">
                <div class="admin-detail-panel-inner">
                    <div class="admin-detail-content">
                        <div class="admin-detail-head">
                            <div>
                                <span class="admin-page-label">NOTICE DETAIL</span>
                                <h2 id="noticeDetailTitle">공지사항 상세</h2>
                            </div>
                            <button type="button" class="admin-detail-close" aria-label="닫기">&times;</button>
                        </div>
                        <dl class="admin-detail-grid">
                            <div>
                                <dt>공지번호</dt>
                                <dd id="noticeId">-</dd>
                            </div>
                            <div>
                                <dt>제목</dt>
                                <dd id="title">-</dd>
                            </div>
                            <div>
                                <dt>내용</dt>
                                <dd id="content">-</dd>
                            </div>
                            <div>
                                <dt>등록일</dt>
                                <dd id="createdAt">-</dd>
                            </div>
                            <div>
                                <dt>수정일</dt>
                                <dd id="updatedAt">-</dd>
                            </div>
                        </dl>
                    </div>
                </div>
            </aside>
        </section>

        <div class="admin-pagination">
            <c:if test="${pagination.totalPage > 0}">
                <c:if test="${pagination.hasPrev}">
                    <a href="/admin/notices?keyword=${keyword}&size=${pagination.size}&page=${pagination.prevPage}">
                        이전
                    </a>
                </c:if>
                <c:if test="${!pagination.hasPrev}">
                    <span class="disabled">이전</span>
                </c:if>

                <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                    <a href="/admin/notices?keyword=${keyword}&size=${pagination.size}&page=${i}"
                        class="${pagination.page == i ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>

                <c:if test="${pagination.hasNext}">
                    <a href="/admin/notices?keyword=${keyword}&size=${pagination.size}&page=${pagination.nextPage}">
                        다음
                    </a>
                </c:if>
                <c:if test="${!pagination.hasNext}">
                    <span class="disabled">다음</span>
                </c:if>
            </c:if>
        </div>
    </main>
</div>
</body>
</html>
