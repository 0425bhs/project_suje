package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("user")
public class UserVO {

    private Long userId;        // BIGINT (PK)
    private String email;       // VARCHAR(255)
    private String password;    // VARCHAR(255)
    private String name;        // VARCHAR(100)
    private String phone;       // VARCHAR(20)
    private String gender;      // ENUM('male', 'female')
    private String role;        // ENUM('USER', 'SELLER', 'ADMIN')
    private String createdAt; // TIMESTAMP
    private String updatedAt; // TIMESTAMP

    private String nickName;   //nick_name VARCHAR(255), Not null
    
}
