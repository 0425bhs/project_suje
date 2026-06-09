package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;
import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("user")
public class UserVO {

    private int user_id; // BIGINT (PK)
    private String email; // VARCHAR(255)
    private String password; // VARCHAR(255)
    private String name; // VARCHAR(100)
    private String phone; // VARCHAR(20)
    private String gender; // ENUM('male', 'female')
    private String role; // ENUM('USER', 'SELLER', 'ADMIN')
    private String created_at; // TIMESTAMP
    private String updated_at; // TIMESTAMP

    private String nick_name; // nick_name VARCHAR(255), Not null

    private MultipartFile photo;
    private String photo_name;
}
