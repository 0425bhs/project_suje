package com.kh.suje.controller;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.kh.suje.dao.CategoryDAO;

import lombok.RequiredArgsConstructor;

@ControllerAdvice
@RequiredArgsConstructor
public class HeaderControllerAdvice {

    private final CategoryDAO categorydao;

    @ModelAttribute("bigCategoryList")
    public Object bigCategoryList(){
        return categorydao.big_category_list();
    }

    @ModelAttribute("smallCategoryList")
    public Object smallCategoryList(){
        return categorydao.small_category_all_list();
    }
}