package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.OptionVO;

public interface OptionDAO {

    int insertOptionList(@Param("optionList") List<OptionVO> optionList);

    List<OptionVO> getOptionListByProductId(int product_id);
    
    int deleteOptionsByProductId(int product_id);

}
