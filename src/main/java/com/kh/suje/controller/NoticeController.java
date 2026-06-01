package com.kh.suje.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.NoticeDAO;
import com.kh.suje.vo.NoticeVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class NoticeController {
    @Autowired
    HttpSession session;

    private final NoticeDAO noticeDAO;

    @GetMapping("/notice_form.do")
    private String reviewForm(Model model) {

        return "/notice/notice_form";
    }

    @PostMapping("/notice_form.do")
    private String reviewFormFin(NoticeVO notice) {
        int res = noticeDAO.addNotice(notice);

        return "redirect:/notice_list.do";
    }

    @GetMapping("/notice_list.do")
    private String noticeList(Model model) {
        List<NoticeVO> list = noticeDAO.getNoticeList();
        
        model.addAttribute("list", list);

        return "/notice/notice_list";
    }

    @GetMapping("/notice_detail.do")
    private String noticeDetail(Model model, int noticeId) {
        NoticeVO notice = noticeDAO.getNoticeById(noticeId);
        
        model.addAttribute("notice", notice);

        return "/notice/notice_detail";
    }
}
