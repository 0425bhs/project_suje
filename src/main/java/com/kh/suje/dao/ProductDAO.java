package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.ProductVO;

public interface ProductDAO {

    List<ProductVO> product_list();
    
    ProductVO product_one(Long product_id);

    int seller_product_insert(ProductVO vo);

    int seller_product_modify(ProductVO vo);
}
