package com.kh.suje.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.suje.dao.OrderDAO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MyShopController {

    private final OrderDAO orderDAO;

    @GetMapping("/myshop")
    private String MyShop(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        int user_id = loginUser.getUser_id();

        // 1. 상태별 개수를 DB에서 한 번에 가져옴 (위의 CASE WHEN 쿼리 실행)
        Map<String, Object> statusCounts = orderDAO.selectOrderStatusCounts(user_id);

        List<OrderVO> orderList = orderDAO.selectOrderListByUserId(user_id);
        model.addAttribute("orderList", orderList);

        // model에 Map의 값들을 통째로 넘겨줌
        model.addAllAttributes(statusCounts);

        model.addAttribute("activeMenu", "myshop");
        model.addAttribute("contentPage", "/myshop/dashboard");

        model.addAttribute("activeMenu", "dashboard");

        return "myshop/myshop_main";
    }

    
}
