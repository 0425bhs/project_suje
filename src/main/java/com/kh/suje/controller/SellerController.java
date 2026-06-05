package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.vo.ProductVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SellerController {

    @Autowired
    HttpSession session;

    private final ProductDAO productdao;
    private final SellerDAO sellerDAO;

    // @GetMapping("/seller_homepage.do")
    // public String sellerHomepage(Model model,Integer seller_id,String sort) {

    //     //테스트용으로 1번 판매자 사용
    //     if (seller_id == null) {
    //         seller_id = 1;
    //     }    

    //     // 처음 들어왔을 때 sort가 없으면 기본값
    //     if (sort == null || sort.equals("")) {
    //         sort = "rank";
    //     }

    //     Map<String, Object> map = new HashMap<>();
    //     map.put("seller_id", seller_id);
    //     map.put("sort", sort);

    //     List<ProductVO> list=productdao.sellerHomepageProductList(map);

    //     model.addAttribute("list", list);
    //     model.addAttribute("seller_id", seller_id);
    //     model.addAttribute("sort", sort);

    //     return "seller/seller_homepage";
    // }

    @PostMapping("/seller_product_delete.do")
    @ResponseBody
    public Map<String, Object> sellerProductDelete(int product_id) {

        Map<String, Object> map = new HashMap<>();

        int result = productdao.seller_product_delete(product_id);

        map.put("result", result);

        return map;
    }

    @GetMapping("/seller_dashboard.do")
    public String sellerDashboard(Model model) {
        // SellerVO seller = (SellerVO) session.getAttribute("seller");
        // int seller_id = seller.getSellerId();
        int seller_id = 1;

        Map<String, Object> orderStatusCounts = sellerDAO.getOrderStatusCounts(seller_id);
        Map<String, Object> productStatusCounts = sellerDAO.getProductStatusCounts(seller_id);
        int unansweredQnaCount = sellerDAO.getUnansweredQnaCount(seller_id);
        int newReviewCount = sellerDAO.getNewReviewCount(seller_id);

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
    public String sellerOrderList(){
        return "/seller/seller_order_list";
    }

    @GetMapping("/seller_qna_list.do")
    public String sellerQnaList(){
        return "/seller/seller_qna_list";
    }

    @GetMapping("/seller_homepage.do")
    public String sellerHomepage(Model model, Integer seller_id, String sort) {

        // 테스트용으로 1번 판매자 사용
        if (seller_id == null) {
            seller_id = 1;
        }

        // 처음 들어왔을 때 sort가 없으면 기본값
        if (sort == null || sort.equals("")) {
            sort = "rank";
        }

        Map<String, Object> map = new HashMap<>();
        map.put("seller_id", seller_id);
        map.put("sort", sort);

        List<ProductVO> list = productdao.sellerHomepageProductList(map);

        model.addAttribute("list", list);
        model.addAttribute("seller_id", seller_id);
        model.addAttribute("sort", sort);
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        return "/seller/seller_homepage";
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

        Map<String, Object> map = new HashMap<>();
        map.put("seller_id", seller_id);
        map.put("sort", sort);

        List<ProductVO> list = productdao.sellerHomepageProductList(map);

        model.addAttribute("list", list);
        model.addAttribute("seller_id", seller_id);
        model.addAttribute("sort", sort);
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        return "/seller/seller_shop_homepage";
    } 

}
