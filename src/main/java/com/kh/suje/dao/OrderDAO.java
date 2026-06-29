package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;

@Mapper
public interface OrderDAO {

    // 내 주문 내역 조회
    List<OrderVO> selectOrderListByUserId(int user_id);

     // 내 주문 내역 상태별 조회
    List<OrderVO> selectOrderListByUserIdAndStatus(
            @Param("user_id") int user_id,
            @Param("status") String status
    );

    // 주문 1건 조회
    OrderVO selectOrderById(int order_id);

    // 주문상품 1개 조회
    OrderItemVO selectOrderItemById(Map<String, Object> map);

    // 주문 생성
    int insertOrder(OrderVO vo);

    // 주문 상품 생성
    int insertOrderItem(OrderItemVO vo);

    // 주문 상품 목록 조회
    List<OrderItemVO> selectOrderItemList(int order_id);

    // 주문 상태 변경
    int updateOrderStatus(OrderVO vo);

    // 결제취소 시 주문 상태, 취소 사유, 취소 일시 변경
    int updateOrderCancelInfo(OrderVO vo);

    int getProductId(int order_item_id);

    // 상태별 주문 개수 조회
    Map<String, Object> selectOrderStatusCounts(int userId);

    // 주문상품 상태 일괄 변경
    int updateOrderItemsStatusByOrderId(Map<String, Object> map);

    // 주문상품 구매확정 처리
    int confirmOrderItem(Map<String, Object> map);

    // 사용 가능한 쿠폰 목록 조회
    List<Map<String, Object>> selectAvailableCouponList(int user_id);

    // 쿠폰 사용 처리
    int useCoupon(Map<String, Object> map);

    // 구매확정 포인트 적립 여부 확인
    int checkPointHistory(Map<String, Object> map);

    // 회원 포인트 보유 row 생성
    int insertUserPointIfNotExists(Map<String, Object> map);

    // 회원 포인트 증가
    int updateUserPoint(Map<String, Object> map);

    // 포인트 적립 이력 저장
    int insertPointHistory(Map<String, Object> map);

    // 보유 포인트 조회
    int getUserPoint(int user_id);

    // 사용 가능한 쿠폰 개수 조회
    int getAvailableCouponCount(int user_id);

    // 포인트 사용 차감
    int useUserPoint(Map<String, Object> map);

    // 포인트 사용 이력 저장
    int insertUsePointHistory(Map<String, Object> map); 

    // 주문 포인트 사용 내역 order_id 연결
    int updateUsePointHistoryOrderId(Map<String, Object> map);

    // 주문에 사용한 포인트 조회
    int getUsedPointByOrderId(Map<String, Object> map);

    // 포인트 사용 복구
    int refundUserPoint(Map<String, Object> map);

    // 포인트 복구 이력 저장
    int insertRefundPointHistory(Map<String, Object> map);

    // 포인트 복구 여부 확인
    int checkRefundPointHistory(Map<String, Object> map);

    // 포인트 내역 조회
    List<Map<String, Object>> selectPointHistoryList(int user_id);

    //취소 내역 조회
    List<OrderVO> selectCancelList(int user_id);

}