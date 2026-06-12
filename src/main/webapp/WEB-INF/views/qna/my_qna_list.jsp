<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>내 문의 목록</title>

    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/order-payment.css?v=3">

    <style>
        .qna-list-card {
            background: #fff;
            border: 1px solid #f0e5dc;
            border-radius: 18px;
            padding: 24px;
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
            border-radius: 14px;
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
            text-decoration: none;
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

        .empty-qna {
            height: 150px;
            color: #777;
            font-weight: 700;
        }

        @media (max-width: 860px) {
            .qna-list-card {
                overflow-x: auto;
            }

            .qna-table {
                min-width: 860px;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="qna" />
</jsp:include>

<section class="myshop-page">
    <div class="myshop-layout">

        <!-- 왼쪽 사이드바 -->
        <jsp:include page="/WEB-INF/views/order/common/myshop_sidebar.jsp" />

        <main class="myshop-content">

            <!-- 회원 요약 카드 -->
            <jsp:include page="/WEB-INF/views/order/common/myshop_user_card.jsp">
                <jsp:param name="label" value="MY QNA" />
                <jsp:param name="count" value="${totalCount}" />
            </jsp:include>

            <!-- 빠른 메뉴 -->
            <jsp:include page="/WEB-INF/views/order/common/myshop_quick_card.jsp" />

            <section class="myshop-review-section myshop-qna-section">

                <div class="myshop-section-head">
                    <div>
                        <h2>내 문의 목록</h2>
                        <p>상품 문의 내용과 답변 여부를 한눈에 확인할 수 있습니다.</p>
                    </div>

                    <a href="/product/main.do">상품 보러가기</a>
                </div>

                <section class="qna-list-card">
                    <div class="table-wrap">
                        <table class="qna-table">
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
                                            <td colspan="6" class="empty-qna">
                                                아직 작성한 문의가 없습니다.
                                            </td>
                                        </tr>
                                    </c:when>

                                    <c:otherwise>
                                        <c:forEach var="qna" items="${list}">
                                            <tr>
                                                <td class="product-cell">
                                                    <div class="qna-product">
                                                        <c:choose>
                                                            <c:when test="${not empty qna.image_s}">
                                                                <img src="${qna.image_s}" alt="${qna.product_name}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="/images/no_image.png" alt="이미지 없음">
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <strong>${qna.product_name}</strong>
                                                    </div>
                                                </td>

                                                <td class="title-cell">
                                                    <a class="title-link" href="qna_detail.do?qna_id=${qna.qna_id}">
                                                        ${qna.title}
                                                    </a>
                                                </td>

                                                <td class="answer-cell">
                                                    <div class="answer-preview">
                                                        <c:choose>
                                                            <c:when test="${empty qna.answer}">
                                                                아직 답변이 등록되지 않았습니다.
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${qna.answer}
                                                            </c:otherwise>
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

            </section>

        </main>

    </div>
</section>

<footer class="site-footer">
    <div class="footer-inner">
        <strong>HANDMADE</strong>
        <p>상품 문의와 답변을 통해 구매 전 궁금한 내용을 확인할 수 있습니다.</p>
    </div>
</footer>

</body>
</html>