package com.kh.suje.vo.order;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("orderitem")
public class OrderItemVO {

    private int order_item_id; // 주문 상품 번호
    private int order_id; // 주문 번호
    private int product_id; // 상품 번호
    private int price; // 주문 당시 상품 1개 가격
    private int quantity; // 주문 수량

    // 주문 상품별 상태
    private String status; // 상품별 주문 상태
    private String confirmed_at; // 구매확정 일시
    private String updated_at; // 상태 변경 일시

    // 화면 출력용 JOIN 데이터
    private String productName; // products.name
    private String imageL; // products.image_l
    private int subtotalAmount; // price * quantity

    //옵션
    private Integer option_id;
    private String optionName;
    private int optionPrice;
 
    // private String option_name;
    // private int option_price;

}
