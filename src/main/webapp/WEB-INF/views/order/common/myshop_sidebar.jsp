<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>

<aside class="myshop-sidebar">
    <div class="myshop-side-card">

        <a href="/order/my" class="myshop-side-home">
            마이쇼핑
        </a>

        <div class="myshop-side-group">
            <strong>주문 관리</strong>
            <a href="/order/my" class="active">주문/배송내역</a>
            <button type="button" onclick="alert('취소/환불내역은 준비중입니다.');">
                취소/환불내역
            </button>
        </div>

        <div class="myshop-side-group">
            <strong>관심 상품</strong>
            <button type="button" onclick="alert('찜한 상품은 준비중입니다.');">
                찜한 상품
            </button>
            <button type="button" onclick="alert('최근 본 상품은 준비중입니다.');">
                최근 본 상품
            </button>
        </div>

        <div class="myshop-side-group">
            <strong>리뷰 관리</strong>
            <button type="button" onclick="alert('작성 가능한 리뷰는 준비중입니다.');">
                작성 가능한 리뷰
            </button>
            <button type="button" onclick="alert('내가 작성한 리뷰는 준비중입니다.');">
                내가 작성한 리뷰
            </button>
        </div>

        <div class="myshop-side-group">
            <strong>문의 관리</strong>
            <button type="button" onclick="alert('내 문의는 준비중입니다.');">
                내 문의
            </button>
            <button type="button" onclick="alert('상품 Q&A는 준비중입니다.');">
                상품 Q&amp;A
            </button>
        </div>

        <div class="myshop-side-group">
            <strong>내 정보</strong>
            <button type="button" onclick="alert('회원 정보 수정은 준비중입니다.');">
                회원 정보 수정
            </button>
            <button type="button" onclick="alert('배송지 관리는 준비중입니다.');">
                배송지 관리
            </button>
        </div>

    </div>
</aside>