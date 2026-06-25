package com.kh.suje.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.OptionVO;

@Mapper
public interface OptionDAO {

    int insertOptionList(@Param("optionList") List<OptionVO> optionList);

    List<OptionVO> getOptionListByProductId(int product_id);
    
    int deleteOptionsByProductId(int product_id);

    List<OptionVO> selectOptionList(int product_id);

    OptionVO selectOptionOne(int option_id);

    int insertOption(OptionVO vo);

    int updateOptionStock(OptionVO vo);

}
