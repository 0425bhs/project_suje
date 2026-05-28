package com.kh.suje.vo;

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

    // 화면 출력용 JOIN 데이터
    private String productName;  // products.name
    private String imageS;       // products.image_s
    private int subtotalAmount;  // price * quantity

}
