package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.InquiryVO;

public interface InquiryDAO {
    int addInquiry(InquiryVO inquiry);
    List<InquiryVO> getInquryListByKeyword(@Param("status") String status,
                                           @Param("keyword") String keyword,
                                           @Param("size") Integer size,
                                           @Param("offset") int offset,
                                           @Param("startDate") String startDate,
                                           @Param("endDate") String endDate,
                                           @Param("sort") String sort);
    int getInquryListCountByKeyword(@Param("status") String status,
                                    @Param("keyword") String keyword,
                                    @Param("startDate") String startDate,
                                    @Param("endDate") String endDate);
    InquiryVO getInquiryById(int inquiry_id);
}
