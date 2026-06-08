package com.kh.suje.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.CartDAO;
import com.kh.suje.vo.CartVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CartController {

    private final CartDAO cartdao;

    private Integer getLoginUserId(HttpSession session){

        Object loginUserId = session.getAttribute("user_id");

        if (loginUserId == null) {
            return null;
        }

        return ((Number) loginUserId).intValue();
    }

    
}
