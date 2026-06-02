package com.kh.suje.vo;

import java.time.LocalDateTime;

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
    private LocalDateTime created_at;

    //product_id    
    private String product_name, image_s;
}
