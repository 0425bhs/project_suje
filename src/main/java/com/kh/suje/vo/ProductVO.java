package com.kh.suje.vo;

import java.util.List;

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

    private String name,description,status,image_l,created_at,updated_at,sale_price_updated_at;

    private MultipartFile image_l_file;
    private List<MultipartFile> image_s_file;
    private List<ImageVO> imageList;
    
    private int price,sale_price,stock,delivery_fee,free_shipping;

    private String company_name;

    private float review_avg;
    private int review_count;

    //할인 기간 설정
    private String sale_start_at;
    private String sale_end_at;

    //할인 설정 구분값
    private String sale_discount_type;

    //옵션
    private List<OptionVO> optionList;

    // 상품 상세에서 리뷰 목록 담을 때 사용
    private List<ReviewVO> review_list;

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

}
