package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("qna")
public class QnaVO {
    private int qna_id, user_id, product_id;
    private String title, content, answer, status, created_at, answered_at;

    //product_id
    private String product_name, image_l;

    private String user_name;
    private String nick_name;
    private String created_at_text;
    private String option_name;
    private String qna_type;
    private int is_private;
}
