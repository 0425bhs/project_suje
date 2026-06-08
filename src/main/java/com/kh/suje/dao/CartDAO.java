package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import com.kh.suje.vo.CartVO;

public interface CartDAO {
    List<Map<String, Object>> cartList(int user_id);

    int cartCheck(CartVO vo);

    int cartInsert(CartVO vo);

    int cartQuantityPlus(CartVO vo);
}
