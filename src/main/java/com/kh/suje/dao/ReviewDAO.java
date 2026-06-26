package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.ReviewVO;

public interface ReviewDAO {
    int addReview(ReviewVO review);
    ReviewVO getReviewById(int review_id);
    int getReviewCount(int user_id);

    List<ReviewVO> getWritableReview(int user_id);
    List<ReviewVO> getWrittenReview(int user_id);
    int getWrittenReviewCount(int user_id);
    int getWritableReviewCount(int user_id);

    List<ReviewVO> getMyReviewList(int user_id);
    List<ReviewVO> getLiveReviewList();

    // 상품 상세페이지 리뷰 목록
    List<ReviewVO> getProductReviewList(int product_id);
    
    int updateReview(ReviewVO review);
    int deleteReview(int review_id);

    List<ReviewVO> productReviewList(int product_id);

    List<Map<String, Object>> bestReview(int product_id);
    
    List<ReviewVO> sellerReviewList(@Param ("seller_id") int seller_id);
    List<ReviewVO> sellerReviewProductList(@Param("seller_id") int seller_id);

}
