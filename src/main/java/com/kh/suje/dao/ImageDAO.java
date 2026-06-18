package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.ImageVO;

public interface ImageDAO {
    int insertImageList(List<ImageVO> imageList);
    List<ImageVO> getImagesByReviewId(int review_id);
    List<ImageVO> getImagesByReviewIds(List<Integer> review_id);

    List<ImageVO> getImagesByProductId(int product_id);
    int deleteImagesByProductId(int product_id);
}
