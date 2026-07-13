<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<aside class="myshop-sidebar">
    <div class="myshop-side-card">

        <a href="/myshop" class="myshop-side-home">
            마이쇼핑
        </a>

        <a href="/user_modify.do" class="myshop-side-profile" aria-label="회원 정보 수정">
            <div class="myshop-side-profile-avatar">
                <c:choose>
                    <c:when test="${not empty sessionScope.user.photo_name and sessionScope.user.photo_name ne 'no_file'}">
                        <img src="/upload/${sessionScope.user.photo_name}"
                             alt="${sessionScope.user.nick_name} 프로필">
                    </c:when>
                    <c:otherwise>
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm7 8a7 7 0 0 0-14 0"/>
                        </svg>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="myshop-side-profile-info">
                <strong>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.nick_name}">
                            ${sessionScope.user.nick_name}님
                        </c:when>
                        <c:when test="${not empty sessionScope.user.name}">
                            ${sessionScope.user.name}님
                        </c:when>
                        <c:otherwise>회원님</c:otherwise>
                    </c:choose>
                </strong>
                <c:if test="${not empty sessionScope.user.email}">
                    <span>${sessionScope.user.email}</span>
                </c:if>
            </div>
        </a>

        <div class="myshop-side-group">
            <strong>내 정보</strong>
            <a href="/user_modify.do" class="${param.activeMenu eq 'user_modify.do' ? 'active' : ''}">회원 정보 수정</a>
            <a href="/addressList.do" class="${param.activeMenu eq 'addressList.do' ? 'active' : ''}">배송지 관리</a>
            <a href="/update_seller.do" class="${param.activeMenu eq 'update_seller.do' ? 'active' : ''}">판매자 신청하기</a>
            <a href="/withdraw.do" class="${param.activeMenu eq 'withdraw.do' ? 'active' : ''}">회원 탈퇴하기</a>
        </div>
        
        <div class="myshop-side-group">
            <strong>주문 관리</strong>
            <a href="/myshop/orders" class="${param.activeMenu eq 'order' ? 'active' : ''}">주문/배송내역</a>
            <a href="/myshop/claim" class="${param.activeMenu eq 'exchange_refund' ? 'active' : ''}">교환/환불내역</a>
        </div>

        <div class="myshop-side-group">
            <strong>리뷰 관리</strong>

            <a href="/myshop/reviews" class="${activeMenu eq 'writtenReview' ? 'active' : ''}">내가 작성한 리뷰</a>
            
            <a href="/myshop/reviews?tab=writable" class="${activeMenu eq 'writableReview' ? 'active' : ''}">작성 가능한 리뷰</a>
            
        </div>

        <div class="myshop-side-group">
            <strong>문의 관리</strong>
            <a href="/myshop/qnas" class="${activeMenu eq 'qna' ? 'active' : ''}">내 문의</a>
            
        </div>

        <div class="myshop-side-group">
            <strong>관심 상품</strong>
            <a href="/myshop/my_favorite_list.do" class="${param.activeMenu eq 'favorite' ? 'active' : ''}">
                찜한 상품
            </a>
            <a href="/myshop/recent" class="${activeMenu eq 'recent' ? 'active' : ''}">
                최근 본 상품
            </a>
        </div>
    </div>
</aside>
