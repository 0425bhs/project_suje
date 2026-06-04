package com.kh.suje.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.QnaDAO;
import com.kh.suje.vo.ProductVO;
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
    private final ProductDAO productDAO;

    @GetMapping("qna_form.do")
    public String qnaForm(Model model, int product_id) {
        ProductVO product = productDAO.product_one(product_id);
        model.addAttribute("product", product);
        
        return "/qna/qna_form";
    }
    
    @PostMapping("qna_form.do")
    public String qnaFormFin(QnaVO qna) {
        // UserVO user = session.getAttribute("user");
        // Long userId = user.getId();
        int user_id = 3;

        qna.setUser_id(user_id);
        int res = qnaDAO.addQna(qna);

        return "redirect:/my_qna_list.do";
    }

    @GetMapping("qna_update_form.do")
    public String qnaUpdateForm(Model model, int qna_id) {
        QnaVO qna = qnaDAO.getQnaById(qna_id);
        model.addAttribute("qna", qna);

        return "/qna/qna_update_form";
    }

    @PostMapping("qna_update_form.do")
    public String qnaUpdateFormFin(QnaVO qna) {
        int res = qnaDAO.updateQna(qna);

        return "redirect:/qna_detail.do?qna_id=" + qna.getQna_id();
    }

    @GetMapping("qna_delete.do")
    public String qnaDelete(int qna_id) {
        int res = qnaDAO.deleteQna(qna_id);

        return "redirect:/my_qna_list.do";
    }

    @GetMapping("my_qna_list.do")
    public String myQnaList(Model model) {
        // UserVO user = session.getAttribute("user");
        // int userId = user.getId();
        int user_id = 3;

        List<QnaVO> list = qnaDAO.getMyQnaList(user_id);
        model.addAttribute("list", list);

        return "/qna/my_qna_list";
    }

    @GetMapping("qna_detail.do")
    public String qnaDetail(Model model, int qna_id) {
        // UserVO user = session.getAttribute("user");
        // int userId = user.getId();
        int user_id = 3;

        QnaVO qna = qnaDAO.getQnaById(qna_id);
        model.addAttribute("qna", qna);

        return "/qna/qna_detail";
    }
    
}   
