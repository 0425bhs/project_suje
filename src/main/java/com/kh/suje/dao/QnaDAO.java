package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.QnaVO;

public interface QnaDAO {
    int addQna(QnaVO qna);
    List<QnaVO> getMyQnaList(int user_id);
    QnaVO getQnaById(int qna_id);
    int updateQna(QnaVO qna);
    int deleteQna(int qna_id);

    List<QnaVO> productQnaList(int product_id);

    //문의 수 조회
    int getQnaCount(int user_id);
}
