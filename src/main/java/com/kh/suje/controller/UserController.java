package com.kh.suje.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.common.MailSendService;
import com.kh.suje.common.PwdSecurity;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.SellerVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;


@Controller
@RequiredArgsConstructor
public class UserController {

   
    private final HttpSession session;
    private final UserDAO userDao;
    private final SellerDAO sellerDao;
    private final PwdSecurity pwdSecurity;
    private final MailSendService mss;

    //첫페이지
    @GetMapping("/login.do")
    public String loginForm() {
        return "user/login"; 
    }


    //회원가입 화면으로
    @GetMapping(value = { "/join.do" })
    public String joinForm() {
        return "user/join"; 
    }



      // 아이디 중복체크
    @PostMapping("/checkNick.do")
    @ResponseBody
    public Map<String, String> nickCheck(String nickName) {

        UserVO vo = userDao.userNickCheck(nickName);
        String res = "no";

        // 사용이 가능한 상태
        if (vo == null) {
            res = "yes";
        }

        Map<String, String> map = new HashMap<>();
        map.put("result", res);
        map.put("nickName", nickName);

        return map;

    }

    // 메일인증
    @PostMapping("/mailCheck.do")
    @ResponseBody
    public Map<String, String> mailCheck(String email) {

        String res = mss.joinEmail(email);

        Map<String, String> map = new HashMap<>();
        map.put("authNumber", res);

        return map;

    }



    //일반회원 가입
    @PostMapping("/join.do")
    public String join(UserVO vo) {
      
        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd);
        
        int result = userDao.insertUser(vo); 
        
        
        return "redirect:/";
    }
    
 //사업자회원 가입
 @Transactional
  @PostMapping("/joinSeller.do")
    public String joinSeller(UserVO vo, SellerVO svo) {

        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd);
      
        int result = userDao.insertUser(vo); 

        svo.setUserId(vo.getUserId());

        int resultS = sellerDao.insertSeller(svo); 
        
        
        return "redirect:/";
    }


//로그인
    @PostMapping("/login.do")
    @ResponseBody
    public Map<String, Object> login( UserVO vo ){

        UserVO user = userDao.LoginCheck( vo.getEmail() );
        boolean isValid = false;

        //비밀번호 확인
        if( user != null && user.getEmail() != null ){
        isValid = pwdSecurity.pwdDecoding( vo.getPassword(), user.getPassword() );
    }

        String param = "noEmail";
        Long userId = (long) 0;

       if( user == null || user.getEmail() == null ){ //이메일이 존재하지 않을 때
            param = "noEmail";
        }else if( !isValid ){ //이메일은 있으나 비밀번호 불일치
            param = "noPassword";
        }else{
            //로그인이 가능한 상태
            param = "clear";
            userId = user.getUserId();

            //세션에 user객체를 저장
            session.setAttribute("user", user);
        }

        //콜백으로 결과 반환
        Map<String, Object> map = new HashMap<>();
        map.put("param", param);
        map.put("userId", userId);

       return map; 
    }    
    
    
}