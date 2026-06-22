<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 공지사항 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
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
                <p>쇼핑몰 공지사항을 등록하고 수정합니다.</p>
            </div>
            <div class="admin-header-actions">
                <a href="/notice_form.do" class="admin-btn">공지 등록</a>
                <a href="/notice_list.do" class="admin-btn light">사용자 공지 보기</a>
            </div>
        </header>

        <section class="admin-grid three">
            <article class="admin-card span-2">
                <div class="admin-card-head">
                    <h3>공지사항 목록</h3>
                </div>
                <div class="admin-filter-box">
                    <div class="admin-filter-tabs">
                        <button type="button" class="active">전체</button>
                        <button type="button">공지</button>
                    </div>
                    <input type="text" class="admin-search" placeholder="제목 검색">
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
                        <tr>
                            <td>#N-32</td>
                            <td>공지</td>
                            <td class="left"><strong>설 연휴 배송 일정 안내</strong></td>
                            <td><span class="admin-status active">노출</span></td>
                            <td>2026-06-16</td>
                            <td class="admin-table-actions">
                                <a href="/notice_update_form.do?notice_id=32" class="admin-btn light">수정</a>
                                <a href="/notice_detail.do?notice_id=32" class="admin-btn light">상세</a>
                            </td>
                        </tr>
                        <tr>
                            <td>#N-31</td>
                            <td>공지</td>
                            <td class="left"><strong>신규 가입 쿠폰 이벤트</strong></td>
                            <td><span class="admin-status active">노출</span></td>
                            <td>2026-06-15</td>
                            <td class="admin-table-actions">
                                <a href="/notice_update_form.do?notice_id=31" class="admin-btn light">수정</a>
                                <a href="/notice_detail.do?notice_id=31" class="admin-btn light">상세</a>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>공지 작성</h3>
                </div>
                <div class="admin-form-grid">
                    <div class="admin-form-row full">
                        <label>공지 유형</label>
                        <select>
                            <option>공지</option>
                            <option>배송 안내</option>
                        </select>
                    </div>
                    <div class="admin-form-row full">
                        <label>제목</label>
                        <input type="text" placeholder="공지 제목을 입력하세요">
                    </div>
                    <div class="admin-form-row full">
                        <label>내용</label>
                        <textarea placeholder="공지 내용을 입력하세요"></textarea>
                    </div>
                    <div class="admin-form-row full">
                        <a href="/notice_form.do" class="admin-btn">등록 화면으로 이동</a>
                    </div>
                </div>
            </article>
        </section>
    </main>
</div>
</body>
</html>
