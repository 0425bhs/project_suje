package com.kh.suje.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.kh.suje.dao.CartDAO;
import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.UserDAO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@ControllerAdvice
@RequiredArgsConstructor
public class HeaderControllerAdvice {

    private final CategoryDAO categorydao;
    private final CartDAO cartdao;
    private final UserDAO userDao;

    @ModelAttribute("bigCategoryList")
    public Object bigCategoryList(){
        return categorydao.big_category_list();
    }

    @ModelAttribute("smallCategoryList")
    public Object smallCategoryList(){
        return categorydao.small_category_all_list();
    }

    @ModelAttribute
     public void headerCartCount(HttpSession session, Model model) {

        int cartCount = 0;

        UserVO user = (UserVO) session.getAttribute("user");

        if (user != null) {
            UserVO latestUser = userDao.selectUser(user.getUser_id());
            if (latestUser != null) {
                user = latestUser;
                session.setAttribute("user", latestUser);
            }
            cartCount = cartdao.cartCount(user.getUser_id());
        }

        model.addAttribute("cartCount", cartCount);
    }
}
