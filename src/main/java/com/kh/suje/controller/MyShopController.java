package com.kh.suje.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MyShopController {

    @GetMapping("/myshop")
    private String MyShop(Model model) {
        String contentPage = "/myshop/dashboard";
        model.addAttribute("contentPage", contentPage);
        
        return "/myshop/myshop_main";
    }
}
