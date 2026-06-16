package com.kh.suje.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MyShopController {

    @GetMapping("/myshop")
    public String myshopMain(Model model) {

        model.addAttribute("contentPage", "/myshop/dashboard");

        model.addAttribute("activeMenu", "dashboard");

        return "myshop/myshop_main";
    }

    
}
