package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import com.kh.suje.vo.FavoriteVO;

public interface FavoriteDAO {

    List<FavoriteVO> getFavoriteList(int user_id);
    int addFavorite(Map<String, Integer> map);
    int delFavorite(Map<String, Integer> map);
    int checkFavoriteShop(Map<String, Object> map);

    List<FavoriteVO> getFavoriteSellerList(int user_id);
    int addFavoriteSeller(Map<String, Integer> map);
    int delFavoriteSeller(Map<String, Integer> map);
    int checkFavoriteSeller(Map<String, Integer> map);
    int SellerFavoriteCount(int seller_id);
}
