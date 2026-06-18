package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.AddressVO;


public interface AddressDAO {

    //int insertAddress( AddressVO vo); //회원가입

    List<AddressVO> selectList( int user_id); //배송지조회
    
}
