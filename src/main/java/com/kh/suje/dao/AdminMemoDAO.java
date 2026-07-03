package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.AdminMemoVO;

public interface AdminMemoDAO {
    List<AdminMemoVO> getAdminMemoList(@Param("target_type") String target_type,
                                       @Param("target_id") int target_id);

    int addAdminMemo(AdminMemoVO memo);

    int updateAdminMemo(AdminMemoVO memo);

    int deleteAdminMemo(int memo_id);
}
