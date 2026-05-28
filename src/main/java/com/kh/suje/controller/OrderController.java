package com.kh.suje.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.PaymentDAO;
import com.kh.suje.vo.OrderItemVO;
import com.kh.suje.vo.OrderVO;
import com.kh.suje.vo.PaymentVO;

@Controller
public class OrderController {

    private final OrderDAO orderDAO;
    private final PaymentDAO paymentDAO;

    public OrderController(OrderDAO orderDAO, PaymentDAO paymentDAO) {
        this.orderDAO = orderDAO;
        this.paymentDAO = paymentDAO;
    }

    // 내 주문 내역
    // 주소: /order/my
    @GetMapping("/order/my")
    public String myOrderList(Model model) {

        // 로그인 기능 붙기 전 테스트용 회원 번호
        int user_id = 1;

        List<OrderVO> orderList = orderDAO.selectOrderListByUserId(user_id);

        model.addAttribute("orderList", orderList);

        return "order/my_order_list";
    }

    // 주문서 작성 화면
    // 주소: /order/form
    @GetMapping("/order/form")
    public String orderForm(Model model) {

        // 상품 상세 페이지가 아직 없으니까 테스트용 상품 정보
        model.addAttribute("product_id", 1);
        model.addAttribute("productName", "핸드메이드 실버 반지");
        model.addAttribute("imageS", "test_ring_small.jpg");
        model.addAttribute("price", 15000);
        model.addAttribute("quantity", 2);
        model.addAttribute("total_amount", 30000);

        return "order/order_form";
    }

    // 주문 생성 처리
    // 주문서 작성 → 결제 대기로 이동
    @PostMapping("/order/create")
    public String createOrder(
            @RequestParam("product_id") int product_id,
            @RequestParam("price") int price,
            @RequestParam("quantity") int quantity,
            @RequestParam("payment_method") String payment_method
    ) {
        // 로그인 붙기 전 테스트용 회원/배송지
        int user_id = 1;
        int address_id = 1;

        int total_amount = price * quantity;

        // 1. orders insert
        OrderVO orderVO = new OrderVO();
        orderVO.setUser_id(user_id);
        orderVO.setTotal_amount(total_amount);
        orderVO.setAddress_id(address_id);
        orderVO.setStatus("PENDING");

        orderDAO.insertOrder(orderVO);

        // 2. order_items insert
        OrderItemVO itemVO = new OrderItemVO();
        itemVO.setOrder_id(orderVO.getOrder_id());
        itemVO.setProduct_id(product_id);
        itemVO.setPrice(price);
        itemVO.setQuantity(quantity);

        orderDAO.insertOrderItem(itemVO);

        // 3. payments insert
        PaymentVO paymentVO = new PaymentVO();
        paymentVO.setOrder_id(orderVO.getOrder_id());
        paymentVO.setPayment_method(payment_method);
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
            Model model
    ) {
        OrderVO order = orderDAO.selectOrderById(order_id);
        List<OrderItemVO> orderItemList = orderDAO.selectOrderItemList(order_id);
        PaymentVO payment = paymentDAO.selectPaymentByOrderId(order_id);

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
            Model model
    ) {
        OrderVO order = orderDAO.selectOrderById(order_id);
        List<OrderItemVO> orderItemList = orderDAO.selectOrderItemList(order_id);
        PaymentVO payment = paymentDAO.selectPaymentByOrderId(order_id);

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
            Model model
    ) {
        OrderVO order = orderDAO.selectOrderById(order_id);

        model.addAttribute("order", order);

        return "order/delivery_status";
    }
}