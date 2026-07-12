package com.kh.suje.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.QnaDAO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.QnaVO;
import com.kh.suje.vo.ReviewVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@RequiredArgsConstructor
public class QnaController {
    // private final HttpSession session;

    private final QnaDAO qnaDAO;
    private final ProductDAO productDAO;

    @GetMapping("qna_form.do")
    public String qnaForm(HttpSession session, Model model, int product_id) {
        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        ProductVO product = productDAO.product_one(product_id);
        model.addAttribute("product", product);
        
        return "/qna/qna_form";
    }
    
    @PostMapping("qna_form.do")
    public String qnaFormFin(HttpSession session, QnaVO qna) {
        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        if (qna.getQna_type() == null || qna.getQna_type().trim().isEmpty()) {
            qna.setQna_type("PRODUCT");
        }

        int user_id = loginUser.getUser_id();

        qna.setUser_id(user_id);
        qnaDAO.addQna(qna);

        return "redirect:/myshop/qnas";
    }

    @GetMapping("qna_update_form.do")
    public String qnaUpdateForm(Model model, int qna_id) {
        QnaVO qna = qnaDAO.getQnaById(qna_id);
        model.addAttribute("qna", qna);

        return "/qna/qna_update_form";
    }

    @PostMapping("qna_update_form.do")
    public String qnaUpdateFormFin(QnaVO qna) {
        if (qna.getQna_type() == null || qna.getQna_type().trim().isEmpty()) {
            qna.setQna_type("PRODUCT");
        }

    qnaDAO.updateQna(qna);

    return "redirect:/qna_detail.do?qna_id=" + qna.getQna_id();
}

    @PostMapping("qna_delete.do")
    public String qnaDelete(int qna_id) {
        qnaDAO.deleteQna(qna_id);

        return "redirect:/myshop/qnas";
    }

    @GetMapping("/myshop/qnas")
    public String myQnaList(HttpSession session, Model model, String status) {
        UserVO user = (UserVO) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.do";
        }
        int user_id = user.getUser_id();

        if (status == null || status.trim().isEmpty()) {
            status = "all"; 
        }

        List<QnaVO> list;
        if ("wating".equals(status)) {
            list = qnaDAO.getWatingQnaList(user_id);
        } else if ("answered".equals(status)) {
            list = qnaDAO.getAnsweredQnaList(user_id);
        } else {
            list = qnaDAO.getMyQnaList(user_id);
        }

        model.addAttribute("list", list);

        int totalCount = qnaDAO.getQnaCount(user_id);
        int watingQnaCount = qnaDAO.getWatingQnaCount(user_id);
        int answeredQnaCount = qnaDAO.getAnsweredQnaCount(user_id);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("watingQnaCount", watingQnaCount);
        model.addAttribute("answeredQnaCount", answeredQnaCount);

        model.addAttribute("activeMenu", "qna");
        model.addAttribute("status", status);
        model.addAttribute("contentPage", "/myshop/qna_list");

        return "/myshop/myshop_main";
    }

    @GetMapping("qna_detail.do")
    public String qnaDetail(Model model, int qna_id) {
        QnaVO qna = qnaDAO.getQnaById(qna_id);
        model.addAttribute("qna", qna);

        return "/qna/qna_detail";
    }
    
}   
