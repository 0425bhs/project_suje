package com.kh.suje.controller;

import java.util.ArrayList;
import java.util.stream.Collectors;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.QnaDAO;
import com.kh.suje.vo.QnaVO;
import com.kh.suje.dao.ImageDAO;
import com.kh.suje.vo.ImageVO;
import com.kh.suje.vo.PaginationVO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.vo.ReviewVO;
import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.FavoriteDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.SellerVO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SellerController {

    private final HttpSession session;

    private final ProductDAO productdao;
    private final CategoryDAO categorydao;
    private final SellerDAO sellerdao;
    private final FavoriteDAO favoritedao;
    private final ReviewDAO reviewdao;
    private final ImageDAO imagedao;
    private final QnaDAO qnadao;

    // 로그인한 회원 기준으로 seller_id 찾기
    private Integer getLoginSellerId(){

        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null){
            return null;
        }

        SellerVO seller = sellerdao.selectSeller(user.getUser_id());

        if (seller == null){
            return null;
        }

        return seller.getSeller_id();
    }

    @GetMapping("/seller_dashboard.do")
    public String sellerDashboard(Model model){
        
        Integer seller_id=getLoginSellerId();

        if(seller_id==null){
            return "redirect:/login.do";
        }

        Map<String, Object> orderStatusCounts = sellerdao.getOrderStatusCounts(seller_id);
        Map<String, Object> productStatusCounts = sellerdao.getProductStatusCounts(seller_id);
        Map<String, Object> salesSummary = sellerdao.getSellerSalesSummary(seller_id);
        List<Map<String, Object>> dailySalesList = sellerdao.getSellerDailySales(seller_id);
        int unansweredQnaCount = sellerdao.getUnansweredQnaCount(seller_id);
        int newReviewCount = sellerdao.getNewReviewCount(seller_id);
        List<Map<String, Object>> noticeList = sellerdao.selectSellerNoticeList();

        if (orderStatusCounts != null){
            model.addAllAttributes(orderStatusCounts); 
        }

        if (productStatusCounts != null){
            model.addAllAttributes(productStatusCounts); 
        }

        if (salesSummary != null) {
            model.addAllAttributes(salesSummary);
        }

        model.addAttribute("unansweredQnaCount", unansweredQnaCount); 
        model.addAttribute("newReviewCount", newReviewCount);
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("dailySalesList", dailySalesList);

        return "/seller/seller_dashboard";
    }

    @GetMapping("/seller_order_list.do")
    public String seller_order_list(Model model, String status, String claimTab, Integer size, Integer page){

        Integer seller_id = getLoginSellerId();

        if (seller_id == null){
            return "redirect:/login.do";
        }

        if ("RETURN_EXCHANGE".equals(status)) {
            if (claimTab == null || claimTab.trim().equals("")) {
                claimTab = "ALL";
            }
        }

        Map<String, Object> countMap = new HashMap<>();
        countMap.put("seller_id", seller_id);
        countMap.put("status", status);
        countMap.put("claimTab", claimTab);

        int totalCount = sellerdao.getSellerOrderCount(countMap);

        PaginationVO pagination = new PaginationVO(page, size, totalCount);

        Map<String, Object> map = new HashMap<>();
        map.put("seller_id", seller_id);
        map.put("status", status);
        map.put("claimTab", claimTab);
        map.put("size", pagination.getSize());
        map.put("offset", pagination.getOffset());

        List<OrderVO> orderList = sellerdao.getSellerOrderList(map);

        Map<Integer, List<OrderItemVO>> orderItemMap = new HashMap<>();

        for (OrderVO order : orderList){
            Map<String, Object> itemMap = new HashMap<>();
            itemMap.put("seller_id", seller_id);
            itemMap.put("order_id", order.getOrder_id());

            List<OrderItemVO> itemList = sellerdao.getSellerOrderItemList(itemMap);
            orderItemMap.put(order.getOrder_id(), itemList);
        }

        model.addAttribute("orderList", orderList);
        model.addAttribute("orderItemMap", orderItemMap);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("claimTab", claimTab);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

        return "/seller/seller_order_list";
    }
    
    @PostMapping("/seller_order_status_update.do")
    public String sellerOrderStatusUpdate(
            @RequestParam("order_id") int order_id,
            @RequestParam("status") String status,
            @RequestParam(value = "selectedStatus", required = false) String selectedStatus,
            @RequestParam(value = "page", required = false) Integer page) {

        Integer seller_id = getLoginSellerId();

        if (seller_id == null) {
            return "redirect:/login.do";
        }

        Map<String, Object> map = new HashMap<>();
        map.put("seller_id", seller_id);
        map.put("order_id", order_id);
        map.put("status", status);

        sellerdao.sellerOrderStatus(map);

        String url = "redirect:/seller_order_list.do";

        boolean hasParam = false;

        if (selectedStatus != null && !selectedStatus.trim().equals("")) {
            url += "?status=" + selectedStatus;
            hasParam = true;
        }

        if (page != null && page > 0) {
            url += hasParam ? "&page=" + page : "?page=" + page;
        }

        return url;
    }

    @GetMapping("/seller_review_list.do")
    public String sellerReviewList(Model model,String tab,Integer product_id,Integer size,Integer page) {

        Integer seller_id = getLoginSellerId();

        if (seller_id == null) {
            return "redirect:/login.do";
        }

        if (tab == null || tab.trim().isEmpty()) {
            tab = "all";
        }

        if (product_id != null && product_id <= 0) {
            product_id = null;
        }

        Map<String, Object> countMap = new HashMap<>();
        countMap.put("seller_id", seller_id);
        countMap.put("tab", tab);
        countMap.put("product_id", product_id);

        int totalCount = reviewdao.sellerReviewCount(countMap);

        PaginationVO pagination = new PaginationVO(page, size, totalCount);

        Map<String, Object> map = new HashMap<>();
        map.put("seller_id", seller_id);
        map.put("tab", tab);
        map.put("product_id", product_id);
        map.put("size", pagination.getSize());
        map.put("offset", pagination.getOffset());

        List<ReviewVO> reviewList = reviewdao.sellerReviewList(map);

        if (reviewList != null && !reviewList.isEmpty()) {

            List<Integer> reviewIds = reviewList.stream().map(ReviewVO::getReview_id).collect(Collectors.toList());

            List<ImageVO> imageList =imagedao.getImagesByReviewIds(reviewIds);

            if (imageList != null && !imageList.isEmpty()) {

                Map<Integer, List<ImageVO>> imageMap = imageList.stream().collect(Collectors.groupingBy(ImageVO::getTarget_id));

                for (ReviewVO review : reviewList) {
                    review.setImageList(imageMap.getOrDefault(review.getReview_id(),new ArrayList<>()));
                }
            }
        }

        List<ReviewVO> productList = reviewdao.sellerReviewProductList(seller_id);

        Map<String, Object> summaryMap = new HashMap<>();
        summaryMap.put("seller_id", seller_id);
        summaryMap.put("product_id", product_id);

        int totalReviewCount = reviewdao.sellerReviewTotalCount(summaryMap);
        int waitingReviewCount = reviewdao.sellerReviewWaitingCount(summaryMap);
        int completedReviewCount = reviewdao.sellerReviewCompletedCount(summaryMap);
        int photoReviewCount = reviewdao.sellerReviewPhotoCount(summaryMap);

        model.addAttribute("reviewList", reviewList);
        model.addAttribute("productList", productList);

        model.addAttribute("selectedTab", tab);
        model.addAttribute("selectedProductId", product_id);

        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pagination", pagination);

        model.addAttribute("totalReviewCount", totalReviewCount);
        model.addAttribute("waitingReviewCount", waitingReviewCount);
        model.addAttribute("completedReviewCount", completedReviewCount);
        model.addAttribute("photoReviewCount", photoReviewCount);

        return "/seller/seller_review_list";
    }

    @GetMapping("/seller_qna_list.do")
    public String sellerQnaList(Model model){

        Integer seller_id = getLoginSellerId();

        if (seller_id == null){
            return "redirect:/login.do";
        }

        List<QnaVO> qnaList = qnadao.sellerQnaList(seller_id);
        List<QnaVO> productList = qnadao.sellerQnaProductList(seller_id);

        model.addAttribute("qnaList", qnaList);
        model.addAttribute("productList", productList);

        return "/seller/seller_qna_list";
    }

    // 구매자용 판매자샵
    @GetMapping("/seller_shop_homepage.do")
    public String sellerShopHomepage(Model model, Integer seller_id, String sort){

        if (seller_id == null){
            return "redirect:/product/main.do";
        }

        if (sort == null || sort.equals("")){
            sort = "rank";
        }

        boolean favorite = false;
        UserVO user = (UserVO) session.getAttribute("user");

        if (user != null){
            int user_id = user.getUser_id();

            Map<String, Integer> map = new HashMap<>();
            map.put("user_id", user_id);
            map.put("seller_id", seller_id);

            int check = favoritedao.checkFavoriteSeller(map);
            favorite = check >= 1;
        }

        Map<String, Object> seller = sellerdao.sellerShopInfo(seller_id);

        Map<String, Object> listMap = new HashMap<>();
        listMap.put("seller_id", seller_id);
        listMap.put("sort", sort);

        List<ProductVO> list = productdao.sellerHomepageProductList(listMap);
        int favoriteCount = favoritedao.SellerFavoriteCount(seller_id);
        
        Number productFavoriteCount = 0;

        if (seller != null && seller.get("product_favorite_count") != null){
            productFavoriteCount = (Number) seller.get("product_favorite_count");
        }

        model.addAttribute("seller", seller);
        model.addAttribute("favoriteCount", favoriteCount);
        model.addAttribute("sellerFavoriteCountText", compactCount(favoriteCount));
        model.addAttribute("productFavoriteCountText", compactCount(productFavoriteCount));

        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        model.addAttribute("favorite", favorite);
        model.addAttribute("seller_id", seller_id);
        model.addAttribute("sort", sort);
        model.addAttribute("list", list);

        return "/seller/seller_shop_homepage";
    }

    private String compactCount(Number number){

        if (number == null){
            return "0";
        }

        long count = number.longValue();

        if (count < 1000){
            return String.valueOf(count);
        }

        if (count < 10000){
            double value = Math.ceil(count / 100.0) / 10.0;
            return String.format("%.1f천", value);
        }

        double value = Math.ceil(count / 1000.0) / 10.0;
        return String.format("%.1f만", value);
    }

    @GetMapping("/seller_statistics.do")
    public String seller_statistics(Model model){

        Integer seller_id = getLoginSellerId();

        if (seller_id == null) {
            return "redirect:/login.do";
        }

        Map<String, Object> salesSummary = sellerdao.getSellerSalesSummary(seller_id);

        List<Map<String, Object>> dailySalesList =
                sellerdao.getSellerDailySales(seller_id);

        List<Map<String, Object>> productSalesTopList =
                sellerdao.getSellerProductSalesTop(seller_id);

        List<Map<String, Object>> categorySalesList =
                sellerdao.getSellerCategorySales(seller_id);

        if (salesSummary != null) {
            model.addAllAttributes(salesSummary);
        }

        model.addAttribute("dailySalesList", dailySalesList);
        model.addAttribute("productSalesTopList", productSalesTopList);
        model.addAttribute("categorySalesList", categorySalesList);

        return "/seller/seller_statistics";
    }

    @PostMapping("/seller_review_reply.do")
    @ResponseBody
    public Map<String, Object> sellerReviewReply(
            @RequestParam("review_id") int review_id,
            @RequestParam("reply_content") String reply_content){

        Map<String, Object> result = new HashMap<>();

        Integer seller_id = getLoginSellerId();

        if (seller_id == null){
            result.put("result", "login");
            return result;
        }

        if (reply_content == null || reply_content.trim().equals("")){
            result.put("result", "empty");
            return result;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("seller_id", seller_id);
        map.put("review_id", review_id);
        map.put("reply_content", reply_content.trim());

        int updateCount = reviewdao.sellerReviewReply(map);

        if (updateCount > 0){
            result.put("result", "success");
        } else {
            result.put("result", "fail");
        }

        return result;
    }

    @PostMapping("/seller_qna_answer.do")
    @ResponseBody
    public Map<String, Object> sellerQnaAnswer(
            @RequestParam("qna_id") int qna_id,
            @RequestParam("answer") String answer){

        Map<String, Object> result = new HashMap<>();

        Integer seller_id = getLoginSellerId();

        if (seller_id == null){
            result.put("result", "login");
            return result;
        }

        if (answer == null || answer.trim().equals("")){
            result.put("result", "empty");
            return result;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("seller_id", seller_id);
        map.put("qna_id", qna_id);
        map.put("answer", answer.trim());

        int updateCount = qnadao.sellerQnaAnswer(map);

        if (updateCount > 0){
            result.put("result", "success");
        } else {
            result.put("result", "fail");
        }

        return result;
    }

    @PostMapping("/seller_direct_claim_done.do")
    public String sellerDirectClaimDone(
            @RequestParam("order_item_id") int order_item_id,
            @RequestParam("status") String status,
            @RequestParam("reason") String reason,
            @RequestParam(value = "detail_reason", required = false) String detail_reason,
            @RequestParam(value = "seller_answer", required = false) String seller_answer,
            @RequestParam(value = "selectedStatus", required = false) String selectedStatus) {

        Integer seller_id = getLoginSellerId();
        if (seller_id == null) {
            return "redirect:/login.do";
        }
        if (sellerdao.ownsOrderItem(seller_id, order_item_id) == 0) {
            return "redirect:/seller_order_list.do";
        }

        sellerdao.insertSellerDirectClaimDone(
                order_item_id,
                status,
                reason,
                detail_reason,
                seller_answer
        );

        if (selectedStatus != null && !selectedStatus.isBlank()) {
            return "redirect:/seller_order_list.do?status=" + selectedStatus;
        }

        return "redirect:/seller_order_list.do";
    }

    @PostMapping("/seller_buyer_claim_done.do")
    public String sellerBuyerClaimDone(
            @RequestParam("claim_id") int claim_id,
            @RequestParam("status") String status,
            @RequestParam("seller_answer") String seller_answer,
            @RequestParam(value = "claimTab", required = false) String claimTab) {

        Integer seller_id = getLoginSellerId();

        if (seller_id == null) {
            return "redirect:/login.do";
        }

        if (sellerdao.ownsClaim(seller_id, claim_id) == 0) {
            return "redirect:/seller_order_list.do?status=RETURN_EXCHANGE";
        }

        if (!"RETURN_DONE".equals(status)
                && !"EXCHANGE_DONE".equals(status)
                && !"RETURN_REJECTED".equals(status)
                && !"EXCHANGE_REJECTED".equals(status)) {
            return "redirect:/seller_order_list.do?status=RETURN_EXCHANGE";
        }

        sellerdao.updateBuyerRequestClaimDone(
                claim_id,
                status,
                seller_answer
        );

        if (claimTab == null || claimTab.isBlank()) {
            claimTab = "ALL";
        }

        return "redirect:/seller_order_list.do?status=RETURN_EXCHANGE&claimTab=" + claimTab;
    }

}
