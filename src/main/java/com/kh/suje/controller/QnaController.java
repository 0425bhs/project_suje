package com.kh.suje.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.kh.suje.dao.QnaDAO;
import com.kh.suje.dao.ReviewDAO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
@RequiredArgsConstructor
public class QnaController {
    @Autowired
    HttpSession session;

    private final QnaDAO qnaDAO;

    @GetMapping("qna_form.do")
    public String gnaForm() {

        return "qna_form";
    }
    
}   
