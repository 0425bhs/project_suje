package com.kh.suje.dao;

import java.util.List;

import com.kh.suje.vo.AddressVO;


public interface AddressDAO {

    int insertAddress(AddressVO vo); //배송지 추가

    List<AddressVO> selectList( int user_id); //배송지 목록조회

    AddressVO selectDefault(int user_id); //기본 배송지 조회

    AddressVO selectOne( int address_id); //address_id로 조회

    int deleteDefault(int user_id); //기존의 기본배송지 삭제

    int deleteAddress(int address_id);  //배송지 삭제

    int modifyAddress(AddressVO vo); //배송지 수정
    

    
}
