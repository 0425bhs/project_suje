package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.SellerVO;
import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;

public interface SellerDAO {
    SellerVO getSellerById(int seller_id);
    List<SellerVO> getSellerListByKeyword(@Param("status") String status,
                                          @Param("keyword") String keyword,
                                          @Param("size") Integer size,
                                          @Param("offset") int offset);
    int getSellerListCountByKeyword(@Param("status") String status,
                                    @Param("keyword") String keyword);
    
    int insertSeller(SellerVO svo);
    
    Map<String, Object> getOrderStatusCounts(int seller_id);
    Map<String, Object> getProductStatusCounts(int seller_id);

    int getUnansweredQnaCount(int seller_id);
    int getNewReviewCount(int seller_id);

    // 판매자 주문 목록 조회
    List<OrderVO> getSellerOrderList(Map<String, Object> map);

    // 판매자 주문별 상품 목록 조회
    List<OrderItemVO> getSellerOrderItemList(Map<String, Object> map);

    // 판매자 주문상품 상태 변경
    int updateSellerOrderItemStatus(Map<String, Object> map);
        
    Map<String,Object> sellerShopInfo(int seller_id);

    SellerVO selectSeller(int user_id);

    int sellerModify(SellerVO vo);

    
    SellerVO selectSellerByUserId(int user_id);
}
