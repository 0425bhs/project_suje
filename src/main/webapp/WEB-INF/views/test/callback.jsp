<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="ko">
<head>
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
</head>
<body>
<script type="text/javascript">
  var naver_id_login = new naver_id_login("PJUFdZV_k1HGDTGlI5o9", "http://localhost:9090/login_callback.do");
  // 접근 토큰 값 출력
  alert(naver_id_login.oauthParams.access_token);
  // 네이버 사용자 프로필 조회
  naver_id_login.get_naver_userprofile("naverSignInCallback()");
  // 네이버 사용자 프로필 조회 이후 프로필 정보를 처리할 callback function
  function naverSignInCallback() {
    // alert(naver_id_login.getProfileData('email'));
    // alert(naver_id_login.getProfileData('nickname'));
    // alert(naver_id_login.getProfileData('age'));

    let input = document.getElementsByTagName("input");

    for (let i of input) {
      let tag = document.getElementById(i.id);
      tag.value = naver_id_login.getProfileData(i.id);
    }

    let nickname = document.getElementById("nickname"); 
    let name = document.getElementById("name"); 
    let email = document.getElementById("email"); 
    let gender = document.getElementById("gender"); 
    let birthday = document.getElementById("birthday"); 
    
    nickname.value = naver_id_login.getProfileData('nickname');
    name.value = naver_id_login.getProfileData('name');
    email.value = naver_id_login.getProfileData('email');
    gender.value = naver_id_login.getProfileData('gender');
    birthday.value = naver_id_login.getProfileData('birthday');
  }
</script>
</body>
</html>