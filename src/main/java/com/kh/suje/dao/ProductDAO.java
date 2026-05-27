package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import com.kh.suje.vo.ProductVO;

public interface ProductDAO {

    List<ProductVO> product_list();
    
    ProductVO product_one(Long product_id);

    Map<String,Object> seller_product_insert(ProductVO vo);
    
}
