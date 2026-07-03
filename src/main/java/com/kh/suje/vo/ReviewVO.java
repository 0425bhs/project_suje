package com.kh.suje.vo;

import java.util.List;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("review")
public class ReviewVO {
    private int review_id, user_id, product_id, order_item_id;
    private Integer rating;
    private String content;
    private String created_at;
    private String status;

    //user_id
    private String user_name, nick_name;
    
    //product_id    
    private String product_name, image_l;

    private List<ImageVO> imageList;

    private String created_at_text;//화면 표시용

    private String photo_name;   // 회원 프로필 사진
    private String option_name;  // 주문 옵션명

    private String reply_content;
    private String reply_created_at;
    private String reply_created_at_text;

    private int report_count;
    private String order_status;
    private String order_created_at;
}
