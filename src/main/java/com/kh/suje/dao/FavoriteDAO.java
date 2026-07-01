package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

public interface FavoriteDAO {

    // 상품 찜 추가
    int addFavoriteProduct(Map<String, Object> map);

    // 상품 찜 삭제
    int delFavoriteProduct(Map<String, Object> map);

    // 상품 찜 여부 확인
    int checkFavoriteProduct(Map<String, Object> map);

    // 마이쇼핑 찜한 상품 목록 조회
    List<Map<String, Object>> getFavoriteProductList(int user_id);

    // 찜한 상품 개수 조회
    int getFavoriteProductCount(int user_id);

    // 마이쇼핑 찜한 작가 목록 조회
    List<Map<String, Object>> getFavoriteSellerList(int user_id);

    // 작가 찜 추가
    int addFavoriteSeller(Map<String, Integer> map);

    // 작가 찜 삭제
    int delFavoriteSeller(Map<String, Integer> map);

    // 작가 찜 여부 확인
    int checkFavoriteSeller(Map<String, Integer> map);

    // 특정 작가를 찜한 회원 수 조회
    int SellerFavoriteCount(int seller_id);

    // 회원이 찜한 작가 수 조회
    int getFavoriteSellerCount(int user_id);

    // 작가샵 첫 찜 쿠폰 발급 여부 확인
    int checkSellerFavoriteCoupon(Map<String, Integer> map);

    // 작가샵 첫 찜 500원 쿠폰 발급
    int insertSellerFavoriteCoupon(Map<String, Integer> map);
}