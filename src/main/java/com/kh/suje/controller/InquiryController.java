package com.kh.suje.controller;

import java.io.IOException;
import java.io.PrintWriter;

import org.springframework.stereotype.Controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.InquiryDAO;
import com.kh.suje.vo.InquiryVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@Controller
@RequiredArgsConstructor
public class InquiryController {
    private final InquiryDAO inquiryDao;

    @GetMapping("/inquiry_form.do")
    public String inquiryForm(HttpSession session, HttpServletResponse response, String param) throws IOException {
        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            
            out.println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='/login.do';</script>");
            out.flush();
            
            return null;
        }

        return "/inquiry/inquiry_form";
    }

    @PostMapping("/inquiry_form.do")
    public String inquiryFormFin(HttpSession session, InquiryVO inquiry) {
        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        int user_id = loginUser.getUser_id();

        inquiry.setUser_id(user_id);
        inquiryDao.addInquiry(inquiry);

        return "/inquiry/inquiry_form";
    }


    
}
