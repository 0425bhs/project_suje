package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.OptionVO;

public interface OptionDAO {
    int insertOptionList(List<OptionVO> optionList);
    List<OptionVO> getOptionListByProductId(int product_id);
}
