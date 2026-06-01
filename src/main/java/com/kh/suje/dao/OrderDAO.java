package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;

@Mapper
public interface OrderDAO {

    // 내 주문 내역 조회
    List<OrderVO> selectOrderListByUserId(int user_id);

    // 주문 1건 조회
    OrderVO selectOrderById(int order_id);

    // 주문 생성
    int insertOrder(OrderVO vo);

    // 주문 상품 생성
    int insertOrderItem(OrderItemVO vo);

    // 주문 상품 목록 조회
    List<OrderItemVO> selectOrderItemList(int order_id);

    // 주문 상태 변경
    int updateOrderStatus(OrderVO vo);
}