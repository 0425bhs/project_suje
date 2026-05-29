package com.kh.suje.vo.order;

import lombok.Data;

@Data
public class OrderVO {
    
    private Long order_id; // 주문 번호
    private Long user_id; // 주문한 회원 번호
    private int total_amount; // 주문 전체 금액
    private Long address_id; // 배송지 번호
    private String status; // 주문 상태
    private String created_at; // 주문 생성일
    private String updated_at; // 주문 수정일 / 주문 상태 변경일

}
