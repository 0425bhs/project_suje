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
            const managePanel = initAdminDetailManage({
                targetType: "NOTICE"
            });

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

                        setDetailTitleBlock(
                            "noticeDetailTitle",
                            "noticeDetailMeta",
                            notice.title || "공지사항 상세",
                            notice.created_at || "-"
                        );
                        setText("title", notice.title);
                        setText("content", notice.content);
                        setText("createdAt", notice.created_at);
                        setText("updatedAt", notice.updated_at);
                        managePanel.setTarget(notice.notice_id);

                        document.getElementById("noticePublicDetailLink").href =
                            "/notice_detail.do?notice_id=" + encodeURIComponent(notice.notice_id);

                        highlightAdminKeyword(document.getElementById("adminDetailPanel"));
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

    <main class="admin-main admin-main-fixed">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">NOTICE MANAGEMENT</span>
                <h1>공지사항 관리</h1>
            </div>
            <div class="admin-header-actions">
                <a href="/notice_form.do" class="admin-btn">공지 등록</a>
                <a href="/notice_list.do" class="admin-btn light">사용자 공지 보기</a>
            </div>
        </header>

        <div class="admin-fixed-list-layout">
            <div class="admin-filter-box admin-filter-modern">
            <form class="admin-filter-form" action="/admin/notices" method="get">
                <div class="admin-filter-main-row">
                    <div class="admin-filter-tabs">
                        <button type="button" class="active">전체</button>
                    </div>

                    <div class="admin-search-wrap">
                        <input type="text" id="keyword" class="admin-search" name="keyword"
                            placeholder="제목 검색" value="${keyword}">
                        <span class="admin-search-icon" aria-hidden="true"></span>
                    </div>
                    <button type="submit" class="admin-btn admin-search-submit">검색</button>
                    <button type="button" class="admin-btn light admin-filter-toggle">상세 검색</button>
                    <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                        <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                        <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                        <option value="title" ${sort eq 'title' ? 'selected' : ''}>제목순</option>
                    </select>
                    <select id="pageSize" class="admin-filter-control admin-page-size-control" name="size">
                        <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                        <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                        <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                    </select>
                </div>

                <div class="admin-filter-detail-row">
                    <label class="admin-filter-field admin-filter-date-range">
                        <span>등록일 범위</span>
                        <input type="date" class="admin-filter-control" name="startDate" value="${startDate}">
                        <em>~</em>
                        <input type="date" class="admin-filter-control" name="endDate" value="${endDate}">
                    </label>
                    <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                </div>

                <c:if test="${not empty keyword || not empty startDate || not empty endDate}">
                    <div class="admin-filter-applied">
                        <span class="admin-filter-applied-label">적용된 조건:</span>
                        <c:if test="${not empty keyword}">
                            <a class="admin-filter-chip" href="/admin/notices?startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                검색어: ${keyword}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <c:if test="${not empty startDate || not empty endDate}">
                            <a class="admin-filter-chip" href="/admin/notices?keyword=${keyword}&sort=${sort}&size=${pagination.size}&page=1">
                                등록일: ${startDate} ~ ${endDate}
                                <span aria-hidden="true">&times;</span>
                            </a>
                        </c:if>
                        <a class="admin-filter-clear" href="/admin/notices">전체 해제</a>
                    </div>
                </c:if>

                <input type="hidden" name="page" value="1">
            </form>
        </div>

        <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-card-head">
                    <h3>공지사항 목록</h3>
                </div>
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>등록일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty noticeList}">
                            <tr>
                                <td colspan="3">공지 목록이 없습니다.</td>
                            </tr>
                        </c:if>
                        <c:forEach var="notice" items="${noticeList}" varStatus="loop">
                        <tr class="admin-clickable-row" data-notice-id="${notice.notice_id}">
                            <td>${pagination.offset + loop.index + 1}</td>
                            <td class="left admin-highlight-target"><strong>${notice.title}</strong></td>
                            <td>${notice.created_at}</td>
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
                                        <div class="admin-detail-head-main">
                                            <div class="admin-detail-title-block">
                                                <div class="admin-detail-title-line">
                                                    <h2 id="noticeDetailTitle">공지사항 상세</h2>
                                                </div>
                                                <p id="noticeDetailMeta">목록에서 공지사항을 선택하세요.</p>
                                            </div>
                                            <div class="admin-detail-toolbar">
                                                <button type="button" class="admin-detail-close"
                                                    aria-label="닫기">&times;</button>
                                            </div>
                                        </div>
                                        <div class="admin-detail-tabs">
                                            <button type="button" class="admin-detail-tab active" data-detail-tab="info">
                                                정보
                                            </button>
                                            <button type="button" class="admin-detail-tab" data-detail-tab="manage">
                                                관리
                                            </button>
                                        </div>
                                    </div>
                        <div class="admin-detail-tab-body">
                                        <div class="admin-detail-tab-panel active" data-detail-panel="info">
                                            <div class="admin-detail-info-scroll">
                                                <div class="admin-detail-manage-section admin-detail-quick-link-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>바로가기</h3>
                                                    </div>
                                                    <div class="admin-detail-link-list">
                                                        <a href="#" id="noticePublicDetailLink">
                                                            <span>공지 상세</span>
                                                        </a>
                                                    </div>
                                                </div>
                                                <dl class="admin-detail-grid">
                            <div>
                                <dt>제목</dt>
                                <dd id="title" class="admin-highlight-target">-</dd>
                            </div>
                            <div>
                                <dt>내용</dt>
                                <dd id="content" class="admin-highlight-target">-</dd>
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
                                        <div class="admin-detail-tab-panel" data-detail-panel="manage">
                                            <div class="admin-detail-manage">
                                                <div class="admin-detail-manage-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>관리 메모</h3>
                                                    </div>
                                                    <textarea class="admin-detail-memo" rows="5"
                                                        placeholder="관리 중 필요한 메모를 입력하세요."></textarea>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light">메모 저장</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                    </div>
                </div>
            </aside>
        </section>

        <div class="admin-pagination">
            <div class="admin-pagination-pages">
                <c:if test="${pagination.totalPage > 0}">
                    <c:if test="${pagination.hasPrev}">
                        <a href="/admin/notices?keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                            이전
                        </a>
                    </c:if>
                    <c:if test="${!pagination.hasPrev}">
                        <span class="disabled">이전</span>
                    </c:if>

                    <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                        <a href="/admin/notices?keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                            class="${pagination.page == i ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${pagination.hasNext}">
                        <a href="/admin/notices?keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
                            다음
                        </a>
                    </c:if>
                    <c:if test="${!pagination.hasNext}">
                        <span class="disabled">다음</span>
                    </c:if>
                </c:if>
            </div>
            <span class="admin-filter-count">전체 ${totalCount}건</span>
        </div>
            </div>
    </main>
</div>
</body>
</html>
