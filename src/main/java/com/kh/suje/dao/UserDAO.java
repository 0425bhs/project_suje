package com.kh.suje.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.kh.suje.vo.UserVO;

public interface UserDAO {
    List<UserVO> getUserList(); //전체 회원 정보 가져오기
    // List<UserVO> getUserListByRole(String role); //특정 권한 회원 정보 가져오기
    List<UserVO> getUserListByKeyword(@Param("role") String role,
                                      @Param("keyword") String keyword,
                                      @Param("size") Integer size,
                                      @Param("offset") int offset); //키워드로 회원 검색

    int getUserListCountByKeyword(@Param("role") String role,
                                  @Param("keyword") String keyword);

    int insertUser(UserVO vo); //회원가입

    UserVO userNickCheck(String nick_name); //닉네임 중복체크

    UserVO userLoginIdCheck(String login_id); //아이디 중복체크

    UserVO mailDuplicateCheck(String email); //메일 중복체크

    UserVO loginCheck(UserVO vo); //아이디로그인

    UserVO findLoginId(UserVO vo); //아이디찾기

    UserVO findPwd(UserVO vo); //패스워드찾기

    int updatePwd(Map<String, Object> paramMap);//임시비번으로 비번변경

    UserVO selectUser(int user_id); //내정보 갖고오기

    int userModify(UserVO vo); //내 정보 수정하기

    int updateSeller(int user_id); // 일반=>판매자 신청



    UserVO kakaoLogin(String kakao_id); //카톡로그인

    UserVO naverLogin(String naver_id); //네이버로그인
    
}
