package com.kh.suje.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminController {
    @GetMapping(value={"/admin", "/admin/dashboard"})
    public String adminDashboard() {

        return "/admin/admin_dashboard";
    }

    @GetMapping("/admin/members")
    public String members() {

        return "/admin/admin_member_list";
    }

    @GetMapping("/admin/sellers")
    public String sellers() {

        return "/admin/admin_seller_approval";
    }

    @GetMapping("/admin/products")
    public String products() {

        return "/admin/admin_product_approval";
    }

    @GetMapping("/admin/reviews")
    public String reviews() {

        return "/admin/admin_review_manage";
    }


    @GetMapping("/admin/qnas")
    public String qnas() {

        return "/admin/admin_qna_manage";
    }

    @GetMapping("/admin/reports")
    public String reports() {

        return "/admin/admin_report_manage";
    }

    @GetMapping("/admin/categories")
    public String categories() {

        return "/admin/admin_category_manage";
    }

    @GetMapping("/admin/notices")
    public String notices() {

        return "/admin/admin_notice_manage";
    }

    @GetMapping("/admin/statistics")
    public String statistics() {

        return "/admin/admin_statistics";
    }
}
