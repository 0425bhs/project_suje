package com.kh.suje.controller;

import java.util.ArrayList;
import java.util.stream.Collectors;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.ImageDAO;
import com.kh.suje.vo.ImageVO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.vo.ReviewVO;
import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.FavoriteDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.SellerVO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SellerController {

    private final HttpSession session;

    private final ProductDAO productdao;
    private final CategoryDAO categorydao;
    private final SellerDAO sellerdao;
    private final FavoriteDAO favoritedao;
    private final ReviewDAO reviewdao;
    private final ImageDAO imagedao;

    // 로그인한 회원 기준으로 seller_id 찾기
    private Integer getLoginSellerId() {

        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            return null;
        }

        SellerVO seller = sellerdao.selectSeller(user.getUser_id());

        if (seller == null) {
            return null;
        }

        return seller.getSeller_id();
    }

    @GetMapping("/seller_dashboard.do")
    public String sellerDashboard(Model model) {
        
        Integer seller_id=getLoginSellerId();

        if(seller_id==null){
            return "redirect:/login.do";
        }

        Map<String, Object> orderStatusCounts = sellerdao.getOrderStatusCounts(seller_id);
        Map<String, Object> productStatusCounts = sellerdao.getProductStatusCounts(seller_id);
        int unansweredQnaCount = sellerdao.getUnansweredQnaCount(seller_id);
        int newReviewCount = sellerdao.getNewReviewCount(seller_id);

        if (orderStatusCounts != null) {
            model.addAllAttributes(orderStatusCounts); 
        }

        if (productStatusCounts != null) {
            model.addAllAttributes(productStatusCounts); 
        }

        model.addAttribute("unansweredQnaCount", unansweredQnaCount); 
        model.addAttribute("newReviewCount", newReviewCount);

        return "/seller/seller_dashboard";
    }

    @GetMapping("/seller_order_list.do")
    public String sellerOrderList(Model model, String status) {

        Integer seller_id = getLoginSellerId();

        if (seller_id == null) {
            return "redirect:/login.do";
        }

        Map<String, Object> map = new HashMap<>();
        map.put("seller_id", seller_id);
        map.put("status", status);

        List<OrderVO> orderList = sellerdao.getSellerOrderList(map);

        Map<Integer, List<OrderItemVO>> orderItemMap = new HashMap<>();

        for (OrderVO order : orderList) {
            Map<String, Object> itemMap = new HashMap<>();
            itemMap.put("seller_id", seller_id);
            itemMap.put("order_id", order.getOrder_id());
            itemMap.put("status", status);

            List<OrderItemVO> itemList = sellerdao.getSellerOrderItemList(itemMap);
            orderItemMap.put(order.getOrder_id(), itemList);
        }

        model.addAttribute("orderList", orderList);
        model.addAttribute("orderItemMap", orderItemMap);
        model.addAttribute("selectedStatus", status);

        return "/seller/seller_order_list";
    }
    
    @PostMapping("/seller_order_status_update.do")
    public String sellerOrderStatusUpdate(int order_item_id, String status, String selectedStatus) {

        Integer seller_id = getLoginSellerId();

        if (seller_id == null) {
            return "redirect:/login.do";
        }

        Map<String, Object> map = new HashMap<>();
        map.put("seller_id", seller_id);
        map.put("order_item_id", order_item_id);
        map.put("status", status);

        sellerdao.updateSellerOrderItemStatus(map);

        if (selectedStatus != null && !selectedStatus.trim().equals("")) {
            return "redirect:/seller_order_list.do?status=" + selectedStatus;
        }

        return "redirect:/seller_order_list.do";
    }

    @GetMapping("/seller_review_list.do")
    public String sellerReviewList(Model model) {

        Integer seller_id = getLoginSellerId();

        if (seller_id == null) {
            return "redirect:/login.do";
        }

        List<ReviewVO> reviewList = reviewdao.sellerReviewList(seller_id);
        List<ReviewVO> productList = reviewdao.sellerReviewProductList(seller_id);

        if (reviewList != null && !reviewList.isEmpty()) {
            List<Integer> reviewIds = reviewList.stream()
                    .map(ReviewVO::getReview_id)
                    .collect(Collectors.toList());

            List<ImageVO> images = imagedao.getImagesByReviewIds(reviewIds);

            if (images != null && !images.isEmpty()) {
                Map<Integer, List<ImageVO>> imageMap = images.stream()
                        .collect(Collectors.groupingBy(ImageVO::getTarget_id));

                for (ReviewVO review : reviewList) {
                    review.setImageList(
                            imageMap.getOrDefault(review.getReview_id(), new ArrayList<>())
                    );
                }
            }
        }

        model.addAttribute("reviewList", reviewList);
        model.addAttribute("productList", productList);

        return "/seller/seller_review_list";
    }

    @GetMapping("/seller_qna_list.do")
    public String sellerQnaList(HttpSession session, Model model) {

        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login_form.do";
        }

        model.addAttribute("activeMenu", "qna");

        return "seller/seller_qna_list";
    }

    // 구매자용 판매자샵
    @GetMapping("/seller_shop_homepage.do")
    public String sellerShopHomepage(Model model, Integer seller_id, String sort) {

        if (seller_id == null) {
            return "redirect:/product/main.do";
        }

        if (sort == null || sort.equals("")) {
            sort = "rank";
        }

        boolean favorite = false;
        UserVO user = (UserVO) session.getAttribute("user");

        if (user != null) {
            int user_id = user.getUser_id();

            Map<String, Integer> map = new HashMap<>();
            map.put("user_id", user_id);
            map.put("seller_id", seller_id);

            int check = favoritedao.checkFavoriteSeller(map);
            favorite = check >= 1;
        }

        Map<String, Object> seller = sellerdao.sellerShopInfo(seller_id);

        Map<String, Object> listMap = new HashMap<>();
        listMap.put("seller_id", seller_id);
        listMap.put("sort", sort);

        List<ProductVO> list = productdao.sellerHomepageProductList(listMap);
        int favoriteCount = favoritedao.SellerFavoriteCount(seller_id);
        
        Number productFavoriteCount = 0;

        if (seller != null && seller.get("product_favorite_count") != null) {
            productFavoriteCount = (Number) seller.get("product_favorite_count");
        }

        model.addAttribute("seller", seller);
        model.addAttribute("favoriteCount", favoriteCount);
        model.addAttribute("sellerFavoriteCountText", compactCount(favoriteCount));
        model.addAttribute("productFavoriteCountText", compactCount(productFavoriteCount));

        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        model.addAttribute("favorite", favorite);
        model.addAttribute("seller_id", seller_id);
        model.addAttribute("sort", sort);
        model.addAttribute("list", list);

        return "/seller/seller_shop_homepage";
    }

    private String compactCount(Number number) {

        if (number == null) {
            return "0";
        }

        long count = number.longValue();

        if (count < 1000) {
            return String.valueOf(count);
        }

        if (count < 10000) {
            double value = Math.ceil(count / 100.0) / 10.0;
            return String.format("%.1f천", value);
        }

        double value = Math.ceil(count / 1000.0) / 10.0;
        return String.format("%.1f만", value);
    }

    @GetMapping("/seller_statistics.do")
    public String seller_statistics(){
        return "/seller/seller_statistics";
    }

}
