package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("memo")
public class AdminMemoVO {
    private int memo_id, target_id;
    private Integer admin_id;
    private String target_type, content, created_at, updated_at;

    // admin_id(user_id)
    private String admin_name;
}
