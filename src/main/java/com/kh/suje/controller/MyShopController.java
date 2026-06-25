package com.kh.suje.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.AddressDAO;
import com.kh.suje.dao.OrderDAO;
<<<<<<< HEAD
=======
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.dao.UserDAO;
>>>>>>> dd0ae9eb6da1fe0f282905e8284600fd5b58f512
import com.kh.suje.vo.AddressVO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MyShopController {

    private final HttpSession session;
<<<<<<< HEAD
=======
    private final UserDAO userDao;
>>>>>>> dd0ae9eb6da1fe0f282905e8284600fd5b58f512
    private final AddressDAO addressDao;
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

        //배송지 추가폼으로
    @GetMapping("/insertAddress.do")
    private String insertAddress(Model model) {

        UserVO sessionUser = (UserVO) session.getAttribute("user");
   
        model.addAttribute("user", sessionUser); 
        model.addAttribute("activeMenu", "myshop");
        model.addAttribute("contentPage", "/myshop/address_form");

<<<<<<< HEAD
        return "myshop/myshop_main";
    }


    //배송지 추가
    @PostMapping("/insertAddress.do")
    private String insertAddress(AddressVO vo) {    

        UserVO sessionUser = (UserVO) session.getAttribute("user");

        //안전장치
        if(sessionUser == null) {
        return "redirect:/login.do";
    }

        int user_id = sessionUser.getUser_id();
        vo.setUser_id(user_id);

        if (vo.getIs_default() == null) {
        vo.setIs_default("false");
    }

    if ("true".equals(vo.getIs_default())) {             
        // 기존에 설정되어 있는 기본 배송지 삭제
          addressDao.deleteDefault(user_id); 
        }
        
       int res = addressDao.insertAddress(vo);
   
        return "redirect:/addressList.do";
=======
        return "/myshop/address_list";
>>>>>>> dd0ae9eb6da1fe0f282905e8284600fd5b58f512
    }


    //배송지 조회
    @GetMapping("/addressList.do")
    private String addressList(Model model) {

        UserVO sessionUser = (UserVO) session.getAttribute("user");

        List<AddressVO> list = addressDao.selectList(sessionUser.getUser_id());
        
        model.addAttribute("user", sessionUser); 
        model.addAttribute("list", list); 
        model.addAttribute("activeMenu", "myshop");
        model.addAttribute("contentPage", "/myshop/address_list");

        return "myshop/myshop_main";
    }


    //배송지 삭제
    @PostMapping("/deleteAddress.do")
    private String deleteAddress(int address_id) {
        

        int res = addressDao.deleteAddress(address_id);

        return "redirect:/addressList.do";
    }


     //배송지 수정폼으로
    @GetMapping("/modifyAddress.do")
    private String  modifyAddress(Model model, int address_id) {

    AddressVO vo = addressDao.selectOne(address_id);
   
        model.addAttribute("vo", vo); 
        model.addAttribute("activeMenu", "myshop");
        model.addAttribute("contentPage", "/myshop/address_modiForm");

        return "myshop/myshop_main";
    }
         


    //배송지 수정
    @PostMapping("/modifyAddress.do")
    private String modifyAddress(AddressVO vo) {

        UserVO sessionUser = (UserVO) session.getAttribute("user");
    if (sessionUser == null) {
        return "redirect:/login.do";
    }

    int user_id = sessionUser.getUser_id();
    vo.setUser_id(user_id);

        if (vo.getIs_default() == null) {
        vo.setIs_default("false");
    }

if ("true".equals(vo.getIs_default())) {
             
        // 기존에 설정되어 있는 기본 배송지 삭제
        addressDao.deleteDefault(user_id); 
    }

        int result = addressDao.modifyAddress(vo);

        return "redirect:/addressList.do";
    } 

}
