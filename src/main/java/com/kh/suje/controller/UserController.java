package com.kh.suje.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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


    //회원가입 화면으로
    @GetMapping(value = { "/join.do" })
    public String joinForm() {
        return "user/join"; 
    }



      // 아이디 중복체크
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

        //저장경로 지정 - 윈도우는 C:\Users\사용자이름\, 맥은 /Users/사용자이름/
String userHome = System.getProperty("user.home");
String savePath = userHome + File.separator + "suje_upload" + File.separator;

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
        
        return "redirect:/";
    }
    
 //사업자회원 가입
 @Transactional
  @PostMapping("/joinSeller.do")
    public String joinSeller(UserVO vo, SellerVO svo) {

        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd);
      
        int result = userDao.insertUser(vo); 

        svo.setUser_id(vo.getUser_id());

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
        int user_id = 0;

       if( user == null || user.getEmail() == null ){ //이메일이 존재하지 않을 때
            param = "noEmail";
        }else if( !isValid ){ //이메일은 있으나 비밀번호 불일치
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
 
    
    //일반회원 정보수정폼으로
    @GetMapping("/user_modify.do")
    public String user_modifyForm( Model model, int user_id) {

        UserVO vo = userDao.selectUser( user_id );

        model.addAttribute("user",vo);

        return "user/user_edit";
    }
 
    //일반회원 정보수정
    @PostMapping("/user_modify.do")
    @ResponseBody
    public Map<String, Integer> user_modify( UserVO vo, String ori_photo_name, String del_photo_name ) throws Exception {

        if(vo.getPassword()!=null && vo.getPassword().trim().isEmpty() ){
        //수정에 사용한 비밀번호 암호화
        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd); 
        } else {
            // 새 비밀번호를 입력하지 않은 경우 기존 비밀번호 유지
            UserVO currentInfo = userDao.selectUser(vo.getUser_id());
            vo.setPassword(currentInfo.getPassword());
        }

        //이미지 저장 폴더
        String userHome = System.getProperty("user.home");
        String savePath = userHome + File.separator + "suje_upload" + File.separator;

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
        
        int res = userDao.user_modify( vo );

        //업데이트 후 필요없어진 이미지가 있다면 삭제
        if( res == 1 ){
            File del_photo = new File(savePath, del_photo_name);

            //새로운 사진이 등록되었거나 사진을 등록하지 않은 경우
            if( !photo.isEmpty() || ori_photo_name.equals("no_file") ){
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


    



}