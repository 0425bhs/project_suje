package com.kh.suje.vo.order;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("order")
public class OrderVO {
    
    private int order_id; // 주문 번호
    private int user_id; // 주문한 회원 번호
    private int total_amount; // 주문 전체 금액
    private int address_id; // 배송지 번호
    private String status; // 주문 상태
    private String created_at; // 주문 생성일
    private String updated_at; // 주문 수정일 / 주문 상태 변경일

    // 취소 사유
    private String cancel_reason;

    // 취소 일시
    private String cancelled_at;

    //유저 포인트
    private int used_point;
    //판매자 주문 관리
    private String receiver_name;
    private String receiver_phone;
    private String delivery_address;

}
