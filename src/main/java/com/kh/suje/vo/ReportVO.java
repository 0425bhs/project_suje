package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("report")
public class ReportVO {
    private int report_id, reporter_id;
    private String target_type;
    private int target_id;
    private String report_type,reason, status, created_at;

    //reporter_id(user_id)
    private String reporter_name;
}
