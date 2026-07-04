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
                                      @Param("user_id") Integer user_id,
                                      @Param("size") Integer size,
                                      @Param("offset") int offset,
                                      @Param("gender") String gender,
                                      @Param("status") String status,
                                      @Param("startDate") String startDate,
                                      @Param("endDate") String endDate,
                                      @Param("sort") String sort); //키워드로 회원 검색

    int getUserListCountByKeyword(@Param("role") String role,
                                  @Param("keyword") String keyword,
                                  @Param("user_id") Integer user_id,
                                  @Param("gender") String gender,
                                  @Param("status") String status,
                                  @Param("startDate") String startDate,
                                  @Param("endDate") String endDate);

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

    int withdraw(int user_id); //회원 탈퇴하기



    UserVO kakaoLogin(String kakao_id); //카톡로그인

    UserVO naverLogin(String naver_id); //네이버로그인
    
    int updateUserStatus(@Param("user_id") int user_id, 
                         @Param("status") String status);
}
