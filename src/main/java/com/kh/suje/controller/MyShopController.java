package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.AddressDAO;
import com.kh.suje.dao.FavoriteDAO;
import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.QnaDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.AddressVO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.QnaVO;
import com.kh.suje.vo.ReviewVO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MyShopController {

    private final HttpSession session;
    private final UserDAO userDao;
    private final AddressDAO addressDao;
    private final OrderDAO orderDAO;
    private final QnaDAO qnaDAO;
    private final ProductDAO productDAO;
    private final ReviewDAO reviewDAO;
    private final FavoriteDAO favoritedao;
    
    @GetMapping("/myshop")
    public String MyShop(HttpSession session, Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        int user_id = loginUser.getUser_id();

        Map<String, Object> statusCounts = orderDAO.selectOrderStatusCounts(user_id);
        model.addAllAttributes(statusCounts);

        int writtenReviewCount = reviewDAO.getWrittenReviewCount(user_id);
        int writableReviewCount = reviewDAO.getWritableReviewCount(user_id);
        model.addAttribute("writtenReviewCount", writtenReviewCount);
        model.addAttribute("writableReviewCount", writableReviewCount);

        int watingQnaCount = qnaDAO.getWatingQnaCount(user_id);
        int answeredQnaCount = qnaDAO.getAnsweredQnaCount(user_id);
        model.addAttribute("watingQnaCount", watingQnaCount);
        model.addAttribute("answeredQnaCount", answeredQnaCount);

        int productFavoriteCount = favoritedao.getFavoriteProductCount(user_id);
        int sellerFavoriteCount = favoritedao.getFavoriteSellerCount(user_id);
        model.addAttribute("productFavoriteCount", productFavoriteCount);
        model.addAttribute("sellerFavoriteCount", sellerFavoriteCount);
        // int orderCount = orderDAO.getOrderCount(user_id);
        // int reviewCount = reviewDAO.getReviewCount(user_id);
        // int qnaCount = qnaDAO.getQnaCount(user_id);

        List<OrderVO> orderList = orderDAO.selectOrderListByUserId(user_id);
        
        // 주문별 주문상품 목록
        Map<Integer, List<OrderItemVO>> orderItemMap = new HashMap<>();
        
        for (OrderVO order : orderList) {
            List<OrderItemVO> itemList = orderDAO.selectOrderItemList(order.getOrder_id());

            orderItemMap.put(order.getOrder_id(), itemList);
        }
        model.addAttribute("orderList", orderList);
        model.addAttribute("orderItemMap", orderItemMap);

        List<ReviewVO> writableReviews = reviewDAO.getWritableReview(user_id);
        model.addAttribute("writableReviews", writableReviews);

        List<QnaVO> qnaList = qnaDAO.getMyQnaList(user_id);
        model.addAttribute("qnaList", qnaList);
        
        List<ProductVO> productRecentList = productDAO.product_recent(user_id);
        model.addAttribute("productRecentList", productRecentList);

        model.addAttribute("activeMenu", "dashboard");
        model.addAttribute("contentPage", "/myshop/dashboard");

        return "myshop/myshop_main";
    }

        //배송지 추가폼으로
    @GetMapping("/insertAddress.do")
    private String insertAddress(Model model) {

        UserVO sessionUser = (UserVO) session.getAttribute("user");
   
        model.addAttribute("user", sessionUser); 
        model.addAttribute("activeMenu", "myshop");
        model.addAttribute("contentPage", "/myshop/address_form");

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


    //최근 본 상품 상세
    @GetMapping("/myshop/recent")
    public String recentViewedProducts(HttpSession session, Model model) {
        UserVO loginUser = (UserVO)session.getAttribute("user");
        if (loginUser == null) {
            return "redirect:/login.do";
        }
        int user_id = loginUser.getUser_id();
        List<ProductVO> recentList = productDAO.product_recent(user_id);

        model.addAttribute("recentList", recentList);
        model.addAttribute("activeMenu", "recent");
        model.addAttribute("contentPage", "/myshop/recent");

        return "/myshop/myshop_main";
    }
}
