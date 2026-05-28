package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kh.suje.vo.OrderItemVO;
import com.kh.suje.vo.OrderVO;

@Mapper
public interface OrderDAO {

    // 내 주문 내역 조회
    List<OrderVO> selectOrderListByUserId(Long user_id);

    // 주문 1건 조회
    OrderVO selectOrderById(Long order_id);

    // 주문 생성
    int insertOrder(OrderVO vo);

    // 주문 상품 생성
    int insertOrderItem(OrderItemVO vo);

    // 주문 상품 목록 조회
    List<OrderItemVO> selectOrderItemList(Long order_id);

    // 주문 상태 변경
    int updateOrderStatus(OrderVO vo);
}