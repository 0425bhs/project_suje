package com.kh.suje.vo;

import java.time.LocalDateTime;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("favorite")
public class FavoriteVO {
    private int favorite_id, user_id, seller_id;
    private LocalDateTime created_at;
}
