package com.kh.suje.dao;

import org.apache.ibatis.annotations.Mapper;

import com.kh.suje.vo.payment.PaymentVO;

@Mapper
public interface PaymentDAO {
    
    //주문번호로 결제 정보 조회
    PaymentVO selectPaymentByOrderId(long orderId);

    //결제 대기
    int insertPayment(PaymentVO vo);

    //결제 성공
    int updatePaymentSuccess(PaymentVO vo);

    //결제 실패
    int updatePaymentFail(PaymentVO vo);
    
}
