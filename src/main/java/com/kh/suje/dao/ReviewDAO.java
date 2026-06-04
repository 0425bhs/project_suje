package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.ReviewVO;

public interface ReviewDAO {
    int addReview(ReviewVO review);
    ReviewVO getReviewById(int review_id);
    List<ReviewVO> getMyReviewList(int user_id);
    List<ReviewVO> getLiveReviewList();
    int updateReview(ReviewVO review);
    int deleteReview(int review_id);
}
