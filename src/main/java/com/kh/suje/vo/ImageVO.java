package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("image")
public class ImageVO {
    private int image_id, target_id, sort_order;
    private String target_type, image_url, original_name, created_at;
}
