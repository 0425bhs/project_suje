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

import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.PaymentDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;
import com.kh.suje.vo.payment.PaymentVO;

import jakarta.servlet.http.HttpSession;

@Controller
public class OrderController {

    private final OrderDAO orderDAO;
    private final PaymentDAO paymentDAO;
    private final ProductDAO productDAO;

    public OrderController(OrderDAO orderDAO, PaymentDAO paymentDAO, ProductDAO productDAO) {
        this.orderDAO = orderDAO;
        this.paymentDAO = paymentDAO;
        this.productDAO = productDAO;
    }

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
    // 주소: /order/my
    @GetMapping("/order/my")
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

        // 로그인한 회원의 전체 주문 목록
        List<OrderVO> allOrderList = orderDAO.selectOrderListByUserId(user_id);

        List<OrderVO> orderList;

        if (status == null || status.trim().isEmpty()) {
            orderList = allOrderList;
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
        model.addAttribute("allOrderList", allOrderList);
        model.addAttribute("orderList", orderList);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("orderItemMap", orderItemMap);

        return "order/my_order_list";
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

        int item_amount = price * quantity;

        int delivery_fee = product.getDelivery_fee();

        if (product.getFree_shipping() > 0 && item_amount >= product.getFree_shipping()) {
            delivery_fee = 0;
        }

        int total_amount = item_amount + delivery_fee;

        model.addAttribute("loginUser", loginUser);
        model.addAttribute("product", product);
        model.addAttribute("quantity", quantity);
        model.addAttribute("price", price);
        model.addAttribute("item_amount", item_amount);
        model.addAttribute("delivery_fee", delivery_fee);
        model.addAttribute("total_amount", total_amount);

        return "order/order_form";
    }

    // 주문 생성 처리
    // 주문서 작성 → 결제 대기로 이동
    @PostMapping("/order/create")
    @Transactional
    public String createOrder(
            @RequestParam("product_id") int product_id,
            @RequestParam("quantity") int quantity,
            HttpSession session
    ) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        // 로그인한 회원 번호 사용
        int user_id = getLoginUserId(session);

        // 배송지 기능 붙기 전까지 임시 사용
        int address_id = 1;

        // product_id로 실제 상품 정보 조회
        ProductVO product = productDAO.product_one(product_id);

        // 상품이 없으면 상품 목록으로 이동
        if (product == null) {
            return "redirect:/product/list.do";
        }

        // 할인 가격이 있으면 sale_price 사용, 없으면 price 사용
        int price = product.getSale_price() > 0
                ? product.getSale_price()
                : product.getPrice();

        // 상품 금액 = 상품 가격 * 수량
        int item_amount = price * quantity;

        // 배송비
        int delivery_fee = product.getDelivery_fee();

        if (product.getFree_shipping() > 0 && item_amount >= product.getFree_shipping()) {
            delivery_fee = 0;
        }

        // 최종 결제 금액 = 상품 금액 + 배송비
        int total_amount = item_amount + delivery_fee;

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

        // 4. 결제 대기 화면으로 이동
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
            return "redirect:/order/my";
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

        return "redirect:/order/my";
    }
}