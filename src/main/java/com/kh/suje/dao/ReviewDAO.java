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

    List<ReviewVO> getReviewListByKeyword(@Param("keyword") String keyword,
                                          @Param("user_id") Integer user_id,
                                          @Param("product_id") Integer product_id,
                                          @Param("review_id") Integer review_id,
                                          @Param("rating") Integer rating,
                                          @Param("status") String status,
                                          @Param("size") Integer size,
                                          @Param("offset") int offset,
                                          @Param("startDate") String startDate,
                                          @Param("endDate") String endDate,
                                          @Param("sort") String sort);
    int getReviewListCountByKeyword(@Param("keyword") String keyword,
                                    @Param("user_id") Integer user_id,
                                    @Param("product_id") Integer product_id,
                                    @Param("review_id") Integer review_id,
                                    @Param("rating") Integer rating,
                                    @Param("status") String status,
                                    @Param("startDate") String startDate,
                                    @Param("endDate") String endDate);

    // 상품 상세페이지 리뷰 목록
    List<ReviewVO> getProductReviewList(int product_id);
    
    int updateReview(ReviewVO review);
    int updateReviewStatus(@Param("review_id") int review_id, @Param("status") String status);
    int deleteReview(int review_id);

    List<ReviewVO> productReviewList(int product_id);

    List<Map<String, Object>> bestReview(int product_id);
    
    List<ReviewVO> sellerReviewList(@Param ("seller_id") int seller_id);
    
    List<ReviewVO> sellerReviewProductList(@Param("seller_id") int seller_id);

    int sellerReviewReply(Map<String, Object> map);

    int getReviewCountByUserId(int user_id);
}
