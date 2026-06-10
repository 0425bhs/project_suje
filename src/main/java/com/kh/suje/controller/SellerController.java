package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.FavoriteDAO;
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
    private final CategoryDAO categorydao;
    private final SellerDAO sellerDAO;
    private final FavoriteDAO favoriteDAO;

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

    // 구매자용 판매자샵
    @GetMapping("/seller_shop_homepage.do")
    public String sellerShopHomepage(Model model, Integer seller_id, String sort) {

        if (seller_id == null) {
            return "redirect:/product/main.do";
        }

        if (sort == null || sort.equals("")) {
            sort = "rank";
        }

        // UserVO user = session.getAttribute(user);
        // int user_id = user.getUserId();
        int user_id = 3;

        Map<String, Object> favoriteMap = new HashMap<>();
        favoriteMap.put("user_id", user_id);
        favoriteMap.put("seller_id", seller_id);

        int favoriteShop = favoriteDAO.checkFavoriteShop(favoriteMap);
        boolean favorite = favoriteShop >= 1;

        Map<String, Object> listMap = new HashMap<>();
        listMap.put("seller_id", seller_id);
        listMap.put("sort", sort);

        List<ProductVO> list = productdao.sellerHomepageProductList(listMap);

        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        model.addAttribute("favorite", favorite);

        model.addAttribute("seller_id", seller_id);
        model.addAttribute("sort", sort);

        model.addAttribute("list", list);

        return "/seller/seller_shop_homepage";
    } 

    @GetMapping("/seller_statistics.do")
    public String seller_statistics(){
        return "/seller//seller_statistics";
    }

}
