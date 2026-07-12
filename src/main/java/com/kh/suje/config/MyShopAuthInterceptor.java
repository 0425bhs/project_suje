package com.kh.suje.config;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class MyShopAuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        UserVO user = session == null ? null : (UserVO) session.getAttribute("user");

        if (user != null) {
            return true;
        }

        response.sendRedirect(request.getContextPath() + "/login.do");
        return false;
    }
}
