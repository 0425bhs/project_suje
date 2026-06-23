package com.kh.suje.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.SellerVO;
import com.kh.suje.vo.UserVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminController {
    private final UserDAO userDao;
    private final SellerDAO sellerDao;
    private final ProductDAO productDao;

    @GetMapping(value={"/admin", "/admin/dashboard"})
    public String adminDashboard() {

        return "/admin/admin_dashboard";
    }

    @GetMapping("/admin/members")
    public String members(Model model, String role, String keyword) {

        List<UserVO> userList;
        
        if (!"user".equals(role) && !"seller".equals(role)) {
            role = "all";
        }

        System.out.println("role : " + role);
        System.out.println("keyword : " + keyword);
        
        userList = userDao.getUserListByKeyword(role, keyword);
        int totalCount = userList.size();

        model.addAttribute("role", role);
        model.addAttribute("keyword", keyword);
        model.addAttribute("userList", userList);
        model.addAttribute("totalCount", totalCount);
        
        return "/admin/admin_member_list";
    }

    @GetMapping("/admin/sellers")
    public String sellers(Model model, String status, String keyword) {
        List<SellerVO> sellerList;
        
        if (!"pending".equals(status) && !"approved".equals(status) && !"rejected".equals(status)) {
            status = "all";
        }

        sellerList = sellerDao.getSellerListByKeyword(status, keyword);
        int totalCount = sellerList.size();

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sellerList", sellerList);
        model.addAttribute("totalCount", totalCount);
        
        return "/admin/admin_seller_approval";
    }

    @GetMapping("/admin/products")
    public String products(Model model, String status, String keyword) {
        List<ProductVO> productList;
        
        if (!"pending".equals(status) && !"approved".equals(status) && !"rejected".equals(status)) {
            status = "all";
        }

        productList = productDao.getProductListByKeyword(status, keyword);
        int totalCount = productList.size();

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("sellerList", productList);
        model.addAttribute("totalCount", totalCount);
        
        return "/admin/admin_product_approval";
    }

    @GetMapping("/admin/reviews")
    public String reviews() {

        return "/admin/admin_review_manage";
    }


    @GetMapping("/admin/qnas")
    public String qnas() {

        return "/admin/admin_qna_manage";
    }

    @GetMapping("/admin/reports")
    public String reports() {

        return "/admin/admin_report_manage";
    }

    @GetMapping("/admin/categories")
    public String categories() {

        return "/admin/admin_category_manage";
    }

    @GetMapping("/admin/notices")
    public String notices() {

        return "/admin/admin_notice_manage";
    }

    @GetMapping("/admin/statistics")
    public String statistics() {

        return "/admin/admin_statistics";
    }
}
