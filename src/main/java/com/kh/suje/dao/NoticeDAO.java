package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.NoticeVO;

public interface NoticeDAO {
    int addNotice(NoticeVO notice);
    List<NoticeVO> getNoticeList();
    NoticeVO getNoticeById(int noticeId);
}
