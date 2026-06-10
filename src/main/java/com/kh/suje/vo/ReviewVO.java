package com.kh.suje.vo;

import java.time.LocalDateTime;
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
    private LocalDateTime created_at;

    //user_id
    private String user_name, nick_name;
    
    //product_id    
    private String product_name, image_s, image_l;

    private List<ImageVO> imageList;
}
