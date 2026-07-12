package com.kh.suje.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.kh.suje.dto.UserDTO;

import org.springframework.beans.factory.annotation.Value;
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
import com.kh.suje.dao.OrderDAO;
import com.kh.suje.dao.SellerDAO;
import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.SellerVO;
import com.kh.suje.vo.UserVO;
import com.kh.suje.vo.order.OrderVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final HttpSession session;
    private final UserDAO userDao;
    private final SellerDAO sellerDao;
    private final OrderDAO orderDao;
    private final PwdSecurity pwdSecurity;
    private final MailSendService mss;

    @Value("${file.upload.path}")
    private String uploadPath;

    // 첫페이지
    @GetMapping("/login.do")
    public String loginForm() {
        return "user/login";
    }

    // 회원가입 첫화면으로
    @GetMapping("/join.do")
    public String joinSelect() {
        return "user/join_select";
    }

    // 회원가입폼 화면으로
    @GetMapping("/joinForm.do")
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

    // 메일중복체크
    @PostMapping("/checkMailDuplicate.do")
    @ResponseBody
    public Map<String, String> mailDuplicateCheck(String email) {

        UserVO vo = userDao.mailDuplicateCheck(email);
        String res = "no";

        // 사용이 가능한 상태
        if (vo == null) {
            res = "yes";
        }

        Map<String, String> map = new HashMap<>();
        map.put("result", res);
        map.put("email", email);

        return map;
    }

    // 메일인증
    @PostMapping("/mailCheck.do")
    @ResponseBody
    public Map<String, String> mailCheck(String email) {

        UserVO vo = userDao.mailDuplicateCheck(email);
        String res = "no";
        String authNumber = "";

        // 사용이 가능한 상태
        if (vo == null) {
            res = "yes";
            authNumber = mss.joinEmail(email);
        }

        Map<String, String> map = new HashMap<>();
        map.put("res", res);
        map.put("authNumber", authNumber);

        return map;

    }

    // 일반회원 가입
    @PostMapping("/join.do")
    public String join(UserVO vo) throws Exception {

        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd);

        String kakao_id = (String) session.getAttribute("kakao_id");
        if (kakao_id != null) {
            vo.setKakao_id(kakao_id);
            session.removeAttribute("kakao_id");
            session.removeAttribute("kakao_nickname");

        }

        String naver_id = (String) session.getAttribute("naver_id");
        if (naver_id != null) {
            vo.setNaver_id(naver_id);
            session.removeAttribute("naver_id");
            session.removeAttribute("naver_name");
            session.removeAttribute("naver_email");
            session.removeAttribute("naver_nickname");
            session.removeAttribute("naver_gender");
            session.removeAttribute("naver_mobile");
            session.removeAttribute("naver_photo");
        }

        String savePath = uploadPath + File.separator;

        // 저장경로가 없다면 생성
        File dir = new File(savePath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        MultipartFile photo = vo.getPhoto();
        String photo_name = "no_file";

        // 업로드할 파일 선택여부 확인
        if (photo != null && !photo.isEmpty()) {

            photo_name = photo.getOriginalFilename();
            File saveFile = new File(savePath, photo_name);

            // 파일명 중복 방지
            if (saveFile.exists()) {
                long time = System.currentTimeMillis();
                photo_name = String.format("%d_%s", time, photo_name);
                saveFile = new File(savePath, photo_name);
            }

            photo.transferTo(saveFile);

        } // if

        vo.setPhoto_name(photo_name);
        int res = userDao.insertUser(vo);

        return "redirect:/login.do";
    }

    // 사업자회원 가입
    @Transactional
    @PostMapping("/joinSeller.do")
    public String joinSeller(UserVO vo, SellerVO svo) throws Exception {

        String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
        vo.setPassword(securePwd);
        String savePath = uploadPath + File.separator;

        // 저장경로가 없다면 생성
        File dir = new File(savePath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        MultipartFile photo = vo.getPhoto();
        String photo_name = "no_file";

        // 업로드할 파일 선택여부 확인
        if (photo != null && !photo.isEmpty()) {

            photo_name = photo.getOriginalFilename();
            File saveFile = new File(savePath, photo_name);

            // 파일명 중복 방지
            if (saveFile.exists()) {
                long time = System.currentTimeMillis();
                photo_name = String.format("%d_%s", time, photo_name);
                saveFile = new File(savePath, photo_name);
            }

            photo.transferTo(saveFile);

        } // if

        vo.setPhoto_name(photo_name);
        int result = userDao.insertUser(vo);

        svo.setUser_id(vo.getUser_id());

        int resultS = sellerDao.insertSeller(svo);

        return "redirect:/login.do";
    }

    // 아이디로그인
    @PostMapping("/idLogin.do")
    @ResponseBody
    public Map<String, Object> idLogin(UserVO vo) {

        UserVO user = userDao.loginCheck(vo);
        boolean isValid = false;

        // 비밀번호 확인
        if (user != null && user.getLogin_id() != null) {
            isValid = pwdSecurity.pwdDecoding(vo.getPassword(), user.getPassword());
        }

        String param = "noLoginId";
        int user_id = 0;

        if (user == null || user.getLogin_id() == null) { // 아이디가 존재하지 않을 때
            param = "noLoginId";
        } else if ("suspended".equals(user.getStatus())) { // 정지된 아이디
            param = "suspendedId";    
        } else if ("withdrawn".equals(user.getStatus())) { // 탈퇴한 아이디
            param = "withdrawnId";    
        } else if (!isValid) { // 아이디는 있으나 비밀번호 불일치
            param = "noPassword";
        } else {
            // 로그인이 가능한 상태
            param = "clear";
            user_id = user.getUser_id();

            // 세션에 user객체를 저장
            session.setAttribute("user", user);
        }

        // 콜백으로 결과 반환
        Map<String, Object> map = new HashMap<>();
        map.put("param", param);
        map.put("user_id", user_id);

        return map;
    }

    // 이메일, 비번찾기
    @GetMapping("/findInfo.do")
    public String findInfo(@RequestParam String type, Model model) {

        model.addAttribute("type", type);

        return "user/findInfo";
    }

    /*
     * @PostMapping("/findEmail.do")
     * 
     * @ResponseBody
     * public Map<String, Object> findEmail( UserVO vo) {
     * 
     * UserVO user = userDao.findEmail(vo);
     * 
     * String param = "no";
     * String user_email = "";
     * 
     * if( user == null ){ //존재하지 않을 때
     * param = "no";
     * }else{
     * //메일 찾은 상태
     * param = "clear";
     * user_email = user.getEmail();
     * }
     * 
     * //콜백으로 결과 반환
     * Map<String, Object> map = new HashMap<>();
     * map.put("param", param);
     * map.put("user_email", user_email);
     * 
     * return map;
     * }
     * 
     */

    // 아이디 찾기
    @PostMapping("/findLoginId.do")
    @ResponseBody
    public Map<String, Object> findLoginId(UserVO vo) {

        UserVO user = userDao.findLoginId(vo);

        String param = "no";
        String login_id = "";

        if (user == null) { // 존재하지 않을 때
            param = "no";
        } else {
            // 아이디 찾은 상태
            param = "clear";
            login_id = user.getLogin_id();
        }

        // 콜백으로 결과 반환
        Map<String, Object> map = new HashMap<>();
        map.put("param", param);
        map.put("login_id", login_id);

        return map;
    }

    // 아이디 메일발송
    @PostMapping("/idMailSend.do")
    @ResponseBody
    public String idMailSend(String login_id, String email) {

        try {
            mss.idSendMail(login_id, email);
            return "yes";
        } catch (Exception e) {
            return "no";
        }

    }

    @PostMapping("/phoneMailCheck.do")
    @ResponseBody
    public Map<String, Object> findPassword(UserVO vo) {

        UserVO user = userDao.findPwd(vo);

        String param = "no";

        if (user == null) {
            param = "no"; // 일치하는 정보 없음
        } else {
            param = "clear"; // 일치
        }
        // 콜백으로 결과 반환
        Map<String, Object> map = new HashMap<>();
        map.put("param", param);
        map.put("user", user);

        return map;
    }

    // 비번찾기시 인증메일발송
    @PostMapping("/mailAuthCheck.do")
    @ResponseBody
    public Map<String, String> mailAuthCheck(String email) {

        String authNumber = "";

        authNumber = mss.joinEmail(email);

        Map<String, String> map = new HashMap<>();

        map.put("authNumber", authNumber);

        return map;

    }

    // 임시비번발송
    @PostMapping("/newPwdSend.do")
    @ResponseBody
    // newPassword(String email, Integer user_id)로 변경 권장
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

    // 회원 정보수정폼으로
    @GetMapping("/user_modify.do")
    public String user_modifyForm(Model model) {

        // 로그인한 사람의 정보 꺼내기
        UserVO sessionUser = (UserVO) session.getAttribute("user");

        // 로그인 안 된 상태면 로그인 페이지로
        if (sessionUser == null) {
            return "redirect:/login.do";
        }

        // DTO 조립
        UserDTO dto = new UserDTO();
        dto.setUser(userDao.selectUser(sessionUser.getUser_id()));

        // 판매자면 seller 정보도 담기
        if (sessionUser.getRole().equalsIgnoreCase("SELLER")) {
            dto.setSeller(sellerDao.selectSeller(sessionUser.getUser_id()));
        }

        // JSP 화면
        model.addAttribute("dto", dto); // "user" 대신 "dto"로 변경
        model.addAttribute("activeMenu", "user_modify.do");
        model.addAttribute("contentPage", "/user/user_edit");

        return "myshop/myshop_main"; // myshop_main을 통해서 열기
    }

    // 회원 정보수정
    @PostMapping("/user_modify.do")
    @ResponseBody
    public Map<String, Integer> user_modify(UserVO vo, String ori_photo_name, String del_photo_name, SellerVO svo)
            throws Exception {

        if (vo.getPassword() != null && !vo.getPassword().trim().isEmpty()) {
            // 수정에 사용한 비밀번호 암호화
            String securePwd = pwdSecurity.pwdEncoding(vo.getPassword());
            vo.setPassword(securePwd);
        } else {
            // 새 비밀번호를 입력하지 않은 경우 기존 비밀번호 유지
            UserVO currentInfo = userDao.selectUser(vo.getUser_id());
            vo.setPassword(currentInfo.getPassword());
        }

        // 이미지 저장 폴더
        String savePath = uploadPath + File.separator;

        File dir = new File(savePath);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        // 파일정보
        MultipartFile photo = vo.getPhoto();
        String photo_name = "no_file";

        // 1.업로드 된 파일이 존재하는 경우(새 이미지로 교체)
        if (photo != null && !photo.isEmpty()) {
            photo_name = photo.getOriginalFilename();
            File saveFile = new File(savePath, photo_name);
            if (saveFile.exists()) {
                long time = System.currentTimeMillis();
                photo_name = String.format("%d_%s", time, photo_name);
                saveFile = new File(savePath, photo_name);
            }

            photo.transferTo(saveFile); // 저장

        } else if (!ori_photo_name.equals("no_file")) {
            // 2.기존이미지 그대로 사용
            photo_name = ori_photo_name;
        }
        // 3.프로필 이미지를 쓰지 않는다
        vo.setPhoto_name(photo_name);

        int res = userDao.userModify(vo);
        if (vo.getRole().equalsIgnoreCase("SELLER")) {
            svo.setUser_id(vo.getUser_id());
            int sres = sellerDao.sellerModify(svo);
        }

        // 업데이트 후 필요없어진 이미지가 있다면 삭제
        if (res == 1) {
            File del_photo = new File(savePath, del_photo_name);

            // 새로운 사진이 등록되었거나 사진을 등록하지 않은 경우
            if ((photo != null && !photo.isEmpty()) || ori_photo_name.equals("no_file")) {
                if (del_photo.exists()) {
                    del_photo.delete();
                }
            }

        } // if

        Map<String, Integer> map = new HashMap<>();
        map.put("result", res);
        map.put("user_id", vo.getUser_id());

        return map;
    }

    // 현재비번확인
    @PostMapping("/check_currPassword.do")
    @ResponseBody
    public Map<String, Object> checkCurrentPassword(String ori_password) {

        Map<String, Object> map = new HashMap<>();
        boolean isValid = false;

        UserVO sessionUser = (UserVO) session.getAttribute("user");

        if (sessionUser != null && ori_password != null) {

            UserVO dbUser = userDao.selectUser(sessionUser.getUser_id());

            if (dbUser != null) {
                // DB에 있는 최신 암호화 비밀번호와 유저의 입력값을 비교
                isValid = pwdSecurity.pwdDecoding(ori_password, dbUser.getPassword());

            }
            map.put("isValid", isValid);

        }
        return map;
    }

    // 사업자회원 가입
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

    // 일반회원=>판매자회원폼
    @GetMapping("/update_seller.do")
    public String updgradeSeller(Model model) {

        // 로그인한 사람의 정보 꺼내기
        UserVO sessionUser = (UserVO) session.getAttribute("user");

        if (sessionUser.getRole().equalsIgnoreCase("SELLER")) {
            session.setAttribute("flashMsg", "이미 판매자입니다.");
            return "redirect:/myshop";
        }

        model.addAttribute("sessionUser", sessionUser);
        model.addAttribute("activeMenu", "update_seller.do"); // 사이드바 강조용
        model.addAttribute("contentPage", "/user/update_seller");

        return "myshop/myshop_main"; // myshop_main을 통해서 열기

    }

    // 일반 => 사업자회원으로 변경
    @Transactional
    @PostMapping("/update_seller.do")
    public String updateSeller(int user_id, SellerVO vo) throws Exception {

        userDao.updateSeller(user_id);
        vo.setUser_id(user_id);
        sellerDao.insertSeller(vo);

        UserVO updatedUser = userDao.selectUser(user_id);
        session.setAttribute("user", updatedUser);

        return "redirect:/myshop";
    }

    // 로그아웃
    @GetMapping("/logout.do")
    public String logout() {
        session.invalidate();
        return "redirect:/login.do";
    }

    // 회원탈퇴 페이지로
    @GetMapping("/withdraw.do")
    public String withdrawForm(Model model) {

        UserVO sessionUser = (UserVO) session.getAttribute("user");

        model.addAttribute("sessionUser", sessionUser);
        model.addAttribute("activeMenu", "withdraw.do"); // 사이드바 강조용
        model.addAttribute("contentPage", "/user/withdraw");

        return "myshop/myshop_main";
    }


    // 회원탈퇴
@PostMapping("/withdraw.do")
@ResponseBody
public Map<String, Object> withdraw() {
    Map<String, Object> map = new HashMap<>();
    
    // 1. 세션에서 현재 로그인한 유저 정보 가져오기
    UserVO sessionUser = (UserVO) session.getAttribute("user");
    if (sessionUser == null) {
        map.put("result", "noSession");
        return map;
    }

    List<OrderVO> list = orderDao.withdrawCheck(sessionUser.getUser_id());

    if(!list.isEmpty()){
        map.put("result", "notDeliverYet"); //배송 미완료
        return map;
    }

    // DB 탈퇴 로직 수행
    int res = userDao.withdraw(sessionUser.getUser_id());

    if (res == 1 ) {
        session.invalidate(); // 세션 날리기 (로그아웃)
        map.put("result", "success");
    }else {
        map.put("result", "fail");
    }

    return map;
}
        

    /*
     * @GetMapping("/user_mypage.do")
     * public String user_mypage( Model model) {
     * 
     * //로그인한 사람의 정보 꺼내기
     * UserVO sessionUser = (UserVO) session.getAttribute("user");
     * 
     * //로그인 안 된 상태면 로그인 페이지로
     * if (sessionUser == null) {
     * return "redirect:/login.do";
     * }
     * 
     * //로그인된 유저의 id로 DB 조회
     * UserVO vo = userDao.selectUser(sessionUser.getUser_id());
     * 
     * //JSP 화면
     * model.addAttribute("user", vo);
     * 
     * return "user/mypage";
     * }
     */

}
