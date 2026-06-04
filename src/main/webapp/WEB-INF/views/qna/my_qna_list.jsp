<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>내 문의 목록</title>
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

        .qna-table .product-cell,
        .qna-table .title-cell,
        .qna-table .answer-cell {
            text-align: left;
        }

        .qna-product {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .qna-product img {
            width: 72px;
            height: 72px;
            object-fit: cover;
            display: block;
            background: #f6f6f6;
            border: 1px solid #f0e5dc;
        }

        .qna-product strong {
            display: block;
            color: #2b2b2b;
            font-size: 15px;
            font-weight: 900;
            line-height: 1.45;
        }

        .title-link {
            color: #2b2b2b;
            font-size: 15px;
            font-weight: 900;
            text-decoration: none !important;
        }

        .title-link:hover {
            color: #ff6f4f;
        }

        .answer-preview {
            max-width: 320px;
            color: #555;
            line-height: 1.7;
            word-break: keep-all;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 82px;
            height: 30px;
            padding: 0 12px;
            background: #eef4ff;
            color: #2563eb;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
        }

        .status-pill.empty {
            background: #fff0e7;
            color: #d85b35;
        }

        .empty-order {
            height: 150px;
        }

        @media (max-width: 860px) {
            .community-card {
                overflow-x: auto;
            }

            .order-table {
                min-width: 860px;
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
            <a href="/my_qna_list.do">문의</a>
            <a href="/notice_list.do">공지사항</a>
        </nav>

        <div class="header-actions">
            <a href="/my_qna_list.do">내 문의</a>
            <a href="/order/my">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>MY QNA</span>
                <h2>내 문의 목록</h2>
                <p>작성한 상품 문의와 답변 상태를 확인할 수 있습니다.</p>
            </div>
        </div>

        <section class="community-card">
            <div class="table-wrap">
                <table class="order-table qna-table">
                    <thead>
                        <tr>
                            <th>상품</th>
                            <th>제목</th>
                            <th>답변</th>
                            <th>상태</th>
                            <th>작성일</th>
                            <th>답변일</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:choose>
                            <c:when test="${empty list}">
                                <tr>
                                    <td colspan="6" class="empty-order">아직 작성한 문의가 없습니다.</td>
                                </tr>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="qna" items="${list}">
                                    <tr>
                                        <td class="product-cell">
                                            <div class="qna-product">
                                                <img src="${qna.image_s}" alt="${qna.product_name}">
                                                <strong>${qna.product_name}</strong>
                                            </div>
                                        </td>
                                        <td class="title-cell">
                                            <a class="title-link" href="qna_detail.do?qna_id=${qna.qna_id}">${qna.title}</a>
                                        </td>
                                        <td class="answer-cell">
                                            <div class="answer-preview">
                                                <c:choose>
                                                    <c:when test="${empty qna.answer}">아직 답변이 등록되지 않았습니다.</c:when>
                                                    <c:otherwise>${qna.answer}</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty qna.answer}">
                                                    <span class="status-pill empty">답변 대기</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pill">답변 완료</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${qna.created_at}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty qna.answered_at}">-</c:when>
                                                <c:otherwise>${qna.answered_at}</c:otherwise>
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
        <p>상품 문의와 답변을 통해 구매 전 궁금한 내용을 확인할 수 있습니다.</p>
    </div>
</footer>
</body>
</html>
