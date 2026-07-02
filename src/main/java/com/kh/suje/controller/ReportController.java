package com.kh.suje.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.ReportDAO;
import com.kh.suje.vo.ReportVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReportController {
    // private final HttpSession session;

    private final ReportDAO reportDao;

    @PostMapping("/report.do")
    @ResponseBody
    public Map<String, String> reportFormFin(HttpSession session, ReportVO report) {
        Map<String, String> map = new HashMap<>();
        String result = "empty";

        UserVO loginUser = (UserVO)session.getAttribute("user");
        
        if (loginUser == null) {
            map.put("result", "login");
            return map;
        }
        
        int user_id = loginUser.getUser_id();
        report.setReporter_id(user_id);

        int res = reportDao.addReport(report);
        if (res > 0) {
            result = "success";
        }

        map.put("result", result);

        return map;
    }
}
