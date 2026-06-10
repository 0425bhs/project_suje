package com.kh.suje.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.dao.QnaDAO;
import com.kh.suje.dao.ReviewDAO;
import com.kh.suje.util.Paging;
import com.kh.suje.vo.ProductVO;
import com.kh.suje.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ProductController {

    private final ProductDAO productdao;
    private final CategoryDAO categorydao;
    private final ReviewDAO reviewdao;
    private final QnaDAO qnadao;
    
   
    @GetMapping(value={"/", "/main.do", "/product/main.do", "/product/list.do"})
    public String main(Model model){

        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());
        return "main";
    }
        
    @GetMapping("/category_list.do")
    public String product_category_list(Model model, Integer page, Integer category_id, String sort) {

        // 정렬 기본값
        if (sort == null || sort.trim().equals("")) {
            sort = "popular";
        }

        String category_name = categorydao.getCategroyNameById(category_id);

        // 소분류면 parent_id를 찾음, 대분류면 parent_id가 null
        Integer selectedBigCategoryId = categorydao.find_parent_id(category_id);

        // parent_id가 null이면 현재 category_id 자체가 대분류
        if (selectedBigCategoryId == null) {
            selectedBigCategoryId = category_id;
        }

        int nowPage = 1;

        if (page != null) {
            nowPage = page;
        }

        int blockList = 10;
        int blockPage = 5;

        int start = (nowPage - 1) * blockList;

        Map<String, Object> map = new HashMap<>();
        map.put("category_id", category_id);
        map.put("start", start);
        map.put("blockList", blockList);
        map.put("sort", sort);

        int rowTotal = productdao.product_category_cnt(map);

        List<ProductVO> list = productdao.product_category_list(map);

        String pageMenu = Paging.getPaging(
            "/category_list.do?category_id=" + category_id + "&sort=" + sort,
            nowPage,
            rowTotal,
            blockList,
            blockPage
        );

        model.addAttribute("list", list);
        model.addAttribute("pageMenu", pageMenu);
        model.addAttribute("category_id", category_id);
        model.addAttribute("category_name", category_name);
        model.addAttribute("rowTotal", rowTotal);

        // JSP에서 active 표시할 때 사용할 값
        model.addAttribute("currentSort", sort);

        // 카테고리 페이지 왼쪽 메뉴용
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());
        model.addAttribute("selectedBigCategoryId", selectedBigCategoryId);

        return "product/product_category_list";
    }

    @GetMapping("/product_search.do")
    public String productSearch(Model model, String keyword, Integer page){

        if(keyword == null || keyword.trim().isEmpty()){
            return "redirect:/all_list.do";
        }

        keyword = keyword.trim();

        int nowPage = 1;
        
        if(page != null){
            nowPage = page;
        }

        // ========== 페이징 처리 관련 변수 ==========
        // blockList: 한 페이지에 보여줄 상품 개수 (10개씩 표시)
        int blockList = 10;
        
        // blockPage: 페이지 네비게이션에서 보여줄 페이지 버튼 개수
        // 예) 1,2,3,4,5 / 6,7,8,9,10 (각 그룹당 5개씩)
        int blockPage = 5;

        // start: 데이터베이스 쿼리의 시작 위치 계산
        // 예) 1페이지(nowPage=1): start = 0       → LIMIT 0, 10 (0~9번째 상품)
        //     2페이지(nowPage=2): start = 10      → LIMIT 10, 10 (10~19번째 상품)
        //     3페이지(nowPage=3): start = 20      → LIMIT 20, 10 (20~29번째 상품)
        int start = (nowPage - 1) * blockList;

        Map<String, Object> map = new HashMap<>();
        map.put("keyword", keyword);
        map.put("start", start);
        map.put("blockList", blockList);

        int rowTotaL = productdao.product_search_cnt(map);
        List<ProductVO> list = productdao.product_search_list(map);

        String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8);

        String pageMenu = Paging.getPaging(
            "/product_search.do?keyword=" + encodedKeyword,
            nowPage,
            rowTotaL,
            blockList,
            blockPage
         );

        model.addAttribute("list", list);
        model.addAttribute("pageMenu", pageMenu);
        model.addAttribute("keyword", keyword);
        model.addAttribute("isSearch", true);
        model.addAttribute("rowTotal", rowTotaL);

        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        return "product/product_new_list";
    }
   

    @GetMapping("/product_detail.do")
    public String product_detail_form(
            int product_id,
            Model model,
            HttpSession session
    ) {
        // 상품 상세 정보 조회
        ProductVO vo = productdao.product_one(product_id);

        // 상품이 없으면 메인으로 이동
        if (vo == null) {
            return "redirect:/product/main.do";
        }

        // 상품 상세 JSP로 상품 정보 전달
        model.addAttribute("vo", vo);

        // 리뷰 목록 전달
        model.addAttribute("review_list", reviewdao.getProductReviewList(product_id));


        // =========================================================
        // 취향발견용 상품 조회 기록 저장
        // - 로그인한 회원이 상품 상세 페이지에 들어왔을 때만 기록
        // - user_id = 1 고정 사용하지 않음
        // - product_view_log에 저장된 기록은 취향발견 추천에 사용
        // =========================================================
        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser != null) {
            Map<String, Object> viewLogMap = new HashMap<>();

            viewLogMap.put("user_id", loginUser.getUser_id());
            viewLogMap.put("product_id", vo.getProduct_id());
            viewLogMap.put("category_id", vo.getCategory_id());

            productdao.insertProductViewLog(viewLogMap);
        }


        // 전체 카테고리 헤더용
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        return "/product/product_detail";
    }

    // 선물추천 페이지
    @GetMapping("/product_gift.do")
    public String product_gift_list(
            Model model,
            Integer category_id,
            String priceRange,
            HttpSession session
    ) {
        // 헤더 전체 카테고리 출력용
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        // 선택된 카테고리
        model.addAttribute("selectedCategoryId", category_id);

        // 선택된 가격대
        model.addAttribute("selectedPriceRange", priceRange);


        // =========================================================
        // 로그인 회원 구매내역 기반 추천
        // =========================================================
        UserVO loginUser = (UserVO) session.getAttribute("user");

        if (loginUser != null) {
        int user_id = loginUser.getUser_id();

        Map<String, Object> personalMap = new HashMap<>();
        personalMap.put("user_id", user_id);
        personalMap.put("limit", 7);

        List<ProductVO> personalGiftList = productdao.product_gift_personal_list(personalMap);

        String loginUserName = loginUser.getName();

        if (loginUserName == null || loginUserName.trim().isEmpty()) {
            loginUserName = loginUser.getNick_name();
        }

        model.addAttribute("personalGiftList", personalGiftList);
        model.addAttribute("loginUserName", loginUserName);
    }


        // =========================================================
        // 선택 조건 상품 목록
        // =========================================================
        Map<String, Object> map = new HashMap<>();
        map.put("category_id", category_id);
        map.put("priceRange", priceRange);
        map.put("limit", 14);

        List<ProductVO> giftList = productdao.product_gift_list(map);

        model.addAttribute("giftList", giftList);

        return "product/product_gift_list";
    }


    @GetMapping("/product_sale.do")
    public String product_sale_list(Model model,Integer page){
        int nowPage = 1;

        if (page != null) {
            nowPage = page;
        }

        int blockList = 10;
        int blockPage = 5;

        int rowTotal = productdao.product_sale_cnt();
        int start = (nowPage - 1) * blockList;

        Map<String, Object> map = new HashMap<>();
        map.put("start", start);
        map.put("blockList", blockList);

        List<ProductVO> list = productdao.product_sale_list(map);

        String pageMenu = Paging.getPaging(
            "/product/sale_list.do",
            nowPage,
            rowTotal,
            blockList,
            blockPage
        );

        model.addAttribute("list", list);
        model.addAttribute("pageMenu", pageMenu);

        // 전체 카테고리용 데이터
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());
        return "product/product_sale_list";
    }

    @GetMapping("/product_best.do")
    public String product_best_list(Model model) {

        List<ProductVO> list = productdao.product_best_all_list();

        model.addAttribute("list", list);

        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        return "product/product_best_list";
    }

    @GetMapping("/product_discovery.do")
    public String product_discovery_list(Model model, HttpSession session) {

        UserVO loginUser = (UserVO) session.getAttribute("user");

        Map<String, Object> map = new HashMap<>();
        map.put("limit", 30);

        List<ProductVO> list = null;
        boolean isFallback = false;

        // 로그인한 회원이면 해당 회원의 취향 기록 기준으로 추천
        if (loginUser != null) {
            int user_id = loginUser.getUser_id();
            map.put("user_id", user_id);

            list = productdao.product_discovery_list(map);
        }

        // 로그인하지 않았거나 취향 데이터가 없으면 기본 추천 상품 출력
        if (list == null || list.isEmpty()) {
            list = productdao.product_discovery_fallback_list(map);
            isFallback = true;
        }

        model.addAttribute("list", list);
        model.addAttribute("isFallback", isFallback);

        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());

        return "product/product_discovery_list";
    }

    @GetMapping("/all_list.do")
    String allProductList(Model model,Integer page){
        
        int nowPage = 1;

        if (page != null) {
            nowPage=page;
        }

        int blockList=10;
        int blockPage=5;

        int rowTotal = productdao.product_cnt();
        int start=(nowPage - 1)*blockList;

        Map<String, Object> map = new HashMap<>();
        map.put("start",start);
        map.put("blockList",blockList);

        List<ProductVO> list=productdao.product_list(map);

        String pageMenu=Paging.getPaging("/all_list.do",nowPage,rowTotal,blockList,blockPage);

        model.addAttribute("list",list);
        model.addAttribute("pageMenu",pageMenu);

        // 전체 카테고리용 데이터  
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());
        return "product/product_new_list";
    }


    
    @GetMapping("/seller_product_insert.do")
    public String seller_product_insert_form(Model model){
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        return "/seller/seller_product_insert_form";
    }


    @PostMapping("/seller_product_insert.do")
    @ResponseBody
    public Map<String,Object> seller_product_insert(ProductVO vo) throws Exception{

        String savePath="c:/upload/";
        File dir= new File(savePath);
        if(!dir.exists()){
            dir.mkdirs();
        }

        MultipartFile image_L=vo.getImage_l_file();
        String filename_l="no_file";

        if(image_L!=null && !image_L.isEmpty()){
            filename_l=image_L.getOriginalFilename();
            File savFile=new File(savePath,filename_l);

            if(savFile.exists()){
                long time=System.currentTimeMillis();
                filename_l=String.format("%d_%s",time, filename_l);
                savFile=new File(savePath,filename_l);
            }

            image_L.transferTo(savFile);
        }

        MultipartFile image_S=vo.getImage_s_file();
        String filename_s="no_file";

        if(image_S!=null && !image_S.isEmpty()){
            filename_s=image_S.getOriginalFilename();
            File savFile=new File(savePath,filename_s);

            if(savFile.exists()){
                long time=System.currentTimeMillis();
                filename_s=String.format("%d_%s",time, filename_s);
                savFile=new File(savePath,filename_s);
            }

            image_S.transferTo(savFile);
        }

        if (filename_l.equals("no_file")){
            vo.setImage_l("no_file");
        } else {
            vo.setImage_l("/upload/" + filename_l);
        }

        if (filename_s.equals("no_file")){
            vo.setImage_s("no_file");
        } else {
            vo.setImage_s("/upload/" + filename_s);
        }

        vo.setStatus("APPROVED");//테스트용 삭제 예정

        int res=productdao.seller_product_insert(vo);

        Map<String,Object> map=new HashMap<>();
        map.put("result", res);

        return map;
    }


    @GetMapping("/seller_product_modify.do")
    public String seller_product_modify_form(int product_id, Model model){
        ProductVO vo=productdao.product_one(product_id);
        // 현재 상품의 하위 카테고리 id
        int category_id=vo.getCategory_id();
        // 하위 카테고리의 대분류 id 찾기
        Integer selectedBigCategoryId=categorydao.find_parent_id(category_id);

        // 기존 데이터가 대분류 id로 저장되어 있던 경우 대비
        if (selectedBigCategoryId == null) {
            selectedBigCategoryId=category_id;
        }

        model.addAttribute("vo", vo);
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("selectedBigCategoryId",selectedBigCategoryId);
        model.addAttribute("smallCategoryList", categorydao.small_category_list(selectedBigCategoryId));
        return "seller/seller_product_modify_form";
    }
 

    @PostMapping("/seller_product_modify.do")
    @ResponseBody
    public Map<String,Object> seller_product_modify(ProductVO vo,String ori_image_l,String ori_image_s,String del_image_l,String del_image_s)throws Exception{
        
        String savePath = "c:/upload/";
        File dir = new File(savePath);

        if (!dir.exists()) {
            dir.mkdirs();
        }

        String image_l_name = "no_file";

        if (vo.getImage_l_file() != null && !vo.getImage_l_file().isEmpty()){
            image_l_name=vo.getImage_l_file().getOriginalFilename();
            File saveFile=new File(savePath, image_l_name);

            if (saveFile.exists()) {
                long time=System.currentTimeMillis();
                image_l_name=String.format("%d_%s", time, image_l_name);
                saveFile=new File(savePath,image_l_name);
            }

            
            vo.getImage_l_file().transferTo(saveFile);

        } else if(ori_image_l != null && !ori_image_l.equals("no_file")){
            image_l_name=ori_image_l;
        }

        String image_s_name = "no_file";

        if (vo.getImage_s_file() != null && !vo.getImage_s_file().isEmpty()){
            image_s_name=vo.getImage_s_file().getOriginalFilename();
            File saveFile=new File(savePath, image_s_name);

            if (saveFile.exists()){
                long time=System.currentTimeMillis();
                image_s_name=String.format("%d_%s", time, image_s_name);
                saveFile=new File(savePath,image_s_name);
            }

            vo.getImage_s_file().transferTo(saveFile);

        } else if (ori_image_s!=null && !ori_image_s.equals("no_file")){
            image_s_name = ori_image_s;
        }

        vo.setImage_l(image_l_name.equals("no_file") ? "no_file":"/upload/"+image_l_name);
        vo.setImage_s(image_s_name.equals("no_file") ? "no_file":"/upload/"+image_s_name);

        int res=productdao.seller_product_modify(vo);

        if (res == 1){
            if (del_image_l != null && !del_image_l.equals("no_file")){
                File delFile = new File(savePath, del_image_l.replace("/upload/", ""));

                if (vo.getImage_l_file()!=null && !vo.getImage_l_file().isEmpty()){
                    if (delFile.exists()){
                        delFile.delete();
                    }
                }
            }

            if (del_image_s!=null && !del_image_s.equals("no_file")){
                File delFile=new File(savePath, del_image_s.replace("/upload/", ""));

                if (vo.getImage_s_file() != null && !vo.getImage_s_file().isEmpty()){
                    if (delFile.exists()){
                        delFile.delete();
                    }
                }
            }
        }

        Map<String, Object> map = new HashMap<>();
        map.put("result",res);
        map.put("product_id",vo.getProduct_id());

        return map;
    }
    
    @GetMapping("/seller_product_list.do")
    public String seller_product_list(Model model,String status,String sort){

        // 로그인/판매자 기능 붙기 전까지 임시 seller_id
        //int seller_id = 1;

        if (sort == null || sort.equals("")) {
            sort = "new";
        }

        Map<String, Object> map = new HashMap<>();
        map.put("status", status);
        map.put("sort", sort);

        List<ProductVO> list = productdao.seller_product_list(map);

        model.addAttribute("list", list);
        model.addAttribute("status", status);
        model.addAttribute("sort", sort);

        return "/seller/seller_product_list";
    }
        
    @PostMapping("/seller_product_toggle.do")
    @ResponseBody
    public Map<String,Object> seller_product_toggle(ProductVO vo){

    Map<String,Object> map=new HashMap<>();

    int result=productdao.seller_product_toggle(vo);

    map.put("result",result);
    map.put("status",vo.getStatus());

    return map;
    }

    @PostMapping("/seller_product_delete.do")
    @ResponseBody
    public Map<String, Object> sellerProductDelete(int product_id){

        Map<String,Object> map = new HashMap<>();

        int result = productdao.seller_product_delete(product_id);

        map.put("result", result);

        return map;
    }

    // 체크된 상품 여러 개 삭제
    @PostMapping("/seller_product_delete_selected.do")
    public String sellerProductDeleteSelected(int[] product_id){

        productdao.sellerProductDeleteSelected(product_id);

        return "redirect:/seller_product_list.do";
    }

}
