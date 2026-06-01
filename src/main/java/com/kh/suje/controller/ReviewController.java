package com.kh.suje.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.vo.ReviewVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReviewController {
    @Autowired
    HttpSession session;

    private final ReviewDAO reviewDAO;

    @GetMapping("/review")
    private String main() {
        return "/main";
    }

    @GetMapping("/review_form.do")
    private String reviewForm(Model model, int productId) {
        model.addAttribute("productId", productId);

        return "/reviews/review_form";
    }

    @PostMapping("/review_form.do")
    private String reviewFormFin(ReviewVO review) {
        // UserVO user = session.getAttribute("user");
        // Long id = user.getId();

        int userId = 1;
        review.setUserId(userId);

        int res = reviewDAO.addReview(review);

        return "redirect:/my_review_list.do";
    }

    @GetMapping("/my_review_list.do")
    private String myReviewList(Model model) {
        // UserVO user = session.getAttribute("user");
        // int id = user.getId();

        int id = 1;

        List<ReviewVO> list = reviewDAO.getMyReviewList(id);
        model.addAttribute("list", list);

        return "/reviews/my_review_list";
    }

    @GetMapping("/live_review_list.do")
    private String liveReviewList(Model model) {
        List<ReviewVO> list = reviewDAO.getLiveReviewList();
        model.addAttribute("list", list);

        return "/reviews/live_review_list";
    }
}
