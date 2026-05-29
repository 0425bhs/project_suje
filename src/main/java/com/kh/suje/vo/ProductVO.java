package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;
import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("product")
public class ProductVO {
    private int product_id,seller_id,category_id;

    private String name,description,status,image_l,image_s,created_at,updated_at;

    private MultipartFile image_l_file,image_s_file;
    
    private int price,sale_price,stock,delivery_fee,free_shipping;

    public int getSale_rate() {

        if (price == 0) {
            return 0;
        }

        if (sale_price == 0) {
            return 0;
        }

        if (sale_price >= price) {
            return 0;
        }

        int rate = (int)((price - sale_price)/(float) price * 100);

        return rate;
    }

    private int free_shipping;

}
