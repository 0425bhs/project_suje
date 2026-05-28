package com.kh.suje.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.PaymentDAO;
import com.kh.suje.vo.OrderItemVO;
import com.kh.suje.vo.OrderVO;
import com.kh.suje.vo.PaymentVO;

@Controller
public class PaymentController {

    private final PaymentDAO paymentDAO;
    private final OrderDAO orderDAO;

    public PaymentController(PaymentDAO paymentDAO, OrderDAO orderDAO) {
        this.paymentDAO = paymentDAO;
        this.orderDAO = orderDAO;
    }

    // 결제 대기 화면
    // 주소: /payment/ready?order_id=1
    @GetMapping("/payment/ready")
    public String paymentReady(
            @RequestParam("order_id") int order_id,
            Model model
    ) {
        OrderVO order = orderDAO.selectOrderById(order_id);
        List<OrderItemVO> orderItemList = orderDAO.selectOrderItemList(order_id);
        PaymentVO payment = paymentDAO.selectPaymentByOrderId(order_id);

        model.addAttribute("order", order);
        model.addAttribute("orderItemList", orderItemList);
        model.addAttribute("payment", payment);

        return "payment/payment_ready";
    }

    // 결제 성공 처리
    // 주소: /payment/success?order_id=1
    @GetMapping("/payment/success")
    public String paymentSuccess(@RequestParam("order_id") int order_id) {

        // 1. payments 상태 SUCCESS로 변경
        PaymentVO paymentVO = new PaymentVO();
        paymentVO.setOrder_id(order_id);
        paymentVO.setTransaction_id("TEST_PAYMENT_KEY_" + order_id);

        paymentDAO.updatePaymentSuccess(paymentVO);

        // 2. orders 상태 PAID로 변경
        OrderVO orderVO = new OrderVO();
        orderVO.setOrder_id(order_id);
        orderVO.setStatus("PAID");

        orderDAO.updateOrderStatus(orderVO);

        // 3. 주문 완료 화면으로 이동
        return "redirect:/order/complete?order_id=" + order_id;
    }

    // 결제 실패 처리
    // 주소: /payment/fail?order_id=1
    @GetMapping("/payment/fail")
    public String paymentFail(
            @RequestParam("order_id") int order_id,
            Model model
    ) {
        PaymentVO paymentVO = new PaymentVO();
        paymentVO.setOrder_id(order_id);

        paymentDAO.updatePaymentFail(paymentVO);

        model.addAttribute("order_id", order_id);

        return "payment/payment_fail";
    }
}