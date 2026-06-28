package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.NoticeVO;

public interface NoticeDAO {
    int addNotice(NoticeVO notice);
    NoticeVO getNoticeById(int notice_id);
    List<NoticeVO> getNoticeList();
    int updateNotice(NoticeVO notice);
    int deleteNotice(int notice_id);
    List<NoticeVO> getNoticeListByKeyword(String keyword);
}
