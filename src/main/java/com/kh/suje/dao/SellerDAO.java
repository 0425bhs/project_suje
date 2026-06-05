package com.kh.suje.dao;

import java.util.Map;

import com.kh.suje.vo.SellerVO;

public interface SellerDAO {
    int insertSeller(SellerVO svo);
    
    Map<String, Object> getOrderStatusCounts(int seller_id);
    Map<String, Object> getProductStatusCounts(int seller_id);

    int getUnansweredQnaCount(int seller_id);
    int getNewReviewCount(int seller_id);
}
