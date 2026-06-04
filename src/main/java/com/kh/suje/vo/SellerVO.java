package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("seller")
public class SellerVO {

    private Long sellerId;           // seller_id : BIGINT (PK, AUTO_INCREMENT)
    private Long userId;             // user_id : BIGINT (FK, 연결된 회원 ID)
    private String companyName;      // company_name : VARCHAR(100) (상호명)
    private String businessNumber;   // business_number : VARCHAR(50) (사업자 등록번호)
    private String sellerStatus;     // seller_status : ENUM ('PENDING', 'APPROVED', 'REJECTED')
    private String createdAt;        // created_at : TIMESTAMP (판매자 신청 일시)

    private String representativeName; // representative_name : VARCHAR(100) (대표자명)
    private String openingDate;        // opening_date : DATE (사업자 개업일자)
    private String businessAddress;    // business_address : VARCHAR(255) (사업자 주소)

 
}
