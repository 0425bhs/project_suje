package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("notice")
public class NoticeVO {
    private int notice_id;
    private String title, content, created_at, updated_at;
}
