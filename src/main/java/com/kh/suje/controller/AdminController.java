package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.InquiryDAO;
import com.kh.suje.dao.NoticeDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.ReportDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.CategoryVO;
import com.kh.suje.vo.InquiryVO;
import com.kh.suje.vo.NoticeVO;
import com.kh.suje.vo.PaginationVO;
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
    private final CategoryDAO categoryDao;
    private final InquiryDAO inquiryDao;
    private final ReportDAO reportDao;
    private final NoticeDAO noticeDao;

    @GetMapping(value = {"/admin", "/admin/dashboard"})
    public String adminDashboard() {

        return "/admin/admin_dashboard";
    }

    @GetMapping("/admin/members")
    public String members(Model model, String role, String keyword, Integer size, Integer page) {
        if (!"user".equals(role) && !"seller".equals(role)) {
            role = "all";
        }

        int totalCount = userDao.getUserListCountByKeyword(role, keyword);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);

        List<UserVO> userList = userDao.getUserListByKeyword(role, keyword, 
                                                             pagination.getSize(), 
                                                             pagination.getOffset());

        model.addAttribute("role", role);
        model.addAttribute("keyword", keyword);
        model.addAttribute("userList", userList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

        return "/admin/admin_member_list";
    }

    @GetMapping("/admin/members/detail")
    @ResponseBody
    public Map<String, Object> memberDetail(int user_id) {
        Map<String, Object> map = new HashMap<>();
        UserVO user = userDao.selectUser(user_id);

        if (user == null) {
            map.put("success", false);
            map.put("message", "회원 정보를 찾을 수 없습니다.");
            return map;
        }

        map.put("success", true);
        map.put("user", user);
        return map;
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

    @GetMapping("/admin/sellers/detail")
    @ResponseBody
    public Map<String, Object> sellerDetail(int seller_id) {
        Map<String, Object> map = new HashMap<>();
        SellerVO seller = sellerDao.getSellerById(seller_id);

        if (seller == null) {
            map.put("success", false);
            map.put("message", "판매자 정보를 찾을 수 없습니다.");
            return map;
        }

        map.put("success", true);
        map.put("seller", seller);
        return map;
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

    @GetMapping("/admin/products/detail")
    @ResponseBody
    public Map<String, Object> productDetail(int product_id) {
        Map<String, Object> map = new HashMap<>();
        ProductVO product = productDao.product_one(product_id);

        if (product == null) {
            map.put("success", false);
            map.put("message", "상품 정보를 찾을 수 없습니다.");
            return map;
        }

        map.put("success", true);
        map.put("product", product);
        return map;
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

    @GetMapping("/admin/reviews/detail")
    @ResponseBody
    public Map<String, Object> reviewDetail(int review_id) {
        Map<String, Object> map = new HashMap<>();
        ReviewVO review = reviewDao.getReviewById(review_id);

        if (review == null) {
            map.put("success", false);
            map.put("message", "후기 정보를 찾을 수 없습니다.");
            return map;
        }

        map.put("success", true);
        map.put("review", review);
        return map;
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

    @GetMapping("/admin/inquiries/detail")
    @ResponseBody
    public Map<String, Object> inquiryDetail(int inquiry_id) {
        Map<String, Object> map = new HashMap<>();
        InquiryVO inquiry = inquiryDao.getInquiryById(inquiry_id);

        if (inquiry == null) {
            map.put("success", false);
            map.put("message", "문의 정보를 찾을 수 없습니다.");
            return map;
        }

        map.put("success", true);
        map.put("inquiry", inquiry);
        return map;
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

    @GetMapping("/admin/reports/detail")
    @ResponseBody
    public Map<String, Object> reportDetail(int report_id) {
        Map<String, Object> map = new HashMap<>();
        ReportVO report = reportDao.getReportById(report_id);

        if (report == null) {
            map.put("success", false);
            map.put("message", "신고 정보를 찾을 수 없습니다.");
            return map;
        }

        map.put("success", true);
        map.put("report", report);
        return map;
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

    @GetMapping("/admin/notices/detail")
    @ResponseBody
    public Map<String, Object> noticeDetail(int notice_id) {
        Map<String, Object> map = new HashMap<>();
        NoticeVO notice = noticeDao.getNoticeById(notice_id);

        if (notice == null) {
            map.put("success", false);
            map.put("message", "공지사항 정보를 찾을 수 없습니다.");
            return map;
        }

        map.put("success", true);
        map.put("notice", notice);
        return map;
    }

    @GetMapping("/admin/statistics")
    public String statistics() {

        return "/admin/admin_statistics";
    }
}
