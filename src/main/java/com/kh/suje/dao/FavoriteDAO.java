package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

public interface FavoriteDAO {

    int addFavoriteProduct(Map<String, Object> map);
    int delFavoriteProduct(Map<String, Object> map);
    int checkFavoriteProduct(Map<String, Object> map);

    List<Map<String, Object>> getFavoriteProductList(int user_id);
    int getFavoriteProductCount(int user_id);

    List<Map<String, Object>> getFavoriteSellerList(int user_id);
    int addFavoriteSeller(Map<String, Integer> map);
    int delFavoriteSeller(Map<String, Integer> map);
    int checkFavoriteSeller(Map<String, Integer> map);

    int SellerFavoriteCount(int seller_id);
    int getFavoriteSellerCount(int user_id);
}
