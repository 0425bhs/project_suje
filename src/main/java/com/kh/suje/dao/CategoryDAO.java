package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.CategoryVO;

public interface CategoryDAO {

    List<CategoryVO> big_category_list();

    List<CategoryVO> small_category_list(int parent_id);

    Integer find_parent_id(int category_id);
    
    String getCategroyNameById(int category_id);

    List<CategoryVO> small_category_all_list();

    List<CategoryVO> getCategoryHierarchy();

    int countParentCategories();

    List<CategoryVO> getParentCategoryPageList(@Param("size") int size,
                                               @Param("offset") int offset);

    CategoryVO getCategoryById(int category_id);

    int countChildCategories(int category_id);

    int countProductsByCategory(int category_id);

    void addCategory(CategoryVO category);

    void updateCategory(CategoryVO category);

    void deleteCategory(int category_id);
}
