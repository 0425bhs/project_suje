package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.vo.ProductVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SellerController {

    private final ProductDAO productdao;

    @GetMapping("/seller_homepage.do")
    public String sellerHomepage(Model model,Integer seller_id,String sort){

    //테스트용으로 1번 판매자 사용
    if (seller_id == null) {
        seller_id = 1;
    }    

    // 처음 들어왔을 때 sort가 없으면 기본값
    if(sort == null || sort.equals("")){
        sort = "rank";
    }

    Map<String, Object> map = new HashMap<>();
    map.put("seller_id", seller_id);
    map.put("sort", sort);

    List<ProductVO> list=productdao.sellerHomepageProductList(map);

    model.addAttribute("list",list);
    model.addAttribute("seller_id",seller_id);
    model.addAttribute("sort",sort);

    return "seller/seller_homepage";
    }

    @GetMapping("/seller_dashboard.do")
    public String sellerDashboard(){
        return "/seller/seller_dashboard";
    }

    @GetMapping("/seller_order_list.do")
    public String sellerOrderList(){
        return "/seller/seller_order_list";
    }

    @GetMapping("/seller_qna_list.do")
    public String sellerQnaList(){
        return "/seller/seller_qna_list";
    }

}
