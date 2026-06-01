package com.kh.suje.vo;

import java.time.LocalDateTime;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("report")
public class ReportVO {
    private int id, reporterId;
    private String targetType;
    private int targetId;
    private String reason, status;
    private LocalDateTime createdAt;
}
