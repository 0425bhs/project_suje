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
                                    const user = data.user;

                                    setText("userId", user.user_id);
                                    setText("role", user.role);
                                    setText("name", user.name);
                                    setText("nickName", user.nick_name);
                                    setText("loginId", user.login_id);
                                    setText("email", user.email);
                                    setText("phone", user.phone);
                                    setText("gender", user.gender);
                                    setText("createdAt", user.created_at);
                                    setText("updatedAt", user.updated_at);

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
                    <jsp:param name="activeMenu" value="members" />
                    <jsp:param name="sidebarTitle" value="회원 관리" />
                </jsp:include>

                <main class="admin-main">
                    <header class="admin-main-header">
                        <div>
                            <span class="admin-page-label">MEMBER MANAGEMENT</span>
                            <h1>회원 관리</h1>
                            <p>가입 회원을 조회하고 기본 정보를 확인합니다.</p>
                        </div>
                    </header>

                    <div class="admin-filter-box admin-filter-modern">
                        <form class="admin-filter-form" action="/admin/members" method="get">
                            <div class="admin-filter-main-row">
                                <div class="admin-filter-tabs">
                                    <a href="/admin/members?role=all&keyword=${keyword}&size=${pagination.size}&page=1"
                                        class="${role == 'all' ? 'active' : ''}">전체</a>
                                    <a href="/admin/members?role=user&keyword=${keyword}&size=${pagination.size}&page=1"
                                        class="${role == 'user' ? 'active' : ''}">일반회원</a>
                                    <a href="/admin/members?role=seller&keyword=${keyword}&size=${pagination.size}&page=1"
                                        class="${role == 'seller' ? 'active' : ''}">판매자</a>
                                </div>
                                <span class="admin-filter-count">전체 ${totalCount}명</span>

                                <div class="admin-search-wrap">
                                    <input type="text" class="admin-search" id="keyword" name="keyword"
                                        placeholder="아이디, 이름, 이메일, 닉네임, 전화번호 검색" value="${keyword}">
                                    <span class="admin-search-icon" aria-hidden="true"></span>
                                </div>
                                <button type="submit" class="admin-btn admin-search-submit">검색</button>
                                <button type="button" class="admin-btn light admin-filter-toggle">
                                    상세 검색
                                </button>
                                <select class="admin-filter-control admin-sort-control" name="sort">
                                    <option value="latest">최신순</option>
                                    <option value="oldest">오래된순</option>
                                    <option value="name">이름순</option>
                                </select>
                                <select id="pageSize" class="admin-filter-control admin-page-size-control" name="size">
                                    <option value="10" ${pagination.size == 10 ? 'selected' : ''}>10개씩</option>
                                    <option value="30" ${pagination.size == 30 ? 'selected' : ''}>30개씩</option>
                                    <option value="50" ${pagination.size == 50 ? 'selected' : ''}>50개씩</option>
                                </select>
                            </div>

                            <div class="admin-filter-detail-row" id="memberAdvancedFilter">
                                <label class="admin-filter-field">
                                    <span>성별</span>
                                    <select class="admin-filter-control" name="gender">
                                        <option value="all">전체</option>
                                        <option value="male">남성</option>
                                        <option value="female">여성</option>
                                    </select>
                                </label>

                                <label class="admin-filter-field">
                                    <span>상태</span>
                                    <select class="admin-filter-control" name="memberStatus">
                                        <option value="all">전체</option>
                                        <option value="active">활성</option>
                                        <option value="suspended">정지</option>
                                        <option value="withdrawn">탈퇴</option>
                                    </select>
                                </label>

                                <label class="admin-filter-field admin-filter-date-range">
                                    <span>가입일 범위</span>
                                    <input type="date" class="admin-filter-control" name="startDate">
                                    <em>~</em>
                                    <input type="date" class="admin-filter-control" name="endDate">
                                </label>

                                <button type="submit" class="admin-btn admin-filter-submit">적용</button>
                            </div>

                            <c:if test="${role ne 'all' || not empty keyword}">
                                <div class="admin-filter-applied">
                                    <span class="admin-filter-applied-label">적용된 조건:</span>

                                    <c:if test="${role ne 'all'}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=all&keyword=${keyword}&size=${pagination.size}&page=1">
                                            유형:
                                            ${role eq 'user' ? '일반회원' : '판매자'}
                                            <span>&times;</span>
                                        </a>
                                    </c:if>

                                    <c:if test="${not empty keyword}">
                                        <a class="admin-filter-chip"
                                            href="/admin/members?role=${role}&size=${pagination.size}&page=1">
                                            검색어: ${keyword}
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
                                                <td><span class="admin-status active">정상(미구현)</span></td>
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
                                        <div>
                                            <span class="admin-page-label">MEMBER DETAIL</span>
                                            <h2 id="memberDetailTitle">회원 상세</h2>
                                        </div>
                                        <button type="button" class="admin-detail-close"
                                            aria-label="닫기">&times;</button>
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
                        </aside>
                    </section>

                    <div class="admin-pagination">
                        <c:if test="${pagination.totalPage > 0}">
                            <c:if test="${pagination.hasPrev}">
                                <a
                                    href="/admin/members?role=${role}&keyword=${keyword}&size=${pagination.size}&page=${pagination.prevPage}">
                                    이전
                                </a>
                            </c:if>
                            <c:if test="${!pagination.hasPrev}">
                                <span class="disabled">이전</span>
                            </c:if>

                            <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                                <a href="/admin/members?role=${role}&keyword=${keyword}&size=${pagination.size}&page=${i}"
                                    class="${pagination.page == i ? 'active' : ''}">
                                    ${i}
                                </a>
                            </c:forEach>

                            <c:if test="${pagination.hasNext}">
                                <a
                                    href="/admin/members?role=${role}&keyword=${keyword}&size=${pagination.size}&page=${pagination.nextPage}">
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
