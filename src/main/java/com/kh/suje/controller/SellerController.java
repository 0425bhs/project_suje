package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.FavoriteDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.vo.ProductVO;
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

    @GetMapping("/seller_dashboard.do")
    public String sellerDashboard(Model model) {
        // SellerVO seller = (SellerVO) session.getAttribute("seller");
        // int seller_id = seller.getSellerId();
        int seller_id = 1;

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

        // 로그인 연동 전까지 임시 판매자 번호 사용
        int seller_id = 1;

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

        // 로그인 연동 전까지 임시 판매자 번호 사용
        int seller_id = 1;

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

        Map<String, Object> listMap = new HashMap<>();
        listMap.put("seller_id", seller_id);
        listMap.put("sort", sort);

        List<ProductVO> list = productdao.sellerHomepageProductList(listMap);

        int favoriteCount = favoritedao.SellerFavoriteCount(seller_id);

        model.addAttribute("favoriteCount", favoriteCount);
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
