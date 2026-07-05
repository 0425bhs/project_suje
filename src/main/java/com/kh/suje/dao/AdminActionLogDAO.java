package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.AdminActionLogVO;

public interface AdminActionLogDAO {
    int addAdminActionLog(AdminActionLogVO log);

    List<AdminActionLogVO> getRecentAdminActionLogList(int size);

    List<AdminActionLogVO> getAdminActionLogPageList(@Param("size") int size,
                                                     @Param("offset") int offset,
                                                     @Param("targetType") String targetType,
                                                     @Param("actionType") String actionType,
                                                     @Param("status") String status,
                                                     @Param("targetId") Integer targetId,
                                                     @Param("keyword") String keyword,
                                                     @Param("startDate") String startDate,
                                                     @Param("endDate") String endDate,
                                                     @Param("sort") String sort);

    int getAdminActionLogCount(@Param("targetType") String targetType,
                               @Param("actionType") String actionType,
                               @Param("status") String status,
                               @Param("targetId") Integer targetId,
                               @Param("keyword") String keyword,
                               @Param("startDate") String startDate,
                               @Param("endDate") String endDate);

    List<AdminActionLogVO> getAdminActionLogList(@Param("target_type") String target_type,
                                                 @Param("target_id") int target_id);
}
