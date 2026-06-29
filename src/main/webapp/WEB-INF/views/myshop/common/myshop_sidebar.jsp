<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<aside class="myshop-sidebar">
    <div class="myshop-side-card">

        <a href="/myshop" class="myshop-side-home">
            마이쇼핑
        </a>

        <div class="myshop-side-group">
            <strong>내 정보</strong>
            <a href="/user_modify.do" class="${param.activeMenu eq 'user_modify.do' ? 'active' : ''}">회원 정보 수정</a>
            <a href="/addressList.do" class="${param.activeMenu eq 'addressList.do' ? 'active' : ''}">배송지 관리</a>
            <a href="/update_seller.do" class="${param.activeMenu eq 'update_seller.do' ? 'active' : ''}">판매자 신청하기</a>
        </div>
        
        <div class="myshop-side-group">
            <strong>주문 관리</strong>
            <a href="/myshop/orders" class="${param.activeMenu eq 'order' ? 'active' : ''}">주문/배송내역</a>
            <a href="/order/cancel" class="${param.activeMenu eq 'order/cancel' ? 'active' : ''}">취소/환불내역</a>
        </div>

        <div class="myshop-side-group">
            <strong>리뷰 관리</strong>
            <button type="button" onclick="alert('작성 가능한 리뷰는 준비중입니다.');">
                작성 가능한 리뷰
            </button>
            <a href="/myshop/reviews" class="${param.activeMenu eq 'review' ? 'active' : ''}">내가 작성한 리뷰</a>
        </div>

        <div class="myshop-side-group">
            <strong>문의 관리</strong>
            <a href="/myshop/qnas" class="${param.activeMenu eq 'qna' ? 'active' : ''}">내 문의</a>
            <!-- <button type="button" onclick="alert('상품 Q&A는 준비중입니다.');">
                상품 Q&amp;A
            </button> -->
        </div>

        <div class="myshop-side-group">
            <strong>관심 상품</strong>
            <a href="/myshop/my_favorite_list.do" class="${param.activeMenu eq 'favorite' ? 'active' : ''}">
                찜한 상품
            </a>
            <button type="button" onclick="">
                최근 본 상품
            </button>
        </div>
    </div>
</aside>