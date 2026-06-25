package com.kh.suje.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.InquiryDAO;
import com.kh.suje.dao.NoticeDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.QnaDAO;
import com.kh.suje.dao.ReportDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.CategoryVO;
import com.kh.suje.vo.InquiryVO;
import com.kh.suje.vo.NoticeVO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.ReportVO;
import com.kh.suje.vo.ReviewVO;
import com.kh.suje.vo.SellerVO;
import com.kh.suje.vo.UserVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminController {
    private final UserDAO userDao;
    private final SellerDAO sellerDao;
    private final ProductDAO productDao;
    private final ReviewDAO reviewDao;
    private final QnaDAO qnaDao;
    private final CategoryDAO categoryDao;
    private final InquiryDAO inquiryDao;
    private final ReportDAO reportDao;
    private final NoticeDAO noticeDao;

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
        
        if (!"pending".equals(status) && !"approved".equals(status) && 
            !"rejected".equals(status) && !"hidden".equals(status)) {
            status = "all";
        }

        productList = productDao.getProductListByKeyword(status, keyword);
        int totalCount = productList.size();

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("productList", productList);
        model.addAttribute("totalCount", totalCount);
        
        return "/admin/admin_product_approval";
    }

    @GetMapping("/admin/reviews")
    public String reviews(Model model, String status, String keyword) {
        List<ReviewVO> reviewList;
        
        if (!"public".equals(status) && !"private".equals(status)) {
            status = "all";
        }

        reviewList = reviewDao.getReviewListByKeyword(status, keyword);
        int totalCount = reviewList.size();

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("reviewList", reviewList);
        model.addAttribute("totalCount", totalCount);

        return "/admin/admin_review_manage";
    }

    @GetMapping("/admin/inquiries")
    public String inquiries(Model model, String status, String keyword) {
        List<InquiryVO> inquiryList;
        
        if (!"waiting".equals(status) && !"answered".equals(status)) {
            status = "all";
        }

        inquiryList = inquiryDao.getInquryListByKeyword(status, keyword);
        int totalCount = inquiryList.size();

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("inquiryList", inquiryList);
        model.addAttribute("totalCount", totalCount);

        return "/admin/admin_inquiry_manage";
    }

    @GetMapping("/admin/reports")
    public String reports(Model model, String status, String keyword) {
        List<ReportVO> reportList;
        
        if (!"pending".equals(status) && !"processed".equals(status) && 
            !"rejected".equals(status)) {
            status = "all";
        }

        reportList = reportDao.getReportListByKeyword(status, keyword);
        int totalCount = reportList.size();

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("reportList", reportList);
        model.addAttribute("totalCount", totalCount);

        return "/admin/admin_report_manage";
    }

    @GetMapping("/admin/categories")
    public String categories(Model model) {
        List<CategoryVO> categoryList = categoryDao.getCategoryHierarchy();
        model.addAttribute("categoryList", categoryList);

        return "/admin/admin_category_manage";
    }

    @GetMapping("/admin/notices")
    public String notices(Model model, String keyword) {
       List<NoticeVO> noticeList;
        
        noticeList = noticeDao.getNoticeListByKeyword(keyword);
        int totalCount = noticeList.size();

        model.addAttribute("keyword", keyword);
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("totalCount", totalCount);

        return "/admin/admin_notice_manage";
    }

    @GetMapping("/admin/statistics")
    public String statistics() {

        return "/admin/admin_statistics";
    }
}
