package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("category")
public class CategoryVO {
    private int category_id;
    private String name;
    private Integer parent_id;//parent_id는 대분류일 때 NULL이라서 Integer
}
