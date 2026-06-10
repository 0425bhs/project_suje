<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>내 후기 목록</title>
    <link rel="stylesheet" href="/css/order-payment.css">
    <style>
        .community-page {
            min-height: calc(100vh - 153px);
        }

        .community-card {
            background: #fff;
            border: 1px solid #f0e5dc;
            padding: 26px;
            border-radius: 8px; /* 카드 모서리 부드럽게 */
        }

        .review-list {
            display: grid;
            gap: 16px;
        }

        .review-item {
            display: grid;
            grid-template-columns: 112px minmax(0, 1fr) auto;
            gap: 24px;
            align-items: start; /* 썸네일이 상단에 맞춰지도록 변경 */
            padding: 20px;
            border: 1px solid #f0e5dc;
            background: #fff;
            border-radius: 8px; /* 아이템 모서리 부드럽게 */
            transition: background 0.2s ease;
        }

        .review-item:hover {
            background: #fffaf7;
        }

        .review-thumb {
            width: 112px;
            height: 112px;
            object-fit: cover;
            display: block;
            background: #f6f6f6;
            border: 1px solid #f0e5dc;
            border-radius: 8px; /* 썸네일 둥글게 */
        }

        .review-body {
            display: flex;
            flex-direction: column;
            gap: 12px; /* 요소들 사이 간격 균일화 */
        }

        .review-body h3 {
            margin: 0;
            color: #2b2b2b;
            font-size: 18px;
            font-weight: 900;
            line-height: 1.4;
        }

        .review-body p {
            margin: 0;
            color: #555;
            font-size: 14px;
            line-height: 1.7;
            word-break: keep-all;
        }

        /* 리뷰 첨부 이미지 목록 스타일 추가 */
        .review-photo-list {
            display: flex;
            flex-wrap: wrap; /* 창이 좁아지면 자연스럽게 줄바꿈 */
            gap: 10px;
            margin-bottom: 4px;
        }

        .review-photo-item {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #eaeaec;
            background: #fafafa;
        }

        .review-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            color: #8a6b5a;
            font-size: 13px;
            font-weight: 800;
        }

        .rating-pill {
            display: inline-flex;
            align-items: center;
            height: 30px;
            padding: 0 12px;
            background: #fff0e7;
            color: #d85b35;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 900;
        }

        .review-actions {
            display: flex;
            gap: 8px;
            white-space: nowrap;
            padding-top: 4px; /* 버튼 위치 살짝 조정 */
        }

        .review-actions .btn {
            height: 40px;
            padding: 0 16px;
            border-radius: 6px;
        }

        .empty-box {
            min-height: 180px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #888;
            font-weight: 800;
            border: 1px solid #f0e5dc;
            background: #fffaf7;
            border-radius: 8px;
        }

        @media (max-width: 820px) {
            .review-item {
                grid-template-columns: 88px minmax(0, 1fr);
                gap: 16px;
            }

            .review-thumb {
                width: 88px;
                height: 88px;
            }

            .review-actions {
                grid-column: 1 / -1;
                justify-content: flex-end;
                margin-top: 8px;
            }
        }

        @media (max-width: 560px) {
            .review-item {
                grid-template-columns: 1fr;
            }

            .review-thumb {
                width: 100%;
                height: auto;
                aspect-ratio: 1 / 1;
            }

            .review-actions {
                justify-content: stretch;
            }

            .review-actions .btn {
                flex: 1;
            }
            
            .review-photo-item {
                width: 68px; /* 모바일에서는 사진 크기 약간 축소 */
                height: 68px;
            }
        }
    </style>
    <script>
        function del(review_id) {
            if (!confirm("삭제하시겠습니까?")) {
                return;
            }
            location.href = "/review_delete.do?review_id=" + review_id;
        }
    </script>
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
                <span>MY REVIEW</span>
                <h2>내 후기 목록</h2>
                <p>작성한 상품 후기를 확인하고 수정할 수 있습니다.</p>
            </div>
            <a class="btn light" href="/live_review_list.do">실시간 리뷰 보기</a>
        </div>

        <section class="community-card">
            <c:choose>
                <c:when test="${empty list}">
                    <div class="empty-box">아직 작성한 후기가 없습니다.</div>
                </c:when>

                <c:otherwise>
                    <div class="review-list">
                        <c:forEach var="review" items="${list}">
                            <article class="review-item">
                                
                                <img class="review-thumb" src="${review.image_s}" alt="${review.product_name}">
                                
                                <div class="review-body">
                                    <h3>${review.product_name}</h3>
                                    <p>${review.content}</p>

                                    <c:if test="${not empty review.imageList}">
                                        <div class="review-photo-list">
                                            <c:forEach var="image" items="${review.imageList}">
                                                <img class="review-photo-item" src="/upload/${image.image_url}" alt="리뷰 사진">
                                            </c:forEach>
                                        </div>
                                    </c:if>

                                    <div class="review-meta">
                                        <span class="rating-pill">별점 ${review.rating}점</span>
                                        <span>${review.created_at}</span>
                                    </div>
                                </div>

                                <div class="review-actions">
                                    <button type="button" class="btn light" onclick="location.href='review_update_form.do?review_id=${review.review_id}'">수정</button>
                                    <button type="button" class="btn dark" onclick="del('${review.review_id}')">삭제</button>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
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