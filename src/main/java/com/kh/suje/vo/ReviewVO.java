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
    private Long id;
    private Long userId;
    private Long productId;
    private Long orderItemId;
    private Integer rating;
    private String content;
    private LocalDateTime createdAt;
}
