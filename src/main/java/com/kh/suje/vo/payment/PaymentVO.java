package com.kh.suje.vo.payment;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("payment")
public class PaymentVO {
    
    private int payment_id; //결제번호
    private int order_id; 
    private String payment_method; //결제 수단
    private int amount; //금액
    private String status; //결제상태
    private String transaction_id; //API
    private String created_at; //결제 데이터 생성 시간

}
