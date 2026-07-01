package com.kh.suje.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.QnaDAO;
import com.kh.suje.dao.ReportDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.QnaVO;
import com.kh.suje.vo.ReportVO;
import com.kh.suje.vo.ReviewVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReportController {
    // private final HttpSession session;

    private final ReportDAO reportDao;

    @PostMapping("/seller_qna_report.do")
    @ResponseBody
    public Map<String, String> reportFormFin(HttpSession session, Model model, ReportVO report) {
        Map<String, String> map = new HashMap<>();
        String result = "empty";

        UserVO loginUser = (UserVO)session.getAttribute("user");
        if (loginUser == null) {
            result = "login";

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
