package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import com.kh.suje.vo.ProductVO;

public interface ProductDAO {

    List<ProductVO> product_list(Map<String, Object> map);

    int product_cnt();
    
    ProductVO product_one(int product_id);

    int seller_product_insert(ProductVO vo);

    int seller_product_modify(ProductVO vo);

    // 신제품 목록
    List<ProductVO> new_product_list(Map<String, Object> map);

    // 카테고리별 상품 목록
    List<ProductVO> product_category_list(Map<String, Object> map);

    // 카테고리별 상품 개수
    int product_category_cnt(Map<String, Object> map);

    // 세일 상품 목록
    List<ProductVO> product_sale_list(Map<String, Object> map);

    // 세일 상품 개수
    int product_sale_cnt();

    //베스트 상품
    List<ProductVO> product_best_all_list();

    //판매자 내 상품 목록
    List<ProductVO> seller_product_list(Map<String, Object> map);

    int seller_product_toggle(ProductVO vo);
    
    List<ProductVO> sellerHomepageProductList(Map<String, Object> map);

    int seller_product_delete(int product_id);
    
    int sellerProductDeleteSelected(int[] product_id);
}
