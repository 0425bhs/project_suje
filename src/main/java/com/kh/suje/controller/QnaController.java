package com.kh.suje.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import com.kh.suje.dao.QnaDAO;
import com.kh.suje.vo.QnaVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@RequiredArgsConstructor
public class QnaController {
    @Autowired
    HttpSession session;

    private final QnaDAO qnaDAO;

    @GetMapping("qna_form.do")
    public String qnaForm(Model model, int productId) {
        model.addAttribute("productId", productId);
        
        return "/qna/qna_form";
    }
    
    @PostMapping("qna_form.do")
    public String qnaFormFin(QnaVO qna) {
        // UserVO user = session.getAttribute("user");
        // Long userId = user.getId();
        int userId = 1;

        qna.setUserId(userId);
        int res = qnaDAO.addQna(qna);

        return "redirect:/my_qna_list.do";
    }

    @GetMapping("my_qna_list.do")
    public String myQnaList(Model model) {
        // UserVO user = session.getAttribute("user");
        // int userId = user.getId();
        int userId = 1;

        List<QnaVO> list = qnaDAO.getMyQnaList(userId);
        model.addAttribute("list", list);

        return "/qna/my_qna_list";
    }

    @GetMapping("qna_detail.do")
    public String qnaDetail(Model model, int qnaId) {
        // UserVO user = session.getAttribute("user");
        // int userId = user.getId();
        int userId = 1;

        QnaVO qna = qnaDAO.getQnaById(qnaId);
        model.addAttribute("qna", qna);

        return "/qna/qna_detail";
    }
}   
