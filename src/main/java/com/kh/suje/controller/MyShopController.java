package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.QnaDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MyShopController {

    private final ReviewDAO reviewDAO;
    private final OrderDAO orderDAO;
    private final QnaDAO qnaDAO;

    @GetMapping("/myshop")
    private String MyShop(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        int user_id = loginUser.getUser_id();

        Map<String, Object> statusCounts = orderDAO.selectOrderStatusCounts(user_id);
        
        int orderCount = orderDAO.getOrderCount(user_id);
        int reviewCount = reviewDAO.getReviewCount(user_id);
        int qnaCount = qnaDAO.getQnaCount(user_id);

        List<OrderVO> orderList = orderDAO.selectOrderListByUserId(user_id);
        
        // 주문별 주문상품 목록
        Map<Integer, List<OrderItemVO>> orderItemMap = new HashMap<>();
        
        for (OrderVO order : orderList) {
            List<OrderItemVO> itemList = orderDAO.selectOrderItemList(order.getOrder_id());

            orderItemMap.put(order.getOrder_id(), itemList);
        }

        model.addAllAttributes(statusCounts);

        model.addAttribute("orderCount", orderCount);
        model.addAttribute("reviewCount", reviewCount);
        model.addAttribute("qnaCount", qnaCount);

        model.addAttribute("orderList", orderList);
        model.addAttribute("orderItemMap", orderItemMap);

        model.addAttribute("activeMenu", "dashboard");
        model.addAttribute("contentPage", "/myshop/dashboard");

        return "myshop/myshop_main";
    }
}
