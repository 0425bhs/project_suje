package com.kh.suje.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.kh.suje.dao.ImageDAO;
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
    private final ImageDAO imageDAO;
    
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
    @Transactional(rollbackFor = Exception.class)
    private String reviewFormFin(ReviewVO review, List<MultipartFile> images) throws IllegalStateException, IOException {
        // UserVO user = session.getAttribute("user");
        // Long id = user.getId();

        int user_id = 2;
        review.setUser_id(user_id);

        int res = reviewDAO.addReview(review);

        //저장경로 지정
        String savePath = "/Users/kkt/Desktop/KKT/Spring_boot/upload";

        //저장경로가 없다면 생성
        File dir = new File(savePath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        List<ImageVO> imageList = new ArrayList<>();
        int sort_order = 1;

        for (MultipartFile file : images) {
            if (file.isEmpty()) {
                continue;
            }

            String saveName = UUID.randomUUID() + "_" + file.getOriginalFilename();
            File saveFile = new File(savePath, saveName);
            file.transferTo(saveFile);

            ImageVO image = new ImageVO();
            image.setTarget_type("REVIEW");
            image.setTarget_id(review.getReview_id());
            image.setImage_url(saveName);
            image.setOriginal_name(file.getOriginalFilename());
            image.setSort_order(sort_order++);

            imageList.add(image);
        }

        if (!imageList.isEmpty()) {
            imageDAO.insertImageList(imageList); 
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
