package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.CartDAO;
import com.kh.suje.vo.CartVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CartController {
    @Autowired
    HttpSession session;

    private final CartDAO cartdao;

    @GetMapping("/cart_list.do")
    public String cartList(Model model){
    
        UserVO user=(UserVO)session.getAttribute("user");

        if (user==null) {
            return "redirect:/login.do";
        }

        int user_id=user.getUser_id();

        List<Map<String,Object>> list=cartdao.cartList(user_id);

        int totalPrice = 0;
        int totalDeliveryFee = 0;
        for (Map<String, Object> item : list) {

            int itemTotal=((Number)item.get("item_total")).intValue();

            int deliveryFee=((Number)item.get("delivery_fee")).intValue();

            totalPrice += itemTotal;

            totalDeliveryFee += deliveryFee;
        }

        int paymentPrice = totalPrice + totalDeliveryFee;

        model.addAttribute("list",list);
        model.addAttribute("totalPrice",totalPrice);
        model.addAttribute("totalDeliveryFee",totalDeliveryFee);
        model.addAttribute("paymentPrice",paymentPrice);

        return "/cart_list";
    }    

    @PostMapping("cart_insert.do")
    public Map<String, Object> cartInsert(CartVO vo){
        Map<String, Object> map=new HashMap<>();

        UserVO user=(UserVO)session.getAttribute("user");

        if (user == null){
            map.put("result", "login");
            return map;
        }

        int user_id=user.getUser_id();

        vo.setUser_id(user_id);

        if (vo.getQuantity()<=0){
            vo.setQuantity(1);
        }

        int count=cartdao.cartCheck(vo);

        int res=0;

        if (count>0){
            res=cartdao.cartQuantityPlus(vo);
        } else {
            res=cartdao.cartInsert(vo);
        }

        if (res>0){
            map.put("result", "success");
        } else{
            map.put("result", "fail");
        }

        return map;
    }
}
