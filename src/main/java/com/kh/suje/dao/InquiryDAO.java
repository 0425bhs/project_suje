package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.InquiryVO;

public interface InquiryDAO {
    int addInquiry(InquiryVO inquiry);
    List<InquiryVO> getInquryListByKeyword(String status, String keyword);
    InquiryVO getInquiryById(int inquiry_id);
}
