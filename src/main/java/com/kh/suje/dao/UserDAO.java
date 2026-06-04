package com.kh.suje.dao;

import com.kh.suje.vo.UserVO;

public interface UserDAO {

    int insertUser( UserVO vo); //회원가입

    UserVO userNickCheck(String id); //중복체크

    UserVO LoginCheck(String email); //로그인
    
}
