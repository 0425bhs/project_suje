package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.suje.dao.CartDAO;
import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.PaymentDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;
import com.kh.suje.vo.payment.PaymentVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class OrderController {

    private final OrderDAO orderDAO;
    private final PaymentDAO paymentDAO;
    private final ProductDAO productDAO;
    private final CartDAO cartdao;

    // 로그인 회원 정보 가져오기
    private UserVO getLoginUser(HttpSession session) {
        return (UserVO) session.getAttribute("user");
    }

    // 로그인 회원 user_id 가져오기
    private int getLoginUserId(HttpSession session) {
        UserVO user = getLoginUser(session);

        if (user == null) {
            return 0;
        }

        return user.getUser_id();
    }

    //현재 날짜 기준으로 실제 적용할 상품 가격 구하기
    private int getActiveProductPrice(ProductVO product){

        int price = product.getPrice();
        int salePrice = product.getSale_price();

        //할인가가 없거나 원가보다 크거나 같으먄 원가 사용
        if(salePrice <=0 || salePrice >= price){
            return price;
        }

        String saleStartAt = product.getSale_start_at();
        String saleEndAt = product.getSale_end_at();

        boolean emtyStart = saleStartAt == null || saleStartAt.trim().isEmpty();
        boolean emtyEnd = saleEndAt == null || saleEndAt.trim().isEmpty();

        //할인 시작일, 종료일 둘 다 없으면 상시 할인
        if(emtyStart && emtyEnd){
            return salePrice;
        }

        //할인 시작일, 종료일 둘 다 있으면 기간 할인
        if(!emtyStart && !emtyEnd){
            try{
                LocalDate today = LocalDate.now();

                LocalDate startDate = LocalDate.parse(saleStartAt.substring(0, 10));
                LocalDate endDate = LocalDate.parse(saleEndAt.substring(0, 10));

                if (!today.isBefore(startDate) && !today.isAfter(endDate)) {
                    return salePrice;
                }

            } catch (Exception e) {
                return price;
            }
        }

        // 기간 할인인데 기간이 아니거나 날짜가 이상하면 원가 사용
        return price;
    }

    // 선택한 쿠폰 할인금액 조회
    private int getCouponPrice(int user_id, int user_coupon_id) {

        int couponPrice = 0;

        if (user_coupon_id <= 0) {
            return couponPrice;
        }

        List<Map<String, Object>> couponList = orderDAO.selectAvailableCouponList(user_id);

        for (Map<String, Object> coupon : couponList) {
            int dbUserCouponId = ((Number) coupon.get("user_coupon_id")).intValue();

            if (dbUserCouponId == user_coupon_id) {
                couponPrice = ((Number) coupon.get("discount_amount")).intValue();
                break;
            }
        }

        return couponPrice;
    }

    // 포인트/쿠폰 사용으로 결제금액이 0원인 경우 Toss 결제 없이 바로 결제완료 처리
    private String completeZeroPaymentOrder(int order_id) {

        PaymentVO successPaymentVO = new PaymentVO();
        successPaymentVO.setOrder_id(order_id);
        successPaymentVO.setTransaction_id("POINT_PAYMENT");

        paymentDAO.updatePaymentSuccess(successPaymentVO);

        OrderVO paidOrderVO = new OrderVO();
        paidOrderVO.setOrder_id(order_id);
        paidOrderVO.setStatus("PAID");

        orderDAO.updateOrderStatus(paidOrderVO);

        Map<String, Object> itemStatusMap = new HashMap<>();
        itemStatusMap.put("order_id", order_id);
        itemStatusMap.put("status", "PAID");

        orderDAO.updateOrderItemsStatusByOrderId(itemStatusMap);

        return "redirect:/order/complete?order_id=" + order_id;
    }

    // 내 주문 내역
    // 주소: /myshop/orders
    @GetMapping("/myshop/orders")
    public String myOrderList(
            @RequestParam(value = "status", required = false) String status,
            Model model,
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        int user_id = getLoginUserId(session);

        Map<String, Object> statusCounts = orderDAO.selectOrderStatusCounts(user_id);
        
        List<OrderVO> orderList;

        if (status == null || status.trim().isEmpty()) {
            orderList = orderDAO.selectOrderListByUserId(user_id);
        } else {
            orderList = orderDAO.selectOrderListByUserIdAndStatus(user_id, status);
        }

        Map<Integer, List<OrderItemVO>> orderItemMap = new HashMap<>();

        for (OrderVO order : orderList) {
            List<OrderItemVO> itemList = orderDAO.selectOrderItemList(order.getOrder_id());

            orderItemMap.put(order.getOrder_id(), itemList);
        }
        
        model.addAttribute("loginUser", loginUser);
        model.addAllAttributes(statusCounts);
        model.addAttribute("orderList", orderList);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("orderItemMap", orderItemMap);

        model.addAttribute("activeMenu", "order");
        model.addAttribute("contentPage", "/myshop/order_list");

        return "myshop/myshop_main";
    }

    // 주문서 작성 화면
    // 주소: /order/form
    @GetMapping("/order/form")
    public String orderForm(
            @RequestParam("product_id") int product_id,
            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
            Model model,
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        ProductVO product = productDAO.product_one(product_id);

        if (product == null) {
            return "redirect:/product/list.do";
        }

        int price = getActiveProductPrice(product);

        int originTotal = product.getPrice() * quantity;
        int item_amount = price * quantity;
        int discountTotal = originTotal - item_amount;

        int delivery_fee = product.getDelivery_fee();

        if (product.getFree_shipping() > 0 && item_amount >= product.getFree_shipping()) {
            delivery_fee = 0;
        }

        Map<String, Object> item = new HashMap<>();
        item.put("product_id", product.getProduct_id());
        item.put("name", product.getName());
        item.put("image_l", product.getImage_l());
        item.put("price", product.getPrice());
        item.put("sale_price", product.getSale_price());
        item.put("item_price", price);
        item.put("quantity", quantity);
        item.put("origin_total", originTotal);
        item.put("item_total", item_amount);
        item.put("discount_total", discountTotal);
        item.put("delivery_fee", delivery_fee);
        item.put("cart_id", 0);

        List<Map<String, Object>> orderItemList = new java.util.ArrayList<>();
        orderItemList.add(item);

        model.addAttribute("loginUser", loginUser);

        List<Map<String, Object>> couponList = orderDAO.selectAvailableCouponList(loginUser.getUser_id());

        int couponPrice = 0;

        int total_amount = item_amount + delivery_fee - couponPrice;

        int pointBalance = orderDAO.getUserPoint(loginUser.getUser_id());
        model.addAttribute("pointBalance", pointBalance);

        model.addAttribute("orderItemList", orderItemList);
        model.addAttribute("totalOriginPrice", originTotal);
        model.addAttribute("totalDiscountPrice", discountTotal);
        model.addAttribute("totalItemPrice", item_amount);
        model.addAttribute("totalDeliveryFee", delivery_fee);
        model.addAttribute("paymentPrice", total_amount);
        model.addAttribute("couponPrice", couponPrice);
        model.addAttribute("couponList", couponList);

        return "order/order_form";
    }

    // 주문 생성 처리
    // 주문서 작성 → 결제 대기로 이동
    @PostMapping("/order/create")
    @Transactional
    public String createOrder(
            @RequestParam(value = "product_id", required = false) Integer product_id,
            @RequestParam(value = "quantity", required = false, defaultValue = "1") Integer quantity,
            @RequestParam(value = "cart_id", required = false) int[] cart_id,
            @RequestParam(value = "user_coupon_id", required = false, defaultValue = "0") int user_coupon_id,
            @RequestParam(value = "use_point", required = false, defaultValue = "0") int use_point,
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        int user_id = getLoginUserId(session);

        int address_id = 1;

        int couponPrice = getCouponPrice(user_id, user_coupon_id);

        int pointBalance = orderDAO.getUserPoint(user_id);

        if (use_point < 0) {
            use_point = 0;
        }

        if (use_point > pointBalance) {
            use_point = pointBalance;
        }

        if (cart_id != null && cart_id.length > 0) {

            Map<String, Object> map = new HashMap<>();
            map.put("user_id", user_id);
            map.put("cart_id", cart_id);

            List<Map<String, Object>> orderCartList = cartdao.cartOrderList(map);

            if (orderCartList == null || orderCartList.isEmpty()) {
                return "redirect:/cart_list.do";
            }

            int totalItemPrice = 0;

            Map<Integer, Integer> sellerMaxDeliveryMap = new HashMap<>();
            Map<Integer, Boolean> sellerFreeDeliveryMap = new HashMap<>();

            for (Map<String, Object> item : orderCartList) {

                int seller_id = ((Number) item.get("seller_id")).intValue();

                int item_total = ((Number) item.get("item_total")).intValue();
                int delivery_fee = ((Number) item.get("delivery_fee")).intValue();
                int free_shipping = ((Number) item.get("free_shipping")).intValue();

                totalItemPrice += item_total;

                boolean isFreeDelivery = false;

                if (delivery_fee == 0) {
                    isFreeDelivery = true;
                }

                if (free_shipping > 0 && item_total >= free_shipping) {
                    isFreeDelivery = true;
                }

                if (isFreeDelivery) {
                    sellerFreeDeliveryMap.put(seller_id, true);
                }

                int currentMaxDeliveryFee = sellerMaxDeliveryMap.getOrDefault(seller_id, 0);

                if (delivery_fee > currentMaxDeliveryFee) {
                    sellerMaxDeliveryMap.put(seller_id, delivery_fee);
                }
            }

            int totalDeliveryFee = 0;

            for (Integer seller_id : sellerMaxDeliveryMap.keySet()) {

                boolean sellerFreeDelivery = sellerFreeDeliveryMap.getOrDefault(seller_id, false);

                if (!sellerFreeDelivery) {
                    totalDeliveryFee += sellerMaxDeliveryMap.get(seller_id);
                }
            }

            int maxUsePoint = totalItemPrice + totalDeliveryFee - couponPrice;

            if (maxUsePoint < 0) {
                maxUsePoint = 0;
            }

            if (use_point > maxUsePoint) {
                use_point = maxUsePoint;
            }

            int total_amount = totalItemPrice + totalDeliveryFee - couponPrice - use_point;

            if (total_amount < 0) {
                total_amount = 0;
            }

            OrderVO orderVO = new OrderVO();
            orderVO.setUser_id(user_id);
            orderVO.setTotal_amount(total_amount);
            orderVO.setUsed_point(use_point);
            orderVO.setAddress_id(address_id);
            orderVO.setStatus("PENDING");

            orderDAO.insertOrder(orderVO);

            for (Map<String, Object> item : orderCartList) {

                int itemProductId = ((Number) item.get("product_id")).intValue();
                int itemPrice = ((Number) item.get("item_price")).intValue();
                int itemQuantity = ((Number) item.get("quantity")).intValue();

                OrderItemVO itemVO = new OrderItemVO();
                itemVO.setOrder_id(orderVO.getOrder_id());
                itemVO.setProduct_id(itemProductId);
                itemVO.setPrice(itemPrice);
                itemVO.setQuantity(itemQuantity);

                orderDAO.insertOrderItem(itemVO);
            }

            PaymentVO paymentVO = new PaymentVO();
            paymentVO.setOrder_id(orderVO.getOrder_id());
            paymentVO.setPayment_method("TOSS");
            paymentVO.setAmount(total_amount);
            paymentVO.setStatus("READY");
            paymentVO.setTransaction_id(null);

            paymentDAO.insertPayment(paymentVO);

            if (use_point > 0) {
                Map<String, Object> pointMap = new HashMap<>();
                pointMap.put("user_id", user_id);
                pointMap.put("point_amount", use_point);

                int pointResult = orderDAO.useUserPoint(pointMap);

                if (pointResult > 0) {
                    orderDAO.insertUsePointHistory(pointMap);
                }
            }

            if (user_coupon_id > 0 && couponPrice > 0) {
                Map<String, Object> couponMap = new HashMap<>();
                couponMap.put("user_coupon_id", user_coupon_id);
                couponMap.put("user_id", user_id);

                orderDAO.useCoupon(couponMap);
            }

            cartdao.cartDeleteSelected(map);

            if (total_amount == 0) {
                return completeZeroPaymentOrder(orderVO.getOrder_id());
            }

            return "redirect:/payment/ready?order_id=" + orderVO.getOrder_id();
        }

        if (product_id == null) {
            return "redirect:/product/list.do";
        }

        ProductVO product = productDAO.product_one(product_id);

        if (product == null) {
            return "redirect:/product/list.do";
        }

        int price = getActiveProductPrice(product);

        int item_amount = price * quantity;

        int delivery_fee = product.getDelivery_fee();

        if (product.getFree_shipping() > 0 && item_amount >= product.getFree_shipping()) {
            delivery_fee = 0;
        }

        int maxUsePoint = item_amount + delivery_fee - couponPrice;

        if (maxUsePoint < 0) {
            maxUsePoint = 0;
        }

        if (use_point > maxUsePoint) {
            use_point = maxUsePoint;
        }

        int total_amount = item_amount + delivery_fee - couponPrice - use_point;

        if (total_amount < 0) {
            total_amount = 0;
        }

        OrderVO orderVO = new OrderVO();
        orderVO.setUser_id(user_id);
        orderVO.setTotal_amount(total_amount);
        orderVO.setUsed_point(use_point);
        orderVO.setAddress_id(address_id);
        orderVO.setStatus("PENDING");

        orderDAO.insertOrder(orderVO);

        OrderItemVO itemVO = new OrderItemVO();
        itemVO.setOrder_id(orderVO.getOrder_id());
        itemVO.setProduct_id(product_id);
        itemVO.setPrice(price);
        itemVO.setQuantity(quantity);

        orderDAO.insertOrderItem(itemVO);

        PaymentVO paymentVO = new PaymentVO();
        paymentVO.setOrder_id(orderVO.getOrder_id());
        paymentVO.setPayment_method("TOSS");
        paymentVO.setAmount(total_amount);
        paymentVO.setStatus("READY");
        paymentVO.setTransaction_id(null);

        paymentDAO.insertPayment(paymentVO);

        if (use_point > 0) {
            Map<String, Object> pointMap = new HashMap<>();
            pointMap.put("user_id", user_id);
            pointMap.put("point_amount", use_point);

            int pointResult = orderDAO.useUserPoint(pointMap);

            if (pointResult > 0) {
                orderDAO.insertUsePointHistory(pointMap);
            }
        }

        if (user_coupon_id > 0 && couponPrice > 0) {
            Map<String, Object> couponMap = new HashMap<>();
            couponMap.put("user_coupon_id", user_coupon_id);
            couponMap.put("user_id", user_id);

            orderDAO.useCoupon(couponMap);
        }

        if (total_amount == 0) {
            return completeZeroPaymentOrder(orderVO.getOrder_id());
        }

        return "redirect:/payment/ready?order_id=" + orderVO.getOrder_id();
    }

    // 주문 완료 화면
    // 주소: /order/complete?order_id=1
    @GetMapping("/order/complete")
    public String orderComplete(
            @RequestParam("order_id") int order_id,
            Model model,
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        OrderVO order = orderDAO.selectOrderById(order_id);
        List<OrderItemVO> orderItemList = orderDAO.selectOrderItemList(order_id);
        PaymentVO payment = paymentDAO.selectPaymentByOrderId(order_id);

        model.addAttribute("loginUser", loginUser);
        model.addAttribute("order", order);
        model.addAttribute("orderItemList", orderItemList);
        model.addAttribute("payment", payment);

        return "order/order_complete";
    }

    // 주문 상세 화면
    // 주소: /order/detail?order_id=1
    @GetMapping("/order/detail")
    public String orderDetail(
            @RequestParam("order_id") int order_id,
            Model model,
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        OrderVO order = orderDAO.selectOrderById(order_id);
        List<OrderItemVO> orderItemList = orderDAO.selectOrderItemList(order_id);
        PaymentVO payment = paymentDAO.selectPaymentByOrderId(order_id);

        model.addAttribute("loginUser", loginUser);
        model.addAttribute("order", order);
        model.addAttribute("orderItemList", orderItemList);
        model.addAttribute("payment", payment);

        return "order/order_detail";
    }

    // 배송 상태 확인
    // 주소: /order/delivery?order_id=1
    @GetMapping("/order/delivery")
    public String deliveryStatus(
            @RequestParam("order_id") int order_id,
            Model model,
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        OrderVO order = orderDAO.selectOrderById(order_id);

        model.addAttribute("loginUser", loginUser);
        model.addAttribute("order", order);

        return "order/delivery_status";
    }

    @PostMapping("/order/cancel")
    public String cancelOrder(
            @RequestParam("order_id") int order_id,
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        OrderVO order = orderDAO.selectOrderById(order_id);

        if (order == null) {
            return "redirect:/myshop/orders";
        }

        if ("PENDING".equals(order.getStatus())) {
            OrderVO orderVO = new OrderVO();
            orderVO.setOrder_id(order_id);
            orderVO.setStatus("CANCELLED");

            orderDAO.updateOrderStatus(orderVO);

            Map<String, Object> itemStatusMap = new HashMap<>();
            itemStatusMap.put("order_id", order_id);
            itemStatusMap.put("status", "CANCELLED");

            orderDAO.updateOrderItemsStatusByOrderId(itemStatusMap);

            PaymentVO paymentVO = new PaymentVO();
            paymentVO.setOrder_id(order_id);

            paymentDAO.updatePaymentCancel(paymentVO);
        }

        return "redirect:/myshop/orders";
    }

    @PostMapping("/order_cart_form.do")
    public String orderCartForm(
            @RequestParam(value = "cart_id", required = false) int[] cart_id,
            Model model,
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        if (cart_id == null || cart_id.length == 0) {
            return "redirect:/cart_list.do";
        }

        int user_id = getLoginUserId(session);

        Map<String, Object> map = new HashMap<>();
        map.put("user_id", user_id);
        map.put("cart_id", cart_id);

        List<Map<String, Object>> orderCartList = cartdao.cartOrderList(map);

        int totalOriginPrice = 0;
        int totalDiscountPrice = 0;
        int totalItemPrice = 0;

        Map<Integer, Integer> sellerMaxDeliveryMap = new HashMap<>();
        Map<Integer, Boolean> sellerFreeDeliveryMap = new HashMap<>();

        for (Map<String, Object> item : orderCartList) {

            int seller_id = ((Number) item.get("seller_id")).intValue();

            int origin_total = ((Number) item.get("origin_total")).intValue();
            int discount_total = ((Number) item.get("discount_total")).intValue();
            int item_total = ((Number) item.get("item_total")).intValue();

            int delivery_fee = ((Number) item.get("delivery_fee")).intValue();
            int free_shipping = ((Number) item.get("free_shipping")).intValue();

            totalOriginPrice += origin_total;
            totalDiscountPrice += discount_total;
            totalItemPrice += item_total;

            boolean isFreeDelivery = false;

            if (delivery_fee == 0) {
                isFreeDelivery = true;
            }

            if (free_shipping > 0 && item_total >= free_shipping) {
                isFreeDelivery = true;
            }

            if (isFreeDelivery) {
                sellerFreeDeliveryMap.put(seller_id, true);
            }

            int currentMaxDeliveryFee = sellerMaxDeliveryMap.getOrDefault(seller_id, 0);

            if (delivery_fee > currentMaxDeliveryFee) {
                sellerMaxDeliveryMap.put(seller_id, delivery_fee);
            }
        }

        int totalDeliveryFee = 0;

        for (Integer seller_id : sellerMaxDeliveryMap.keySet()) {

            boolean sellerFreeDelivery = sellerFreeDeliveryMap.getOrDefault(seller_id, false);

            if (!sellerFreeDelivery) {
                totalDeliveryFee += sellerMaxDeliveryMap.get(seller_id);
            }
        }

        List<Map<String, Object>> couponList = orderDAO.selectAvailableCouponList(user_id);

        int couponPrice = 0;

        int paymentPrice = totalItemPrice + totalDeliveryFee - couponPrice;

        int pointBalance = orderDAO.getUserPoint(user_id);
        model.addAttribute("pointBalance", pointBalance);

        model.addAttribute("loginUser", loginUser);
        model.addAttribute("orderItemList", orderCartList);
        model.addAttribute("totalOriginPrice", totalOriginPrice);
        model.addAttribute("totalDiscountPrice", totalDiscountPrice);
        model.addAttribute("totalItemPrice", totalItemPrice);
        model.addAttribute("totalDeliveryFee", totalDeliveryFee);
        model.addAttribute("paymentPrice", paymentPrice);
        model.addAttribute("couponPrice", couponPrice);
        model.addAttribute("couponList", couponList);

        return "order/order_form";
    }

    // 구매확정 처리
    @PostMapping("/order_confirm.do")
    @Transactional
    public String orderConfirm(
            @RequestParam("order_item_id") int order_item_id,
            HttpSession session
    ) {
        UserVO user = (UserVO) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login.do";
        }

        Map<String, Object> map = new HashMap<>();
        map.put("order_item_id", order_item_id);
        map.put("user_id", user.getUser_id());

        int result = orderDAO.confirmOrderItem(map);

        if (result > 0) {

            int pointCheck = orderDAO.checkPointHistory(map);

            if (pointCheck == 0) {

                OrderItemVO item = orderDAO.selectOrderItemById(map);

                if (item != null) {
                    int pointAmount = (int) Math.floor((item.getPrice() * item.getQuantity()) * 0.03);

                    if (pointAmount > 0) {
                        map.put("point_amount", pointAmount);

                        orderDAO.insertUserPointIfNotExists(map);
                        orderDAO.updateUserPoint(map);
                        orderDAO.insertPointHistory(map);
                    }
                }
            }
        }

        return "redirect:/myshop/orders";
    }
}