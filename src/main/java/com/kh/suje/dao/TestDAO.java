package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.TestVO;

public interface TestDAO {
    List<TestVO> getCategoryList();
    List<TestVO> getCategoryListById(int parent_id);
}
