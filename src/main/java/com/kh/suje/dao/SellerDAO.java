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
                                          @Param("user_id") Integer user_id,
                                          @Param("seller_id") Integer seller_id,
                                          @Param("size") Integer size,
                                          @Param("offset") int offset,
                                          @Param("startDate") String startDate,
                                          @Param("endDate") String endDate,
                                          @Param("sort") String sort);
    int getSellerListCountByKeyword(@Param("status") String status,
                                    @Param("keyword") String keyword,
                                    @Param("user_id") Integer user_id,
                                    @Param("seller_id") Integer seller_id,
                                    @Param("startDate") String startDate,
                                    @Param("endDate") String endDate);

    int updateAdminSellerStatus(@Param("seller_id") int seller_id,
                                @Param("status") String status);
    
    int insertSeller(SellerVO svo);
    
    Map<String, Object> getOrderStatusCounts(int seller_id);
    Map<String, Object> getProductStatusCounts(int seller_id);

    Map<String, Object> getSellerSalesSummary(int seller_id);
    List<Map<String, Object>> getSellerDailySales(int seller_id);
    List<Map<String, Object>> selectSellerNoticeList();

    int getUnansweredQnaCount(int seller_id);
    int getNewReviewCount(int seller_id);

    // 판매자 주문 목록 조회
    List<OrderVO> getSellerOrderList(Map<String, Object> map);

    // 판매자 주문별 상품 목록 조회
    List<OrderItemVO> getSellerOrderItemList(Map<String, Object> map);

    // 판매자 주문상품 상태 변경
    int sellerOrderStatus(Map<String, Object> map);
        
    Map<String,Object> sellerShopInfo(int seller_id);

    SellerVO selectSeller(int user_id);

    int sellerModify(SellerVO vo);

    SellerVO selectSellerByUserId(int user_id);

    int getSellerOrderCount(Map<String, Object> map);

    List<Map<String, Object>> getSellerProductSalesTop(int seller_id);
    
    List<Map<String, Object>> getSellerCategorySales(int seller_id);

    int updateBuyerRequestClaimDone(@Param("claim_id") int claim_id,
                                    @Param("status") String status,
                                    @Param("seller_answer") String seller_answer);

    int insertSellerDirectClaimDone(@Param("order_item_id") int order_item_id,
                                    @Param("status") String status,
                                    @Param("reason") String reason,
                                    @Param("detail_reason") String detail_reason,
                                    @Param("seller_answer") String seller_answer);

    int ownsOrderItem(@Param("seller_id") int seller_id,
                      @Param("order_item_id") int order_item_id);

    int ownsClaim(@Param("seller_id") int seller_id,
                  @Param("claim_id") int claim_id);
                                    
}
