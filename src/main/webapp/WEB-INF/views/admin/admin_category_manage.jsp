<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 카테고리 관리</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="categories" />
        <jsp:param name="sidebarTitle" value="카테고리 관리" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">CATEGORY MANAGEMENT</span>
                <h1>카테고리 관리</h1>
                <p>상품 분류를 추가, 수정, 노출 순서 변경, 비활성화 처리합니다.</p>
            </div>
            <div class="admin-header-actions">
                <button type="button" class="admin-btn">카테고리 추가</button>
                <button type="button" class="admin-btn light">순서 저장</button>
            </div>
        </header>

        <section class="admin-grid three">
            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>카테고리 등록</h3>
                </div>
                <div class="admin-form-grid">
                    <div class="admin-form-row full">
                        <label>상위 카테고리</label>
                        <select>
                            <option>최상위</option>
                            <option>패션잡화</option>
                            <option>생활소품</option>
                        </select>
                    </div>
                    <div class="admin-form-row full">
                        <label>카테고리명</label>
                        <input type="text" placeholder="예: 도자기">
                    </div>
                    <div class="admin-form-row">
                        <label>노출 순서</label>
                        <input type="number" value="1">
                    </div>
                    <div class="admin-form-row">
                        <label>상태</label>
                        <select>
                            <option>노출</option>
                            <option>숨김</option>
                        </select>
                    </div>
                    <div class="admin-form-row full">
                        <button type="button" class="admin-btn">저장</button>
                    </div>
                </div>
            </article>

            <article class="admin-card span-2">
                <div class="admin-card-head">
                    <h3>카테고리 목록</h3>
                    <span class="admin-status active">노출중 12개</span>
                </div>
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>순서</th>
                            <th>대분류</th>
                            <th>중분류</th>
                            <th>상품 수</th>
                            <th>상태</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>1</td>
                            <td><strong>패션잡화</strong></td>
                            <td>가방/파우치</td>
                            <td>128</td>
                            <td><span class="admin-status active">노출</span></td>
                            <td class="admin-table-actions">
                                <button type="button" class="admin-btn light">수정</button>
                                <button type="button" class="admin-btn muted">숨김</button>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><strong>생활소품</strong></td>
                            <td>도자기</td>
                            <td>86</td>
                            <td><span class="admin-status active">노출</span></td>
                            <td class="admin-table-actions">
                                <button type="button" class="admin-btn light">수정</button>
                                <button type="button" class="admin-btn muted">숨김</button>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </article>
        </section>
    </main>
</div>
</body>
</html>
