package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.ReportVO;

public interface ReportDAO {
    int addReport(ReportVO report);
    List<ReportVO> getReportListByKeyword(String status, String keyword);
}
