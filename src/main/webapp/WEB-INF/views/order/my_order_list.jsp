<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>내 주문 내역</title>
        <link rel="stylesheet" href="/css/order-payment.css">
    </head>

    <body>

    <header class="site-header">
        <div class="header-inner">
            <div class="brand">HAND<span>MADE</span></div>

            <nav class="main-nav">
                <a href="#">선물추천</a>
                <a href="#">베스트</a>
                <a href="#">취향발견</a>
                <a href="#">최신작품</a>
                <a href="#">작가</a>
                <a href="#">커뮤니티</a>
            </nav>

            <div class="header-actions">
                <a href="/order/form">주문서 작성</a>
                <a href="/order/my">주문내역</a>
                <a href="#">장바구니</a>
            </div>
        </div>
    </header>

    <section class="hero-order">
        <div class="block-inner hero-inner">
            <div class="hero-copy">
                <span class="hero-label">CREATOR MARKET ORDER</span>
                <h1>핸드메이드 상품 주문을 확인하세요</h1>
                <p>
                    작가가 직접 만든 상품의 주문 정보, 결제 상태, 배송 진행 상황을
                    한 화면에서 자연스럽게 확인할 수 있습니다.
                </p>

                <div class="hero-tags">
                    <span>주문 확인</span>
                    <span>결제 진행</span>
                    <span>작가 제작 준비</span>
                    <span>배송 조회</span>
                </div>
            </div>

            <div class="hero-card">
                <strong>주문 진행 흐름</strong>

                <div class="hero-flow">
                    <div>
                        <span>01</span>
                        <p>주문 정보 확인</p>
                    </div>

                    <div>
                        <span>02</span>
                        <p>결제 진행</p>
                    </div>

                    <div>
                        <span>03</span>
                        <p>상품 준비</p>
                    </div>

                    <div>
                        <span>04</span>
                        <p>배송 상태 확인</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="page-block soft">
        <div class="block-inner">
            <div class="page-title-row">
                <div>
                    <span>MY ORDER</span>
                    <h2>내 주문 내역</h2>
                </div>
                <p>내가 주문한 핸드메이드 상품의 결제와 배송 상태를 확인합니다.</p>
            </div>

            <div class="order-filter">
                <button class="active">전체</button>
                <button>결제완료</button>
                <button>준비중</button>
                <button>배송중</button>
                <button>취소</button>
            </div>

            <div class="table-wrap">
                <table class="order-table">
                    <tr>
                        <th>주문번호</th>
                        <th>결제금액</th>
                        <th>주문상태</th>
                        <th>주문일</th>
                        <th>관리</th>
                    </tr>

                    <c:forEach var="order" items="${orderList}">
                        <tr>
                            <td>${order.order_id}</td>
                            <td>${order.total_amount}원</td>
                            <td>
                                <span class="badge ${order.status}">
                                    <c:choose>
                                        <c:when test="${order.status eq 'PENDING'}">주문 접수</c:when>
                                        <c:when test="${order.status eq 'PAID'}">결제 완료</c:when>
                                        <c:when test="${order.status eq 'PREPARING'}">제작/배송 준비중</c:when>
                                        <c:when test="${order.status eq 'SHIPPING'}">배송중</c:when>
                                        <c:when test="${order.status eq 'DELIVERED'}">배송 완료</c:when>
                                        <c:when test="${order.status eq 'CANCELLED'}">주문 취소</c:when>
                                        <c:otherwise>${order.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>${order.created_at}</td>
                            <td>
                                <a href="/order/detail?order_id=${order.order_id}">상세보기</a>

                                <c:if test="${order.status eq 'PENDING'}">
                                    <a href="/payment/ready?order_id=${order.order_id}">결제하기</a>
                                </c:if>

                                <c:if test="${order.status ne 'PENDING'}">
                                    <a href="/order/delivery?order_id=${order.order_id}">배송조회</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
    </section>

    <footer class="site-footer">
        <div class="footer-inner">
            <strong>HANDMADE</strong>
            <p>작가의 손길이 담긴 상품을 주문하고 결제하는 공간입니다.</p>
        </div>
    </footer>

    </body>
</html>