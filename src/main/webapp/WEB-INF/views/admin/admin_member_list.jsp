<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
                        
                        console.log(user.role);

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

        <section class="admin-master-detail is-collapsed" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-filter-box">
                    <form class="admin-filter-form" action="/admin/members" method="get">
                        <div class="admin-filter-tabs">
                            <a href="/admin/members?role=all&keyword=${keyword}&size=${pagination.size}&page=1" class="${role == 'all' ? 'active' : ''}">전체</a>
                            <a href="/admin/members?role=user&keyword=${keyword}&size=${pagination.size}&page=1" class="${role == 'user' ? 'active' : ''}">일반회원</a>
                            <a href="/admin/members?role=seller&keyword=${keyword}&size=${pagination.size}&page=1" class="${role == 'seller' ? 'active' : ''}">판매자</a>
                        </div>
                        <span class="admin-filter-count">전체 ${totalCount}명</span>
                        <input type="hidden" name="role" value="${role}">
                        <input type="text" class="admin-search" name="keyword" 
                               placeholder="아이디, 이름, 이메일 검색" value="${keyword}">
                        <input type="hidden" name="size" value="${pagination.size}">
                    </form>
                </div>

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
                            <td><strong>${user.name}</strong></td>
                            <td class="left">${user.email}</td>
                            <td>${user.role eq 'SELLER' ? "판매자" : "일반회원"}</td>
                            <td><span class="admin-status active">정상(미구현)</span></td>
                            <td>${user.created_at}</td>
                            <td class="admin-table-actions">
                                <button type="button" class="admin-btn light admin-detail-btn">상세</button>
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
                            <button type="button" class="admin-detail-close" aria-label="닫기">&times;</button>
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
                                <dd id="name">-</dd>
                            </div>
                            <div>
                                <dt>닉네임</dt>
                                <dd id="nickName">-</dd>
                            </div>
                            <div>
                                <dt>아이디</dt>
                                <dd id="loginId">-</dd>
                            </div>
                            <div>
                                <dt>이메일</dt>
                                <dd id="email">-</dd>
                            </div>
                            <div>
                                <dt>연락처</dt>
                                <dd id="phone">-</dd>
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
                    <a href="/admin/members?role=${role}&keyword=${keyword}&size=${pagination.size}&page=${pagination.prevPage}">
                        이전
                    </a>
                </c:if>

                <c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
                    <a href="/admin/members?role=${role}&keyword=${keyword}&size=${pagination.size}&page=${i}"
                       class="${pagination.page == i ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>

                <c:if test="${pagination.hasNext}">
                    <a href="/admin/members?role=${role}&keyword=${keyword}&size=${pagination.size}&page=${pagination.nextPage}">
                        다음
                    </a>
                </c:if>
            </c:if>
        </div>
    </main>
</div>
</body>
</html>
