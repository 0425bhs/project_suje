package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.CategoryVO;

public interface CategoryDAO {

    List<CategoryVO> big_category_list();

    List<CategoryVO> small_category_list(int parent_id);

    Integer find_parent_id(int category_id);
    
    String getCategroyNameById(int category_id);

    List<CategoryVO> small_category_all_list();
}
