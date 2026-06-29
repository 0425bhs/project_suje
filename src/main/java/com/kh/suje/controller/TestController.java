package com.kh.suje.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class TestController {

    @GetMapping("/testmain")
    public String main() {
        return "/test/testmain";
    }

    @GetMapping("/editor")
    public String editor() {
        return "test/editor";
    }

    @PostMapping("/quiz/insert.do")
    public String quizInsert(String quizContent) {

        System.out.println("퀴즈 내용 = " + quizContent);

        return "redirect:/editor";
    }
}