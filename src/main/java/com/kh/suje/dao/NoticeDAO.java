package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.NoticeVO;

public interface NoticeDAO {
    int addNotice(NoticeVO notice);
    NoticeVO getNoticeById(int notice_id);
    List<NoticeVO> getNoticeList();
    int updateNotice(NoticeVO notice);
    int deleteNotice(int notice_id);
    List<NoticeVO> getNoticeListByKeyword(@Param("keyword") String keyword,
                                          @Param("size") Integer size,
                                          @Param("offset") int offset);
    int getNoticeListCountByKeyword(@Param("keyword") String keyword);
}
