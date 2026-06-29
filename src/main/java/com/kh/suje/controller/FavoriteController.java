package com.kh.suje.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.suje.dao.FavoriteDAO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class FavoriteController {

    private final HttpSession session;
    private final FavoriteDAO favoritedao;

    @PostMapping("/favorite_shop.do")
    @ResponseBody
    public Map<String, Object> favoriteShop(int seller_id){
        Map<String, Object> resMap = new HashMap<>();

        UserVO user = (UserVO) session.getAttribute("user");

        // 로그인 체크
        if(user == null){
            resMap.put("result","login");
            return resMap;
        }

        int user_id = user.getUser_id();

        Map<String, Integer> map = new HashMap<>();
        map.put("user_id", user_id);
        map.put("seller_id", seller_id);

        // 현재 찜 여부 확인
        int check = favoritedao.checkFavoriteSeller(map);

        // 이미 찜한 상태 → 찜 취소
        if(check > 0){

            favoritedao.delFavoriteSeller(map);

            resMap.put("result", "delete");
            resMap.put("liked", false);

        } else {

            // 작가 찜 추가
            favoritedao.addFavoriteSeller(map);

            // 작가샵 첫 찜 쿠폰 발급 여부 확인
            int couponCheck = favoritedao.checkSellerFavoriteCoupon(map);

            // 처음 찜한 경우만 쿠폰 지급
            if(couponCheck == 0){

                favoritedao.insertSellerFavoriteCoupon(map);

                // JS에서 쿠폰 발급 안내창 띄우기용
                resMap.put("couponIssued", true);

            } else {

                resMap.put("couponIssued", false);

            }

            resMap.put("result", "insert");
            resMap.put("liked", true);
        }

        return resMap;
    }

    @PostMapping("/favorite_shop_cancel.do")
    public String favoriteShopCancel(int seller_id){
        UserVO user = (UserVO) session.getAttribute("user");

        if(user == null){
            return "redirect:/login.do";
        }

        int user_id = user.getUser_id();

        Map<String, Integer> map = new HashMap<>();
        map.put("user_id", user_id);
        map.put("seller_id", seller_id);
        
        int res = favoritedao.delFavoriteSeller(map);

        return "redirect:/seller_shop_homepage.do?seller_id=" + seller_id;
    }

    @GetMapping("/myshop/my_favorite_list.do")
    public String myFavoriteList(Model model,@RequestParam(value = "tab", required = false, defaultValue = "all") String tab){
        UserVO user = (UserVO) session.getAttribute("user");

        if(user == null){
            return "redirect:/login.do";
        }

        int user_id = user.getUser_id();

        int productFavoriteCount = favoritedao.getFavoriteProductCount(user_id);
        int sellerFavoriteCount = favoritedao.getFavoriteSellerCount(user_id);

        int totalCount = productFavoriteCount + sellerFavoriteCount;

        List<Map<String, Object>> favoriteProductList = Collections.emptyList();
        List<Map<String, Object>> favoriteSellerList = Collections.emptyList();

        if ("all".equals(tab) || "product".equals(tab)) {
            favoriteProductList = favoritedao.getFavoriteProductList(user_id);
        }

        if ("all".equals(tab) || "seller".equals(tab)) {
            favoriteSellerList = favoritedao.getFavoriteSellerList(user_id);
        }

        model.addAttribute("selectedTab", tab);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("productFavoriteCount", productFavoriteCount);
        model.addAttribute("sellerFavoriteCount", sellerFavoriteCount);

        model.addAttribute("favoriteProductList", favoriteProductList);
        model.addAttribute("favoriteSellerList", favoriteSellerList);

        model.addAttribute("contentPage", "/myshop/favorite_list");
        model.addAttribute("activeMenu", "favorite");

        return "myshop/myshop_main";
    }

    @PostMapping("/favorite_product.do")
    @ResponseBody
    public Map<String, Object> favoriteProduct(int product_id){
        Map<String, Object> result = new HashMap<>();

        UserVO loginUser = (UserVO) session.getAttribute("user");

        if(loginUser == null){
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

    @PostMapping("/favorite_product_cancel.do")
    public String favoriteProductCancel(int product_id) {
        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login.do";
        }

        Map<String, Object> map = new HashMap<>();
        map.put("user_id", user.getUser_id());
        map.put("product_id", product_id);

        favoritedao.delFavoriteProduct(map);

        return "redirect:/myshop/my_favorite_list.do?tab=product";
    }

    // 마이페이지에서 작가 찜 삭제
    @PostMapping("/favorite_seller_cancel_mypage.do")
    public String favoriteSellerCancelMypage(int seller_id) {
        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login.do";
        }

        Map<String, Integer> map = new HashMap<>();
        map.put("user_id", user.getUser_id());
        map.put("seller_id", seller_id);

        favoritedao.delFavoriteSeller(map);

        return "redirect:/myshop/my_favorite_list.do?tab=seller";
    }
}
