<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>관리자 센터 - 고객센터 문의 관리</title>
            <link rel="stylesheet" href="/css/admin/admin_common.css">
            <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
            <script src="/js/admin_detail_common.js"></script>
            <script>
                document.addEventListener("DOMContentLoaded", () => {
                    const master = document.getElementById("adminMasterDetail");
                    const rows = document.querySelectorAll(".admin-clickable-row");

                    rows.forEach((row) => {
                        //모든 행에 클릭 이벤트 부여
                        row.addEventListener("click", () => {
                            //상세 패널이 열려있고 이미 선택된 행을 눌렀을 때
                            if (!master.classList.contains("is-collapsed") && row.classList.contains("selected")) {
                                closeDetailPanel(master, row);
                                return;
                            }

                            openDetailPanel(master, rows, row);

                            //상세 패널 내용 변경
                            const inquiryId = row.dataset.inquiryId;

                            fetch("/admin/inquiries/detail?inquiry_id=" + encodeURIComponent(inquiryId))
                                .then(res => res.json())
                                .then(data => {
                                    const inquiry = data.inquiry;

                                    setText("inquiryId", inquiry.inquiry_id);
                                    setText("userId", inquiry.user_id);
                                    setText("userName", inquiry.user_name);
                                    setText("inquiryType", inquiry.inquiry_type);
                                    setText("title", inquiry.title);
                                    setText("content", inquiry.content);
                                    setText("status", inquiry.status);
                                    setText("createdAt", inquiry.created_at);
                                    highlightAdminKeyword(document.getElementById("adminDetailPanel"));
                                })
                        });
                    });
                });
            </script>
        </head>

        <body>
            <div class="admin-board">
                <jsp:include page="admin_sidebar.jsp">
                    <jsp:param name="activeMenu" value="inquiries" />
                    <jsp:param name="sidebarTitle" value="고객센터 문의 관리" />
                </jsp:include>

                <main class="admin-main">
                    <header class="admin-main-header">
                        <div>
                            <span class="admin-page-label">INQUIRY MANAGEMENT</span>
                            <h1>고객센터 문의 관리</h1>
                            <p>회원, 주문, 결제, 판매자 관련 문의를 확인하고 답변합니다.</p>
                        </div>
                    </header>

                    <div class="admin-filter-box admin-filter-modern">
                        <form class="admin-filter-form" action="/admin/inquiries" method="get">
                            <div class="admin-filter-main-row">
                                <div class="admin-filter-tabs">
                                    <a href="/admin/inquiries?status=all&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${status eq 'all' ? 'active' : ''}">전체</a>
                                    <a href="/admin/inquiries?status=waiting&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${status eq 'waiting' ? 'active' : ''}">미답변</a>
                                    <a href="/admin/inquiries?status=answered&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${status eq 'answered' ? 'active' : ''}">답변완료</a>
                                </div>

                                <div class="admin-search-wrap">
                                    <input type="text" id="keyword" class="admin-search" name="keyword"
                                        placeholder="문의 제목, 작성자 검색" value="${keyword}">
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
                                <label class="admin-filter-field">
                                    <span>상태</span>
                                    <select class="admin-filter-control" name="status">
                                        <option value="all" ${status eq 'all' ? 'selected' : ''}>전체</option>
                                        <option value="waiting" ${status eq 'waiting' ? 'selected' : ''}>미답변</option>
                                        <option value="answered" ${status eq 'answered' ? 'selected' : ''}>답변완료</option>
                                    </select>
                                </label>
                                <label class="admin-filter-field admin-filter-date-range">
                                    <span>작성일 범위</span>
                                    <input type="date" class="admin-filter-control" name="startDate" value="${startDate}">
                                    <em>~</em>
                                    <input type="date" class="admin-filter-control" name="endDate" value="${endDate}">
                                </label>
                                <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                            </div>

                            <c:if test="${status ne 'all' || not empty keyword || not empty startDate || not empty endDate}">
                                <div class="admin-filter-applied">
                                    <span class="admin-filter-applied-label">적용된 조건:</span>
                                    <c:if test="${status ne 'all'}">
                                        <a class="admin-filter-chip"
                                            href="/admin/inquiries?status=all&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            상태: ${status eq 'waiting' ? '미답변' : '답변완료'}
                                            <span aria-hidden="true">&times;</span>
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty keyword}">
                                        <a class="admin-filter-chip" href="/admin/inquiries?status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            검색어: ${keyword}
                                            <span aria-hidden="true">&times;</span>
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty startDate || not empty endDate}">
                                        <a class="admin-filter-chip" href="/admin/inquiries?status=${status}&keyword=${keyword}&sort=${sort}&size=${pagination.size}&page=1">
                                            작성일: ${startDate} ~ ${endDate}
                                            <span aria-hidden="true">&times;</span>
                                        </a>
                                    </c:if>
                                    <a class="admin-filter-clear" href="/admin/inquiries">전체 해제</a>
                                </div>
                            </c:if>

                            <input type="hidden" name="page" value="1">
                        </form>
                    </div>

                    <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
                        <div class="admin-card admin-list-panel">
                            <div class="admin-table-wrap">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>문의번호</th>
                                            <th>문의 유형</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th>상태</th>
                                            <th>작성일</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="inquiry" items="${inquiryList}">
                                            <tr class="admin-clickable-row" data-inquiry-id="${inquiry.inquiry_id}">
                                                <td>${inquiry.inquiry_id}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inquiry.inquiry_type eq 'SERVICE'}">서비스 이용
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'ACCOUNT'}">회원/계정
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'PAYMENT'}">결제 오류
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'SELLER'}">판매자 센터
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'POLICY'}">운영 정책
                                                        </c:when>
                                                        <c:when test="${inquiry.inquiry_type eq 'ETC'}">기타</c:when>
                                                    </c:choose>
                                                </td>
                                                <td class="left admin-highlight-target"><strong>${inquiry.title}</strong></td>
                                                <td class="admin-highlight-target">${inquiry.user_name}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inquiry.status eq 'WAITING'}">
                                                            <span class="admin-status waiting">미답변</span>
                                                        </c:when>

                                                        <c:when test="${inquiry.status eq 'ANSWERED'}">
                                                            <span class="admin-status answered">답변</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>${inquiry.created_at}</td>
                                                <td class="admin-table-actions">
                                                    <button type="button" class="admin-btn">답변</button>
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
                                            <span class="admin-page-label">INQUIRY DETAIL</span>
                                            <h2 id="inquiryDetailTitle">문의 상세</h2>
                                        </div>
                                        <button type="button" class="admin-detail-close"
                                            aria-label="닫기">&times;</button>
                                    </div>
                                    <dl class="admin-detail-grid">
                                        <div>
                                            <dt>문의 번호</dt>
                                            <dd id="inquiryId">-</dd>
                                        </div>
                                        <div>
                                            <dt>작성자 번호</dt>
                                            <dd id="userId">-</dd>
                                        </div>
                                        <div>
                                            <dt>작성자</dt>
                                            <dd id="userName" class="admin-highlight-target">-</dd>
                                        </div>
                                        <div>
                                            <dt>문의 종류</dt>
                                            <dd id="inquiryType">-</dd>
                                        </div>
                                        <div>
                                            <dt>제목</dt>
                                            <dd id="title" class="admin-highlight-target">-</dd>
                                        </div>
                                        <div>
                                            <dt>내용</dt>
                                            <dd id="content" class="admin-highlight-target">-</dd>
                                        </div>
                                        <div>
                                            <dt>상태</dt>
                                            <dd id="status">-</dd>
                                        </div>
                                        <div>
                                            <dt>작성일</dt>
                                            <dd id="createdAt">-</dd>
                                        </div>
                                    </dl>
                                </div>
                            </div>
                        </aside>
                    </section>

                    <div class="admin-pagination">
                        <div class="admin-pagination-pages">
                            <c:if test="${pagination.totalPage > 0}">
                                <c:if test="${pagination.hasPrev}">
                                    <a
                                        href="/admin/inquiries?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                                        이전
                                    </a>
                                </c:if>
                                <c:if test="${!pagination.hasPrev}">
                                    <span class="disabled">이전</span>
                                </c:if>

                                <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                                <a href="/admin/inquiries?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                                        class="${pagination.page == i ? 'active' : ''}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <c:if test="${pagination.hasNext}">
                                    <a
                                        href="/admin/inquiries?status=${status}&keyword=${keyword}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
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
                </main>
            </div>
        </body>

        </html>
