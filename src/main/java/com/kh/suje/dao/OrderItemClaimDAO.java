package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import com.kh.suje.vo.order.OrderItemClaimVO;

public interface OrderItemClaimDAO {


    int insertClaim(OrderItemClaimVO orderitemclaim); //교환,환불 신청

    List<OrderItemClaimVO> selectClaimListByUserId(int user_id); //아이디로 교환,환불건 조회

    int cancelClaim(Map<String, Object> map); //교환,환불 취소

    
}
