<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>관리자 센터 - 회원 관리</title>
            <link rel="stylesheet" href="/css/admin/admin_common.css">
            <link rel="stylesheet" href="/css/admin/admin_detail_panel.css">
            <script src="/js/admin_detail_common.js"></script>
            <script>
                document.addEventListener("DOMContentLoaded", () => {
                    let selectedMemberId = "";
                    let selectedMemberStatus = "";

                    const statusControl = document.getElementById("memberStatusControl");
                    const statusChangeButton = document.getElementById("memberStatusChangeButton");

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
                            const userId = row.dataset.userId;

                            fetch("/admin/members/detail?user_id=" + encodeURIComponent(userId))
                                .then(res => res.json())
                                .then(data => {
                                    if (!data.success) {
                                        alert(data.message);
                                        return;
                                    }

                                    const user = data.user;

                                    setText("userId", user.user_id);
                                    setText("role", user.role);
                                    setText("status", user.status);
                                    setText("name", user.name);
                                    setText("nickName", user.nick_name);
                                    setText("loginId", user.login_id);
                                    setText("email", user.email);
                                    setText("phone", user.phone);
                                    setText("gender", user.gender);
                                    setText("createdAt", user.created_at);
                                    setText("updatedAt", user.updated_at);
                                    
                                    setText("memberOrderCount", data.orderCount);
                                    setText("memberReviewCount", data.reviewCount);
                                    setText("memberInquiryCount", data.inquiryCount);
                                    setText("memberReportCount", data.reportCount);

                                    const roleLabel = user.role === "SELLER" ? "판매자" : "일반회원";
                                    const memberMeta = (user.login_id || "-") + " · " + roleLabel;
                                    const memberStatus = user.status || "";

                                    setText("memberDetailTitle", user.name);
                                    setText("memberDetailMeta", memberMeta);

                                    const statusLabel = {
                                        active: "활성",
                                        suspended: "정지",
                                        withdrawn: "탈퇴"
                                    };

                                    const statusBadge = document.getElementById("memberDetailStatusBadge");
                                    if (statusBadge) {
                                        statusBadge.className = "admin-detail-status-badge " + memberStatus;
                                        statusBadge.textContent = statusLabel[memberStatus] || "-";
                                    }

                                    const userId = encodeURIComponent(user.login_id);

                                    const orderLink = document.getElementById("memberOrderLink");
                                    const reviewLink = document.getElementById("memberReviewLink");
                                    const inquiryLink = document.getElementById("memberInquiryLink");
                                    const reportLink = document.getElementById("memberReportLink");

                                    orderLink.href = "/admin/orders?status=all&user_id=" + userId + "&page=1";
                                    reviewLink.href = "/admin/reviews?user_id=" + userId + "&page=1";
                                    inquiryLink.href = "/admin/inquiries?status=all&user_id=" + userId + "&page=1";
                                    reportLink.href = "/admin/reports?status=all&user_id=" + userId + "&page=1";

                                    highlightAdminKeyword(document.getElementById("adminDetailPanel"));

                                    selectedMemberId = user.user_id;
                                    selectedMemberStatus = user.status;
                                    if (statusControl) {
                                        statusControl.value = selectedMemberStatus;
                                    }
                                })
                        });
                    });

                    statusChangeButton.addEventListener("click", () => {
                        fetch("/admin/members/status", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/x-www-form-urlencoded"
                            },
                            body: "user_id=" + encodeURIComponent(selectedMemberId)
                                + "&status=" + encodeURIComponent(statusControl.value)
                        })
                        .then(res => res.json())
                        .then(data => {
                            if (!data.success) {
                                alert(data.message);
                                return;
                            }

                            setText("status", data.status);
                        });
                    });

                    document.querySelectorAll(".admin-detail-tab").forEach((tab) => {
                        tab.addEventListener("click", () => {
                            const tabName = tab.dataset.detailTab;

                            document.querySelectorAll(".admin-detail-tab").forEach((item) => {
                                item.classList.toggle("active", item === tab);
                            });

                            document.querySelectorAll(".admin-detail-tab-panel").forEach((panel) => {
                                panel.classList.toggle("active", panel.dataset.detailPanel === tabName);
                            });
                        });
                    });
                });

                function memberDetailPanelInit() {

                }
            </script>
        </head>

        <body>
            <div class="admin-board">
                <jsp:include page="admin_sidebar.jsp">
                    <jsp:param name="activeMenu" value="members" />
                    <jsp:param name="sidebarTitle" value="회원 관리" />
                </jsp:include>

                <main class="admin-main admin-main-fixed">
                    <header class="admin-main-header">
                        <div>
                            <span class="admin-page-label">MEMBER MANAGEMENT</span>
                            <h1>회원 관리</h1>
                        </div>
                    </header>

                    <div class="admin-fixed-list-layout">
                        <div class="admin-filter-box admin-filter-modern">
                        <form class="admin-filter-form" action="/admin/members" method="get">
                            <div class="admin-filter-main-row">
                                <div class="admin-filter-tabs">
                                    <a href="/admin/members?role=all&keyword=${keyword}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${role == 'all' ? 'active' : ''}">전체</a>
                                    <a href="/admin/members?role=user&keyword=${keyword}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${role == 'user' ? 'active' : ''}">일반회원</a>
                                    <a href="/admin/members?role=seller&keyword=${keyword}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1"
                                        class="${role == 'seller' ? 'active' : ''}">판매자</a>
                                </div>

                                <div class="admin-search-wrap">
                                    <input type="text" class="admin-search" id="keyword" name="keyword"
                                        placeholder="아이디, 이름, 이메일, 닉네임, 전화번호 검색" value="${keyword}">
                                    <span class="admin-search-icon" aria-hidden="true"></span>
                                </div>
                                <button type="submit" class="admin-btn admin-search-submit">검색</button>
                                <button type="button" class="admin-btn light admin-filter-toggle">
                                    상세 검색
                                </button>
                                <select class="admin-filter-control admin-sort-control" id="sort" name="sort">
                                    <option value="latest" ${sort eq 'latest' ? 'selected' : ''}>최신순</option>
                                    <option value="oldest" ${sort eq 'oldest' ? 'selected' : ''}>오래된순</option>
                                </select>
                                <select class="admin-filter-control admin-page-size-control" id="pageSize" name="size">
                                    <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                                    <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                                    <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                                </select>
                            </div>

                            <div class="admin-filter-detail-row" id="memberAdvancedFilter">
                                <label class="admin-filter-field">
                                    <span>성별</span>
                                    <select class="admin-filter-control" name="gender">
                                        <option value="all" ${gender eq 'all' ? 'selected' : ''}>전체</option>
                                        <option value="male" ${gender eq 'male' ? 'selected' : ''}>남성</option>
                                        <option value="female" ${gender eq 'female' ? 'selected' : ''}>여성</option>
                                    </select>
                                </label>

                                <label class="admin-filter-field">
                                    <span>상태</span>
                                    <select class="admin-filter-control" name="status">
                                        <option value="all" ${status eq 'all' ? 'selected' : ''}>전체</option>
                                        <option value="active" ${status eq 'active' ? 'selected' : ''}>활성</option>
                                        <option value="suspended" ${status eq 'suspended' ? 'selected' : ''}>정지</option>
                                        <option value="withdrawn" ${status eq 'withdrawn' ? 'selected' : ''}>탈퇴</option>
                                    </select>
                                </label>

                                <label class="admin-filter-field admin-filter-date-range">
                                    <span>가입일 범위</span>
                                    <input type="date" class="admin-filter-control" name="startDate"
                                           value="${startDate}">
                                    <em>~</em>
                                    <input type="date" class="admin-filter-control" name="endDate"
                                           value="${endDate}">
                                </label>

                                <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                            </div>

                            <c:if test="${role ne 'all' || not empty keyword
                                          || gender ne 'all' || status ne 'all'
                                          || not empty startDate || not empty endDate}">
                                <div class="admin-filter-applied">
                                    <span class="admin-filter-applied-label">적용된 조건:</span>

                                    <c:if test="${role ne 'all'}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=all&keyword=${keyword}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            유형:
                                            ${role eq 'user' ? '일반회원' : '판매자'}
                                            <span>&times;</span>
                                        </a>
                                    </c:if>

                                    <c:if test="${not empty keyword}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            검색어: ${keyword}
                                            <span>&times;</span>
                                        </a>
                                    </c:if>

                                    <c:if test="${gender ne 'all'}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&keyword=${keyword}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            성별:
                                            <c:choose>
                                                <c:when test="${gender eq 'male'}">
                                                    남성
                                                </c:when>
                                                <c:when test="${gender eq 'female'}">
                                                    여성
                                                </c:when>
                                            </c:choose>
                                            <span>&times;</span>
                                        </a>
                                    </c:if>
                                    
                                    <c:if test="${status ne 'all'}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&keyword=${keyword}&gender=${gender}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=1">
                                            상태:
                                            <c:choose>
                                                <c:when test="${status eq 'active'}">
                                                    활성
                                                </c:when>
                                                <c:when test="${status eq 'suspended'}">
                                                    정지
                                                </c:when>
                                                <c:when test="${status eq 'withdrawn'}">
                                                    탈퇴
                                                </c:when>
                                            </c:choose>
                                            <span>&times;</span>
                                        </a>
                                    </c:if>

                                    <c:if test="${not empty startDate or not empty endDate}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&keyword=${keyword}&gender=${gender}&status=${status}&sort=${sort}&size=${pagination.size}&page=1">
                                            가입일: ${startDate} ~ ${endDate}
                                            <span>&times;</span>
                                        </a>
                                    </c:if>
                                    <a class="admin-filter-clear" href="/admin/members">전체 해제</a>
                                </div>
                            </c:if>

                            <input type="hidden" name="role" value="${role}">
                            <input type="hidden" name="page" value="1">
                        </form>
                    </div>

                    <section class="admin-master-detail admin-master-detail-filtered is-collapsed" id="adminMasterDetail">
                        <div class="admin-card admin-list-panel">
                            <div class="admin-table-wrap">
                                <table class="admin-table admin-member-table">
                                    <thead>
                                        <tr>
                                            <th>회원번호</th>
                                            <th>회원명</th>
                                            <th>이메일</th>
                                            <th>유형</th>
                                            <th>상태</th>
                                            <th>가입일</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${userList}">
                                            <tr class="admin-clickable-row" data-user-id="${user.user_id}">
                                                <td>${user.user_id}</td>
                                                <td class="admin-highlight-target"><strong>${user.name}</strong></td>
                                                <td class="left admin-highlight-target">${user.email}</td>
                                                <td>${user.role eq 'SELLER' ? "판매자" : "일반회원"}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.status eq 'active'}">
                                                            <span class="admin-status active">
                                                                활성
                                                            </span>
                                                        </c:when>
                                                        
                                                        <c:when test="${user.status eq 'suspended'}">
                                                            <span class="admin-status suspended">
                                                                정지
                                                            </span>
                                                        </c:when>

                                                        <c:when test="${user.status eq 'withdrawn'}">
                                                            <span class="admin-status withdrawn">
                                                                탈퇴
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>${user.created_at}</td>
                                                <td class="admin-table-actions">
                                                    <button type="button"
                                                        class="admin-btn light admin-detail-btn">상세</button>
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
                                        <div class="admin-detail-head-main">
                                            <div class="admin-detail-title-block">
                                                <div class="admin-detail-title-line">
                                                    <h2 id="memberDetailTitle">회원 상세</h2>
                                                    <span class="admin-detail-status-badge"
                                                        id="memberDetailStatusBadge">-</span>
                                                </div>
                                                <p id="memberDetailMeta">목록에서 회원을 선택하세요.</p>
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
                                                <div class="admin-detail-activity">
                                                    <a href="#" id="memberOrderLink">
                                                        <strong id="memberOrderCount">-</strong>
                                                        <span>주문</span>
                                                    </a>
                                                    <a href="#" id="memberReviewLink">
                                                        <strong id="memberReviewCount">-</strong>
                                                        <span>후기</span>
                                                    </a>
                                                    <a href="#" id="memberInquiryLink">
                                                        <strong id="memberInquiryCount">-</strong>
                                                        <span>문의</span>
                                                    </a>
                                                    <a href="#" id="memberReportLink">
                                                        <strong id="memberReportCount">-</strong>
                                                        <span>신고</span>
                                                    </a>
                                                </div>
                                                <dl class="admin-detail-grid">
                                                    <div>
                                                        <dt>회원번호</dt>
                                                        <dd id="userId">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>회원 유형</dt>
                                                        <dd id="role">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>회원 상태</dt>
                                                        <dd id="status">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>회원명</dt>
                                                        <dd id="name" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>닉네임</dt>
                                                        <dd id="nickName" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>아이디</dt>
                                                        <dd id="loginId" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>이메일</dt>
                                                        <dd id="email" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>연락처</dt>
                                                        <dd id="phone" class="admin-highlight-target">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>성별</dt>
                                                        <dd id="gender">-</dd>
                                                    </div>
                                                    <div>
                                                        <dt>가입일</dt>
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
                                                        <h3>상태 관리</h3>
                                                    </div>
                                                    <div class="admin-detail-setting-row">
                                                        <label class="admin-detail-control">
                                                            <span>회원 상태</span>
                                                            <select class="admin-filter-control" id="memberStatusControl">
                                                                <option value="active">활성</option>
                                                                <option value="suspended">정지</option>
                                                                <option value="withdrawn">탈퇴</option>
                                                            </select>
                                                        </label>
                                                    </div>
                                                    <div class="admin-detail-section-actions">
                                                        <button type="button" class="admin-btn light">변경 취소</button>
                                                        <button type="button" class="admin-btn">상태 변경</button>
                                                    </div>
                                                </div>

                                                <div class="admin-detail-manage-section">
                                                    <div class="admin-detail-section-head">
                                                        <h3>관리 메모</h3>
                                                    </div>
                                                    <textarea class="admin-detail-memo" rows="5"
                                                        placeholder="회원 관리에 필요한 메모를 입력하세요."></textarea>
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
                                    <a href="/admin/members?role=${role}&keyword=${keyword}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.prevPage}">
                                        
                                        이전
                                    </a>
                                </c:if>
                                <c:if test="${!pagination.hasPrev}">
                                    <span class="disabled">이전</span>
                                </c:if>

                                <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                                    <a href="/admin/members?role=${role}&keyword=${keyword}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${i}"
                                        class="${pagination.page == i ? 'active' : ''}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <c:if test="${pagination.hasNext}">
                                    <a href="/admin/members?role=${role}&keyword=${keyword}&gender=${gender}&status=${status}&startDate=${startDate}&endDate=${endDate}&sort=${sort}&size=${pagination.size}&page=${pagination.nextPage}">
                                        다음
                                    </a>
                                </c:if>
                                <c:if test="${!pagination.hasNext}">
                                    <span class="disabled">다음</span>
                                </c:if>
                            </c:if>
                        </div>
                        <span class="admin-filter-count">전체 ${totalCount}명</span>
                        </div>
                    </div>
                </main>
            </div>
        </body>

        </html>
