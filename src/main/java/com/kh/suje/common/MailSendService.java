package com.kh.suje.common;

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
        
        String setFrom = "@naver.com"; //보내는 사람 메일 
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

}
