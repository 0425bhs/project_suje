package com.kh.suje.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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


    //회원가입 첫화면으로
    @GetMapping("/join.do" )
    public String joinSelect() {
        return "user/join_select"; 
    }

    //회원가입폼 화면으로
    @GetMapping("/joinForm.do" )
    public String joinForm(@RequestParam String role, Model model) {
        model.addAttribute("role", role);
        return "user/join"; 
    }


      // 닉네임 중복체크
    @PostMapping("/checkNick.do")
    @ResponseBody
    public Map<String, String> nickCheck(String nick_name) {

        UserVO vo = userDao.userNickCheck(nick_name);
        String res = "no";

        // 사용이 가능한 상태
        if (vo == null) {
            res = "yes";
        }

        Map<String, String> map = new HashMap<>();
        map.put("result", res);
        map.put("nick_name", nick_name);

        return map;

    }


          // 아이디 중복체크
    @PostMapping("/checkLoginId.do")
    @ResponseBody
    public Map<String, String> userLoginIdCheck(String login_id) {

        UserVO vo = userDao.userLoginIdCheck(login_id);
        String res = "no";

        // 사용이 가능한 상태
        if (vo == null) {
            res = "yes";
        }

        Map<String, String> map = new HashMap<>();
        map.put("result", res);
        map.put("login_id", login_id);

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
    public String join(UserVO vo) throws Exception {
      
        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd);

    String savePath = "c:" + File.separator + "upload" + File.separator;

        //저장경로가 없다면 생성
        File dir = new File(savePath);
        if( !dir.exists() ){
            dir.mkdirs();
        }

        MultipartFile photo = vo.getPhoto();
        String photo_name = "no_file";

        //업로드할 파일 선택여부 확인
        if( photo != null && !photo.isEmpty() ){

            photo_name = photo.getOriginalFilename();
            File saveFile = new File( savePath, photo_name );

            //파일명 중복 방지
            if( saveFile.exists() ){
                long time = System.currentTimeMillis();
                photo_name = String.format("%d_%s", time, photo_name);
                saveFile = new File(savePath, photo_name);
            }

            photo.transferTo(saveFile);
            
        }//if

        vo.setPhoto_name(photo_name);
        int res = userDao.insertUser(vo);        
        
        return "redirect:/login.do";
    }
    
 //사업자회원 가입
 @Transactional
  @PostMapping("/joinSeller.do")
    public String joinSeller(UserVO vo, SellerVO svo) throws Exception {

        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd);
        String savePath = "c:" + File.separator + "upload" + File.separator;

        //저장경로가 없다면 생성
        File dir = new File(savePath);
        if( !dir.exists() ){
            dir.mkdirs();
        }

        MultipartFile photo = vo.getPhoto();
        String photo_name = "no_file";

        //업로드할 파일 선택여부 확인
        if( photo != null && !photo.isEmpty() ){

            photo_name = photo.getOriginalFilename();
            File saveFile = new File( savePath, photo_name );

            //파일명 중복 방지
            if( saveFile.exists() ){
                long time = System.currentTimeMillis();
                photo_name = String.format("%d_%s", time, photo_name);
                saveFile = new File(savePath, photo_name);
            }

            photo.transferTo(saveFile);
            
        }//if

        vo.setPhoto_name(photo_name);
        int result = userDao.insertUser(vo); 

        svo.setUser_id(vo.getUser_id());

        int resultS = sellerDao.insertSeller(svo); 
        
        
        return "redirect:/login.do";
    }


//아이디로그인
    @PostMapping("/idLogin.do")
    @ResponseBody
    public Map<String, Object> idLogin( UserVO vo ){

        UserVO user = userDao.loginCheck( vo);
        boolean isValid = false;

        //비밀번호 확인
        if( user != null && user.getLogin_id() != null ){
        isValid = pwdSecurity.pwdDecoding( vo.getPassword(), user.getPassword() );
    }

        String param = "noLoginId";
        int user_id = 0;

       if( user == null || user.getLogin_id() == null ){ //아이디가 존재하지 않을 때
            param = "noLoginId";
        }else if( !isValid ){ //아이디는 있으나 비밀번호 불일치
            param = "noPassword";
        }else{
            //로그인이 가능한 상태
            param = "clear";
            user_id = user.getUser_id();

            //세션에 user객체를 저장
            session.setAttribute("user", user);
        }

        //콜백으로 결과 반환
        Map<String, Object> map = new HashMap<>();
        map.put("param", param);
        map.put("user_id", user_id);

       return map; 
    }    



    //이메일, 비번찾기
    @GetMapping("/findInfo.do")
    public String findInfo( @RequestParam String type, Model model) {
    
    model.addAttribute("type", type);
    
    return "user/findInfo";
}

/*
 @PostMapping("/findEmail.do")
  @ResponseBody
    public Map<String, Object> findEmail( UserVO vo) {
  
        UserVO user = userDao.findEmail(vo);

        String param = "no";
        String user_email = "";

       if( user == null ){ //존재하지 않을 때
            param = "no";
        }else{
            //메일 찾은 상태
            param = "clear";
            user_email = user.getEmail();       
        }

        //콜백으로 결과 반환
        Map<String, Object> map = new HashMap<>();
        map.put("param", param);
        map.put("user_email", user_email);

       return map; 
}

 */


//아이디 찾기
 @PostMapping("/findLoginId.do")
  @ResponseBody
    public Map<String, Object> findLoginId( UserVO vo) {
  
        UserVO user = userDao.findLoginId(vo);

        String param = "no";
        String login_id = "";

       if( user == null ){ //존재하지 않을 때
            param = "no";
        }else{
            //아이디 찾은 상태
            param = "clear";
            login_id = user.getLogin_id();       
        }

        //콜백으로 결과 반환
        Map<String, Object> map = new HashMap<>();
        map.put("param", param);
        map.put("login_id", login_id);

       return map; 
}


@PostMapping("/phoneMailCheck.do")
  @ResponseBody
    public Map<String, Object> findPassword( UserVO vo) {
  
        UserVO user = userDao.findPwd(vo);
        
        String param = "no";

      if( user == null ){
    param = "no"; // 일치하는 정보 없음
}else{
    param = "clear"; // 일치
}
        //콜백으로 결과 반환
        Map<String, Object> map = new HashMap<>();
        map.put("param", param);
        map.put("user", user );

       return map; 
}



// 임시비번발송
@PostMapping("/newPwdSend.do")
  @ResponseBody
    
  
  //newPassword(String email, Integer user_id)로 변경 권장
    public Map<String, Object> newPassword(String email, int user_id) {

        String newPwd = mss.newPwdEmail(email);

       newPwd = pwdSecurity.pwdEncoding(newPwd);

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("newPwd", newPwd);
        paramMap.put("user_id", user_id);

        int res = userDao.updatePwd(paramMap);

        Map<String, Object> map = new HashMap<>();
        map.put("res", res);

        return map;

    }

    
    //일반회원 정보수정폼으로
    @GetMapping("/user_modify.do")
    public String user_modifyForm( Model model, HttpSession session) {

       //로그인한 사람의 정보 꺼내기
    UserVO sessionUser = (UserVO) session.getAttribute("user");
    
    //로그인 안 된 상태면 로그인 페이지로
    if (sessionUser == null) {
        return "redirect:/login.do";
    }
    
    //로그인된 유저의 id로 DB 조회
    UserVO vo = userDao.selectUser(sessionUser.getUser_id());
    
    //JSP 화면
    model.addAttribute("user", vo);
    
    return "user/user_edit";
}
 
    //일반회원 정보수정
    @PostMapping("/user_modify.do")
    @ResponseBody
    public Map<String, Integer> user_modify( UserVO vo, String ori_photo_name, String del_photo_name ) throws Exception {

        if(vo.getPassword()!=null && !vo.getPassword().trim().isEmpty() ){
        //수정에 사용한 비밀번호 암호화
        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd); 
        } else {
            // 새 비밀번호를 입력하지 않은 경우 기존 비밀번호 유지
            UserVO currentInfo = userDao.selectUser(vo.getUser_id());
            vo.setPassword(currentInfo.getPassword());
        }

        //이미지 저장 폴더
        String savePath = "c:" + File.separator + "upload" + File.separator;

        File dir = new File(savePath); 
        if( !dir.exists() ){
            dir.mkdirs();
        }
        //파일정보
        MultipartFile photo = vo.getPhoto();
        String photo_name = "no_file";

        //1.업로드 된 파일이 존재하는 경우(새 이미지로 교체)
        if (photo != null && !photo.isEmpty()){
            photo_name = photo.getOriginalFilename();
            File saveFile = new File(savePath, photo_name);
            if( saveFile.exists() ){ 
                long time = System.currentTimeMillis();
                photo_name = String.format("%d_%s", time, photo_name);
                saveFile = new File(savePath, photo_name);                
            }

            photo.transferTo(saveFile); //저장

        }else if( !ori_photo_name.equals("no_file") ){
            //2.기존이미지 그대로 사용
            photo_name = ori_photo_name;
        }
        //3.프로필 이미지를 쓰지 않는다
        vo.setPhoto_name(photo_name);
        
        int res = userDao.userModify( vo );

        //업데이트 후 필요없어진 이미지가 있다면 삭제
        if( res == 1 ){
            File del_photo = new File(savePath, del_photo_name);

            //새로운 사진이 등록되었거나 사진을 등록하지 않은 경우
            if ( (photo != null && !photo.isEmpty()) || ori_photo_name.equals("no_file") ){
                if( del_photo.exists() ){ 
                    del_photo.delete(); 
                }
            }
            
        }//if

        Map<String, Integer> map = new HashMap<>();
        map.put("result", res);
        map.put("user_id", vo.getUser_id());

        return map;
    }


    
@PostMapping("/check_currPassword.do")
    @ResponseBody
    public Map<String, Object> checkCurrentPassword( String ori_password, HttpSession session ){

        
        Map<String, Object> map = new HashMap<>();
boolean isValid = false;

UserVO sessionUser = (UserVO) session.getAttribute("user");

if (sessionUser != null && ori_password != null) {
 
    UserVO dbUser = userDao.selectUser(sessionUser.getUser_id()); 
    
    if(dbUser != null) {
        // DB에 있는 최신 암호화 비밀번호와 유저의 입력값을 비교하므로 100% 정확합니다.
        isValid = pwdSecurity.pwdDecoding(ori_password, dbUser.getPassword());

    }
    map.put("isValid", isValid);
   
}
 return map;
    }

     //사업자회원 가입
 @Transactional
  @PostMapping("/addSeller.do")
    public String addSeller(UserVO vo, SellerVO svo) {

        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd);
      
        int result = userDao.insertUser(vo); 

        svo.setUser_id(vo.getUser_id());

        int resultS = sellerDao.insertSeller(svo); 
        
        
        return "redirect:/login.do";
    }


   @GetMapping("/user_mypage.do")
    public String user_mypage( Model model, HttpSession session) {

       //로그인한 사람의 정보 꺼내기
    UserVO sessionUser = (UserVO) session.getAttribute("user");
    
    //로그인 안 된 상태면 로그인 페이지로
    if (sessionUser == null) {
        return "redirect:/login.do";
    }
    
    //로그인된 유저의 id로 DB 조회
    UserVO vo = userDao.selectUser(sessionUser.getUser_id());
    
    //JSP 화면
    model.addAttribute("user", vo);
    
    return "user/mypage";
}



 //로그아웃
    @GetMapping("/logout.do")
    public String logout(){
        session.invalidate();
         return "redirect:/login.do";}



}