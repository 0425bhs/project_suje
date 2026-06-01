package com.kh.suje.vo;

import java.time.LocalDateTime;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("qna")
public class QnaVO {
    private int qnaId, userId, productId;
    private String title, content, answer, status;
    private LocalDateTime createdAt, answeredAt;
}
