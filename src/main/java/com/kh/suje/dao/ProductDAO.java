package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import com.kh.suje.vo.ProductVO;

public interface ProductDAO {

    List<ProductVO> product_list(Map<String, Object> map);
    
    ProductVO product_one(int product_id);

    int seller_product_insert(ProductVO vo);

    int seller_product_modify(ProductVO vo);

    int product_cnt();

    
}
