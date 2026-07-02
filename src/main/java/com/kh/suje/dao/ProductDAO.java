package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.order.OrderItemVO;

public interface ProductDAO {

    List<ProductVO> product_list(Map<String, Object> map);

    List<ProductVO> getProductListByKeyword(@Param("status") String status,
                                            @Param("keyword") String keyword,
                                            @Param("size") Integer size,
                                            @Param("offset") int offset,
                                            @Param("startDate") String startDate,
                                            @Param("endDate") String endDate,
                                            @Param("sort") String sort);
    int getProductListCountByKeyword(@Param("status") String status,
                                     @Param("keyword") String keyword,
                                     @Param("startDate") String startDate,
                                     @Param("endDate") String endDate);

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
    int product_sale_cnt(Map<String, Object> map);

    //베스트 상품
    List<ProductVO> product_best_all_list();

    //판매자 내 상품 목록
    List<ProductVO> seller_product_list(Map<String, Object> map);

    int seller_product_toggle(ProductVO vo);
    
    List<ProductVO> sellerHomepageProductList(Map<String, Object> map);

    int seller_product_delete(int product_id);
    
    int sellerProductDeleteSelected(int[] product_id);

    // 결제 성공 시 재고 차감
    int decreaseStock(OrderItemVO vo);

    // 결제 취소 시 재고 복구
    int increaseStock(OrderItemVO vo);

    // 상품 상세 조회 시 사용자가 본 상품 기록 저장
    int insertProductViewLog(Map<String, Object> map);

    // 취향발견 추천 상품 목록
    List<ProductVO> product_discovery_list(Map<String, Object> map);

    // 취향발견 추천용 카테고리 목록
    List<Integer> product_discovery_category_list(int user_id);

    // 취향 데이터가 없을 때 보여줄 최신 상품 목록
    List<ProductVO> product_discovery_fallback_list(Map<String, Object> map);

    //상품 검색 목록
    List<ProductVO> product_search_list(Map<String,Object> map);

    //상품 검색 개수
    int product_search_cnt(Map<String, Object> map);

    // 선물 추천 목록
    List<ProductVO> product_gift_list(Map<String, Object> map);

    // 로그인 회원 구매내역 기반 선물추천
    List<ProductVO> product_gift_personal_list(Map<String, Object> map);

    // 선물추천 테마별 상품 목록
    List<ProductVO> product_gift_theme_list(Map<String, Object> map); 

    // 테스트 용도 최근 본 상품 목록 출력
    List<ProductVO> product_recent(int user_id);

    int seller_product_count(Map<String, Object> map);
}
