package com.kh.suje.config;

import java.io.IOException;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AdminAuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        UserVO user = session == null ? null : (UserVO) session.getAttribute("user");

        if (user != null && "ADMIN".equals(user.getRole())) {
            return true;
        }

        if (isAjaxAdminRequest(request)) {
            writeDeniedJson(response);
            return false;
        }

        response.sendRedirect("/");
        return false;
    }

    private boolean isAjaxAdminRequest(HttpServletRequest request) {
        String uri = request.getRequestURI();
        return "POST".equalsIgnoreCase(request.getMethod())
               || uri.endsWith("/detail")
               || uri.endsWith("/memos")
               || uri.endsWith("/answer")
               || uri.endsWith("/status");
    }

    private void writeDeniedJson(HttpServletResponse response) throws IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"success\":false,\"message\":\"관리자만 접근할 수 있습니다.\"}");
    }
}
