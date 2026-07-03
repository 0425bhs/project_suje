package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.ReportVO;

public interface ReportDAO {
    int addReport(ReportVO report);
    ReportVO getReportById(int report_id);
    List<ReportVO> getReportListByKeyword(@Param("status") String status,
                                          @Param("keyword") String keyword,
                                          @Param("user_id") Integer user_id,
                                          @Param("targetType") String targetType,
                                          @Param("target_id") Integer target_id,
                                          @Param("size") Integer size,
                                          @Param("offset") int offset,
                                          @Param("startDate") String startDate,
                                          @Param("endDate") String endDate,
                                          @Param("sort") String sort);
    int getReportListCountByKeyword(@Param("status") String status,
                                    @Param("keyword") String keyword,
                                    @Param("user_id") Integer user_id,
                                    @Param("targetType") String targetType,
                                    @Param("target_id") Integer target_id,
                                    @Param("startDate") String startDate,
                                    @Param("endDate") String endDate);

    int updateReportStatus(@Param("report_id") int report_id,
                           @Param("status") String status);

    int getReportCountByReporterId(int user_id);
}
