package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.ReportVO;

public interface ReportDAO {
    int addReport(ReportVO report);
    ReportVO getReportById(int report_id);
    List<ReportVO> getReportListByKeyword(String status, String keyword);
}
