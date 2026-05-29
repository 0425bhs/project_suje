package com.kh.suje.controller;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;
import java.time.Duration;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.PaymentDAO;
import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;
import com.kh.suje.vo.payment.PaymentVO;

@Controller
public class PaymentController {

    private final PaymentDAO paymentDAO;
    private final OrderDAO orderDAO;

    @Value("${toss.client-key}")
    private String tossClientKey;

    @Value("${toss.secret-key}")
    private String tossSecretKey;

    public PaymentController(PaymentDAO paymentDAO, OrderDAO orderDAO) {
        this.paymentDAO = paymentDAO;
        this.orderDAO = orderDAO;
    }

    // 결제 대기 화면
    // 주소: /payment/ready?order_id=1
    @GetMapping("/payment/ready")
    public String paymentReady(
            @RequestParam("order_id") Long order_id,
            Model model
    ) {
        OrderVO order = orderDAO.selectOrderById(order_id);
        List<OrderItemVO> orderItemList = orderDAO.selectOrderItemList(order_id);
        PaymentVO payment = paymentDAO.selectPaymentByOrderId(order_id);

        String tossOrderId = "ORDER_" + order_id;

        String orderName = "핸드메이드 상품 주문";

        if (orderItemList != null && !orderItemList.isEmpty()) {
            orderName = orderItemList.get(0).getProductName();

            if (orderItemList.size() > 1) {
                orderName += " 외 " + (orderItemList.size() - 1) + "건";
            }
        }

        model.addAttribute("order", order);
        model.addAttribute("orderItemList", orderItemList);
        model.addAttribute("payment", payment);

        // Toss 결제창에서 사용할 값
        model.addAttribute("tossClientKey", tossClientKey);
        model.addAttribute("tossOrderId", tossOrderId);
        model.addAttribute("orderName", orderName);
        model.addAttribute("customerKey", "USER_" + order.getUser_id());

        return "payment/payment_ready";
    }

    // Toss 결제 인증 성공 후 돌아오는 주소
    // Toss successUrl: /payment/toss/success
    @GetMapping("/payment/toss/success")
    public String tossSuccess(
            @RequestParam("paymentKey") String paymentKey,
            @RequestParam("orderId") String tossOrderId,
            @RequestParam("amount") int amount,
            Model model
    ) {
        System.out.println("[TOSS] success callback 진입");
        System.out.println("[TOSS] orderId = " + tossOrderId);
        System.out.println("[TOSS] paymentKey = " + paymentKey);
        System.out.println("[TOSS] amount = " + amount);

        if (tossOrderId == null || !tossOrderId.startsWith("ORDER_")) {
            model.addAttribute("order_id", null);
            model.addAttribute("message", "잘못된 주문번호입니다.");
            return "payment/payment_fail";
        }

        Long order_id = Long.parseLong(tossOrderId.replace("ORDER_", ""));

        PaymentVO dbPayment = paymentDAO.selectPaymentByOrderId(order_id);

        if (dbPayment == null) {
            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "결제 정보가 없습니다.");
            return "payment/payment_fail";
        }

        if (dbPayment.getAmount() != amount) {
            PaymentVO failPayment = new PaymentVO();
            failPayment.setOrder_id(order_id);
            paymentDAO.updatePaymentFail(failPayment);

            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "결제 금액이 일치하지 않습니다.");
            return "payment/payment_fail";
        }

        try {
            String auth = Base64.getEncoder()
                    .encodeToString((tossSecretKey + ":").getBytes(StandardCharsets.UTF_8));

            String jsonBody = "{"
                    + "\"paymentKey\":\"" + paymentKey + "\","
                    + "\"orderId\":\"" + tossOrderId + "\","
                    + "\"amount\":" + amount
                    + "}";

            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(5))
                    .build();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.tosspayments.com/v1/payments/confirm"))
                    .timeout(Duration.ofSeconds(10))
                    .header("Authorization", "Basic " + auth)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            HttpResponse<String> response = client.send(
                    request,
                    HttpResponse.BodyHandlers.ofString()
            );

            System.out.println("[TOSS] confirm status = " + response.statusCode());
            System.out.println("[TOSS] confirm body = " + response.body());

            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                PaymentVO paymentVO = new PaymentVO();
                paymentVO.setOrder_id(order_id);
                paymentVO.setTransaction_id(paymentKey);

                paymentDAO.updatePaymentSuccess(paymentVO);

                OrderVO orderVO = new OrderVO();
                orderVO.setOrder_id(order_id);
                orderVO.setStatus("PAID");

                orderDAO.updateOrderStatus(orderVO);

                return "redirect:/order/complete?order_id=" + order_id;
            }

            PaymentVO failPayment = new PaymentVO();
            failPayment.setOrder_id(order_id);
            paymentDAO.updatePaymentFail(failPayment);

            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "결제 승인에 실패했습니다. Toss 응답: " + response.body());
            return "payment/payment_fail";

        } catch (Exception e) {
            e.printStackTrace();

            PaymentVO failPayment = new PaymentVO();
            failPayment.setOrder_id(order_id);
            paymentDAO.updatePaymentFail(failPayment);

            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "결제 승인 요청 중 오류가 발생했습니다: " + e.getMessage());
            return "payment/payment_fail";
        }
    }
}