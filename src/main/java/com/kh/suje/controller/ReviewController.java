package com.kh.suje.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.vo.ImageVO;
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
    private final OrderDAO orderDAO;
    private final ProductDAO productDAO;
    
    @GetMapping(value={"testmain" ,"/review"})
    private String main() {
        return "/testmain";
    }

    @GetMapping("/review_form.do")
    private String reviewForm(Model model, int order_item_id) {

        int product_id = orderDAO.getProduct_id(order_item_id);
        ProductVO product = productDAO.product_one(product_id);
        model.addAttribute("product", product);
        model.addAttribute("order_item_id", order_item_id);

        return "/reviews/review_form";
    }

    @PostMapping("/review_form.do")
    private String reviewFormFin(ReviewVO review, List<MultipartFile> images) {
        // UserVO user = session.getAttribute("user");
        // Long id = user.getId();

        int user_id = 2;
        review.setUser_id(user_id);

        int res = reviewDAO.addReview(review);

        List<ImageVO> imageList = new ArrayList<>();
        
        // image_id INT AUTO_INCREMENT PRIMARY KEY,
        // target_type VARCHAR(30) NOT NULL,
        // target_id INT NOT NULL,
        // image_url VARCHAR(500) NOT NULL,
        // original_name VARCHAR(255),
        // sort_order INT DEFAULT 0,
        // created_at DATETIME DEFAULT NOW()

        int sort_order = 1;

        for (MultipartFile file : images) {
            if (file.isEmpty()) {
                continue;
            }

            String saveName = UUID.randomUUID() + "_" + file.getOriginalFilename();

            file.transferTo(new File(uploadPath, saveName));

            ImageVO image = new ImageVO();

            image.setTarget_type("REVIEW");
            image.setTarget_id(review.getReview_id());
            image.setImage_url("");
            image.setOriginal_name("");
            image.setSort_order(sort_order++);

            imageList.add(image);
        }

        return "redirect:/my_review_list.do";
    }

    @GetMapping("/my_review_list.do")
    private String myReviewList(Model model) {
        // UserVO user = session.getAttribute("user");
        // int id = user.getId();

        int userId = 2;

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
