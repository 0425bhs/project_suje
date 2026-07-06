<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 센터 - 기본 통계</title>
    <link rel="stylesheet" href="/css/admin/admin_common.css">
</head>
<body>
<div class="admin-board">
    <jsp:include page="admin_sidebar.jsp">
        <jsp:param name="activeMenu" value="statistics" />
        <jsp:param name="sidebarTitle" value="기본 통계" />
    </jsp:include>

    <main class="admin-main">
        <header class="admin-main-header">
            <div>
                <span class="admin-page-label">BASIC STATISTICS</span>
                <h1>통계</h1>
            </div>
            <div class="admin-header-actions">
                <select class="admin-filter-control">
                    <option>최근 7일</option>
                    <option>최근 30일</option>
                    <option>이번 달</option>
                </select>
                <button type="button" class="admin-btn light">다운로드</button>
            </div>
        </header>

        <section class="admin-grid">
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">총 결제 금액</span>
                <strong class="admin-stat-value">18,420,000<small>원</small></strong>
                <span class="admin-stat-note">payments SUCCESS 합계</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">총 주문</span>
                <strong class="admin-stat-value">234<small>건</small></strong>
                <span class="admin-stat-note">orders created_at 기준</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">취소 주문</span>
                <strong class="admin-stat-value">18<small>건</small></strong>
                <span class="admin-stat-note">orders CANCELLED 기준</span>
            </article>
            <article class="admin-card admin-stat-card">
                <span class="admin-stat-label">신규 회원</span>
                <strong class="admin-stat-value">46<small>명</small></strong>
                <span class="admin-stat-note">users created_at 기준</span>
            </article>
        </section>

        <section class="admin-grid three" style="margin-top:18px;">
            <article class="admin-card span-2">
                <div class="admin-card-head">
                    <h3>일자별 주문/결제</h3>
                </div>
                <div class="admin-table-wrap">
                    <table class="admin-table">
                        <thead>
                        <tr>
                            <th>일자</th>
                            <th>주문</th>
                            <th>결제금액</th>
                            <th>취소</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>2026-07-03</td>
                            <td>12건</td>
                            <td>1,248,000원</td>
                            <td>1건</td>
                        </tr>
                        <tr>
                            <td>2026-07-02</td>
                            <td>18건</td>
                            <td>1,930,000원</td>
                            <td>2건</td>
                        </tr>
                        <tr>
                            <td>2026-07-01</td>
                            <td>15건</td>
                            <td>1,640,000원</td>
                            <td>0건</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>주문 상태</h3>
                </div>
                <div class="admin-metric-list">
                    <div class="admin-metric-row">
                        <span>결제완료</span>
                        <strong>42%</strong>
                        <em><i style="width: 42%;"></i></em>
                    </div>
                    <div class="admin-metric-row">
                        <span>상품준비중</span>
                        <strong>24%</strong>
                        <em><i style="width: 24%;"></i></em>
                    </div>
                    <div class="admin-metric-row">
                        <span>배송중</span>
                        <strong>18%</strong>
                        <em><i style="width: 18%;"></i></em>
                    </div>
                    <div class="admin-metric-row">
                        <span>취소</span>
                        <strong>8%</strong>
                        <em><i style="width: 8%;"></i></em>
                    </div>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>카테고리별 매출</h3>
                </div>
                <div class="admin-metric-list">
                    <div class="admin-metric-row">
                        <span>식품</span>
                        <strong>5,820,000원</strong>
                        <em><i style="width: 86%;"></i></em>
                    </div>
                    <div class="admin-metric-row">
                        <span>공예</span>
                        <strong>4,380,000원</strong>
                        <em><i style="width: 64%;"></i></em>
                    </div>
                    <div class="admin-metric-row">
                        <span>홈리빙</span>
                        <strong>3,540,000원</strong>
                        <em><i style="width: 52%;"></i></em>
                    </div>
                    <div class="admin-metric-row">
                        <span>패션/주얼리</span>
                        <strong>2,460,000원</strong>
                        <em><i style="width: 36%;"></i></em>
                    </div>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>상품 판매 순위</h3>
                </div>
                <div class="admin-list">
                    <a href="/admin/products?keyword=베이커리&page=1" class="admin-list-item">
                        <span>프리미엄 베이커리 박스</span>
                        <strong>38건</strong>
                    </a>
                    <a href="/admin/products?keyword=초콜릿&page=1" class="admin-list-item">
                        <span>초콜릿 선물상자</span>
                        <strong>31건</strong>
                    </a>
                    <a href="/admin/products?keyword=도시락&page=1" class="admin-list-item">
                        <span>프리미엄 도시락 세트</span>
                        <strong>27건</strong>
                    </a>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>판매자 매출 순위</h3>
                </div>
                <div class="admin-list">
                    <a href="/admin/sellers?keyword=그린테이블&page=1" class="admin-list-item">
                        <span>그린테이블</span>
                        <strong>4,820,000원</strong>
                    </a>
                    <a href="/admin/sellers?keyword=디어캔들랩&page=1" class="admin-list-item">
                        <span>디어캔들랩</span>
                        <strong>3,260,000원</strong>
                    </a>
                    <a href="/admin/sellers?keyword=라온핸드&page=1" class="admin-list-item">
                        <span>라온핸드</span>
                        <strong>2,940,000원</strong>
                    </a>
                </div>
            </article>

            <article class="admin-card">
                <div class="admin-card-head">
                    <h3>회원 현황</h3>
                </div>
                <div class="admin-list">
                    <a href="/admin/members?role=user&page=1" class="admin-list-item">
                        <span>일반회원</span>
                        <strong>28명</strong>
                    </a>
                    <a href="/admin/members?role=seller&page=1" class="admin-list-item">
                        <span>판매자 회원</span>
                        <strong>27명</strong>
                    </a>
                    <a href="/admin/members?status=suspended&page=1" class="admin-list-item">
                        <span>정지 회원</span>
                        <strong>2명</strong>
                    </a>
                </div>
            </article>
        </section>
    </main>
</div>
</body>
</html>
