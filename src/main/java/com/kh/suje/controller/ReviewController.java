package com.kh.suje.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.ReviewVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReviewController {
    @Autowired
    HttpSession session;

    private final ReviewDAO reviewDAO;
    private final ProductDAO productDAO;
    
    @GetMapping("/review")
    private String main() {
        return "/main";
    }

    @GetMapping("/review_form.do")
    private String reviewForm(Model model, int product_id) {
        ProductVO product = productDAO.product_one(product_id);
        model.addAttribute("product", product);

        return "/reviews/review_form";
    }

    @PostMapping("/review_form.do")
    private String reviewFormFin(ReviewVO review) {
        // UserVO user = session.getAttribute("user");
        // Long id = user.getId();

        int userId = 3;
        review.setUser_id(userId);

        int res = reviewDAO.addReview(review);

        return "redirect:/my_review_list.do";
    }

    @GetMapping("/my_review_list.do")
    private String myReviewList(Model model) {
        // UserVO user = session.getAttribute("user");
        // int id = user.getId();

        int userId = 3;

        List<ReviewVO> list = reviewDAO.getMyReviewList(userId);
        model.addAttribute("list", list);

        return "/reviews/my_review_list";
    }

    @GetMapping("/live_review_list.do")
    private String liveReviewList(Model model) {
        List<ReviewVO> list = reviewDAO.getLiveReviewList();
        model.addAttribute("list", list);

        return "/reviews/live_review_list";
    }

    @GetMapping("/review_update_form.do")
    private String reviewUpdateForm(Model model, int review_id) {
        ReviewVO review = reviewDAO.getReviewById(review_id);
        model.addAttribute("review", review);

        return "/reviews/review_update_form";
    }

    @PostMapping("/review_update_form.do")
    private String reviewUpdateFormFin(ReviewVO review) {
        int res = reviewDAO.updateReview(review);

        return "redirect:/my_review_list.do";
    }

    @GetMapping("/review_delete.do")
    private String reviewDelete(int review_id) {
        int res = reviewDAO.deleteReview(review_id);

        return "redirect:/my_review_list.do";
    }
}
