package com.kh.suje.dto;

import com.kh.suje.vo.SellerVO;
import com.kh.suje.vo.UserVO;
import lombok.Data;

@Data
public class UserDTO {
    private UserVO user;
    private SellerVO seller;
}