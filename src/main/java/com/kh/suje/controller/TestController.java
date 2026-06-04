package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import com.kh.suje.dao.TestDAO;
import com.kh.suje.vo.TestVO;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
public class TestController {
    private final TestDAO testDAO;

    @GetMapping("category.do")
    public String category(Model model) {
        List<TestVO> categories = testDAO.getCategoryList();
        model.addAttribute("categories", categories);

        return "/test/category";
    }

    @GetMapping("getChildCategories.do")
    @ResponseBody
    public Map<String, Object> getChildCategories(@RequestParam("parentId") int parentId) {
        Map<String, Object> result = new HashMap<>();
        
        // 1. DB에서 하위 카테고리 리스트 조회
        List<TestVO> childList = testDAO.getCategoryListById(parentId);
        
        // 2. Map에 데이터 담기
        result.put("status", "success");
        result.put("count", childList.size());
        result.put("list", childList); // 리스트를 Map 안에 쏙 넣습니다.

        return result; // 스프링이 Map을 JSON 객체{} 형태로 자동 변환합니다.
    }

    @GetMapping("login.do")
    public String login() {
        return "/test/APIExamNaverLogin";
    }

    @GetMapping("login_callback.do")
    public String loginCallback() {
        return "/test/callback";
    }
}
