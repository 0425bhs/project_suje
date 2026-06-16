<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>공지사항</title>
    <link rel="stylesheet" href="/css/order-payment.css">
    <style>
        .community-page {
            min-height: calc(100vh - 153px);
        }

        .community-card {
            background: #fff;
            border: 1px solid #f0e5dc;
            padding: 26px;
        }

        .notice-table .title-cell {
            text-align: left;
        }

        .notice-title-link {
            color: #2b2b2b;
            font-size: 15px;
            font-weight: 900;
            text-decoration: none !important;
        }

        .notice-title-link:hover {
            color: #ff6f4f;
        }

        .notice-number {
            color: #8a6b5a;
            font-weight: 900;
        }

        .empty-order {
            height: 150px;
        }

        @media (max-width: 720px) {
            .community-card {
                overflow-x: auto;
            }

            .order-table {
                min-width: 700px;
            }
        }
    </style>
</head>

<body>
<header class="site-header">
    <div class="header-inner">
        <a class="brand" href="/main.do">HAND<span>MADE</span></a>

        <nav class="main-nav">
            <a href="/product/main.do">상품보기</a>
            <a href="/live_review_list.do">후기</a>
            <a href="/mypage/qna">문의</a>
            <a href="/notice_list.do">공지사항</a>
        </nav>

        <div class="header-actions">
            <a href="/notice_list.do">고객센터</a>
            <a href="/myshop/orders">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>NOTICE</span>
                <h2>공지사항</h2>
                <p>서비스 운영 안내와 주요 소식을 확인할 수 있습니다.</p>
            </div>

            <a class="btn primary" href="/notice_form.do">공지사항 작성</a>
        </div>

        <section class="community-card">
            <div class="table-wrap">
                <table class="order-table notice-table">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성일</th>
                            <th>수정일</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:choose>
                            <c:when test="${empty list}">
                                <tr>
                                    <td colspan="4" class="empty-order">등록된 공지사항이 없습니다.</td>
                                </tr>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="notice" items="${list}">
                                    <tr>
                                        <td><span class="notice-number">#${notice.notice_id}</span></td>
                                        <td class="title-cell">
                                            <a class="notice-title-link" href="/notice_detail.do?notice_id=${notice.notice_id}">${notice.title}</a>
                                        </td>
                                        <td>${notice.created_at}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty notice.updated_at}">-</c:when>
                                                <c:otherwise>${notice.updated_at}</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</main>

<footer class="site-footer">
    <div class="footer-inner">
        <strong>HANDMADE</strong>
        <p>공지사항을 통해 서비스 안내와 운영 소식을 전달합니다.</p>
    </div>
</footer>
</body>
</html>
