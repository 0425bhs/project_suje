package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

        // 1. 상태별 개수를 DB에서 한 번에 가져옴 (위의 CASE WHEN 쿼리 실행)
        Map<String, Object> statusCounts = orderDAO.selectOrderStatusCounts(user_id);
        
        List<OrderVO> orderList;

        if (status == null || status.trim().isEmpty()) {
            orderList = orderDAO.selectOrderListByUserId(user_id);
        } else {
            orderList = orderDAO.selectOrderListByUserIdAndStatus(user_id, status);
        }

        // 주문별 주문상품 목록
        Map<Integer, List<OrderItemVO>> orderItemMap = new HashMap<>();

        for (OrderVO order : orderList) {
            List<OrderItemVO> itemList = orderDAO.selectOrderItemList(order.getOrder_id());

            orderItemMap.put(order.getOrder_id(), itemList);
        }
        
        model.addAttribute("loginUser", loginUser);
        
        // model에 Map의 값들을 통째로 넘겨줌
        model.addAllAttributes(statusCounts);
        
        model.addAttribute("orderList", orderList);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("orderItemMap", orderItemMap);

        model.addAttribute("activeMenu", "orders");
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

        int price = product.getSale_price() > 0
                ? product.getSale_price()
                : product.getPrice();

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

        int couponPrice = 0;

        int total_amount = item_amount + delivery_fee - couponPrice;

        model.addAttribute("orderItemList", orderItemList);
        model.addAttribute("totalOriginPrice", originTotal);
        model.addAttribute("totalDiscountPrice", discountTotal);
        model.addAttribute("totalItemPrice", item_amount);
        model.addAttribute("totalDeliveryFee", delivery_fee);
        model.addAttribute("paymentPrice", total_amount);
        model.addAttribute("couponPrice", couponPrice);

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
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        int user_id = getLoginUserId(session);

        // 배송지 기능 붙기 전까지 임시 사용
        int address_id = 1;

        int couponPrice = 0;


        // =========================================================
        // 1. 장바구니 주문
        // cart_id 배열이 넘어온 경우
        // =========================================================
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

            int total_amount = totalItemPrice + totalDeliveryFee - couponPrice;

            // 1. orders 테이블에 주문 기본 정보 저장
            OrderVO orderVO = new OrderVO();
            orderVO.setUser_id(user_id);
            orderVO.setTotal_amount(total_amount);
            orderVO.setAddress_id(address_id);
            orderVO.setStatus("PENDING");

            orderDAO.insertOrder(orderVO);

            // 2. order_items 테이블에 장바구니 상품 여러 개 저장
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

            // 3. payments 테이블에 결제 대기 정보 저장
            PaymentVO paymentVO = new PaymentVO();
            paymentVO.setOrder_id(orderVO.getOrder_id());
            paymentVO.setPayment_method("TOSS");
            paymentVO.setAmount(total_amount);
            paymentVO.setStatus("READY");
            paymentVO.setTransaction_id(null);

            paymentDAO.insertPayment(paymentVO);

            cartdao.cartDeleteSelected(map);

            return "redirect:/payment/ready?order_id=" + orderVO.getOrder_id();
        }


        // =========================================================
        // 2. 바로구매 주문
        // product_id 하나가 넘어온 경우
        // =========================================================
        if (product_id == null) {
            return "redirect:/product/list.do";
        }

        ProductVO product = productDAO.product_one(product_id);

        if (product == null) {
            return "redirect:/product/list.do";
        }

        int price = product.getSale_price() > 0
                ? product.getSale_price()
                : product.getPrice();

        int item_amount = price * quantity;

        int delivery_fee = product.getDelivery_fee();

        if (product.getFree_shipping() > 0 && item_amount >= product.getFree_shipping()) {
            delivery_fee = 0;
        }

        int total_amount = item_amount + delivery_fee - couponPrice;

        // 1. orders 테이블에 주문 기본 정보 저장
        OrderVO orderVO = new OrderVO();
        orderVO.setUser_id(user_id);
        orderVO.setTotal_amount(total_amount);
        orderVO.setAddress_id(address_id);
        orderVO.setStatus("PENDING");

        orderDAO.insertOrder(orderVO);

        // 2. order_items 테이블에 주문 상품 정보 저장
        OrderItemVO itemVO = new OrderItemVO();
        itemVO.setOrder_id(orderVO.getOrder_id());
        itemVO.setProduct_id(product_id);
        itemVO.setPrice(price);
        itemVO.setQuantity(quantity);

        orderDAO.insertOrderItem(itemVO);

        // 3. payments 테이블에 결제 대기 정보 저장
        PaymentVO paymentVO = new PaymentVO();
        paymentVO.setOrder_id(orderVO.getOrder_id());
        paymentVO.setPayment_method("TOSS");
        paymentVO.setAmount(total_amount);
        paymentVO.setStatus("READY");
        paymentVO.setTransaction_id(null);

        paymentDAO.insertPayment(paymentVO);

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

        // 결제 전 주문만 여기서 바로 취소
        if ("PENDING".equals(order.getStatus())) {
            OrderVO orderVO = new OrderVO();
            orderVO.setOrder_id(order_id);
            orderVO.setStatus("CANCELLED");

            orderDAO.updateOrderStatus(orderVO);

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

            // 배송비가 0원이면 무료배송 상품
            if (delivery_fee == 0) {
                isFreeDelivery = true;
            }

            // 무료배송 조건 금액을 달성했으면 무료배송
            if (free_shipping > 0 && item_total >= free_shipping) {
                isFreeDelivery = true;
            }

            // 같은 판매자 상품 중 하나라도 무료배송이면 판매자 전체 배송비 0원
            if (isFreeDelivery) {
                sellerFreeDeliveryMap.put(seller_id, true);
            }

            // 무료배송이 하나도 없을 때 적용할 판매자별 최대 배송비 저장
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

        int couponPrice = 0;

        int paymentPrice = totalItemPrice + totalDeliveryFee - couponPrice;

        model.addAttribute("loginUser", loginUser);
        model.addAttribute("orderItemList", orderCartList);
        model.addAttribute("totalOriginPrice", totalOriginPrice);
        model.addAttribute("totalDiscountPrice", totalDiscountPrice);
        model.addAttribute("totalItemPrice", totalItemPrice);
        model.addAttribute("totalDeliveryFee", totalDeliveryFee);
        model.addAttribute("paymentPrice", paymentPrice);
        model.addAttribute("couponPrice", couponPrice);

        return "order/order_form";
    }
}