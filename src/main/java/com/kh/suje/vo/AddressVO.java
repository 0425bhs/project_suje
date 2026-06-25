package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("address")
public class AddressVO {

    private int address_id, user_id;
    private String address_name;
    private String recipient_name;
    private String phone;
    private String zipcode;
    private String address;
    private String detail_address;
    private String is_default;
    
}
