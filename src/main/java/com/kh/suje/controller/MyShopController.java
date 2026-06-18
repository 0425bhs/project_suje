package com.kh.suje.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.AddressDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.AddressVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MyShopController {

    private final HttpSession session;
    private final UserDAO userDao;
    private final AddressDAO addressDao;

    @GetMapping("/myshop")
    private String MyShop(Model model) {
        model.addAttribute("activeMenu", "myshop");
        model.addAttribute("contentPage", "/myshop/dashboard");

        return "/myshop/myshop_main";
    }


    //배송지 추가폼으로
    @GetMapping("/insertAddress.do")
    private String insertAddress(Model model) {

        UserVO sessionUser = (UserVO) session.getAttribute("user");
   
        model.addAttribute("user", sessionUser); 
        model.addAttribute("activeMenu", "myshop");
        model.addAttribute("contentPage", "/myshop/address_form");

        return "/myshop/address_list";
    }


    //배송지 조회
    @GetMapping("/addressList.do")
    private String addressLis(Model model) {

UserVO sessionUser = (UserVO) session.getAttribute("user");

List<AddressVO> list = addressDao.selectList(sessionUser.getUser_id());
   
        model.addAttribute("user", sessionUser); 
        model.addAttribute("list", list); 
        model.addAttribute("activeMenu", "myshop");
        model.addAttribute("contentPage", "/myshop/dashboard");

        return "/myshop/address_list";
    }

}
