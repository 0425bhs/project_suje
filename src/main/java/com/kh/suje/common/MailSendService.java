package com.kh.suje.common;

import java.security.SecureRandom;
import java.util.Random;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;


import jakarta.mail.internet.MimeMessage;

@Service  
public class MailSendService {
    
    private final JavaMailSender javaMailSender;
    private int authNumber;
   
    
    public MailSendService( JavaMailSender javaMailSender ){
        this.javaMailSender = javaMailSender;
    }

    //인증번호 생성 메서드
    public void makeRandomNumber(){
        Random rnd = new Random();
        //111111 ~ 999999 사이의 난수
        authNumber = rnd.nextInt( 999999 - 111111 + 1 ) + 111111;
    }

    //메일발송
    public String joinEmail( String email ){

        makeRandomNumber();
        
        String setFrom = "ktkim0209@naver.com"; //보내는 사람 메일 
        String toMail = email; //받는 사람 메일 
        
        //메일 제목
        String title = "가입 인증 이메일 입니다"; 

        //메일 내용
        StringBuffer content = new StringBuffer();
        content.append("<h3>요청하신 인증번호 입니다</h3>");
        content.append("<h1><b>" + authNumber + "</b></h1>");
        content.append("<p>번호를 입력해주세요</p>");

        try {
            
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper( message, true, "UTF-8" );

            helper.setFrom(setFrom);
            helper.setTo(toMail);
            helper.setSubject(title);

            helper.setText( content.toString(),true );

            javaMailSender.send( message );

        } catch (Exception e) {
           e.printStackTrace();
        }

        return String.valueOf(authNumber);
    }//joinEmail


//임시비번 생성
    private String makeRandomPassword() {
    String charSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    SecureRandom rnd = new SecureRandom();
    
    // 8~16 사이의 랜덤한 길이 결정
    int length = rnd.nextInt(16 - 8 + 1) + 8; 
    
    StringBuilder sb;
    boolean hasLetter;
    boolean hasDigit;

    // 영문과 숫자가 최소 1개 이상 무조건 포함될 때까지 반복
    do {
        sb = new StringBuilder();
        hasLetter = false;
        hasDigit = false;

        for (int i = 0; i < length; i++) {
            int index = rnd.nextInt(charSet.length());
            char ch = charSet.charAt(index);
            sb.append(ch);

            if (Character.isLetter(ch)) hasLetter = true;
            if (Character.isDigit(ch)) hasDigit = true;
        }
    } while (!hasLetter || !hasDigit);

    return sb.toString();
}

//임시비번발송
        public String newPwdEmail( String email ){
String temporaryPwd = makeRandomPassword();
        
        
        String setFrom = "ktkim0209@naver.com"; //보내는 사람 메일 
        String toMail = email; //받는 사람 메일 
        
        //메일 제목
        String title = "임시 비밀번호입니다"; 

        //메일 내용
        StringBuffer content = new StringBuffer();
        content.append("<h3>요청하신 임시비밀번호입니다 : " + temporaryPwd + "</h3>");
     

        try {
            
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper( message, true, "UTF-8" );

            helper.setFrom(setFrom);
            helper.setTo(toMail);
            helper.setSubject(title);

            helper.setText( content.toString(),true );

            javaMailSender.send( message );

        } catch (Exception e) {
           e.printStackTrace();
        }

        return temporaryPwd;

    }//newPwdEmail


    //아이디 발송
    public void idSendMail( String login_id, String email ) throws Exception{

        String setFrom = "ktkim0209@naver.com"; //보내는 사람 메일 
        String toMail = email; //받는 사람 메일 
        
        //메일 제목
        String title = "가입하신 아이디입니다"; 

        //메일 내용
        StringBuffer content = new StringBuffer();
        content.append("<h1>가입하신 아이디는</h1>");
        content.append("<h1><b>" + login_id + "</b></h1>");
        content.append("<h1> 입니다. </h1>");

        try {
            
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper( message, true, "UTF-8" );

            helper.setFrom(setFrom);
            helper.setTo(toMail);
            helper.setSubject(title);

            helper.setText( content.toString(),true );

            javaMailSender.send( message );

        } catch (Exception e) {
           e.printStackTrace();
           throw e;
        }

    }//idSendMail


}
