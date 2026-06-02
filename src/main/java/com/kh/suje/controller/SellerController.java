package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.vo.ProductVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SellerController {

    private final ProductDAO productdao;

    @GetMapping("/seller_homepage.do")
    public String seller_homepage_form(){
    return "/seller/seller_homepage";
    }

    @PostMapping("/seller_homepage.do")
    public String sellerHomepage(Model model,int seller_id,String sort) {

    // 처음 들어왔을 때 sort가 없으면 기본값
    if (sort == null || sort.equals("")) {
        sort = "rank";
    }

    Map<String, Object> map = new HashMap<>();
    map.put("seller_id", seller_id);
    map.put("sort", sort);

    List<ProductVO> list=productdao.sellerHomepageProductList(map);

    model.addAttribute("list", list);
    model.addAttribute("seller_id", seller_id);
    model.addAttribute("sort", sort);

    return "seller/seller_homepage";
    }
}
