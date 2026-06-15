package com.kh.suje.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.suje.vo.ReportVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReportController {
    // private final HttpSession session;

    // private final ReportDAO reportDAO;

    @GetMapping("/report_form.do")
    public String reportForm(Model model, ReportVO report) {
        model.addAttribute("report", report);

        return "/report/report_form";
    }
}
