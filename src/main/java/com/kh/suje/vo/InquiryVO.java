package com.kh.suje.vo;

import java.time.LocalDateTime;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("inquiry")
public class InquiryVO {
    private int inquiry_id, user_id;
    private String inquiry_type, title, content, answer, status;
    private LocalDateTime created_at, answered_at;

    //user_id
    private String user_name;
}
