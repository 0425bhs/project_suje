package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.QnaVO;

public interface QnaDAO {
    int addQna(QnaVO qna);
    List<QnaVO> getMyQnaList(int userId);
    QnaVO getQnaById(int qnaId);
}
