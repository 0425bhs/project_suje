package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.FavoriteDAO;
import com.kh.suje.vo.FavoriteVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class FavoriteController {
    private final HttpSession session;

    private final FavoriteDAO favoritedao;

    @PostMapping("favorite_shop.do")
    @ResponseBody
    public Map<String, Object> favoriteShop(int seller_id, HttpSession session){
        Map<String, Object> resMap = new HashMap<>();

        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            resMap.put("result", "login");
            return resMap;
        }

        int user_id = user.getUser_id();

        Map<String, Integer> map = new HashMap<>();
        map.put("user_id", user_id);
        map.put("seller_id", seller_id);

        int check = favoritedao.checkFavoriteSeller(map);

        if (check > 0) {
            favoritedao.delFavoriteSeller(map);
            resMap.put("result", "delete");
            resMap.put("liked", false);
        } else {
            favoritedao.addFavoriteSeller(map);
            resMap.put("result", "insert");
            resMap.put("liked", true);
        }

        return resMap;
    }

    @PostMapping("favorite_shop_cancel.do")
    public String favoriteShopCancel(int seller_id){
        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login.do";
        }

        int user_id = user.getUser_id();

        Map<String, Integer> map = new HashMap<>();
        map.put("user_id", user_id);
        map.put("seller_id", seller_id);
        
        int res = favoritedao.delFavoriteSeller(map);

        return "redirect:/seller_shop_homepage.do?seller_id=" + seller_id;
    }

    @GetMapping("my_favorite_list.do")
    public String myFavoriteList(Model model){
        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login.do";
        }

        int user_id = user.getUser_id();

        List<FavoriteVO> list = favoritedao.getFavoriteSellerList(user_id);
        model.addAttribute("list", list);

        return "/favorite/my_favorite_list";
    }

    @PostMapping("/favorite_product.do")
    @ResponseBody
    public Map<String, Object> favoriteProduct(int product_id,HttpSession session){
        Map<String, Object> result = new HashMap<>();

        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser == null) {
            result.put("result", "login");
            return result;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("user_id", loginUser.getUser_id());
        map.put("product_id", product_id);

        int check = favoritedao.checkFavoriteProduct(map);

        if (check > 0) {
            favoritedao.delFavoriteProduct(map);
            result.put("liked", false);
        } else {
            favoritedao.addFavoriteProduct(map);
            result.put("liked", true);
        }

        result.put("result", "success");

        return result;
    }
}
