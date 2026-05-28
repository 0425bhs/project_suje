package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.ReviewVO;

public interface ReviewDAO {
    int addReview(ReviewVO review);
    List<ReviewVO> getMyReviewList(int id);
    List<ReviewVO> getLiveReviewList();

}
