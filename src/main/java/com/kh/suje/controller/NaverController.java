package com.kh.suje.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

import java.net.*;
import org.json.*;

@Controller
@RequiredArgsConstructor
public class NaverController {
 private final UserDAO userDao;
 
    private static final String CLIENT_ID = "WRlrhlhNnY73Y1Qixajm";
    private static final String REDIRECT_URI = "http://localhost:9090/naver/callback.do";

    @GetMapping("/naver/callback.do")
    public String kakaoCallback(@RequestParam String code, HttpSession session) throws Exception {

        String tokenUrl = "https://nid.naver.com/oauth2.0/token";
        String params = "grant_type=authorization_code"
        + "&client_id=" + CLIENT_ID
        + "&client_secret=" + "JGWwMIIDwB"
        + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
        + "&code=" + code;

        String tokenResponse = post(tokenUrl, params);
        JSONObject tokenJson = new JSONObject(tokenResponse);
        String accessToken = tokenJson.getString("access_token");

        String userResponse = get("https://openapi.naver.com/v1/nid/me", accessToken);
        JSONObject userJson = new JSONObject(userResponse); //추가
        JSONObject response = userJson.getJSONObject("response");
        String naver_id = response.getString("id");

        //System.out.println("네이버 사용자 정보: " + userJson);

        UserVO user = userDao.naverLogin(naver_id);

        if(user == null) {
            
session.setAttribute("naver_id", naver_id);
session.setAttribute("naver_name", response.getString("name"));
session.setAttribute("naver_email", response.getString("email"));
session.setAttribute("naver_nickname", response.getString("nickname"));
session.setAttribute("naver_mobile", response.getString("mobile"));

   return "redirect:/joinNaver.do";

} else {
   session.setAttribute("user", user);
     return "redirect:/";
}      
    }

 private String post(String url, String params) throws Exception {
    HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
    conn.setRequestMethod("POST");
    conn.setDoOutput(true);
    conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
    conn.getOutputStream().write(params.getBytes("UTF-8"));
    return new String(conn.getInputStream().readAllBytes(), "UTF-8");
}

    private String get(String url, String accessToken) throws Exception {
        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        return new String(conn.getInputStream().readAllBytes(), "UTF-8");
    }

    
@GetMapping("/joinNaver.do")
public String naverJoinForm() {
    return "user/join_naver";  
}


}

