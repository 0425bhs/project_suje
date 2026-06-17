<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<aside class="myshop-sidebar">
    <div class="myshop-side-card">

        <a href="/myshop" class="myshop-side-home">
            마이쇼핑
        </a>

        <div class="myshop-side-group">
            <strong>내 정보</strong>
            <button type="button" onclick="alert('회원 정보 수정은 준비중입니다.');">
                회원 정보 수정
            </button>
            <button type="button" onclick="alert('배송지 관리는 준비중입니다.');">
                배송지 관리
            </button>
        </div>
        
        <div class="myshop-side-group">
            <strong>주문 관리</strong>
            <a href="/myshop/orders" class="${param.activeMenu eq 'order' ? 'active' : ''}">주문/배송내역</a>
            <button type="button" onclick="alert('취소/환불내역은 준비중입니다.');">
                취소/환불내역
            </button>
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
