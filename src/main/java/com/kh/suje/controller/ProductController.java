package com.kh.suje.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.kh.suje.dao.CategoryDAO;
import com.kh.suje.dao.ProductDAO;
import com.kh.suje.util.Paging;
import com.kh.suje.vo.ProductVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ProductController {

    private final ProductDAO productdao;
    private final CategoryDAO categorydao;
   
    @GetMapping(value={"/", "/main.do", "/product/main.do", "/product/list.do"})
    public String main(Model model){

        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());
        return "main";
    }

    @GetMapping("/main2.do")
    public String main2() {
        return "main2";
    }
        
    @GetMapping("/category_list.do")
    public String product_category_list(Model model, Integer page, Integer category_id) {

        String category_name = categorydao.getCategroyNameById(category_id);

        //소분류면 parent_id를 찾음,대분류면 parent_id가 null
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

        int rowTotal = productdao.product_category_cnt(map);

        List<ProductVO> list = productdao.product_category_list(map);

        String pageMenu = Paging.getPaging(
            "/category_list.do?category_id=" + category_id,
            nowPage,
            rowTotal,
            blockList,
            blockPage
        );

        model.addAttribute("list", list);
        model.addAttribute("pageMenu", pageMenu);
        model.addAttribute("category_id", category_id);
        model.addAttribute("category_name", category_name);

        // 카테고리 페이지 왼쪽 메뉴용
        model.addAttribute("bigCategoryList", categorydao.big_category_list());
        model.addAttribute("smallCategoryList", categorydao.small_category_all_list());
        model.addAttribute("selectedBigCategoryId", selectedBigCategoryId);

        return "product/product_category_list";
    } 
   

    @GetMapping("/product_detail.do")
    public String product_detail_form(int product_id,Model model){
        ProductVO vo=productdao.product_one(product_id);
        model.addAttribute("vo",vo);
        return "/product/product_detail";
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
        return "product/product_sale_list";
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

        if (filename_l.equals("no_file")) {
            vo.setImage_l("no_file");
        } else {
            vo.setImage_l("/upload/" + filename_l);
        }

        if (filename_s.equals("no_file")) {
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

        if (vo.getImage_l_file() != null && !vo.getImage_l_file().isEmpty()) {
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

        } else if (ori_image_s!=null && !ori_image_s.equals("no_file")) {
            image_s_name = ori_image_s;
        }

        vo.setImage_l(image_l_name.equals("no_file") ? "no_file":"/upload/"+image_l_name);
        vo.setImage_s(image_s_name.equals("no_file") ? "no_file":"/upload/"+image_s_name);

        int res=productdao.seller_product_modify(vo);

        if (res == 1) {
            if (del_image_l != null && !del_image_l.equals("no_file")){
                File delFile = new File(savePath, del_image_l.replace("/upload/", ""));

                if (vo.getImage_l_file()!=null && !vo.getImage_l_file().isEmpty()){
                    if (delFile.exists()) {
                        delFile.delete();
                    }
                }
            }

            if (del_image_s!=null && !del_image_s.equals("no_file")){
                File delFile=new File(savePath, del_image_s.replace("/upload/", ""));

                if (vo.getImage_s_file() != null && !vo.getImage_s_file().isEmpty()){
                    if (delFile.exists()) {
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
    public String seller_product_list(Model model) {

        // 로그인/판매자 기능 붙기 전까지 임시 seller_id
        int seller_id = 1;

        List<ProductVO> list = productdao.seller_product_list(seller_id);

        model.addAttribute("list", list);

        return "seller/seller_product_list";
    }
        
    @PostMapping("/seller_product_toggle.do")
    @ResponseBody
    public Map<String,Object> seller_product_toggle(ProductVO vo) {

    Map<String,Object> map=new HashMap<>();

    int result=productdao.seller_product_toggle(vo);

    map.put("result", result);
    map.put("status", vo.getStatus());

    return map;
    }


}
