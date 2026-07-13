package com.kh.suje.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.suje.dao.NoticeDAO;
import com.kh.suje.vo.NoticeVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class NoticeController {
    
    // private final HttpSession session;

    private final NoticeDAO noticeDAO;

    private boolean isAdmin(HttpSession session) {
        UserVO user = (UserVO)session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }

    @GetMapping("/notice_form.do")
    private String noticeForm(HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/notice_list.do";
        }

        return "/notice/notice_form";
    }

    @PostMapping("/notice_form.do")
    private String noticeFormFin(NoticeVO notice, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/notice_list.do";
        }

        noticeDAO.addNotice(notice);

        return "redirect:/notice_list.do";
    }

    @GetMapping("/notice_update_form.do")
    private String noticeUpdateForm(Model model, int notice_id, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/notice_detail.do?notice_id=" + notice_id;
        }

        NoticeVO notice = noticeDAO.getNoticeById(notice_id);

        model.addAttribute("notice", notice);

        return "/notice/notice_update_form";
    }

    @PostMapping("/notice_update_form.do")
    private String noticeUpdateFormFin(NoticeVO notice, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/notice_detail.do?notice_id=" + notice.getNotice_id();
        }

        noticeDAO.updateNotice(notice);

        return "redirect:/notice_detail.do?notice_id="+notice.getNotice_id();
    }

    @GetMapping("/notice_list.do")
    private String noticeList(Model model) {
        List<NoticeVO> list = noticeDAO.getNoticeList();
        
        model.addAttribute("list", list);

        return "/notice/notice_list";
    }

    @GetMapping("/notice_detail.do")
    private String noticeDetail(Model model, int notice_id) {
        NoticeVO notice = noticeDAO.getNoticeById(notice_id);
        
        model.addAttribute("notice", notice);

        return "/notice/notice_detail";
    }

    @PostMapping("/notice_delete.do")
    private String noticeDelete(Model model, int notice_id, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/notice_detail.do?notice_id=" + notice_id;
        }

        noticeDAO.deleteNotice(notice_id);
        
        return "redirect:/notice_list.do";
    }
}
