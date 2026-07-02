package com.kh.suje.vo.order;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("orderitemclaim")
public class OrderItemClaimVO {

    private int claim_id; // 교환/반품 요청 고유 ID
    private int order_item_id; // 요청 대상 주문 상세 항목 ID

    private String status; // 처리 상태 (EXCHANGE_REQUEST, EXCHANGE_DONE, RETURN_REQUEST, RETURN_DONE)
    private String reason; // 요청 사유
    private String seller_answer; // 판매자 답변 내용

    private String requested_at; // 교환/반품 요청 일시
    private String completed_at; // 교환/반품 완료 일시

    private String created_at; // 데이터 생성 일시
    private String updated_at; // 데이터 수정 일시

    // 화면 출력용 JOIN 데이터
    private String productName; // products.name
    private String imageL; // products.image_l
    private int price; // order_items.price
    private int quantity; // order_items.quantity

}