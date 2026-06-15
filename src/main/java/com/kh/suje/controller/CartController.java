package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.CartDAO;
import com.kh.suje.vo.CartVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CartController {
    
    private final CartDAO cartdao;

    private final HttpSession session;
    
    @GetMapping("/cart_list.do")
    public String cartList(Model model){

    UserVO user=(UserVO)session.getAttribute("user");

    if(user==null){
        return "redirect:/login.do";
    }

    int user_id=user.getUser_id();

    List<Map<String,Object>> list=cartdao.cartList(user_id);

    List<Map<String,Object>> sellerGroupList=new java.util.ArrayList<>();

    int totalOriginPrice=0;
    int totalPrice=0;
    int totalDiscountPrice=0;
    int totalDeliveryFee=0;

    Map<String,Object> currentGroup=null;
    int currentSellerId=-1;

    for(Map<String,Object> item:list){

        int sellerId=((Number)item.get("seller_id")).intValue();

        if(currentGroup==null || currentSellerId != sellerId){

            currentGroup=new HashMap<>();
            currentGroup.put("seller_id", sellerId);
            currentGroup.put("seller_name", item.get("seller_name"));

            int deliveryFee=((Number)item.get("delivery_fee")).intValue();
            currentGroup.put("delivery_fee", deliveryFee);

            List<Map<String,Object>> itemList=new java.util.ArrayList<>();
            currentGroup.put("itemList", itemList);

            sellerGroupList.add(currentGroup);

            currentSellerId=sellerId;
            totalDeliveryFee += deliveryFee;
        }

        List<Map<String,Object>> itemList=(List<Map<String,Object>>)currentGroup.get("itemList");
        itemList.add(item);

        totalOriginPrice += ((Number)item.get("origin_total")).intValue();
        totalPrice += ((Number)item.get("item_total")).intValue();
        totalDiscountPrice += ((Number)item.get("discount_total")).intValue();
    }

    int couponPrice=0;
    int paymentPrice=totalPrice + totalDeliveryFee - couponPrice;

    model.addAttribute("sellerGroupList", sellerGroupList);

    model.addAttribute("totalOriginPrice", totalOriginPrice);
    model.addAttribute("totalPrice", totalPrice);
    model.addAttribute("totalDiscountPrice", totalDiscountPrice);
    model.addAttribute("couponPrice", couponPrice);
    model.addAttribute("totalDeliveryFee", totalDeliveryFee);
    model.addAttribute("paymentPrice", paymentPrice);

    return "/cart_list";
}

    @ResponseBody
    @PostMapping("/cart_insert.do")
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

    @GetMapping("/cart_quantity_update.do")
    public String cartQuantityUpdate(int cart_id, int quantity) {

        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login.do";
        }

        if (quantity <= 0) {
            quantity = 1;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("cart_id", cart_id);
        map.put("quantity", quantity);
        map.put("user_id", user.getUser_id());

        cartdao.cartQuantityUpdate(map);

        return "redirect:/cart_list.do";
    }

    @PostMapping("/cart_delete_selected.do")
    public String cartDeleteSelected(int[] cart_id) {

        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login.do";
        }

        if (cart_id != null && cart_id.length > 0) {
            Map<String, Object> map = new HashMap<>();
            map.put("cart_id", cart_id);
            map.put("user_id", user.getUser_id());

            cartdao.cartDeleteSelected(map);
        }

        return "redirect:/cart_list.do";
    }
}
