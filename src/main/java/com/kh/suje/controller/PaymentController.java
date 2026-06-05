package com.kh.suje.controller;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Base64;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.PaymentDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.vo.order.OrderItemVO;
import com.kh.suje.vo.order.OrderVO;
import com.kh.suje.vo.payment.PaymentVO;

@Controller
public class PaymentController {

    private final PaymentDAO paymentDAO;
    private final OrderDAO orderDAO;

    // 상품 재고 차감 / 복구를 위해 사용하는 DAO
    private final ProductDAO productDAO;

    @Value("${toss.client-key}")
    private String tossClientKey;

    @Value("${toss.secret-key}")
    private String tossSecretKey;

    public PaymentController(PaymentDAO paymentDAO, OrderDAO orderDAO, ProductDAO productDAO) {
        this.paymentDAO = paymentDAO;
        this.orderDAO = orderDAO;
        this.productDAO = productDAO;
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

        if (order == null || payment == null) {
            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "주문 또는 결제 정보를 찾을 수 없습니다.");
            return "payment/payment_fail";
        }

        if ("PAID".equals(order.getStatus()) || "SUCCESS".equals(payment.getStatus())) {
            return "redirect:/order/complete?order_id=" + order_id;
        }

        if ("CANCELLED".equals(order.getStatus()) || "CANCELLED".equals(payment.getStatus())) {
            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "이미 취소된 주문은 다시 결제할 수 없습니다. 새로 주문해주세요.");
            return "payment/payment_fail";
        }

        // Toss orderId는 한 번 승인/취소되면 재사용할 수 없으므로 매번 고유하게 생성
        String tossOrderId = "ORDER_" + order_id + "_" + System.currentTimeMillis();

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

        model.addAttribute("tossClientKey", tossClientKey);
        model.addAttribute("tossOrderId", tossOrderId);
        model.addAttribute("orderName", orderName);
        model.addAttribute("customerKey", "USER_" + order.getUser_id());

        return "payment/payment_ready";
    }

    // Toss orderId에서 실제 DB order_id 꺼내기
    // 예: ORDER_10_1716950000000 -> 10
    private Integer extractOrderId(String tossOrderId) {
        if (tossOrderId == null || !tossOrderId.startsWith("ORDER_")) {
            return null;
        }

        String[] orderIdParts = tossOrderId.split("_");

        if (orderIdParts.length < 2) {
            return null;
        }

        try {
            return Integer.parseInt(orderIdParts[1]);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // Toss 결제 인증 성공 후 돌아오는 주소
    // Toss successUrl: /payment/toss/success
    @GetMapping("/payment/toss/success")
    @Transactional
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

        Integer parsedOrderId = extractOrderId(tossOrderId);

        if (parsedOrderId == null) {
            model.addAttribute("order_id", null);
            model.addAttribute("message", "잘못된 주문번호입니다.");
            return "payment/payment_fail";
        }

        int order_id = parsedOrderId;

        PaymentVO dbPayment = paymentDAO.selectPaymentByOrderId(order_id);

        if (dbPayment == null) {
            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "결제 정보가 없습니다.");
            return "payment/payment_fail";
        }

        if ("SUCCESS".equals(dbPayment.getStatus())) {
            return "redirect:/order/complete?order_id=" + order_id;
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
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody, StandardCharsets.UTF_8))
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

                // =========================================================
                // 결제 성공 후 상품 재고 차감
                // - 결제가 정상 승인되고 주문 상태가 PAID로 변경된 뒤 실행
                // - order_items에 저장된 상품 목록을 가져온다.
                // - 각 상품의 주문 수량만큼 products.stock을 감소시킨다.
                // - stock이 부족해서 차감 실패하면 결제 완료 화면으로 보내지 않고 실패 화면으로 보낸다.
                // =========================================================
                List<OrderItemVO> itemList = orderDAO.selectOrderItemList(order_id);

                for (OrderItemVO item : itemList) {

                    int stockResult = productDAO.decreaseStock(item);

                    if (stockResult == 0) {
                        model.addAttribute("order_id", order_id);
                        model.addAttribute("message", "상품 재고가 부족하여 재고 차감에 실패했습니다.");
                        return "payment/payment_fail";
                    }
                }

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

    

    // Toss 결제 실패 후 돌아오는 주소
    // Toss failUrl: /payment/toss/fail
    @GetMapping("/payment/toss/fail")
    public String tossFail(
            @RequestParam(value = "orderId", required = false) String tossOrderId,
            @RequestParam(value = "message", required = false) String message,
            Model model
    ) {
        Integer parsedOrderId = extractOrderId(tossOrderId);

        if (parsedOrderId != null) {
            PaymentVO paymentVO = new PaymentVO();
            paymentVO.setOrder_id(parsedOrderId);

            paymentDAO.updatePaymentFail(paymentVO);
        }

        model.addAttribute("order_id", parsedOrderId);
        model.addAttribute("message", message);

        return "payment/payment_fail";
    }

    // Toss 결제 취소
    @PostMapping("/payment/toss/cancel")
    @Transactional
    public String tossCancel(
            @RequestParam("order_id") int order_id,
            @RequestParam(value = "cancel_reason", required = false, defaultValue = "사용자 요청") String cancel_reason,
            Model model
    ) {
        OrderVO order = orderDAO.selectOrderById(order_id);
        PaymentVO payment = paymentDAO.selectPaymentByOrderId(order_id);

        if (order == null) {
            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "주문 정보를 찾을 수 없습니다.");
            return "payment/payment_fail";
        }

        if (payment == null) {
            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "결제 정보를 찾을 수 없습니다.");
            return "payment/payment_fail";
        }

        // 주문 상태 기준 확인
        if (!"PAID".equals(order.getStatus())) {
            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "결제완료 상태의 주문만 취소할 수 있습니다.");
            return "payment/payment_fail";
        }

        // 결제 상태 기준 확인
        if (!"SUCCESS".equals(payment.getStatus())) {
            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "Toss 결제 성공 상태가 아니라 취소할 수 없습니다. 현재 결제상태: " + payment.getStatus());
            return "payment/payment_fail";
        }

        // Toss paymentKey 확인
        if (payment.getTransaction_id() == null || payment.getTransaction_id().trim().isEmpty()) {
            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "Toss paymentKey가 저장되어 있지 않아 결제취소를 요청할 수 없습니다.");
            return "payment/payment_fail";
        }

        try {
            String auth = Base64.getEncoder()
                    .encodeToString((tossSecretKey + ":").getBytes(StandardCharsets.UTF_8));

            String cancelReason = cancel_reason;

            if (cancelReason == null || cancelReason.trim().isEmpty()) {
                cancelReason = "사용자 요청";
            }

            String safeCancelReason = cancelReason.trim()
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\r", " ")
                    .replace("\n", " ");

            String jsonBody = "{"
                    + "\"cancelReason\":\"" + safeCancelReason + "\""
                    + "}";

            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(5))
                    .build();

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.tosspayments.com/v1/payments/"
                            + payment.getTransaction_id()
                            + "/cancel"))
                    .timeout(Duration.ofSeconds(10))
                    .header("Authorization", "Basic " + auth)
                    .header("Content-Type", "application/json")
                    .header("Idempotency-Key", "cancel-order-" + order_id)
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = client.send(
                    request,
                    HttpResponse.BodyHandlers.ofString()
            );

            System.out.println("[TOSS CANCEL] status = " + response.statusCode());
            System.out.println("[TOSS CANCEL] body = " + response.body());

            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                PaymentVO paymentVO = new PaymentVO();
                paymentVO.setOrder_id(order_id);

                int paymentResult = paymentDAO.updatePaymentCancel(paymentVO);

                // =========================================================
                // 결제취소 성공 후 주문 취소 정보 저장
                // - orders.status = CANCELLED
                // - orders.cancel_reason = 사용자가 선택한 취소 사유
                // - orders.cancelled_at = 현재 시간
                // =========================================================
                OrderVO orderVO = new OrderVO();
                orderVO.setOrder_id(order_id);
                orderVO.setStatus("CANCELLED");
                orderVO.setCancel_reason(cancelReason);

                int orderResult = orderDAO.updateOrderCancelInfo(orderVO);

                if (paymentResult == 0 || orderResult == 0) {
                    model.addAttribute("order_id", order_id);
                    model.addAttribute("message", "Toss 취소는 성공했지만 DB 상태 변경에 실패했습니다.");
                    return "payment/payment_fail";
                }

                // =========================================================
                // 결제 취소 성공 후 상품 재고 복구
                // - Toss 결제취소가 성공하고,
                // - payments.status = CANCELLED,
                // - orders.status = CANCELLED 로 변경된 뒤 실행
                // - 주문 상품 목록을 가져와서 주문 수량만큼 products.stock을 다시 증가시킨다.
                // =========================================================
                List<OrderItemVO> itemList = orderDAO.selectOrderItemList(order_id);

                for (OrderItemVO item : itemList) {
                    productDAO.increaseStock(item);
                }

                return "redirect:/order/my?status=CANCELLED";
            }

            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "결제 취소에 실패했습니다. Toss 응답: " + response.body());
            return "payment/payment_fail";

        } catch (Exception e) {
            e.printStackTrace();

            model.addAttribute("order_id", order_id);
            model.addAttribute("message", "결제 취소 요청 중 오류가 발생했습니다: " + e.getMessage());

            return "payment/payment_fail";
        }
    }
}