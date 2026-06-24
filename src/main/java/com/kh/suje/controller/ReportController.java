package com.kh.suje.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.QnaDAO;
import com.kh.suje.dao.ReportDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.QnaVO;
import com.kh.suje.vo.ReportVO;
import com.kh.suje.vo.ReviewVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReportController {
    // private final HttpSession session;

    private final ReportDAO reportDao;
    private final ProductDAO productDao;
    private final ReviewDAO reviewDao;
    private final QnaDAO qnaDao;

    @GetMapping("/report_form.do")
    public String reportForm(HttpSession session, Model model, String target_type, int target_id) {
        UserVO loginUser = (UserVO)session.getAttribute("user");

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        if ("PRODUCT".equals(target_type)) {
            ProductVO product = productDao.product_one(target_id);
            model.addAttribute("product", product);
        } else if ("REVIEW".equals(target_type)) {
            ReviewVO review = reviewDao.getReviewById(target_id);
            model.addAttribute("review", review);
        } else if ("QNA".equals(target_type)) {
            QnaVO qna = qnaDao.getQnaById(target_id);
            model.addAttribute("qna", qna);
        }
        
        model.addAttribute("target_type", target_type);
        
        return "/report/report_form";
    }
}
