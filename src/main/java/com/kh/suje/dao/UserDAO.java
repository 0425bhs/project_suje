package com.kh.suje.dao;

import com.kh.suje.vo.UserVO;

public interface UserDAO {

    int insertUser( UserVO vo); //회원가입

    UserVO userNickCheck(String id); //중복체크

    UserVO LoginCheck(String email); //로그인

    UserVO selectUser( int user_id); //내정보 갖고오기

    int user_modify(UserVO vo); //내 정보 수정하기

    
}
