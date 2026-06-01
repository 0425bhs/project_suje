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

    private int seller_id,user_id;
    private String company_name,business_number,status,created_at;

}
