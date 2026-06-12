<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>실시간 리뷰</title>
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

        .review-table .product-cell {
            text-align: left;
        }

        .review-product {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .review-product img {
            width: 72px;
            height: 72px;
            object-fit: cover;
            display: block;
            background: #f6f6f6;
            border: 1px solid #f0e5dc;
        }

        .review-product strong {
            display: block;
            color: #2b2b2b;
            font-size: 15px;
            font-weight: 900;
            line-height: 1.45;
        }

        .review-content {
            max-width: 430px;
            color: #555;
            line-height: 1.7;
            text-align: left;
            word-break: keep-all;
        }

        .rating-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 68px;
            height: 30px;
            padding: 0 12px;
            background: #fff0e7;
            color: #d85b35;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 900;
        }

        .table-action {
            height: 38px;
            padding: 0 16px;
        }

        .empty-order {
            height: 150px;
        }

        @media (max-width: 760px) {
            .community-card {
                overflow-x: auto;
            }

            .order-table {
                min-width: 760px;
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
            <a href="/my_review_list.do">내 후기</a>
            <a href="/order/my">주문내역</a>
        </div>
    </div>
</header>

<main class="page-block soft community-page">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>LIVE REVIEW</span>
                <h2>실시간 리뷰</h2>
                <p>최근 등록된 상품 후기를 한눈에 확인할 수 있습니다.</p>
            </div>

            <a class="btn light" href="/my_review_list.do">내 후기 보기</a>
        </div>

        <section class="community-card">
            <div class="table-wrap">
                <table class="order-table review-table">
                    <thead>
                        <tr>
                            <th>상품</th>
                            <th>리뷰 내용</th>
                            <th>별점</th>
                            <th>작성 일시</th>
                            <th>관리</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:choose>
                            <c:when test="${empty list}">
                                <tr>
                                    <td colspan="5" class="empty-order">아직 등록된 리뷰가 없습니다.</td>
                                </tr>
                            </c:when>

                            <c:otherwise>
                                <c:forEach var="review" items="${list}">
                                    <tr>
                                        <td class="product-cell">
                                            <div class="review-product">
                                                <img src="${review.image_s}" alt="${review.product_name}">
                                                <strong>${review.product_name}</strong>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="review-content">${review.content}</div>
                                        </td>
                                        <td><span class="rating-pill">${review.rating}점</span></td>
                                        <td>${review.created_at}</td>
                                        <td>
                                            <button type="button" class="btn dark table-action" onclick="location.href='report_form.do?target_type=REVIEW&target_id=${review.review_id}'">신고</button>
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
        <p>작가 상품을 둘러보고 구매 경험을 공유할 수 있습니다.</p>
    </div>
</footer>
</body>
</html>
