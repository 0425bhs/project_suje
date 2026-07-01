package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.ReportVO;

public interface ReportDAO {
    int addReport(ReportVO report);
    ReportVO getReportById(int report_id);
    List<ReportVO> getReportListByKeyword(@Param("status") String status,
                                          @Param("keyword") String keyword,
                                          @Param("size") Integer size,
                                          @Param("offset") int offset,
                                          @Param("startDate") String startDate,
                                          @Param("endDate") String endDate,
                                          @Param("sort") String sort);
    int getReportListCountByKeyword(@Param("status") String status,
                                    @Param("keyword") String keyword,
                                    @Param("startDate") String startDate,
                                    @Param("endDate") String endDate);
}
