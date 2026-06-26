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

import com.kh.suje.dao.OptionDAO;
import com.kh.suje.vo.OptionVO;
import com.kh.suje.dao.AddressDAO;
import com.kh.suje.dao.CartDAO;
import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.PaymentDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.vo.AddressVO;
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
    private final OptionDAO optiondao;
    private final AddressDAO addressDao;

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

    // 현재 날짜 기준으로 실제 적용할 상품 가격 구하기
    private int getActiveProductPrice(ProductVO product) {

        int price = product.getPrice();
        int salePrice = product.getSale_price();

        // 할인가가 없거나 원가보다 크거나 같으먄 원가 사용
        if (salePrice <= 0 || salePrice >= price) {
            return price;
        }

        String saleStartAt = product.getSale_start_at();
        String saleEndAt = product.getSale_end_at();

        boolean emtyStart = saleStartAt == null || saleStartAt.trim().isEmpty();
        boolean emtyEnd = saleEndAt == null || saleEndAt.trim().isEmpty();

        // 할인 시작일, 종료일 둘 다 없으면 상시 할인
        if (emtyStart && emtyEnd) {
            return salePrice;
        }

        // 할인 시작일, 종료일 둘 다 있으면 기간 할인
        if (!emtyStart && !emtyEnd) {
            try {
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

    // 내 주문 내역
    // 주소: /myshop/orders
    @GetMapping("/myshop/orders")
    public String myOrderList(
            @RequestParam(value = "status", required = false) String status,
            Model model,
            HttpSession session) {
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

        model.addAttribute("activeMenu", "order");
        model.addAttribute("contentPage", "/myshop/order_list");

        return "myshop/myshop_main";
    }

    // 주문서 작성 화면
    @GetMapping("/order/form")
    public String orderForm(
            int product_id,
            @RequestParam(value = "option_id", required = false) List<Integer> optionIdList,
            @RequestParam(value = "quantity", required = false) List<Integer> quantityList,
            Model model,
            HttpSession session) {
        UserVO loginUser = getLoginUser(session);

        if (loginUser == null) {
            return "redirect:/login.do";
        }

        ProductVO product = productDAO.product_one(product_id);

        if (product == null) {
            return "redirect:/product/list.do";
        }

        int basePrice = getActiveProductPrice(product);

        int totalOriginPrice = 0;
        int totalDiscountPrice = 0;
        int totalItemPrice = 0;
        int couponPrice = 0;

        List<Map<String, Object>> orderItemList = new java.util.ArrayList<>();

        /*
            옵션 있는 상품
            option_id, quantity가 여러 개 넘어오는 경우
        */
        if (optionIdList != null && !optionIdList.isEmpty()) {

            if (quantityList == null || optionIdList.size() != quantityList.size()) {
                return "redirect:/product_detail.do?product_id=" + product_id;
            }

            for (int i = 0; i < optionIdList.size(); i++) {

                Integer option_id = optionIdList.get(i);
                Integer quantityObj = quantityList.get(i);

                if (option_id == null || quantityObj == null || quantityObj <= 0) {
                    return "redirect:/product_detail.do?product_id=" + product_id;
                }

                int quantity = quantityObj;

                OptionVO option = optiondao.selectOptionOne(option_id);

                if (option == null) {
                    return "redirect:/product_detail.do?product_id=" + product_id;
                }

                if (option.getProduct_id() != product_id) {
                    return "redirect:/product_detail.do?product_id=" + product_id;
                }

                if (option.getOption_stock() < quantity) {
                    return "redirect:/product_detail.do?product_id=" + product_id;
                }

                int optionPrice = option.getOption_price();
                int itemPrice = basePrice + optionPrice;

                int originTotal = (product.getPrice() + optionPrice) * quantity;
                int itemAmount = itemPrice * quantity;
                int discountTotal = originTotal - itemAmount;

                totalOriginPrice += originTotal;
                totalDiscountPrice += discountTotal;
                totalItemPrice += itemAmount;

                Map<String, Object> item = new HashMap<>();
                item.put("product_id", product.getProduct_id());
                item.put("name", product.getName());
                item.put("image_l", product.getImage_l());
                item.put("price", product.getPrice());
                item.put("sale_price", product.getSale_price());
                item.put("item_price", itemPrice);
                item.put("quantity", quantity);
                item.put("origin_total", originTotal);
                item.put("item_total", itemAmount);
                item.put("discount_total", discountTotal);
                item.put("cart_id", 0);
                item.put("delivery_fee", product.getDelivery_fee());
                item.put("free_shipping", product.getFree_shipping());

                item.put("option_id", option_id);
                item.put("option_name", option.getOption_name());
                item.put("option_price", option.getOption_price());

                orderItemList.add(item);
            }

        } else {

            /*
                옵션 없는 일반 상품
            */
            int quantity = 1;

            if (quantityList != null && !quantityList.isEmpty() && quantityList.get(0) != null) {
                quantity = quantityList.get(0);
            }

            if (quantity <= 0) {
                return "redirect:/product_detail.do?product_id=" + product_id;
            }

            if (product.getStock() < quantity) {
                return "redirect:/product_detail.do?product_id=" + product_id;
            }

            int itemPrice = basePrice;

            int originTotal = product.getPrice() * quantity;
            int itemAmount = itemPrice * quantity;
            int discountTotal = originTotal - itemAmount;

            totalOriginPrice += originTotal;
            totalDiscountPrice += discountTotal;
            totalItemPrice += itemAmount;

            Map<String, Object> item = new HashMap<>();
            item.put("product_id", product.getProduct_id());
            item.put("name", product.getName());
            item.put("image_l", product.getImage_l());
            item.put("price", product.getPrice());
            item.put("sale_price", product.getSale_price());
            item.put("item_price", itemPrice);
            item.put("quantity", quantity);
            item.put("origin_total", originTotal);
            item.put("item_total", itemAmount);
            item.put("discount_total", discountTotal);
            item.put("delivery_fee", product.getDelivery_fee());
            item.put("cart_id", 0);
            item.put("option_id", null);

            orderItemList.add(item);
        }

        int delivery_fee = product.getDelivery_fee();

        if (product.getFree_shipping() > 0 && totalItemPrice >= product.getFree_shipping()) {
            delivery_fee = 0;
        }

        int paymentPrice = totalItemPrice + delivery_fee - couponPrice;

        model.addAttribute("loginUser", loginUser);
        model.addAttribute("orderItemList", orderItemList);
        model.addAttribute("totalOriginPrice", totalOriginPrice);
        model.addAttribute("totalDiscountPrice", totalDiscountPrice);
        model.addAttribute("totalItemPrice", totalItemPrice);
        model.addAttribute("totalDeliveryFee", delivery_fee);
        model.addAttribute("paymentPrice", paymentPrice);
        model.addAttribute("couponPrice", couponPrice);

        int user_id = loginUser.getUser_id();
        List<AddressVO> list = addressDao.selectList(user_id);
        AddressVO defaultAddr = addressDao.selectDefault(user_id);

        model.addAttribute("list", list);
        model.addAttribute("defaultAddr", defaultAddr);

        return "order/order_form";
    }

    // 주문 생성 처리
    // 주문서 작성 → 결제 대기로 이동
    @PostMapping("/order/create")
    @Transactional
    public String createOrder(
            @RequestParam(value = "product_id", required = false) Integer product_id,
            @RequestParam(value = "quantity", required = false) List<Integer> quantityList,
            @RequestParam(value = "option_id", required = false) List<Integer> optionIdList,
            @RequestParam(value = "cart_id", required = false) int[] cart_id,
            HttpSession session) {
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

                Integer itemOptionId = null;

                if (item.get("option_id") != null) {
                    itemOptionId = ((Number) item.get("option_id")).intValue();
                }

                OrderItemVO itemVO = new OrderItemVO();
                itemVO.setOrder_id(orderVO.getOrder_id());
                itemVO.setOption_id(itemOptionId);
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

        int basePrice = getActiveProductPrice(product);

        int totalItemPrice = 0;

        List<OrderItemVO> directOrderItemList = new java.util.ArrayList<>();

        /*
            옵션 여러 개 바로구매
        */
        if (optionIdList != null && !optionIdList.isEmpty()) {

            if (quantityList == null || optionIdList.size() != quantityList.size()) {
                return "redirect:/product_detail.do?product_id=" + product_id;
            }

            for (int i = 0; i < optionIdList.size(); i++) {

                Integer option_id = optionIdList.get(i);
                Integer quantityObj = quantityList.get(i);

                if (option_id == null || quantityObj == null || quantityObj <= 0) {
                    return "redirect:/product_detail.do?product_id=" + product_id;
                }

                int quantity = quantityObj;

                OptionVO option = optiondao.selectOptionOne(option_id);

                if (option == null) {
                    return "redirect:/product_detail.do?product_id=" + product_id;
                }

                if (option.getProduct_id() != product_id) {
                    return "redirect:/product_detail.do?product_id=" + product_id;
                }

                if (option.getOption_stock() < quantity) {
                    return "redirect:/product_detail.do?product_id=" + product_id;
                }

                int price = basePrice + option.getOption_price();
                int itemAmount = price * quantity;

                totalItemPrice += itemAmount;

                OrderItemVO itemVO = new OrderItemVO();
                itemVO.setProduct_id(product_id);
                itemVO.setOption_id(option_id);
                itemVO.setPrice(price);
                itemVO.setQuantity(quantity);

                directOrderItemList.add(itemVO);
            }

        } else {

            /*
                옵션 없는 일반 상품 바로구매
            */
            int quantity = 1;

            if (quantityList != null && !quantityList.isEmpty() && quantityList.get(0) != null) {
                quantity = quantityList.get(0);
            }

            if (quantity <= 0) {
                return "redirect:/product_detail.do?product_id=" + product_id;
            }

            if (product.getStock() < quantity) {
                return "redirect:/product_detail.do?product_id=" + product_id;
            }

            int price = basePrice;
            int itemAmount = price * quantity;

            totalItemPrice += itemAmount;

            OrderItemVO itemVO = new OrderItemVO();
            itemVO.setProduct_id(product_id);
            itemVO.setOption_id(null);
            itemVO.setPrice(price);
            itemVO.setQuantity(quantity);

            directOrderItemList.add(itemVO);
        }

        int delivery_fee = product.getDelivery_fee();

        if (product.getFree_shipping() > 0 && totalItemPrice >= product.getFree_shipping()) {
            delivery_fee = 0;
        }

        int total_amount = totalItemPrice + delivery_fee - couponPrice;

        // 1. orders 테이블에 주문 기본 정보 저장
        OrderVO orderVO = new OrderVO();
        orderVO.setUser_id(user_id);
        orderVO.setTotal_amount(total_amount);
        orderVO.setAddress_id(address_id);
        orderVO.setStatus("PENDING");

        orderDAO.insertOrder(orderVO);

        // 2. order_items 테이블에 여러 옵션 저장
        for (OrderItemVO itemVO : directOrderItemList) {
            itemVO.setOrder_id(orderVO.getOrder_id());
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

        return "redirect:/payment/ready?order_id=" + orderVO.getOrder_id();
    }

    // 주문 완료 화면
    // 주소: /order/complete?order_id=1
    @GetMapping("/order/complete")
    public String orderComplete(
            @RequestParam("order_id") int order_id,
            Model model,
            HttpSession session) {
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
            HttpSession session) {
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
            HttpSession session) {
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
            HttpSession session) {
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
            HttpSession session) {
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

        List<AddressVO> list = addressDao.selectList(user_id);
        AddressVO defaultAddr = addressDao.selectDefault(user_id);

        model.addAttribute("list", list);
        model.addAttribute("defaultAddr", defaultAddr);

        return "order/order_form";
    }
}