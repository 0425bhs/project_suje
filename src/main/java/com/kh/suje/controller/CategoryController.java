package com.kh.suje.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.vo.CategoryVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryDAO categorydao;
    
    
    @GetMapping("/sub.do")
    @ResponseBody
    public List<CategoryVO> smallCategory(int parent_id){
        return categorydao.small_category_list(parent_id);
    }
}
