package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("option")
public class OptionVO {
    private int option_id;
    private int product_id;

    private String option_name;

    private int option_price;
    private int option_stock;

    private String created_at;
}
