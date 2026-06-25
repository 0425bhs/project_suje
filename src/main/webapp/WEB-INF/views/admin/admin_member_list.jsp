<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 회원 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
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
                <p>일반 회원과 판매자 전환 상태, 제재 이력을 관리합니다.</p>
            </div>
            <div class="admin-header-actions">
                <button type="button" class="admin-btn light">CSV 다운로드</button>
                <button type="button" class="admin-btn danger">선택 제재</button>
            </div>
        </header>

        <section class="admin-card">
            <div class="admin-filter-box">
                <div class="admin-filter-tabs">
                    <button type="button" class="active">전체</button>
                    <button type="button">일반회원</button>
                    <button type="button">판매자</button>
                    <button type="button">휴면</button>
                    <button type="button">제재중</button>
                </div>
                <input type="text" class="admin-search" placeholder="아이디, 이름, 이메일 검색">
            </div>

            <div class="admin-table-wrap">
                <table class="admin-table">
                    <thead>
                    <tr>
                        <th><input type="checkbox"></th>
                        <th>회원번호</th>
                        <th>회원명</th>
                        <th>이메일</th>
                        <th>유형</th>
                        <th>상태</th>
                        <th>가입일</th>
                        <th>최근 로그인</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>#10042</td>
                        <td><strong>김하늘</strong></td>
                        <td class="left">sky@example.com</td>
                        <td>일반회원</td>
                        <td><span class="admin-status active">정상</span></td>
                        <td>2026-06-01</td>
                        <td>2026-06-16</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                            <button type="button" class="admin-btn danger">제재</button>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>#10018</td>
                        <td><strong>오브제상점</strong></td>
                        <td class="left">objet@example.com</td>
                        <td>판매자</td>
                        <td><span class="admin-status active">정상</span></td>
                        <td>2026-05-18</td>
                        <td>2026-06-15</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                            <button type="button" class="admin-btn muted">휴면</button>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>#9972</td>
                        <td><strong>문라이트</strong></td>
                        <td class="left">moon@example.com</td>
                        <td>일반회원</td>
                        <td><span class="admin-status danger">제재중</span></td>
                        <td>2026-04-22</td>
                        <td>2026-06-02</td>
                        <td class="admin-table-actions">
                            <button type="button" class="admin-btn light">상세</button>
                            <button type="button" class="admin-btn">해제</button>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>
</body>
</html>
