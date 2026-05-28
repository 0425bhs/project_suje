package com.kh.suje.vo;

import lombok.Data;

@Data
public class PaymentVO {
    
    private long payment_id; //결제번호
    private long order_id; 
    private String payment_method; //결제 수단
    private int amount; //금액
    private String status; //결제상태
    private String transaction_id; //API
    private String created_at; //결제 데이터 생성 시간

}
