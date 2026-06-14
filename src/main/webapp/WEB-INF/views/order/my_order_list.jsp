<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>마이쇼핑 대시보드 - HANDMADE</title>

    <%-- 기존 스타일시트 유지 --%>
    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/order-payment.css?v=3">
    
    <%-- 대시보드 전용 스타일시트 --%>
    <style>
        /* 대시보드 메인 레이아웃 */
        .myshop-dashboard-content {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        /* 1. 상단 회원 환영 바 */
        .dashboard-welcome-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(to right, #ffffff, #fdfbfb);
            padding: 24px 32px;
            border-radius: 16px;
            border: 1px solid #eaeaea;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }
        .user-info-basic { display: flex; align-items: center; gap: 16px; }
        .user-avatar { width: 56px; height: 56px; background-color: #f5f5f5; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 26px; }
        .user-name-email strong { font-size: 18px; color: #222; font-weight: 700; letter-spacing: -0.3px; }
        .user-name-email span { font-size: 14px; color: #888; display: block; margin-top: 4px; }
        .welcome-msg { font-size: 18px; font-weight: 600; color: #333; letter-spacing: -0.3px; }

        /* 2. 종합 현황 카드 영역 */
        .dashboard-status-cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }
        .status-card {
            background-color: #fff;
            padding: 24px 20px;
            border-radius: 16px;
            border: 1px solid #eaeaea;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.01);
        }
        .status-card:hover { 
            border-color: #ff6b6b; 
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(255, 107, 107, 0.08);
        }
        .status-card .icon { font-size: 32px; margin-bottom: 12px; display: inline-block; }
        .status-card h4 { font-size: 14px; color: #666; margin-bottom: 8px; font-weight: 500; }
        .status-card strong { font-size: 26px; color: #222; font-weight: 700; display: block; letter-spacing: -0.5px; }
        .status-card .sub-info { font-size: 12px; color: #a0a0a0; margin-top: 8px; display: block; }

        /* 3. 하단 2단 레이아웃 */
        .dashboard-lower-layout {
            display: grid;
            grid-template-columns: 1.2fr 1fr; /* 폼이 더 예쁘게 떨어지도록 비율 미세조정 */
            gap: 24px;
            align-items: start;
        }

        /* 하단 공통 섹션 스타일 */
        .dashboard-section {
            background-color: #fff;
            padding: 28px;
            border-radius: 16px;
            border: 1px solid #eaeaea;
            box-shadow: 0 2px 8px rgba(0,0,0,0.01);
        }
        .dashboard-section-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .dashboard-section-head h3 { font-size: 18px; color: #222; font-weight: 700; display: flex; align-items: center; letter-spacing: -0.5px; }
        .dashboard-section-head h3 span { color: #ff6b6b; font-weight: 600; font-size: 15px; margin-left: 6px;}
        .view-all-btn { font-size: 13px; color: #888; text-decoration: none; display: inline-flex; align-items: center; transition: color 0.2s;}
        .view-all-btn:hover { color: #ff6b6b; }

        .more-btn-wrap { text-align: center; margin-top: 24px; }
        .more-btn { background: #fff; border: 1px solid #ddd; padding: 10px 24px; border-radius: 30px; color: #555; font-size: 13px; font-weight: 500; cursor: pointer; transition: all 0.2s; }
        .more-btn:hover { background-color: #f9f9f9; border-color: #ccc; color: #222; }

        /* 주문 내역 리스트 (인라인 스타일 분리 및 개선) */
        .dashboard-order-card {
            border: 1px solid #eaeaea;
            margin-bottom: 16px;
            border-radius: 12px;
            overflow: hidden;
            transition: border-color 0.2s;
        }
        .dashboard-order-card:hover { border-color: #ddd; }
        .dashboard-order-card:last-child { margin-bottom: 0; }

        .myshop-order-top {
            background-color: #fcfcfc;
            padding: 14px 20px;
            border-bottom: 1px solid #eaeaea;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
        }
        .myshop-status-badge { font-weight: 700; color: #ff6b6b; margin-right: 10px; }
        .myshop-order-top span { color: #777; }
        .myshop-order-top a { color: #666; text-decoration: none; font-weight: 500; transition: color 0.2s; }
        .myshop-order-top a:hover { color: #222; }

        .myshop-order-body {
            padding: 20px;
            display: flex;
            gap: 16px;
            align-items: center;
            background-color: #fff;
        }
        .myshop-product-thumb { width: 72px; height: 72px; border: 1px solid #f0f0f0; border-radius: 8px; overflow: hidden; flex-shrink: 0; background-color: #fafafa; }
        .myshop-product-thumb img { width: 100%; height: 100%; object-fit: cover; }

        .myshop-product-info { flex: 1; }
        .myshop-product-info a { text-decoration: none; color: #222; font-weight: 600; font-size: 15px; display: block; margin-bottom: 4px; line-height: 1.3; transition: color 0.2s; }
        .myshop-product-info a:hover { color: #ff6b6b; }
        .myshop-product-info p { color: #888; font-size: 13px; margin: 0 0 8px 0; }
        .myshop-product-info strong { display: block; font-size: 15px; color: #222; font-weight: 700; }

        .myshop-order-actions { display: flex; flex-direction: column; gap: 6px; width: 85px; }
        .myshop-order-actions a { border: 1px solid #ddd; padding: 8px 0; border-radius: 6px; color: #555; text-decoration: none; font-size: 12px; font-weight: 500; text-align: center; background: #fff; transition: all 0.2s; }
        .myshop-order-actions a:hover { background: #f9f9f9; border-color: #ccc; }
        .myshop-order-actions a.primary { background-color: #ff6b6b; color: #fff; border-color: #ff6b6b; }
        .myshop-order-actions a.primary:hover { background-color: #e55a5a; border-color: #e55a5a; }

        /* 오른쪽 활동 알림 사이드바 */
        .activity-sub-section { margin-bottom: 24px; }
        .activity-sub-section:last-child { margin-bottom: 0; }
        .activity-sub-section h4 { font-size: 15px; color: #222; margin-bottom: 12px; font-weight: 600; }

        .compact-prod-list { list-style: none; padding: 0; margin: 0; }
        .compact-prod-list li { display: flex; align-items: center; gap: 12px; padding: 12px 0; border-bottom: 1px solid #f5f5f5; }
        .compact-prod-list li:last-child { border-bottom: none; padding-bottom: 0; }
        .compact-prod-list img { width: 48px; height: 48px; border-radius: 8px; border: 1px solid #f0f0f0; object-fit: cover; background-color: #fafafa; }
        .compact-prod-list .info { flex: 1; }
        .compact-prod-list .info span { font-size: 14px; color: #333; display: block; margin-bottom: 4px; font-weight: 500; }
        .compact-prod-list .info .action { font-size: 12px; color: #ff6b6b; font-weight: 600; cursor: pointer; }
        .compact-prod-list .info .stars { font-size: 12px; color: #ffc107; }

        .compact-inquiry { background-color: #fbfbfb; padding: 16px; border-radius: 12px; border: 1px solid #eaeaea; }
        .compact-inquiry p { margin: 0 0 6px 0; color: #222; font-size: 14px; font-weight: 600; }
        .compact-inquiry .status { color: #ff6b6b; font-size: 13px; font-weight: 600; }
        .compact-inquiry .type { color: #a0a0a0; font-size: 12px; margin-left: 8px; }

        .recent-prod-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
        .recent-prod-grid .prod-item { border: 1px solid #eaeaea; border-radius: 8px; aspect-ratio: 1; background-color: #fafafa; display: flex; align-items: center; justify-content: center; color: #ccc; font-size: 12px; overflow: hidden; transition: border-color 0.2s; }
        .recent-prod-grid .prod-item:hover { border-color: #ccc; }
    </style>

    <%-- 기존 스크립트 유지 --%>
    <script src="/js/product_main.js" defer></script>
    <script src="/js/order-payment.js" defer></script>
</head>

<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="order" />
</jsp:include>

<section class="myshop-page">
    <div class="myshop-layout">

        <!-- 왼쪽 사이드바 (기존 유지) -->
        <jsp:include page="/WEB-INF/views/order/common/myshop_sidebar.jsp" />

        <!-- 오른쪽 본문 -->
        <main class="myshop-content myshop-dashboard-content">

            <!-- 1. 상단 회원 환영 바 -->
            <div class="dashboard-welcome-bar">
                <div class="user-info-basic">
                    <div class="user-avatar">👤</div>
                    <div class="user-name-email">
                        <strong>${sessionScope.loginMember.name}님</strong>
                        <span>${sessionScope.loginMember.email}</span>
                    </div>
                </div>
                <div class="welcome-msg">안녕하세요, ${sessionScope.loginMember.name}님!</div>
            </div>

            <!-- 2. 종합 현황 카드 영역 -->
            <section class="dashboard-status-cards">
                
                <%-- 주문 현황 카드 --%>
                <div class="status-card" onclick="location.href='/order/my'">
                    <span class="icon">📦</span>
                    <h4>나의 주문 현황</h4>
                    <strong>${totalCount}건</strong>
                    <span class="sub-info">결제대기 ${pendingCount} / 배송중 ${shippingCount} / 배송완료 ${deliveredCount}</span>
                </div>

                <%-- 리뷰 관리 카드 --%>
                <div class="status-card" onclick="location.href='/mypage/review'">
                    <span class="icon">⭐</span>
                    <h4>리뷰 관리</h4>
                    <strong>12건</strong>
                    <span class="sub-info">작성 가능: 3건</span>
                </div>

                <%-- 문의 현황 카드 --%>
                <div class="status-card" onclick="location.href='/mypage/qna'">
                    <span class="icon">💬</span>
                    <h4>문의 현황</h4>
                    <strong>4건</strong>
                    <span class="sub-info">미답변: 0건</span>
                </div>

                <%-- 관심 상품 카드 --%>
                <div class="status-card" onclick="alert('찜한 상품 기능은 준비중입니다.');">
                    <span class="icon">♡</span>
                    <h4>관심 상품</h4>
                    <strong>18건</strong>
                </div>

            </section>

            <!-- 3. 하단 2단 본문 레이아웃 -->
            <div class="dashboard-lower-layout">

                <!-- ================= 왼쪽: 최근 주문 내역 시작 ================= -->
                <section class="dashboard-section dashboard-recent-orders">
                    
                    <div class="dashboard-section-head">
                        <h3>[최근 주문 내역]</h3>
                        <a href="/order/my" class="view-all-btn">전체보기 ></a>
                    </div>

                    <c:choose>
                        <c:when test="${empty orderList}">
                            <div class="myshop-empty-order" style="padding: 50px 0; text-align: center; color: #999;">
                                최근 주문 내역이 없습니다.
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="myshop-order-list dashboard-list-compact">
                                <%-- 최근 3건만 출력 --%>
                                <c:forEach var="order" items="${orderList}" varStatus="status">
                                    <c:if test="${status.index < 3}"> 

                                        <c:set var="items" value="${orderItemMap[order.order_id]}" />
                                        <c:set var="mainItem" value="${items[0]}" />

                                        <article class="myshop-order-card dashboard-order-card" style="border: 1px solid #eee; margin-bottom: 15px; border-radius: 8px;">
                                            <div class="myshop-order-top" style="background-color: #fcfcfc; padding: 10px 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; font-size: 13px;">
                                                <div>
                                                    <strong class="myshop-status-badge ${order.status}" style="font-weight: bold; color: #ff6b6b; margin-right: 10px;">
                                                        <c:choose>
                                                            <c:when test="${order.status eq 'PENDING'}">주문 접수</c:when>
                                                            <c:when test="${order.status eq 'PAID'}">결제 완료</c:when>
                                                            <c:when test="${order.status eq 'PREPARING'}">제작 준비중</c:when>
                                                            <c:when test="${order.status eq 'SHIPPING'}">배송중</c:when>
                                                            <c:when test="${order.status eq 'DELIVERED'}">배송 완료</c:when>
                                                            <c:when test="${order.status eq 'CANCELLED'}">주문 취소</c:when>
                                                            <c:otherwise>${order.status}</c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                    <span style="color: #777;">${order.created_at} · 주문번호 #${order.order_id}</span>
                                                </div>
                                                <a href="/order/detail?order_id=${order.order_id}" style="color: #555; text-decoration: none;">주문상세 ></a>
                                            </div>

                                            <div class="myshop-order-body" style="padding: 15px; display: flex; gap: 15px; align-items: center;">
                                                <div class="myshop-product-thumb" style="width: 70px; height: 70px; border: 1px solid #eee; border-radius: 4px; overflow: hidden;">
                                                    <c:choose>
                                                        <c:when test="${not empty mainItem and not empty mainItem.imageS and mainItem.imageS ne 'no_file'}">
                                                            <img src="${mainItem.imageS}" alt="${mainItem.productName}" style="width: 100%; height: 100%; object-fit: cover;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="/images/no_image.png" alt="이미지 없음" style="width: 100%; height: 100%; object-fit: cover;">
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="myshop-product-info" style="flex: 1; font-size: 14px;">
                                                    <c:choose>
                                                        <c:when test="${not empty mainItem}">
                                                            <a href="/product_detail.do?product_id=${mainItem.product_id}" style="text-decoration: none; color: #333; font-weight: 500;">
                                                                ${mainItem.productName}
                                                                <c:if test="${fn:length(items) > 1}">
                                                                    외 ${fn:length(items) - 1}건
                                                                </c:if>
                                                            </a>
                                                            <p style="color: #888; font-size: 13px; margin-top: 4px;">
                                                                수량 ${mainItem.quantity}개 ·
                                                                <fmt:formatNumber value="${mainItem.price}" pattern="#,###"/>원
                                                            </p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <strong>주문 상품 정보 없음</strong>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <strong style="display: block; margin-top: 8px; font-size: 15px;">
                                                        총 결제금액 <fmt:formatNumber value="${order.total_amount}" pattern="#,###"/>원
                                                    </strong>
                                                </div>

                                                <div class="myshop-order-actions" style="display: flex; flex-direction: column; gap: 5px;">
                                                    <a href="/order/detail?order_id=${order.order_id}" style="border: 1px solid #ddd; padding: 5px 12px; border-radius: 4px; color: #555; text-decoration: none; font-size: 12px; text-align: center;">
                                                        상세보기
                                                    </a>
                                                    <c:if test="${order.status eq 'PENDING'}">
                                                        <a href="/payment/ready?order_id=${order.order_id}" class="primary" style="background-color: #ff6b6b; color: #fff; border: 1px solid #ff6b6b; padding: 5px 12px; border-radius: 4px; text-decoration: none; font-size: 12px; text-align: center;">
                                                            결제하기
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </article>

                                    </c:if>
                                </c:forEach>
                            </div>
                            
                            <div class="more-btn-wrap">
                                <button type="button" class="more-btn" onclick="location.href='/order/my'">더보기</button>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </section>
                <!-- ================= 왼쪽: 최근 주문 내역 끝 ================= -->

                <!-- ================= 오른쪽: 최근 활동 알림 시작 ================= -->
                <aside class="dashboard-activity-sidebar">
                                    
                    <%-- 1. 나의 혜택 요약 (추가 제안) --%>
                    <section class="dashboard-section" style="margin-bottom: 24px; padding: 20px;">
                        <div class="dashboard-section-head" style="margin-bottom: 15px;">
                            <h3 style="font-size: 16px;">나의 쇼핑 혜택</h3>
                        </div>
                        <div style="display: flex; gap: 10px;">
                            <div style="flex: 1; background: #fff4f4; padding: 15px; border-radius: 8px; text-align: center;">
                                <span style="font-size: 12px; color: #ff6b6b; font-weight: 600; display: block; margin-bottom: 4px;">적립금</span>
                                <strong style="font-size: 16px; color: #222;">2,500<span style="font-size: 13px; font-weight: normal;">원</span></strong>
                            </div>
                            <div style="flex: 1; background: #f4f6ff; padding: 15px; border-radius: 8px; text-align: center;">
                                <span style="font-size: 12px; color: #4a6ee0; font-weight: 600; display: block; margin-bottom: 4px;">쿠폰</span>
                                <strong style="font-size: 16px; color: #222;">2<span style="font-size: 13px; font-weight: normal;">장</span></strong>
                            </div>
                        </div>
                    </section>

                    <%-- 2. 작성 가능한 리뷰 (워딩 변경) --%>
                    <section class="dashboard-section" style="margin-bottom: 24px;">
                        <div class="dashboard-section-head">
                            <h3>작성 가능한 리뷰</h3>
                            <a href="/mypage/review" class="view-all-btn">더보기 &gt;</a>
                        </div>
                        <ul class="compact-prod-list" style="list-style: none; padding: 0;">
                            <li style="display: flex; align-items: center; gap: 10px; padding: 8px 0;">
                                <img src="/images/tmp_prod_1.jpg" alt="" style="width: 48px; height: 48px; border-radius: 6px; background-color: #eee; object-fit: cover;">
                                <div style="flex: 1;">
                                    <span style="font-size: 13px; color: #333; display: block; margin-bottom: 4px;">핸드메이드 코스튬 자켓</span>
                                    <a href="/mypage/review/write" style="font-size: 12px; color: #ff6b6b; font-weight: 600; text-decoration: none;">✏️ 리뷰 쓰고 500원 받기</a>
                                </div>
                            </li>
                        </ul>
                    </section>

                    <%-- 3. 최근 내 문의 --%>
                    <section class="dashboard-section" style="margin-bottom: 24px;">
                        <div class="dashboard-section-head">
                            <h3>최근 내 문의</h3>
                            <a href="/mypage/qna" class="view-all-btn">더보기 &gt;</a>
                        </div>
                        <div class="compact-inquiry" style="background-color: #fcfcfc; padding: 12px; border-radius: 8px; border: 1px solid #eaeaea; font-size: 13px;">
                            <p style="margin: 0 0 6px 0; color: #222; font-weight: 600;">배송 지연 문의드립니다.</p>
                            <span style="color: #ff6b6b; font-size: 12px; font-weight: 600;">답변 완료</span>
                            <span style="color: #999; font-size: 12px; margin-left: 8px;">2023.10.25</span>
                        </div>
                    </section>

                    <%-- 4. 공지사항 (추가 제안) --%>
                    <section class="dashboard-section" style="margin-bottom: 24px; padding: 20px;">
                        <div class="dashboard-section-head" style="margin-bottom: 12px;">
                            <h3 style="font-size: 15px;">📢 공지사항</h3>
                        </div>
                        <ul style="list-style: none; padding: 0; margin: 0; font-size: 13px;">
                            <li style="margin-bottom: 8px;"><a href="#" style="color: #555; text-decoration: none;">[안내] 설 연휴 배송 일정 안내</a></li>
                            <li><a href="#" style="color: #555; text-decoration: none;">[이벤트] 신규 가입 10% 쿠폰 지급</a></li>
                        </ul>
                    </section>

                    <%-- 5. 최근 본 상품 --%>
                    <section class="dashboard-section recently-viewed">
                        <div class="dashboard-section-head">
                            <h3>최근 본 상품 <span>(4)</span></h3>
                            <a href="/mypage/recent" class="view-all-btn">더보기 &gt;</a>
                        </div>
                        <div class="recent-prod-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;">
                            <div class="prod-item" style="border: 1px solid #eee; border-radius: 4px; aspect-ratio: 1; background-color: #f9f9f9; display: flex; align-items: center; justify-content: center; color: #ccc;">img</div>
                            <div class="prod-item" style="border: 1px solid #eee; border-radius: 4px; aspect-ratio: 1; background-color: #f9f9f9; display: flex; align-items: center; justify-content: center; color: #ccc;">img</div>
                            <div class="prod-item" style="border: 1px solid #eee; border-radius: 4px; aspect-ratio: 1; background-color: #f9f9f9; display: flex; align-items: center; justify-content: center; color: #ccc;">img</div>
                            <div class="prod-item" style="border: 1px solid #eee; border-radius: 4px; aspect-ratio: 1; background-color: #f9f9f9; display: flex; align-items: center; justify-content: center; color: #ccc;">img</div>
                        </div>
                    </section>

                </aside>
                <!-- ================= 오른쪽: 최근 활동 알림 끝 ================= -->

            </div>

        </main>
    </div>
</section>

<!-- 중요: 결제취소 모달 (필요시 사용) -->
<div class="cancel-modal-wrap" id="cancelModal" style="display: none;">
    <div class="cancel-modal-bg" onclick="closeCancelModal()"></div>
    <div class="cancel-modal-box">
        <div class="cancel-modal-head">
            <div>
                <span>PAYMENT CANCEL</span>
                <h3>결제취소 요청</h3>
                <p>취소 사유와 안내사항을 확인해주세요.</p>
            </div>
            <button type="button" class="cancel-modal-close" onclick="closeCancelModal()">×</button>
        </div>

        <div class="cancel-modal-body">
            <div class="cancel-info-row">
                <span>주문번호</span>
                <strong id="cancelOrderIdText">#</strong>
            </div>
            <div class="cancel-info-row">
                <span>결제금액</span>
                <strong id="cancelAmountText">0원</strong>
            </div>
            <div class="cancel-form-row">
                <label for="cancelReason">취소 사유</label>
                <select id="cancelReason">
                    <option value="">취소 사유를 선택해주세요</option>
                    <option value="단순 변심">단순 변심</option>
                    <option value="상품을 잘못 주문함">상품을 잘못 주문함</option>
                    <option value="배송 일정 변경">배송 일정 변경</option>
                    <option value="다른 상품으로 재주문 예정">다른 상품으로 재주문 예정</option>
                    <option value="기타">기타</option>
                </select>
            </div>
            <div class="cancel-form-row">
                <label for="cancelDetail">상세 사유</label>
                <textarea id="cancelDetail" placeholder="상세 사유를 입력해주세요. 선택 입력입니다."></textarea>
            </div>
            <div class="cancel-guide-box">
                <strong>결제취소 안내</strong>
                <ul>
                    <li>결제취소가 완료되면 주문 상태가 <b>주문 취소</b>로 변경됩니다.</li>
                    <li>환불은 결제 수단과 카드사 정책에 따라 처리 시간이 다를 수 있습니다.</li>
                    <li>이미 제작 또는 배송이 시작된 주문은 취소가 제한될 수 있습니다.</li>
                    <li>취소 요청 후에는 동일 주문으로 다시 결제할 수 없습니다.</li>
                </ul>
            </div>
            <label class="cancel-agree">
                <input type="checkbox" id="cancelAgree"> 결제취소 안내사항을 확인했습니다.
            </label>
        </div>

        <div class="cancel-modal-actions">
            <button type="button" class="cancel-close-btn" onclick="closeCancelModal()">닫기</button>
            <form action="/payment/toss/cancel" method="post" id="cancelForm">
                <input type="hidden" name="order_id" id="cancelOrderId">
                <input type="hidden" name="cancel_reason" id="cancelReasonInput">
                <button type="button" class="cancel-submit-btn" onclick="submitCancelForm()">결제취소 요청</button>
            </form>
        </div>
    </div>
</div>

<script>
    // 결제 취소 모달 스크립트 예시 (기존 유지)
    function openCancelModal(orderId, amount) {
        document.getElementById('cancelOrderIdText').innerText = '#' + orderId;
        document.getElementById('cancelOrderId').value = orderId;
        document.getElementById('cancelAmountText').innerText = amount + '원';
        document.getElementById('cancelModal').style.display = 'block';
    }

    function closeCancelModal() {
        document.getElementById('cancelModal').style.display = 'none';
    }

    function submitCancelForm() {
        // 유효성 검사 로직
        if(!document.getElementById('cancelReason').value) {
            alert('취소 사유를 선택해주세요.');
            return;
        }
        if(!document.getElementById('cancelAgree').checked) {
            alert('결제취소 안내사항에 동의해주세요.');
            return;
        }
        document.getElementById('cancelReasonInput').value = document.getElementById('cancelReason').value;
        document.getElementById('cancelForm').submit();
    }
</script>

</body>
</html>