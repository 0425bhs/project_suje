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
public class KakaoController {

    private final UserDAO userDao;
 
    private static final String CLIENT_ID = "33aac57d1dfd2b5b7498004ba718b9d1";
    private static final String REDIRECT_URI = "http://localhost:9090/kakao/callback.do";

    @GetMapping("/kakao/callback.do")
    public String kakaoCallback(@RequestParam String code, HttpSession session) throws Exception {

        String tokenUrl = "https://kauth.kakao.com/oauth/token";
        String params = "grant_type=authorization_code"
                + "&client_id=" + CLIENT_ID
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&code=" + code;

        String tokenResponse = post(tokenUrl, params);
        JSONObject tokenJson = new JSONObject(tokenResponse);
        String accessToken = tokenJson.getString("access_token");

        String userResponse = get("https://kapi.kakao.com/v2/user/me", accessToken);
        JSONObject userJson = new JSONObject(userResponse);

        //System.out.println("카카오 사용자 정보: " + userJson);

        String kakao_id = String.valueOf(userJson.getLong("id"));
        UserVO user = userDao.kakaoLogin(kakao_id);

        if(user == null) {
            
    session.setAttribute("kakao_id", kakao_id);
    session.setAttribute("kakao_nickname", userJson.getJSONObject("properties").getString("nickname"));
   return "redirect:/joinKakao.do";

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

    
@GetMapping("/joinKakao.do")
public String kakaoJoinForm() {
    return "user/join_kakao";  
}


}

