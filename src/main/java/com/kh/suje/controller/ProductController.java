package com.kh.suje.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

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

    @GetMapping("/seller_product_modify.do")
    public String seller_product_modify_form(){
        return "/product/seller_product_modify_form";
    }

    @GetMapping("/product_detail.do")
    public String product_detail_form(String id){
        return "/product/product_detail_form";
    }    


    
}
