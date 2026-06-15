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

    private final FavoriteDAO favoriteDAO;

    @PostMapping("favorite_shop.do")
    @ResponseBody
    public Map<String, String> favoriteShop(int seller_id) {
        String result = "error";

        // UserVO user = (UserVO) session.getAttribute("user");
        // if (user != null) {
        //     int user_id = user.getUser_id();

        //     Map<String, Integer> map = new HashMap<>();
        //     map.put("user_id", user_id);
        //     map.put("seller_id", seller_id);
            
        //     int res = favoriteDAO.addFavorite(map);

        //     if (res >= 1) {
        //         result = "success";
        //     }
        // }

        Map<String, String> resMap = new HashMap<>();
        resMap.put("result", result);

        return resMap;
    }

    @PostMapping("favorite_shop_cancel.do")
    public String favoriteShopCancel(int seller_id) {
        // UserVO user = (UserVO) session.getAttribute("user");
        // int user_id = user.getUser_id();

        // Map<String, Integer> map = new HashMap<>();
        // map.put("user_id", user_id);
        // map.put("seller_id", seller_id);
        
        // int res = favoriteDAO.delFavorite(map);

        return "redirect:/seller_shop_homepage.do?seller_id=" + seller_id;
    }

    @GetMapping("my_favorite_list.do")
    public String myFavoriteList(Model model) {
        UserVO user = (UserVO) session.getAttribute("user");
        int user_id = user.getUser_id();

        List<FavoriteVO> list = favoriteDAO.getFavoriteList(user_id);
        model.addAttribute("list", list);

        return "/favorite/my_favorite_list";
    }
}
