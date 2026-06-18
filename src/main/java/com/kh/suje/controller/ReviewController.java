package com.kh.suje.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

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
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReviewController {
    private final ReviewDAO reviewDAO;
    private final OrderDAO orderDAO;
    private final ProductDAO productDAO;
    private final ImageDAO imageDAO;

    @GetMapping(value={"testmain" ,"/review"})
    public String main() {
        return "/testmain";
    }

    @GetMapping("/review_form.do")
    public String reviewForm(Model model, int order_item_id) {

        Integer product_id = orderDAO.getProductId(order_item_id);
        ProductVO product = productDAO.product_one(product_id);

        model.addAttribute("product", product);
        model.addAttribute("order_item_id", order_item_id);

        return "/reviews/review_form";
    }

    @PostMapping("/review_form.do")
    @Transactional(rollbackFor = Exception.class)
    public String reviewFormFin(ReviewVO review, List<MultipartFile> images) throws IllegalStateException, IOException {
        // UserVO user = session.getAttribute("user");
        // Long id = user.getId();

        int user_id = 2;
        review.setUser_id(user_id);

        reviewDAO.addReview(review);

        //저장경로 지정
        String savePath = "C:\\upload";
        // String savePath = "/Users/kkt/Desktop/KKT/Spring_boot/upload";

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

        return "redirect:/myshop/reviews";
    }

    @GetMapping("/myshop/reviews")
    public String myReviewList(HttpSession session, Model model, String tab) {
        UserVO user = (UserVO)session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.do";
        }
        int user_id = user.getUser_id();

        if (tab == null || tab.trim().isEmpty()) {
            tab = "written"; 
        }

        List<ReviewVO> list;
        if ("writable".equals(tab)) {
            list = reviewDAO.getWritableReview(user_id);
        } else {
            list = reviewDAO.getWrittenReview(user_id);
        }
        
        if (list != null && !list.isEmpty()) {
            //리뷰 리스트에서 리뷰id를 가져와서 리뷰 아이디 리스트에 담기
            List<Integer> reviewIds = list.stream()
                                      .map(ReviewVO::getReview_id)
                                      .collect(Collectors.toList());

            //리뷰 아이디 리스트를 가지고 해당하는 이미지를 모두 가져와서 이미지 리스트에 담기
            List<ImageVO> images = imageDAO.getImagesByReviewIds(reviewIds);
            
            if (images != null && !images.isEmpty()) {
                //이미지 리스트에서 타겟 아이디를 기준으로 이미지들을 그룹화
                Map<Integer, List<ImageVO>> imageMap = images.stream()
                        .collect(Collectors.groupingBy(ImageVO::getTarget_id));

                // 리뷰 리스트에 리뷰 리스트와 동일한 아이디를 갖는 이미지 그룹을 연결
                for (ReviewVO review : list) {
                    review.setImageList(imageMap.getOrDefault(review.getReview_id(), new ArrayList<>()));
                }
            }
        }

        // int totalCount = list == null ? 0 : list.size();
        int writtenReviewCount = reviewDAO.getWrittenReviewCount(user_id);
        int writableReviewCount = reviewDAO.getWritableReviewCount(user_id);

        model.addAttribute("list", list);
        // model.addAttribute("totalCount", totalCount);
        model.addAttribute("tab", tab);
        model.addAttribute("writtenReviewCount", writtenReviewCount);
        model.addAttribute("writableReviewCount", writableReviewCount);
        model.addAttribute("activeMenu", "review");
        model.addAttribute("contentPage", "/myshop/review_list");

        return "/myshop/myshop_main";

        // 이전 코드
        // List<ReviewVO> list;

        // if (tab == null || tab.trim().isEmpty()) {
        //     list = reviewDAO.getWrittenReview(user_id);
        // } else {
        //     list = reviewDAO.getWritableReview(user_id);
        // }

        // if (list != null && !list.isEmpty()) {
        //     List<Integer> reviewIds = new ArrayList<>();
        //     for (ReviewVO review : list) {
        //         reviewIds.add(review.getReview_id()); 
        //     }

        //     List<ImageVO> images = imageDAO.getImagesByReviewIds(reviewIds);
            
        //     for (ReviewVO review : list) {
        //         List<ImageVO> matchedImages = new ArrayList<>();
        //         for (ImageVO image : images) {
        //             if (review.getReview_id() == image.getTarget_id()) {
        //                 matchedImages.add(image);
        //             }
        //         }
        //         review.setImageList(matchedImages);
        //     }
        // }

    }

    @GetMapping("/live_review_list.do")
    public String liveReviewList(Model model) {
        List<ReviewVO> list = reviewDAO.getLiveReviewList();
        model.addAttribute("list", list);

        return "/reviews/live_review_list";
    }

    @GetMapping("/review_update_form.do")
    public String reviewUpdateForm(Model model, int review_id) {
        ReviewVO review = reviewDAO.getReviewById(review_id);

        List<ImageVO> images = imageDAO.getImagesByReviewId(review.getReview_id());
        review.setImageList(images);

        model.addAttribute("review", review);

        return "/reviews/review_update_form";
    }

    @PostMapping("/review_update_form.do")
    public String reviewUpdateFormFin(ReviewVO review) {
        reviewDAO.updateReview(review);

        return "redirect:/myshop/reviews";
    }

    @GetMapping("/review_delete.do")
    public String reviewDelete(int review_id) {
        reviewDAO.deleteReview(review_id);

        return "redirect:/myshop/reviews";
    }
}
