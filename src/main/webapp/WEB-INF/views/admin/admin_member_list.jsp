<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 회원 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const rows = document.querySelectorAll(".admin-clickable-row");

            rows.forEach((row) => {
                row.addEventListener("click", () => {
                    const userId = row.dataset.userId;

                    fetch("/admin/members/detail?user_id=" + userId)
                    .then(res => res.json())
                    .then(data => {
                        const user = data.user;

                        setText("panelUserId", user.user_id);
                        setText("panelRole", user.role);
                        setText("panelName", user.name);
                        setText("panelNickName", user.nick_name);
                        setText("panelLoginId", user.login_id);
                        setText("panelEmail", user.email);
                        setText("panelPhone", user.phone);
                        setText("panelGender", user.gender);
                        setText("panelCreatedAt", user.created_at);
                        setText("panelUpdatedAt", user.updated_at);
                    })
                });
            });

            function setText(id, value) {
                document.getElementById(id).textContent = value ?? "-";
            }
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

        <section class="admin-master-detail" id="adminMasterDetail">
            <div class="admin-card admin-list-panel">
                <div class="admin-filter-box">
                    <form class="admin-filter-form" action="/admin/members" method="get">
                        <div class="admin-filter-tabs">
                            <a href="/admin/members?role=all&keyword=${keyword}" class="${role == 'all' ? 'active' : ''}">전체</a>
                            <a href="/admin/members?role=user&keyword=${keyword}" class="${role == 'user' ? 'active' : ''}">일반회원</a>
                            <a href="/admin/members?role=seller&keyword=${keyword}" class="${role == 'seller' ? 'active' : ''}">판매자</a>
                        </div>
                        <span class="admin-filter-count">전체 ${totalCount}명</span>
                        <input type="hidden" id="role" name="role" value="${role}">
                        <input type="text" class="admin-search" id="keyword" name="keyword" 
                               placeholder="아이디, 이름, 이메일 검색" value="${keyword}">
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

            <aside class="admin-card admin-detail-panel" id="adminDetailPanel" aria-labelledby="memberDetailTitle">
                <div class="admin-detail-panel-inner">
                    <div class="admin-detail-content" hidden>
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
                                <dd id="panelUserId">-</dd>
                            </div>
                            <div>
                                <dt>회원유형</dt>
                                <dd id="panelRole">-</dd>
                            </div>
                            <div>
                                <dt>회원명</dt>
                                <dd id="panelName">-</dd>
                            </div>
                            <div>
                                <dt>닉네임</dt>
                                <dd id="panelNickName">-</dd>
                            </div>
                            <div>
                                <dt>아이디</dt>
                                <dd id="panelLoginId">-</dd>
                            </div>
                            <div>
                                <dt>이메일</dt>
                                <dd id="panelEmail">-</dd>
                            </div>
                            <div>
                                <dt>연락처</dt>
                                <dd id="panelPhone">-</dd>
                            </div>
                            <div>
                                <dt>성별</dt>
                                <dd id="panelGender">-</dd>
                            </div>
                            <div>
                                <dt>가입일</dt>
                                <dd id="panelCreatedAt">-</dd>
                            </div>
                            <div>
                                <dt>수정일</dt>
                                <dd id="panelUpdatedAt">-</dd>
                            </div>
                        </dl>
                    </div>
                </div>
            </aside>
        </section>
    </main>
</div>
</body>
</html>
