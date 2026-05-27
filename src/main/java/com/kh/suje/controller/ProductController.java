package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.vo.ProductVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ProductController {

    private final ProductDAO productdao;

    @GetMapping(value = {"/","/product/list.do"})
    public String productList(Model model) {
        List<ProductVO> list=productdao.product_list();
        model.addAttribute("list",list);
        return "product/product_list";
    }

    @GetMapping("/seller_product_insert.do")
    public String seller_product_insert_form(){
        return "/product/seller_product_insert_form";
    }

    @PostMapping("/seller_product_insert.do")
    @ResponseBody
    public Map<String,Object> seller_product_insert(ProductVO vo){
        int res=productdao.seller_product_insert(vo);
        Map<String,Object> map=new HashMap<>();
        map.put("result",res);
        return map;
    }

    @GetMapping("/seller_product_modify.do")
    public String seller_product_modify_form(){
        return "/product/seller_product_modify_form";
    }

    @PostMapping("/seller_product_modify.do")
    @ResponseBody
    public Map<String,Object> seller_product_modify(Long product_id,Model model){
        model.addAttribute("vo",vo);
    }


    @GetMapping("/product_detail.do")
    public String product_detail_form(Long product_id,Model model){
        ProductVO vo=productdao.product_one(product_id);
        model.addAttribute("vo",vo);
        return "/product/product_detail_form";
    }    


    
}
