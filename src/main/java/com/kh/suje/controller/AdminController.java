package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.AdminActionLogDAO;
import com.kh.suje.dao.AdminMemoDAO;
import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.InquiryDAO;
import com.kh.suje.dao.NoticeDAO;
import com.kh.suje.dao.OptionDAO;
import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.ReportDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.AdminActionLogVO;
import com.kh.suje.vo.AdminMemoVO;
import com.kh.suje.vo.CategoryVO;
import com.kh.suje.vo.InquiryVO;
import com.kh.suje.vo.NoticeVO;
import com.kh.suje.vo.PaginationVO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.ReportVO;
import com.kh.suje.vo.ReviewVO;
import com.kh.suje.vo.SellerVO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderVO;

import jakarta.servlet.http.HttpSession;
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
    private final OrderDAO orderDao;
    private final AdminMemoDAO adminMemoDao;
    private final AdminActionLogDAO adminActionLogDao;
    private final OptionDAO optionDao;
    private final HttpSession session;

    @GetMapping(value = {"/admin", "/admin/dashboard"})
    public String adminDashboard(Model model) {

        model.addAttribute("pendingSellerCount",
                           sellerDao.getSellerListCountByKeyword("pending", null, null, null, null, null));
        model.addAttribute("pendingProductCount",
                           productDao.getProductListCountByKeyword("pending", null, null, null, null,
                                                                   null, null, null, null));
        model.addAttribute("pendingReportCount",
                           reportDao.getReportListCountByKeyword("pending", null, null, "all", null, null, null));
        model.addAttribute("waitingInquiryCount",
                           inquiryDao.getInquryListCountByKeyword("waiting", null, null, "all", null, null));
        model.addAttribute("totalMemberCount",
                           userDao.getUserListCountByKeyword("all", null, null, "all", "all", null, null));
        model.addAttribute("totalSellerCount",
                           sellerDao.getSellerListCountByKeyword("all", null, null, null, null, null));
        model.addAttribute("approvedProductCount",
                           productDao.getProductListCountByKeyword("approved", null, null, null, null,
                                                                   null, null, null, null));
        model.addAttribute("recentActionLogList", adminActionLogDao.getRecentAdminActionLogList(5));

        return "/admin/admin_dashboard";
    }

    @GetMapping("/admin/sellers")
    public String sellers(Model model, String status, String keyword,
                          Integer user_id, Integer seller_id,
                          String startDate, String endDate,
                          String sort, Integer size, Integer page) {
        if (!"pending".equals(status) && !"approved".equals(status) && !"rejected".equals(status)) {
            status = "all";
        }

        if (!"oldest".equals(sort) && !"name".equals(sort) &&
            !"products".equals(sort) && !"orders".equals(sort) && !"sales".equals(sort)) {
            sort = "latest";
        }

        UserVO filterUser = user_id == null ? null : userDao.selectUser(user_id);
        SellerVO filterSeller = seller_id == null ? null : sellerDao.getSellerById(seller_id);
        int totalCount = sellerDao.getSellerListCountByKeyword(status, keyword, user_id, seller_id, startDate, endDate);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);
        List<SellerVO> sellerList = sellerDao.getSellerListByKeyword(status, keyword,
                                                                     user_id,
                                                                     seller_id,
                                                                     pagination.getSize(),
                                                                     pagination.getOffset(),
                                                                     startDate, endDate,
                                                                     sort);

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("user_id", user_id);
        model.addAttribute("seller_id", seller_id);
        model.addAttribute("filterUser", filterUser);
        model.addAttribute("filterSeller", filterSeller);
        model.addAttribute("sort", sort);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("sellerList", sellerList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

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

    @PostMapping("/admin/sellers/status")
    @ResponseBody
    public Map<String, Object> updateSellerStatus(int seller_id, String status, String memo) {

        Map<String, Object> map = new HashMap<>();

        if (!"PENDING".equals(status) && !"APPROVED".equals(status) && !"REJECTED".equals(status)) {
            map.put("success", false);
            map.put("message", "잘못된 상태입니다.");
            return map;
        }

        SellerVO seller = sellerDao.getSellerById(seller_id);
        String beforeStatus = seller == null ? null : seller.getStatus();

        sellerDao.updateAdminSellerStatus(seller_id, status);
        addActionLog("SELLER", seller_id, "STATUS_CHANGE", beforeStatus, status, cleanMemo(memo, "판매자 상태 변경"));

        map.put("success", true);
        map.put("status", status);

        return map;
    }

    @GetMapping("/admin/products")
    public String products(Model model, String status, String keyword,
                           Integer seller_id, Integer product_id,
                           Integer category_id, Integer minPrice, Integer maxPrice,
                           String startDate, String endDate,
                           String sort, Integer size, Integer page) {
        if (!"pending".equals(status) && !"approved".equals(status) &&
            !"rejected".equals(status) && !"hidden".equals(status)) {
            status = "all";
        }

        if (!"oldest".equals(sort) && !"name".equals(sort) &&
            !"reviews".equals(sort) && !"orders".equals(sort) && !"favorites".equals(sort)) {
            sort = "latest";
        }

        SellerVO filterSeller = seller_id == null ? null : sellerDao.getSellerById(seller_id);
        ProductVO filterProduct = product_id == null ? null : productDao.product_one(product_id);
        String filterCategoryName = category_id == null ? null : categoryDao.getCategroyNameById(category_id);
        List<CategoryVO> categoryList = categoryDao.small_category_all_list();

        int totalCount = productDao.getProductListCountByKeyword(status, keyword, seller_id, product_id,
                                                                 category_id, minPrice, maxPrice,
                                                                 startDate, endDate);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);
        List<ProductVO> productList = productDao.getProductListByKeyword(status, keyword,
                                                                         seller_id,
                                                                         product_id,
                                                                         category_id,
                                                                         minPrice,
                                                                         maxPrice,
                                                                         pagination.getSize(),
                                                                         pagination.getOffset(),
                                                                         startDate, endDate,
                                                                         sort);

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("seller_id", seller_id);
        model.addAttribute("product_id", product_id);
        model.addAttribute("category_id", category_id);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("filterSeller", filterSeller);
        model.addAttribute("filterProduct", filterProduct);
        model.addAttribute("filterCategoryName", filterCategoryName);
        model.addAttribute("categoryList", categoryList);
        model.addAttribute("sort", sort);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("productList", productList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

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
        map.put("optionList", optionDao.getOptionListByProductId(product_id));
        return map;
    }

    @PostMapping("/admin/products/status")
    @ResponseBody
    public Map<String, Object> updateProductStatus(int product_id, String status, String memo) {

        Map<String, Object> map = new HashMap<>();

        if (!"PENDING".equals(status) && !"APPROVED".equals(status) &&
            !"REJECTED".equals(status) && !"HIDDEN".equals(status)) {
            map.put("success", false);
            map.put("message", "잘못된 상태입니다.");
            return map;
        }

        ProductVO product = productDao.product_one(product_id);
        String beforeStatus = product == null ? null : product.getStatus();

        productDao.updateAdminProductStatus(product_id, status);
        addActionLog("PRODUCT", product_id, "STATUS_CHANGE", beforeStatus, status, cleanMemo(memo, "상품 상태 변경"));

        map.put("success", true);
        map.put("status", status);

        return map;
    }

    @GetMapping("/admin/reports")
    public String reports(Model model, String status, String keyword,
                          Integer user_id,
                          String targetType, Integer target_id,
                          String startDate, String endDate,
                          String sort, Integer size, Integer page) {
        if (!"pending".equals(status) && !"processed".equals(status) &&
            !"rejected".equals(status)) {
            status = "all";
        }

        if (!"oldest".equals(sort) && !"target".equals(sort)) {
            sort = "latest";
        }

        if (!"PRODUCT".equals(targetType) && !"REVIEW".equals(targetType) && !"QNA".equals(targetType)) {
            targetType = "all";
        }

        UserVO filterUser = user_id == null ? null : userDao.selectUser(user_id);
        int totalCount = reportDao.getReportListCountByKeyword(status, keyword, user_id, targetType, target_id, startDate, endDate);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);
        List<ReportVO> reportList = reportDao.getReportListByKeyword(status, keyword,
                                                                     user_id,
                                                                     targetType,
                                                                     target_id,
                                                                     pagination.getSize(),
                                                                     pagination.getOffset(),
                                                                     startDate, endDate,
                                                                     sort);

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("user_id", user_id);
        model.addAttribute("targetType", targetType);
        model.addAttribute("target_id", target_id);
        model.addAttribute("filterUser", filterUser);
        model.addAttribute("sort", sort);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("reportList", reportList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

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

    @PostMapping("/admin/reports/status")
    @ResponseBody
    public Map<String, Object> updateReportStatus(int report_id, String status, String memo) {

        Map<String, Object> map = new HashMap<>();

        if (!"PENDING".equals(status) && !"PROCESSED".equals(status) && !"REJECTED".equals(status)) {
            map.put("success", false);
            map.put("message", "잘못된 상태입니다.");
            return map;
        }

        ReportVO report = reportDao.getReportById(report_id);
        String beforeStatus = report == null ? null : report.getStatus();

        reportDao.updateReportStatus(report_id, status);
        addActionLog("REPORT", report_id, "STATUS_CHANGE", beforeStatus, status, cleanMemo(memo, "신고 상태 변경"));

        map.put("success", true);
        map.put("status", status);

        return map;
    }

    @GetMapping("/admin/inquiries")
    public String inquiries(Model model, String status, String keyword,
                            Integer user_id,
                            String inquiryType,
                            String startDate, String endDate,
                            String sort, Integer size, Integer page) {
        if (!"waiting".equals(status) && !"answered".equals(status)) {
            status = "all";
        }

        if (!"oldest".equals(sort) && !"title".equals(sort)) {
            sort = "latest";
        }

        if (!"SERVICE".equals(inquiryType) && !"ACCOUNT".equals(inquiryType) &&
            !"PAYMENT".equals(inquiryType) && !"SELLER".equals(inquiryType) &&
            !"POLICY".equals(inquiryType) && !"ETC".equals(inquiryType)) {
            inquiryType = "all";
        }

        UserVO filterUser = user_id == null ? null : userDao.selectUser(user_id);
        int totalCount = inquiryDao.getInquryListCountByKeyword(status, keyword, user_id, inquiryType, startDate, endDate);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);
        List<InquiryVO> inquiryList = inquiryDao.getInquryListByKeyword(status, keyword,
                                                                       user_id,
                                                                       inquiryType,
                                                                       pagination.getSize(),
                                                                       pagination.getOffset(),
                                                                       startDate, endDate,
                                                                       sort);

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("user_id", user_id);
        model.addAttribute("inquiryType", inquiryType);
        model.addAttribute("filterUser", filterUser);
        model.addAttribute("sort", sort);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("inquiryList", inquiryList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

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

    @PostMapping("/admin/inquiries/status")
    @ResponseBody
    public Map<String, Object> updateInquiryStatus(int inquiry_id, String status, String memo) {

        Map<String, Object> map = new HashMap<>();

        if (!"WAITING".equals(status) && !"ANSWERED".equals(status)) {
            map.put("success", false);
            map.put("message", "잘못된 상태입니다.");
            return map;
        }

        InquiryVO inquiry = inquiryDao.getInquiryById(inquiry_id);
        String beforeStatus = inquiry == null ? null : inquiry.getStatus();

        inquiryDao.updateInquiryStatus(inquiry_id, status);
        addActionLog("INQUIRY", inquiry_id, "STATUS_CHANGE", beforeStatus, status, cleanMemo(memo, "문의 상태 변경"));

        map.put("success", true);
        map.put("status", status);

        return map;
    }

    @PostMapping("/admin/inquiries/answer")
    @ResponseBody
    public Map<String, Object> updateInquiryAnswer(int inquiry_id, String answer) {

        Map<String, Object> map = new HashMap<>();

        if (answer == null || answer.trim().isEmpty()) {
            map.put("success", false);
            map.put("message", "답변 내용을 입력하세요.");
            return map;
        }

        InquiryVO beforeInquiry = inquiryDao.getInquiryById(inquiry_id);
        String beforeStatus = beforeInquiry == null ? null : beforeInquiry.getStatus();

        inquiryDao.updateInquiryAnswer(inquiry_id, answer.trim());
        InquiryVO inquiry = inquiryDao.getInquiryById(inquiry_id);
        addActionLog("INQUIRY", inquiry_id, "ANSWER", beforeStatus, inquiry.getStatus(), "문의 답변 저장");

        map.put("success", true);
        map.put("inquiry", inquiry);

        return map;
    }

    @GetMapping("/admin/action-logs")
    public String actionLogs(Model model, Integer size, Integer page,
                             String targetType, String actionType, String status,
                             Integer targetId, String keyword,
                             String startDate, String endDate, String sort) {

        targetType = cleanFilter(targetType, "all");
        actionType = cleanFilter(actionType, "all");
        status = cleanFilter(status, "all");
        sort = cleanFilter(sort, "latest");
        keyword = cleanFilter(keyword, "");
        startDate = cleanFilter(startDate, "");
        endDate = cleanFilter(endDate, "");

        String queryTargetType = "all".equals(targetType) ? "all" : targetType.toUpperCase();
        String queryActionType = "all".equals(actionType) ? "all" : actionType.toUpperCase();
        String queryStatus = "all".equals(status) ? "all" : status.toUpperCase();

        int totalCount = adminActionLogDao.getAdminActionLogCount(queryTargetType, queryActionType, queryStatus,
                                                                  targetId, keyword, startDate, endDate);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);

        model.addAttribute("actionLogList",
                           adminActionLogDao.getAdminActionLogPageList(pagination.getSize(), pagination.getOffset(),
                                                                       queryTargetType, queryActionType, queryStatus,
                                                                       targetId, keyword, startDate, endDate, sort));
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);
        model.addAttribute("targetType", queryTargetType);
        model.addAttribute("actionType", queryActionType);
        model.addAttribute("status", queryStatus);
        model.addAttribute("targetId", targetId);
        model.addAttribute("keyword", keyword);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("sort", sort);

        return "/admin/admin_action_log_list";
    }

    @GetMapping("/admin/members")
    public String members(Model model, 
                          String role, String keyword, 
                          String gender, String status,
                          Integer user_id,
                          String startDate, String endDate,
                          String sort, Integer size, Integer page) {

        if (!"user".equals(role) && !"seller".equals(role)) {
            role = "all";
        }

        if (!"male".equals(gender) && !"female".equals(gender)) {
            gender = "all";
        }

        if (!"active".equalsIgnoreCase(status) && !"suspended".equalsIgnoreCase(status)
            && !"withdrawn".equalsIgnoreCase(status)) {
            status = "all";
        }

        if (!"oldest".equals(sort)) {
            sort = "latest";
        }

        UserVO filterUser = user_id == null ? null : userDao.selectUser(user_id);

        int totalCount = userDao.getUserListCountByKeyword(role, keyword, user_id,
                                                           gender, status,
                                                           startDate, endDate);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);

        List<UserVO> userList = userDao.getUserListByKeyword(role, keyword, user_id,
                                                             pagination.getSize(), 
                                                             pagination.getOffset(),
                                                             gender, status,
                                                             startDate, endDate,
                                                             sort);

        model.addAttribute("role", role);
        model.addAttribute("keyword", keyword);
        model.addAttribute("user_id", user_id);
        model.addAttribute("filterUser", filterUser);
        model.addAttribute("gender", gender);
        model.addAttribute("status", status);
        model.addAttribute("sort", sort);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);
        model.addAttribute("userList", userList);

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

        int orderCount = orderDao.getOrderCountByUserId(user_id);
        int reviewCount = reviewDao.getReviewCountByUserId(user_id);
        int inquiryCount = inquiryDao.getInquiryCountByUserId(user_id);
        int reportCount = reportDao.getReportCountByReporterId(user_id);
        SellerVO seller = "SELLER".equals(user.getRole()) ? sellerDao.selectSellerByUserId(user_id) : null;

        map.put("success", true);
        map.put("user", user);
        map.put("seller", seller);

        map.put("orderCount", orderCount);
        map.put("reviewCount", reviewCount);
        map.put("inquiryCount", inquiryCount);
        map.put("reportCount", reportCount);
        
        return map;
    }

    @PostMapping("/admin/members/status")
    @ResponseBody
    public Map<String, Object> updateMemberStatus(int user_id, String status, String memo) {

        Map<String, Object> map = new HashMap<>();

        if (!"active".equals(status) && !"suspended".equals(status) && !"withdrawn".equals(status)) {
            map.put("success", false);
            map.put("message", "잘못된 상태입니다.");
            return map;
        }

        UserVO user = userDao.selectUser(user_id);
        String beforeStatus = user == null ? null : user.getStatus();

        userDao.updateUserStatus(user_id, status);
        addActionLog("MEMBER", user_id, "STATUS_CHANGE", beforeStatus, status, cleanMemo(memo, "회원 상태 변경"));

        map.put("success", true);
        map.put("status", status);

        return map;
    }

    @GetMapping("/admin/reviews")
    public String reviews(Model model, String keyword,
                          Integer user_id, Integer product_id, Integer review_id,
                          Integer rating,
                          String startDate, String endDate,
                          String sort, Integer size, Integer page) {
        if (rating != null && (rating < 1 || rating > 5)) {
            rating = null;
        }

        if (!"oldest".equals(sort) && !"rating".equals(sort) && !"reports".equals(sort)) {
            sort = "latest";
        }

        UserVO filterUser = user_id == null ? null : userDao.selectUser(user_id);
        ProductVO filterProduct = product_id == null ? null : productDao.product_one(product_id);
        ReviewVO filterReview = review_id == null ? null : reviewDao.getReviewById(review_id);
        int totalCount = reviewDao.getReviewListCountByKeyword(keyword, user_id, product_id, review_id, rating, startDate, endDate);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);
        List<ReviewVO> reviewList = reviewDao.getReviewListByKeyword(keyword,
                                                                     user_id,
                                                                     product_id,
                                                                     review_id,
                                                                     rating,
                                                                     pagination.getSize(),
                                                                     pagination.getOffset(),
                                                                     startDate, endDate,
                                                                     sort);

        model.addAttribute("keyword", keyword);
        model.addAttribute("user_id", user_id);
        model.addAttribute("product_id", product_id);
        model.addAttribute("review_id", review_id);
        model.addAttribute("rating", rating);
        model.addAttribute("filterUser", filterUser);
        model.addAttribute("filterProduct", filterProduct);
        model.addAttribute("filterReview", filterReview);
        model.addAttribute("sort", sort);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("reviewList", reviewList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

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

    @GetMapping("/admin/orders")
    public String orders(Model model, String status, String keyword,
                         Integer user_id, Integer seller_id, Integer product_id,
                         Integer minAmount, Integer maxAmount,
                         String startDate, String endDate,
                         String sort, Integer size, Integer page) {
        if (!"pending".equals(status) && !"paid".equals(status) &&
            !"preparing".equals(status) && !"shipping".equals(status) &&
            !"delivered".equals(status) && !"cancelled".equals(status)) {
            status = "all";
        }

        if (!"oldest".equals(sort) && !"amount".equals(sort)) {
            sort = "latest";
        }

        UserVO filterUser = user_id == null ? null : userDao.selectUser(user_id);
        SellerVO filterSeller = seller_id == null ? null : sellerDao.getSellerById(seller_id);
        ProductVO filterProduct = product_id == null ? null : productDao.product_one(product_id);
        int totalCount = orderDao.getAdminOrderListCountByKeyword(status, keyword, user_id, seller_id, product_id,
                                                                  minAmount, maxAmount,
                                                                  startDate, endDate);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);
        List<Map<String, Object>> orderList = orderDao.getAdminOrderListByKeyword(status, keyword,
                                                                                  user_id,
                                                                                  seller_id,
                                                                                  product_id,
                                                                                  minAmount,
                                                                                  maxAmount,
                                                                                  pagination.getSize(),
                                                                                  pagination.getOffset(),
                                                                                  startDate, endDate,
                                                                                  sort);

        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        model.addAttribute("user_id", user_id);
        model.addAttribute("seller_id", seller_id);
        model.addAttribute("product_id", product_id);
        model.addAttribute("minAmount", minAmount);
        model.addAttribute("maxAmount", maxAmount);
        model.addAttribute("filterUser", filterUser);
        model.addAttribute("filterSeller", filterSeller);
        model.addAttribute("filterProduct", filterProduct);
        model.addAttribute("sort", sort);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("orderList", orderList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

        return "/admin/admin_order_manage";
    }

    @GetMapping("/admin/orders/detail")
    @ResponseBody
    public Map<String, Object> orderDetail(int order_id) {

        Map<String, Object> map = new HashMap<>();
        Map<String, Object> order = orderDao.getAdminOrderById(order_id);

        if (order == null) {
            map.put("success", false);
            map.put("message", "주문 정보를 찾을 수 없습니다.");
            return map;
        }

        map.put("success", true);
        map.put("order", order);
        map.put("orderItemList", orderDao.getAdminOrderItemList(order_id));
        return map;
    }

    @PostMapping("/admin/orders/status")
    @ResponseBody
    public Map<String, Object> updateOrderStatus(int order_id, String status, String memo) {

        Map<String, Object> map = new HashMap<>();

        if (!"PENDING".equals(status) && !"PAID".equals(status) &&
            !"PREPARING".equals(status) && !"SHIPPING".equals(status) &&
            !"DELIVERED".equals(status) && !"CANCELLED".equals(status)) {
            map.put("success", false);
            map.put("message", "잘못된 상태입니다.");
            return map;
        }

        Map<String, Object> beforeOrder = orderDao.getAdminOrderById(order_id);
        String beforeStatus = getStringValue(beforeOrder, "status");

        OrderVO order = new OrderVO();
        order.setOrder_id(order_id);
        order.setStatus(status);
        orderDao.updateOrderStatus(order);

        Map<String, Object> itemStatusMap = new HashMap<>();
        itemStatusMap.put("order_id", order_id);
        itemStatusMap.put("status", status);
        orderDao.updateOrderItemsStatusByOrderId(itemStatusMap);
        addActionLog("ORDER", order_id, "STATUS_CHANGE", beforeStatus, status, cleanMemo(memo, "주문 상태 변경"));

        map.put("success", true);
        map.put("status", status);

        return map;
    }

    @GetMapping("/admin/categories")
    public String categories(Model model, Integer size, Integer page) {

        int totalCount = categoryDao.countParentCategories();
        PaginationVO pagination = new PaginationVO(page, size, totalCount);
        List<CategoryVO> parentCategoryList = categoryDao.getParentCategoryPageList(pagination.getSize(),
                                                                                   pagination.getOffset());
        List<CategoryVO> allParentCategoryList = categoryDao.big_category_list();
        List<CategoryVO> childCategoryList = categoryDao.small_category_all_list();

        model.addAttribute("parentCategoryList", parentCategoryList);
        model.addAttribute("allParentCategoryList", allParentCategoryList);
        model.addAttribute("childCategoryList", childCategoryList);
        model.addAttribute("pagination", pagination);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("childTotalCount", childCategoryList.size());

        return "/admin/admin_category_manage";
    }

    @PostMapping("/admin/categories/create")
    @ResponseBody
    public Map<String, Object> createCategory(CategoryVO category) {

        Map<String, Object> map = new HashMap<>();
        String name = category.getName() == null ? null : category.getName().trim();

        if (name == null || name.isEmpty()) {
            map.put("success", false);
            map.put("message", "카테고리명을 입력해주세요.");
            return map;
        }

        if (category.getParent_id() != null) {
            CategoryVO parentCategory = categoryDao.getCategoryById(category.getParent_id());

            if (parentCategory == null || parentCategory.getParent_id() != null) {
                map.put("success", false);
                map.put("message", "상위 카테고리는 대분류만 선택할 수 있습니다.");
                return map;
            }
        }

        category.setName(name);
        categoryDao.addCategory(category);

        map.put("success", true);
        return map;
    }

    @PostMapping("/admin/categories/update")
    @ResponseBody
    public Map<String, Object> updateCategory(CategoryVO category) {

        Map<String, Object> map = new HashMap<>();
        CategoryVO beforeCategory = categoryDao.getCategoryById(category.getCategory_id());
        String name = category.getName() == null ? null : category.getName().trim();

        if (beforeCategory == null) {
            map.put("success", false);
            map.put("message", "카테고리를 찾을 수 없습니다.");
            return map;
        }

        if (name == null || name.isEmpty()) {
            map.put("success", false);
            map.put("message", "카테고리명을 입력해주세요.");
            return map;
        }

        if (category.getParent_id() != null) {
            if (beforeCategory.getParent_id() == null && categoryDao.countChildCategories(category.getCategory_id()) > 0) {
                map.put("success", false);
                map.put("message", "하위 카테고리가 있는 대분류는 하위로 이동할 수 없습니다.");
                return map;
            }

            if (category.getParent_id() == category.getCategory_id()) {
                map.put("success", false);
                map.put("message", "자기 자신을 상위 카테고리로 선택할 수 없습니다.");
                return map;
            }

            CategoryVO parentCategory = categoryDao.getCategoryById(category.getParent_id());

            if (parentCategory == null || parentCategory.getParent_id() != null) {
                map.put("success", false);
                map.put("message", "상위 카테고리는 대분류만 선택할 수 있습니다.");
                return map;
            }
        }

        category.setName(name);
        categoryDao.updateCategory(category);

        map.put("success", true);
        return map;
    }

    @PostMapping("/admin/categories/delete")
    @ResponseBody
    public Map<String, Object> deleteCategory(int category_id) {

        Map<String, Object> map = new HashMap<>();
        CategoryVO beforeCategory = categoryDao.getCategoryById(category_id);

        if (beforeCategory == null) {
            map.put("success", false);
            map.put("message", "카테고리를 찾을 수 없습니다.");
            return map;
        }

        if (categoryDao.countChildCategories(category_id) > 0) {
            map.put("success", false);
            map.put("message", "하위 카테고리가 있는 대분류는 삭제할 수 없습니다.");
            return map;
        }

        if (categoryDao.countProductsByCategory(category_id) > 0) {
            map.put("success", false);
            map.put("message", "상품에 사용 중인 카테고리는 삭제할 수 없습니다.");
            return map;
        }

        categoryDao.deleteCategory(category_id);

        map.put("success", true);
        return map;
    }

    @GetMapping("/admin/notices")
    public String notices(Model model, String keyword,
                          String startDate, String endDate,
                          String sort, Integer size, Integer page) {

        if (!"oldest".equals(sort) && !"title".equals(sort)) {
            sort = "latest";
        }

        int totalCount = noticeDao.getNoticeListCountByKeyword(keyword, startDate, endDate);
        PaginationVO pagination = new PaginationVO(page, size, totalCount);
        List<NoticeVO> noticeList = noticeDao.getNoticeListByKeyword(keyword,
                                                                     pagination.getSize(),
                                                                     pagination.getOffset(),
                                                                     startDate, endDate,
                                                                     sort);

        model.addAttribute("keyword", keyword);
        model.addAttribute("sort", sort);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

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

    @GetMapping("/admin/action-logs/recent")
    @ResponseBody
    public Map<String, Object> recentActionLogs(String target_type, Integer target_id) {

        Map<String, Object> map = new HashMap<>();

        if (target_type == null || target_type.trim().isEmpty() || target_id == null) {
            map.put("success", false);
            map.put("message", "관리 내역 조회 대상이 올바르지 않습니다.");
            return map;
        }

        List<AdminActionLogVO> actionLogList = adminActionLogDao.getAdminActionLogList(target_type, target_id);

        map.put("success", true);
        map.put("actionLogList", actionLogList.size() > 5 ? actionLogList.subList(0, 5) : actionLogList);

        return map;
    }

    @GetMapping("/admin/memos")
    @ResponseBody
    public Map<String, Object> getAdminMemoList(String target_type, int target_id) {

        Map<String, Object> map = new HashMap<>();

        List<AdminMemoVO> memoList = adminMemoDao.getAdminMemoList(target_type, target_id);

        map.put("success", true);
        map.put("memoList", memoList);

        return map;
    }

    @PostMapping("/admin/memos")
    @ResponseBody
    public Map<String, Object> addAdminMemo(AdminMemoVO memo) {

        Map<String, Object> map = new HashMap<>();

        if (memo.getContent() == null || memo.getContent().trim().isEmpty()) {
            map.put("success", false);
            map.put("message", "메모 내용을 입력하세요.");
            return map;
        }

        memo.setAdmin_id(getLoginAdminId());
        adminMemoDao.addAdminMemo(memo);

        map.put("success", true);

        return map;
    }

    private Integer getLoginAdminId() {
        UserVO admin = (UserVO) session.getAttribute("user");
        return admin == null ? null : admin.getUser_id();
    }

    private void addActionLog(String targetType, int targetId, String actionType,
                              String beforeStatus, String afterStatus, String memo) {
        AdminActionLogVO log = new AdminActionLogVO();
        log.setAdmin_id(getLoginAdminId());
        log.setTarget_type(targetType);
        log.setTarget_id(targetId);
        log.setAction_type(actionType);
        log.setBefore_status(beforeStatus);
        log.setAfter_status(afterStatus);
        log.setMemo(memo);

        adminActionLogDao.addAdminActionLog(log);
    }

    private String getStringValue(Map<String, Object> map, String key) {
        Object value = map == null ? null : map.get(key);
        return value == null ? null : String.valueOf(value);
    }

    private String cleanMemo(String memo, String defaultMemo) {
        if (memo == null || memo.trim().isEmpty()) {
            return defaultMemo;
        }

        return memo.trim();
    }

    private String cleanFilter(String value, String defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }

        return value.trim();
    }
}
